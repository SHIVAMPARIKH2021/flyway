ALTER TABLE analytics.fund_reporting
    ADD COLUMN IF NOT EXISTS created_by VARCHAR(20),
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

ALTER TABLE analytics.holding
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP,
    ADD COLUMN IF NOT EXISTS created_by VARCHAR(20),
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP;

ALTER TABLE analytics.fund_master
    ADD COLUMN IF NOT EXISTS created_by VARCHAR(20);

ALTER TABLE analytics.fund_classes
    ADD COLUMN IF NOT EXISTS updated_by VARCHAR(20),
    ADD COLUMN IF NOT EXISTS created_by VARCHAR(20),
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;

DO $$
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'analytics' 
          AND table_name = 'compliance_rules' 
          AND column_name = 'created_date'
    ) THEN
        ALTER TABLE analytics.compliance_rules RENAME COLUMN created_date TO created_at;
    END IF;

    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_schema = 'analytics' 
          AND table_name = 'compliance_rules' 
          AND column_name = 'modified_date'
    ) THEN
        ALTER TABLE analytics.compliance_rules RENAME COLUMN modified_date TO updated_at;
    END IF;
END $$;

ALTER TABLE analytics.benchmark_master
    ADD COLUMN IF NOT EXISTS created_by VARCHAR(20),
    ADD COLUMN IF NOT EXISTS created_at TIMESTAMP,
    ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP;