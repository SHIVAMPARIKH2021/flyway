-- Admin privileges
GRANT USAGE, CREATE ON SCHEMA finance TO emfs_admin;

-- App privileges
GRANT USAGE ON SCHEMA finance TO emfs_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA finance TO emfs_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA finance
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO emfs_app;

-- Admin privileges
GRANT USAGE, CREATE ON SCHEMA document_management TO emfs_admin;

-- App privileges
GRANT USAGE ON SCHEMA document_management TO emfs_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA document_management TO emfs_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA document_management
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO emfs_app;

-- Admin privileges
GRANT USAGE, CREATE ON SCHEMA employee_management TO emfs_admin;

-- App privileges
GRANT USAGE ON SCHEMA employee_management TO emfs_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA employee_management TO emfs_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA employee_management
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO emfs_app;