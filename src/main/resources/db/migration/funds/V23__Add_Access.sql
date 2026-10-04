-- Admin privileges
GRANT USAGE, CREATE ON SCHEMA analytics TO funds_admin;

-- App privileges
GRANT USAGE ON SCHEMA analytics TO funds_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA analytics TO funds_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA analytics
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO funds_app;

-- Admin privileges
GRANT USAGE, CREATE ON SCHEMA sec_financials TO funds_admin;

-- App privileges
GRANT USAGE ON SCHEMA sec_financials TO funds_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sec_financials TO funds_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA sec_financials
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO funds_app;

-- Admin privileges
GRANT USAGE, CREATE ON SCHEMA batch TO funds_admin;

-- App privileges
GRANT USAGE ON SCHEMA batch TO funds_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA batch TO funds_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA batch
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO funds_app;
