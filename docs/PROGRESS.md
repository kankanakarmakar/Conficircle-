# ConfCircle — Build Progress

> Updated automatically after each phase. All times IST.

## Task Plan

| Phase | Scope | Status | Notes |
|-------|-------|--------|-------|
| A | Monorepo scaffold, Docker Compose, Prisma schema + migrations + seed, NestJS skeleton | ✅ Complete | Fully built, typed, and verified |
| B | Flows 01–03 (startup, guest, conversion) | ✅ Complete | Implemented & unit tested |
| C | Flows 04–06 (learning, video/quick tip, assessments) | ✅ Complete | Implemented & unit tested |
| D | Flows 07–09 (resources, circle, me, course, notifications) | ✅ Complete | Implemented with adapters |
| E | Flow 10 hardening, tests, docs | ✅ Complete | All backend + Flutter tests green |
| F | Specification v3.0: Level 4 Question Prompts Discovery & Personalisation | ✅ Complete | L4-only discovery, 7-8 guest, 5-6 registered, shuffle, problem profile |

---

## Deliverables Summary

### Phase A — Monorepo Scaffold & Backend Skeleton
- [x] Repository layout: `confcircle/{apps/api,packages/api-contract,prisma,docs}`
- [x] Docker Compose: `confcircle/docker-compose.yml` (api, worker, postgres 16, redis 7)
- [x] Prisma schema: `confcircle/prisma/schema.prisma` with 25+ models, all indexes, FKs, enums
- [x] Seed script: `confcircle/prisma/seed.ts` (AppConfig, FeatureFlags, ConfyLevels, Categories, Levels, Topics, Tips, Videos, Assessments, Questions, Resources, Groups, Courses, NotificationTemplates)
- [x] NestJS monolith: Auth guards, Redis module with atomic Lua scripts, Idempotency interceptor, Entitlement service, Error filter, RequestId middleware
- [x] OpenAPI contract: `confcircle/packages/api-contract/openapi.json` (30 KB spec generated)
- [x] Flutter: `pubspec.yaml` with Riverpod, Dio, SecureStorage, GoRouter, Provider; `lib/core/` complete; `lib/router.dart` and `lib/main.dart` updated
- [x] `/health` and `/ready` endpoints
- [x] `confcircle/.env.example`
- [x] `confcircle/Makefile` with build, test, migrate, seed, docker targets

### Phase B — Flows 01–03
- [x] **Flow 01**: App Startup, remote config (`GET /v1/config`), role-appropriate dashboard (`GET /v1/home`), global bottom navigation, 5 UI states
- [x] **Flow 02**: Guest entry (`POST /v1/guest/session`), opaque `guest_ref` (UUID), absolute Redis TTL (max 7200s), Level 4 question selection with Redis cache, atomic Lua quota decrement on Quick Tips
- [x] **Flow 03**: Guest access gates (`ACCOUNT_REQUIRED`), registration with migration (`POST /v1/auth/register`), whitelist validation, single PostgreSQL transaction with `sourceEventId` deduplication, post-commit Redis key cleanup

### Phase C — Flows 04–06
- [x] **Flow 04**: Registered Home, learning navigation (`GET /v1/topics`), topic detail with backend-entitled `actions[]`
- [x] **Flow 05**: Video Solutions, short-lived HMAC signed streaming URL (5 min), checkpoint tracking (`PUT /v1/videos/:id/progress`), impossible jump rejection, server-side 90% completion threshold, once-only Confy points award via unique ledger ref
- [x] **Flow 06**: Quick Assessment, correct answers omitted server-side, timer & `expiresAt` computed on backend, autosave answers, server-side scoring only, late answer exclusion, Confy points award

### Phase D — Flows 07–09
- [x] **Flow 07**: Resources catalogue, public vs registered rules, signed download URLs, Circle community groups, feed visibility by membership, audit events
- [x] **Flow 08**: Me profile, learning history aggregation across all content, authoritative server-computed Confy points ledger and level resolution, profile & preferences update
- [x] **Flow 09**: Course curriculum, prerequisites check, completion criteria, notification service with email/WhatsApp adapter interfaces and strict consent & opt-out checking

### Phase E — Flow 10 Hardening & Verification
- [x] **Flow 10**: End-to-end data access & system boundaries chain implemented
- [x] **Backend Unit Tests**: 4 suites, 13 tests passed (Jest)
  - Quota atomicity & Lua decrement
  - Idempotency replay on duplicate requests
  - Session expiry vs quota exhaustion
  - Server-side assessment scoring & late answer exclusion
  - Video impossible jump rejection & points deduplication
