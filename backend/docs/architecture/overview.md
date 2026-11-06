# Architecture — ConfCircle Backend (Phase 3)

## Service topology

```
                          ┌────────────────────┐
        Flutter app ──────►    API Gateway     │  (3000)
        (single entry)    │  auth + rate limit   │
                          │  validation, CORS,   │
                          │  correlation IDs     │
                          │  swagger /docs       │
                          └─┬──────┬──────┬───┬──┘
                            │HTTP  │      │   │
              ┌─────────────▼──┐ ┌─▼────────────┐ ┌─▼──────────────────┐ ┌──────────────────┐
              │ Identity svc   │ │ Content svc  │ │ Assessment svc     │ │ Progress svc     │
              │ (3001) identity| │ (3002) content│ │ (3003) assessment  │ │ (3004) progress  │
              │ _db            │ │ _db          │ │ _db                │ │ _db              │
              └──────┬─────────┘ └──────┬───────┘ └────────┬───────────┘ └───────┬──────────┘
                     │                  │                  │                     │
                     └────────────┬─────┴──────────┬──────┴─────────────────────┘
                                  │ RabbitMQ topic exchange (`conficircle.events`)
                          ┌───────▼────────┐  ┌────────────┐
                          │ Redis          │  │ (events)   │
```

## Responsibility boundaries

| Service | Owns | Must never do |
| --- | --- | --- |
| api-gateway | routing, guards, rate limiting, docs | business logic, direct DB access |
| identity | users, credentials, refresh sessions, guest sessions/quota, conversion | touch content/assessment/progress data |
| content | topics, questions (+correct answers, private), tips, videos, resources, publication | expose correct answers via public API |
| assessment | assessments, attempts, responses, scoring, history | trust client-supplied userId; expose scoring internals |
| progress | activity history, video/topic progress, daily stats, analytics | write to other services' databases |

## Rules

- One database per service; **no cross-service foreign keys**, no direct
  DB access between services (Phase 5).
- User references in other services are plain UUIDs; ownership is
  enforced in the application layer (Phase 8) — never trust frontend
  identity claims.
- Infrastructure ports used locally are non-standard because this
  workstation has other projects on default ports.
