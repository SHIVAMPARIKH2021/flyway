-- 1. Analytics Reporting Quarter Dimension
CREATE TABLE IF NOT EXISTS analytics.reporting_quarter (
    quarter_id   SERIAL PRIMARY KEY,
    filing_year  INTEGER NOT NULL,
    quarter      INTEGER NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    is_active    BOOLEAN NOT NULL DEFAULT TRUE,
    created_at   TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by   VARCHAR(50),
    updated_at   TIMESTAMP WITHOUT TIME ZONE,
    updated_by   VARCHAR(50),
    CONSTRAINT uq_analytics_reporting_quarter UNIQUE (filing_year, quarter)
);

-- 2. Quarter-to-Fund Association (Bridge Table for Quarterly Cohorts)
-- Tracks which funds were active/filed during a specific quarter without breaking 3NF on fund_master
CREATE TABLE IF NOT EXISTS analytics.quarter_fund_association (
    quarter_id       INTEGER NOT NULL REFERENCES analytics.reporting_quarter(quarter_id) ON DELETE CASCADE,
    series_id        VARCHAR(30) NOT NULL REFERENCES analytics.fund_master(series_id) ON DELETE CASCADE,
    accession_number VARCHAR(25) NOT NULL,
    created_at       TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    created_by       VARCHAR(50),
    PRIMARY KEY (quarter_id, series_id)
);

CREATE INDEX IF NOT EXISTS idx_qfa_quarter_id
    ON analytics.quarter_fund_association(quarter_id);

CREATE INDEX IF NOT EXISTS idx_qfa_series_id
    ON analytics.quarter_fund_association(series_id);

-- Optional: Execute audit constraint cleanup if procedure is present
DO $$
BEGIN
    IF EXISTS (
        SELECT 1 FROM pg_proc p
        JOIN pg_namespace n ON p.pronamespace = n.oid
        WHERE n.nspname = 'analytics'
          AND p.proname = 'drop_audit_constraints_and_defaults'
    ) THEN
        CALL analytics.drop_audit_constraints_and_defaults();
    END IF;
END $$;