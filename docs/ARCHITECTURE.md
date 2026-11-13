# ConfCircle — Architecture

> Generated as part of Phase E. Sequence diagrams for Flows 02, 03, 05, 06, 09.

## System Overview

```mermaid
flowchart TB
  subgraph Client["Flutter App (Mobile)"]
    UI["Screen Widget"]
    Provider["Riverpod Provider"]
    UseCase["Use Case"]
    Repo["Repository"]
    ApiClient["Typed API Client (Dio)"]
  end

  subgraph API["NestJS API (Backend Authority)"]
    Controller["Controller"]
    Guard["AuthGuard / RolesGuard / EntitlementGuard"]
    Service["Service Layer"]
    Prisma["PrismaService"]
    Redis["RedisService"]
  end

  subgraph Infra["Infrastructure"]
    PG[("PostgreSQL\n(Durable)")]
    RD[("Redis\n(Ephemeral)")]
  end

  subgraph Worker["BullMQ Worker"]
    NotifProc["Notification Processor"]
    RetryJob["Retry / Cleanup Jobs"]
  end

  UI --> Provider --> UseCase --> Repo --> ApiClient
  ApiClient -->|HTTPS + auth/guest_ref/idempotency| Controller
  Controller --> Guard --> Service
  Service --> Prisma --> PG
  Service --> Redis --> RD
  Worker --> Prisma & Redis
```

## Flow 02 — Guest Entry, Question Selection & Quick Tip

```mermaid
sequenceDiagram
  actor G as Guest
  participant App as Flutter App
  participant API as NestJS API
  participant Redis as Redis
  participant PG as PostgreSQL

  G->>App: Opens app / "Continue as Guest"
  App->>App: Check SecureStorage for guest_ref
  alt No guest_ref
    App->>API: POST /v1/guest/session {deviceId}
    API->>API: Generate opaque guest_ref (UUID)
    API->>Redis: SET guest:session:{guest_ref} {createdAt,expiresAt} EX 3600
    API->>Redis: SET guest:quota:quicktip:{guest_ref} 3 EX 3600
    API-->>App: {guest_ref, expiresAt}
    App->>App: Store guest_ref in SecureStorage
  end

  App->>API: GET /v1/guest/questions [X-Guest-Ref: {guest_ref}]
  API->>Redis: GET guest:questions:{guest_ref}
  alt Questions not cached
    API->>PG: SELECT questions WHERE eligibleForGuest=true AND levelId=Level4 ORDER BY RANDOM() LIMIT 3
    API->>Redis: SET guest:questions:{guest_ref} [q1,q2,q3] EX (remaining TTL)
  end
  API-->>App: {questions: [...]}

  App->>G: Render guest Home with questions + QuickTip cards

  G->>App: Tap a Quick Tip card
  App->>API: POST /v1/quicktips/{id}/open [X-Guest-Ref, Idempotency-Key]
  
  Note over API,Redis: Atomic Lua script
  API->>Redis: EVAL lua_quota_check_decrement(guest_ref, idempotency_key)
  
  alt Quota available
    Redis-->>API: OK {remaining: 2}
    API->>Redis: SET idem:{key} {response} EX 60
    API->>PG: (no write for guest quick tip view)
    API-->>App: {tip: {content, ...}, quotaRemaining: 2}
    App->>G: Display Quick Tip content
  else Quota exhausted
    Redis-->>API: QUOTA_EXHAUSTED
    API-->>App: 429 {code: "QUOTA_EXHAUSTED"}
    App->>G: Show limit reached + Sign In option
  else Session expired
    Redis-->>API: SESSION_EXPIRED
    API-->>App: 403 {code: "SESSION_EXPIRED"}
    App->>G: Show expired + re-enter option
  end
```

## Flow 03 — Guest Conversion & Expiry

```mermaid
sequenceDiagram
  actor G as Guest
  participant App as Flutter App
  participant API as NestJS API
  participant Redis as Redis
  participant PG as PostgreSQL

  G->>App: Tap "Sign Up"
  App->>API: POST /v1/auth/register {email, password, name, guest_ref}
  
  API->>API: Validate input (class-validator)
  API->>PG: Check email uniqueness
  API->>API: Hash password (argon2id)
  API->>PG: CREATE User + Profile (transaction start)
  
  API->>Redis: GET guest:events:{guest_ref}
  Note over API: Filter events against migration whitelist

  loop For each approved event
    API->>PG: INSERT INTO ActivityEvent (sourceEventId=event.id) ON CONFLICT DO NOTHING
  end
  
  API->>PG: CREATE GuestMigration record
  API->>PG: COMMIT transaction
  
  alt Commit successful
    API->>Redis: DEL guest:session:{guest_ref} guest:quota:* guest:events:* guest:questions:*
    API->>API: Issue JWT access + refresh tokens
    API-->>App: {accessToken, refreshToken, user}
    App->>App: Store tokens in SecureStorage, clear guest_ref
    App->>G: Navigate to registered Home
  else Commit failed
    API->>API: Retain Redis keys (do NOT delete)
    API->>API: Schedule retry job (BullMQ, exponential backoff)
    API-->>App: 500 {code: "MIGRATION_FAILED", message: "Will retry"}
    App->>G: Show error, keep guest session active
  end

  Note over Redis: If no conversion, keys expire naturally at absolute TTL (1h default)
```

