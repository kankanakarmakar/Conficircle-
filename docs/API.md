# ConfCircle — API Documentation

> Auto-generated from OpenAPI 3.0 specification at `/packages/api-contract/openapi.json`.
> Swagger UI is available locally at `http://localhost:3000/docs`.

## Base URLs
- Local Development: `http://localhost:3000/v1`
- Production: `https://api.confcircle.com/v1`

---

## Global Headers
| Header | Type | Description | Required |
|---|---|---|---|
| `Authorization` | String | `Bearer <JWT_ACCESS_TOKEN>` for registered users | Yes (protected routes) |
| `X-Guest-Ref` | String | Opaque guest reference token (UUID) | Yes (guest flows) |
| `Idempotency-Key` | String | Client-generated UUID for mutating actions | Yes (mutating actions) |
| `X-Request-ID` | String | Trace correlation ID | Optional (auto-generated) |

---

## Error Envelope
All error responses return:
```json
{
  "code": "ACCOUNT_REQUIRED",
  "message": "This action requires a registered account",
  "details": {},
  "requestId": "req_a1b2c3d4"
}
```
**Typed Error Codes:** `ACCOUNT_REQUIRED`, `QUOTA_EXHAUSTED`, `SESSION_EXPIRED`, `FORBIDDEN`, `NOT_FOUND`, `VALIDATION_FAILED`, `RATE_LIMITED`, `IDEMPOTENCY_CONFLICT`, `UNAUTHORIZED`, `INTERNAL_ERROR`.

---

## 1. System & Config
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/health` | Liveness probe | Public |
| `GET` | `/ready` | Readiness probe (checks PostgreSQL + Redis) | Public |
| `GET` | `/v1/config` | Load remote theme, feature flags, quotas | Public |

---

## 2. Authentication (`/v1/auth`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/v1/auth/register` | Register new user account + migrate guest data | Public |
| `POST` | `/v1/auth/login` | Login with email and password | Public |
| `POST` | `/v1/auth/refresh` | Refresh access token via rotating refresh token | Public |
| `GET` | `/v1/auth/session` | Get current authenticated user session | Bearer |
| `POST` | `/v1/auth/logout` | Revoke active refresh session | Bearer |

---

## 3. Guest Identity (`/v1/guest`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/v1/guest/session` | Obtain opaque `guest_ref` with absolute TTL | Public |
| `GET` | `/v1/guest/questions` | Get 2–3 randomized Level 4 questions (cached) | `X-Guest-Ref` |

---

## 4. Home Dashboard (`/v1/home`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/home` | Role-appropriate dashboard (guest vs registered) | Public / Bearer / Guest |

---

## 5. Topics & Learning Navigation (`/v1/topics`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/topics` | List topics with `category` and `level` filters | Public |
| `GET` | `/v1/topics/:id` | Topic detail with backend-entitled `actions[]` | Public / Bearer |
| `GET` | `/v1/topics/:id/content`| Quick Tips & Video Solution list for topic | Public / Bearer |

---

## 6. Quick Tips (`/v1/quicktips`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `POST` | `/v1/quicktips/:id/open` | Open tip: atomic quota check or registered access | `Idempotency-Key` + Guest/Bearer |
| `GET` | `/v1/quicktips/:id` | Get Quick Tip by ID | Public |

---

## 7. Video Solutions (`/v1/videos`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/videos/:id` | Video metadata | Bearer |
| `GET` | `/v1/videos/:id/playback-url` | Generate short-lived (5 min) signed HMAC streaming URL | Bearer |
| `PUT` | `/v1/videos/:id/progress` | Checkpoint progress + server-computed 90% completion | Bearer + `Idempotency-Key` |

---

## 8. Assessments (`/v1/assessments` & `/v1/attempts`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/assessments/:id` | Assessment questions (**correct answers omitted**) | Bearer |
| `POST` | `/v1/assessments/:id/attempts` | Start attempt: timer and `expiresAt` set server-side | Bearer + `Idempotency-Key` |
| `PUT` | `/v1/attempts/:id/answers` | Autosave answer during attempt (idempotent) | Bearer + `Idempotency-Key` |
| `POST` | `/v1/attempts/:id/submit` | Submit attempt: server-side scoring only | Bearer + `Idempotency-Key` |

---

## 9. Resources (`/v1/resources`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/resources` | List published resources with search/filters | Public / Bearer |
| `GET` | `/v1/resources/:id` | Resource detail metadata | Public / Bearer |
| `GET` | `/v1/resources/:id/download-url` | Get authorized short-lived file download URL | Public / Bearer |

---

## 10. Circle Community (`/v1/circle`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/circle/groups` | List public and joined groups | Public / Bearer |
| `GET` | `/v1/circle/feed` | Permitted community post feed | Public / Bearer |
| `POST` | `/v1/circle/groups/:id/join` | Join a community group | Bearer |
| `POST` | `/v1/circle/groups/:id/leave`| Leave a community group | Bearer |
| `POST` | `/v1/circle/posts` | Create a post in a joined group | Bearer |

---

## 11. Me & Gamification (`/v1/me`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/me` | User profile, settings, summary | Public / Bearer |
| `GET` | `/v1/me/history` | Learning history across tips, videos, quizzes | Bearer |
| `GET` | `/v1/me/progress` | Authoritative Confy points ledger & level | Bearer |
| `PATCH` | `/v1/me` | Update profile and notification preferences | Bearer |

---

## 12. Courses (`/v1/courses` & `/v1/stages`)
| Method | Endpoint | Description | Auth |
|---|---|---|---|
| `GET` | `/v1/courses/mine` | Enrolled courses, modules, stages, and progress | Bearer |
| `GET` | `/v1/courses/:id` | Course curriculum detail | Public |
| `POST` | `/v1/courses/:id/enrol` | Enrol in a course | Bearer |
| `GET` | `/v1/stages/:id` | Stage requirements and completion criteria | Bearer |
| `POST` | `/v1/stages/:id/progress`| Record completion of course stage (checks prereqs) | Bearer + `Idempotency-Key` |