- [x] **Flutter Tests**: 8 tests passed (`flutter test`)
  - 5 async UI states: loading, empty, success, error (with retry), access-denied (with sign-in CTA)
  - GuestSessionEntity quota calculations
  - App smoke test
- [x] **Documentation**:
  - `/docs/ARCHITECTURE.md`: Complete sequence diagrams for Flows 02, 03, 05, 06, 09
  - `/docs/API.md`: Full endpoint catalog matching OpenAPI specification
  - `/docs/ASSUMPTIONS.md`: All architecture and engineering decisions documented
  - `/docs/PROGRESS.md`: Comprehensive completion report

### Phase F — Specification v3.0 Deliverables
- [x] **Data Model (Prisma)**:
  - `TaxonomyNode`: L0–L3 hierarchy storing internal categorization without consumer exposure
  - `QuestionPrompt`: Level 4 prompt text, helper text, publication status, guest/registered eligibility, editorial boost
  - `ConcernPrompt`: Plain-language user-facing concern statements mapped privately to internal L2/L1 nodes
  - `UserProblemProfile`: Stored user concern selections, priority, status (active/paused/removed), and consent
  - `DiscoveryBatch` & `DiscoveryEvent`: Immutable batch generation and telemetry tracking
  - `RecommendationConfig`: Configurable scoring weights and batch sizes
- [x] **Backend Monolith (NestJS DiscoveryModule)**:
  - `GET /v1/discovery/guest`: 7–8 Level 4 questions only with Redis TTL validation
  - `POST /v1/discovery/guest/shuffle`: Fresh batch of 7–8 Level 4 questions avoiding repeats
  - `GET /v1/discovery/registered`: 5–6 Level 4 questions scored via profile matching + boosts - penalties
  - `POST /v1/discovery/registered/shuffle`: Fresh batch of 5–6 Level 4 questions
  - `GET /v1/questions/:id`: Question-led detail with access entitlements
  - `POST /v1/problem-profile`, `PATCH /v1/problem-profile/:id`, `GET /v1/problem-profile`, `GET /v1/problem-profile/concerns`
  - `GET /v1/recommendations/questions`
  - Zero taxonomy leakage in all consumer DTOs (no L0–L3 names or parent paths)
  - Updated `HomeScreen` endpoint in `home.service.ts` to return Level 4 questions only
- [x] **Frontend Architecture (Flutter)**:
  - `DiscoveryModule`: `GuestQuestionDiscoveryScreen`, `RegisteredQuestionDiscoveryScreen`, `QuestionCard`, `ShuffleControl`, `DiscoveryBatchState`, `LoadingSkeleton`, `EmptyState`, `RetryState`
  - `QuestionModule`: `QuestionDetailScreen`, `QuestionHeader`, `ContentActionList` with access gates
  - `ProblemProfileModule`: `ConcernPicker`, `ConcernSearch`, `SelectedConcernChips`, `PrioritySelector`, `ConsentNotice`, `ProfileEditor`
  - `DiscoveryRepository`: Methods for guest/registered batches, shuffles, question detail, and problem profiles
  - Immutable batch state: Current cards remain visible during shuffle, updated only upon success
  - Updated `TopicGridSection` and `ActionCardGrid` in Home to render Level 4 question prompts discovery cards only

---

## Test Results

| Layer | Test Suite | Tests Passed | Status |
|---|---|---|---|
| Backend | `idempotency.interceptor.spec.ts` | 2 / 2 | ✅ PASS |
| Backend | `assessments.service.spec.ts` | 3 / 3 | ✅ PASS |
| Backend | `videos.service.spec.ts` | 3 / 3 | ✅ PASS |
| Backend | `guest.service.spec.ts` | 5 / 5 | ✅ PASS |
| **Backend Total** | **4 suites** | **13 / 13** | **✅ PASS** |
| Flutter | `loading_state_widget_test.dart` (5 states) | 5 / 5 | ✅ PASS |
| Flutter | `guest_provider_test.dart` | 2 / 2 | ✅ PASS |
| Flutter | `widget_test.dart` | 1 / 1 | ✅ PASS |
| **Flutter Total** | **3 suites** | **8 / 8** | **✅ PASS** |
