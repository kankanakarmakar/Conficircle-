# API Integration Guide for Flutter (Phase 9)

## Where to point the app

- Base URL (dev): `http://<host>:3000` — the API gateway only.
- Swagger: `http://localhost:3000/docs`.
- Every response carries `x-request-id`; include it in bug reports.

## Planned route prefixes

| Prefix | Service | Purpose |
| --- | --- | --- |
| `/identity/**` | identity | registration, login, logout, guest sessions, conversion |
| `/content/**` | content | topics, questions, quick tips, videos, resources |
| `/assessment/**` | assessment | assessments, attempts, responses (server scoring only) |
| `/progress/**` | progress | activity history, video progress, dashboard reports |

While dedicated controllers are not yet wired, the gateway exposes a
development relay: `POST /<service>/<path>` forwards JSON bodies to the
upstream service (see `GET /routes`). Do not rely on it in production.

## Auth (to be implemented)

- `Authorization: Bearer <accessToken>` for protected endpoints.
- Access tokens are short-lived (`JWT_ACCESS_TTL`, default 900s);
  refresh via the identity service with the rotated refresh token.
- Roles: `user`, `admin` — checked server-side; never trust
  client-supplied identity.
- Guests: use the guest session endpoints; server tracks quota.

## Endpoint naming rules for the mobile team

- Correct answers / scoring internals are NEVER returned.
- Content selects may differ per request (shuffle = server side).
- Progress writes should be idempotent-friendly (send video position,
  duration; server computes completion).