## Flow 05 — Video Solutions & Quick Tip Content

```mermaid
sequenceDiagram
  actor U as Registered User
  participant App as Flutter App
  participant API as NestJS API
  participant PG as PostgreSQL

  U->>App: Open topic → tap Video
  App->>API: GET /v1/videos/{id}/playback-url [Authorization: Bearer]
  API->>API: AuthGuard: validate JWT
  API->>API: Generate HMAC-SHA256 signed URL (5min TTL, bound to userId)
  API-->>App: {playbackUrl: "...", expiresAt, durationSec}
  
  App->>U: Start video player

  loop Every 10-15s and on pause/exit
    App->>API: PUT /v1/videos/{id}/progress {positionSec, timestamp} [Idempotency-Key]
    API->>API: Validate: positionSec <= durationSec + 5 (reject impossible jumps)
    API->>PG: UPSERT VideoProgress {lastPositionSec, userId, videoId}
    
    alt positionSec / durationSec >= VIDEO_COMPLETION_THRESHOLD (90%)
      API->>PG: UPDATE VideoProgress SET completed=true, completedAt=now()
      API->>PG: INSERT INTO ConfyPointsLedger (refEventId=video_{videoId}_user_{userId}) ON CONFLICT DO NOTHING
      API->>PG: UPSERT TopicProgress (increment videosCompleted, recalc percent)
      API->>PG: INSERT INTO ActivityEvent
    end
    
    API-->>App: {lastPositionSec, completed, pointsAwarded?}
  end
```

## Flow 06 — Quick Assessment & Results

```mermaid
sequenceDiagram
  actor U as Registered User
  participant App as Flutter App
  participant API as NestJS API
  participant PG as PostgreSQL
  participant Worker as BullMQ Worker

  U->>App: Tap "Quick Assessment"
  App->>API: GET /v1/assessments/{id}
  API->>API: Check: registered user, attempt count < maxAttempts
  API-->>App: {assessment: {title, timerSec, questions: [{id, content, options: [{id, content}]}]}}
  Note over App: NO isCorrect field sent to client

  App->>API: POST /v1/assessments/{id}/attempts [Idempotency-Key]
  API->>PG: CREATE AssessmentAttempt {state: draft, expiresAt: now() + timerSec}
  API-->>App: {attemptId, expiresAt}

  loop User answers questions
    App->>API: PUT /v1/attempts/{attemptId}/answers {questionId, selectedOptionId} [Idempotency-Key]
    API->>API: Check: attempt.state == draft AND now() < expiresAt
    API->>PG: UPSERT AttemptAnswer (unique: attemptId+questionId)
    API-->>App: {saved: true}
  end

  U->>App: Submit
  App->>API: POST /v1/attempts/{attemptId}/submit [Idempotency-Key]
  
  alt Already submitted (idempotency replay)
    API-->>App: Cached result response
  else First submission
    API->>API: Check: now() <= expiresAt + graceSeconds (5s)
    API->>PG: Load answers saved BEFORE expiresAt only
    API->>PG: Load AssessmentOptions WHERE isCorrect=true
    API->>API: Compute score = correct answers / total * 100
    
    API->>PG: BEGIN TRANSACTION
    API->>PG: UPDATE Attempt SET state=scored, score=X, status=pass/fail, submittedAt=now()
    API->>PG: INSERT ActivityEvent
    API->>PG: UPSERT TopicProgress (increment assessmentsDone)
    
    alt score >= passMark
      API->>PG: INSERT ConfyPointsLedger (refEventId UNIQUE)
    end
    
    API->>PG: COMMIT
    API-->>App: {score, status, correctAnswers, explanations, nextActions}
    App->>U: Display result screen
  end

  Worker->>PG: Cron: find expired draft attempts (now() > expiresAt + grace)
  Worker->>PG: Auto-score with answers saved before expiry
```

## Flow 09 — Course Interaction & Notifications

