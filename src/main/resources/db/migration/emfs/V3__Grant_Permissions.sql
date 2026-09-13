-- ============================================================================
-- 1. SCHEMA ACCESS
-- ============================================================================
GRANT USAGE ON SCHEMA public TO emfs_app;
GRANT USAGE ON SCHEMA employee_management TO emfs_app;
GRANT USAGE ON SCHEMA finance TO emfs_app;
GRANT USAGE ON SCHEMA document_management TO emfs_app;

-- ============================================================================
-- 2. PERMISSIONS ON EXISTING TABLES & SEQUENCES
-- ============================================================================
-- Public schema (locations)
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO emfs_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO emfs_app;

-- Employee Management schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA employee_management TO emfs_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA employee_management TO emfs_app;

-- Finance schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA finance TO emfs_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA finance TO emfs_app;

-- Document Management schema
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA document_management TO emfs_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA document_management TO emfs_app;

-- ============================================================================
-- 3. DEFAULT PRIVILEGES (For tables created in future Flyway migrations)
-- ============================================================================
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO emfs_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
    GRANT USAGE, SELECT ON SEQUENCES TO emfs_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA employee_management
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO emfs_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA employee_management
    GRANT USAGE, SELECT ON SEQUENCES TO emfs_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA finance
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO emfs_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA finance
    GRANT USAGE, SELECT ON SEQUENCES TO emfs_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA document_management
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO emfs_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA document_management
    GRANT USAGE, SELECT ON SEQUENCES TO emfs_app;