-- Allow application to see and use the schema
GRANT USAGE ON SCHEMA sec_financials TO funds_app;

-- Grant DML access on existing tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA sec_financials TO funds_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA sec_financials TO funds_app;

-- Ensure future tables created by Flyway also grant permissions automatically
ALTER DEFAULT PRIVILEGES IN SCHEMA sec_financials
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO funds_app;

ALTER DEFAULT PRIVILEGES IN SCHEMA sec_financials
GRANT USAGE, SELECT ON SEQUENCES TO funds_app;