```mermaid
sequenceDiagram
  actor U as Registered User
  participant App as Flutter App
  participant API as NestJS API
  participant PG as PostgreSQL
  participant Worker as BullMQ Worker
  participant Email as Email Provider

  U->>App: Open Course Interaction
  App->>API: GET /v1/courses/mine
  API->>PG: Load Enrolments + CourseProgress + Deadlines for userId
  API-->>App: {courses: [...], modules: [...], stages: [...]}

  U->>App: Complete a stage activity
  App->>API: POST /v1/stages/{stageId}/progress [Idempotency-Key]
  API->>API: AuthGuard: validate JWT
  API->>PG: Load CourseStage.prerequisites → validate met
  API->>PG: Load CourseStage.completionCriteria → validate satisfied
  
  API->>PG: BEGIN TRANSACTION
  API->>PG: UPSERT CourseProgress {userId, stageId, completed=true, completedAt}
  API->>PG: INSERT ActivityEvent
  API->>PG: COMMIT
  
  API-->>App: {completed: true, unlockedStages: [...]}

  Worker->>PG: Repeatable BullMQ job: check NotificationSchedules due
  Worker->>PG: Load user Profile {notificationConsentEmail, optOutEmail}
  
  alt Consent given and not opted out
    Worker->>PG: Load NotificationTemplate
    Worker->>PG: INSERT NotificationDelivery {status: queued}
    Worker->>Email: Send via adapter (stub logs to console)
    
    alt Send success
      Worker->>PG: UPDATE NotificationDelivery {status: sent, sentAt}
    else Send failure
      Worker->>PG: UPDATE NotificationDelivery {status: failed, attempts++, error}
      Worker->>Worker: Requeue with exponential backoff (max 3 attempts)
    end
  else No consent / opted out
    Worker->>PG: INSERT NotificationDelivery {status: failed, error: "consent_not_given"}
  end
```

## Level 4 Discovery & Recommendation Architecture (Spec v3.0)

### Taxonomy Hierarchy & Consumer Visibility Boundary

```mermaid
flowchart TD
  subgraph Hidden["Backend Internal Classification & Relationship Layers (NEVER EXPOSED)"]
    L0["Level 0: Root Grouping (Internal Organisation)"]
    L1["Level 1: Broad Problem-Domain (FIXED)"]
    L2["Level 2: Problem Subcategories (99% FIXED)"]
    L3["Level 3: Internal Grouping & Reco Context (WILL EVOLVE)"]
    
    L0 --> L1
    L1 --> L2
    L2 --> L3
  end

  subgraph ConsumerBoundary["=== CONSUMER DISCOVERY BOUNDARY ==="]
    L4["Level 4: Natural-Language Question Prompts (WILL EVOLVE)\nONLY Discovery Content Shown to Guests & Registered Users"]
  end

  L3 --> L4

  subgraph DiscoveryFeeds["Consumer Presentation"]
    GuestFeed["Guest Feed:\n7–8 Level 4 Questions\n+ Shuffle"]
    RegFeed["Registered User Feed:\n5–6 Level 4 Questions\n+ Shuffle + Personalisation"]
  end

  L4 --> GuestFeed
  L4 --> RegFeed

  subgraph PersonalisationMapping["Private Problem Profile Flow"]
    CuratedConcerns["Plain-Language Concern Statements\n(User Facing)"]
    CuratedConcerns -.->|Hidden Private Mapping| L2
  end
```

### Discovery Batch & Shuffle Sequence

```mermaid
sequenceDiagram
  actor User as User (Guest or Registered)
  participant Flutter as Flutter Discovery Screen
  participant API as NestJS DiscoveryController
  participant Service as DiscoveryService
  participant PG as PostgreSQL
  participant Redis as Redis

  User->>Flutter: Opens App / Discovery Home
  alt Guest User
    Flutter->>API: GET /v1/discovery/guest?limit=8 [X-Guest-Ref]
    API->>Redis: Check guest:session:{guest_ref} TTL
    API->>Service: getGuestBatch(guestRef, limit=8)
    Service->>PG: Query QuestionPrompt (publishStatus='published', guestEligible=true)
    Service->>Service: Filter out previous batch items; sample diverse 7–8 L4 questions
    Service->>PG: Create DiscoveryBatch
    Service->>Redis: Record impression event
    Service-->>Flutter: {batchId, items: [7-8 Level 4 question items], expiresAt}
  else Registered User
    Flutter->>API: GET /v1/discovery/registered?limit=6 [Bearer]
    API->>Service: getRegisteredBatch(userId, limit=6)
    Service->>PG: Load UserProblemProfile -> mapped L2/L1 taxonomy nodes
    Service->>PG: Load recent events for repeat penalty
    Service->>Service: Score candidates: profile_match + boosts - penalties; sample 5–6 L4 questions
    Service->>PG: Create DiscoveryBatch & DiscoveryEvent
    Service-->>Flutter: {batchId, items: [5-6 Level 4 question items with safe labels]}
  end
  Flutter->>User: Renders QuestionCard batch (Level 4 questions ONLY)

  opt User Taps Shuffle
    User->>Flutter: Tap Shuffle
    Flutter->>Flutter: Show shuffle spinner; KEEP CURRENT CARDS VISIBLE
    Flutter->>API: POST /v1/discovery/{audience}/shuffle {previousBatchId, excludedIds}
    API->>Service: Sample fresh candidate batch
    Service-->>Flutter: {newBatchId, items: [fresh batch]}
    Flutter->>Flutter: Replace cards only after successful response
    Flutter->>User: Displays fresh question cards
  end
```


