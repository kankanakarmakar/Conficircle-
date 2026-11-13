-- ==========================================================================
-- conficircle_db single-database bootstrap (single-DB architecture)
--
-- Creates the four PostgreSQL schemas (one per service) and the four
-- least-privilege service roles with grants limited to their own schema.
--
-- IDEMPOTENT: safe to run repeatedly.
--
-- Usage (against an ALREADY-initialized volume, where the
-- docker-entrypoint-initdb.d script does NOT run again):
--   docker exec -i conficircle-postgres psql -U conficircle -d conficircle_db \
--     < infrastructure/postgres/init-schemas.sql
--
-- Or use the wrapper: backend/scripts/init-schemas.sh
--
-- Role passwords come from psql variables (:vars). The wrapper script
-- passes them from backend/.env (IDENTITY_DB_PASSWORD, CONTENT_DB_PASSWORD,
-- ASSESSMENT_DB_PASSWORD, PROGRESS_DB_PASSWORD). If a password var is
-- omitted the role is created with an empty password (dev-only; document
-- any such usage).
-- ==========================================================================

-- ---------------------------------------------------------------- schemas --
CREATE SCHEMA IF NOT EXISTS identity;
CREATE SCHEMA IF NOT EXISTS content;
CREATE SCHEMA IF NOT EXISTS assessment;
CREATE SCHEMA IF NOT EXISTS progress;

-- ------------------------------------------------------------------ roles --
-- Passwords are only applied when the role is created; existing roles keep
-- their password unless ALTER ROLE is issued intentionally.

SELECT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = 'identity_service_user') AS exists_identity \gset
\if :exists_identity
\else
CREATE ROLE identity_service_user LOGIN PASSWORD :'identity_password';
\endif

SELECT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = 'content_service_user') AS exists_content \gset
\if :exists_content
\else
CREATE ROLE content_service_user LOGIN PASSWORD :'content_password';
\endif

SELECT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = 'assessment_service_user') AS exists_assessment \gset
\if :exists_assessment
\else
CREATE ROLE assessment_service_user LOGIN PASSWORD :'assessment_password';
\endif

SELECT EXISTS(SELECT 1 FROM pg_roles WHERE rolname = 'progress_service_user') AS exists_progress \gset
\if :exists_progress
\else
CREATE ROLE progress_service_user LOGIN PASSWORD :'progress_password';
\endif

-- ----------------------------------------------------------------- grants --
-- Each service role: usage + create (for migrations) on its OWN schema
-- only, plus table/sequence privileges incl. default privileges for
-- future tables created in that schema. No access to other schemas.
-- (Grant loops are unrolled per schema because psql :var substitution
-- does not work inside dollar-quoted DO blocks.)

GRANT USAGE, CREATE ON SCHEMA identity TO identity_service_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA identity TO identity_service_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA identity TO identity_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA identity GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO identity_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA identity GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO identity_service_user;

GRANT USAGE, CREATE ON SCHEMA content TO content_service_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA content TO content_service_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA content TO content_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA content GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO content_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA content GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO content_service_user;

GRANT USAGE, CREATE ON SCHEMA assessment TO assessment_service_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA assessment TO assessment_service_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA assessment TO assessment_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA assessment GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO assessment_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA assessment GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO assessment_service_user;

GRANT USAGE, CREATE ON SCHEMA progress TO progress_service_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA progress TO progress_service_user;
GRANT USAGE, SELECT, UPDATE ON ALL SEQUENCES IN SCHEMA progress TO progress_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA progress GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO progress_service_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA progress GRANT USAGE, SELECT, UPDATE ON SEQUENCES TO progress_service_user;

-- Revoke PUBLIC access to the four service schemas (defense in depth).
REVOKE ALL ON SCHEMA identity FROM PUBLIC;
REVOKE ALL ON SCHEMA content FROM PUBLIC;
REVOKE ALL ON SCHEMA assessment FROM PUBLIC;
REVOKE ALL ON SCHEMA progress FROM PUBLIC;
