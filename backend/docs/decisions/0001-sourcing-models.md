# 0001 — Sourcing the data model

- Date: 2026-11-05
- Status: Accepted (with limitation)

## Context

Phase 5 requires inspecting the original ConfCircle DBML schema before
designing Prisma models. Inspection of the repository (branch
`Bikram_dev`, clean working tree) found:

- A plain Flutter app (pubspec `conficircle`, go_router/provider/fl_chart).
- No product docs, no `.dbml` files, no API specs, no prior backend code.
- No database artifacts anywhere in the tree.

## Decision

1. Materialize backend scaffolding with **DRAFT** Prisma schemas per
   service, derived only from the service responsibility definitions
   supplied with the tasking, and mark them clearly as drafts
   (top comment in every `prisma/schema.prisma`).
2. Do **not** generate or execute migrations, production or otherwise,
   until an approved DBML/data model exists.
3. Record all model names in the ownership matrix for easy revision.

## Consequences

- Model names/fields may change without a migration cost.
- Business services can now be written against stable TypeScript
  surfaces (contracts/event-schemas) even while schemas are provisional.
- Any divergence between these drafts and the eventual approved schema
  is expected and must be reconciled manually — documented limitation,
  not invented requirements.
