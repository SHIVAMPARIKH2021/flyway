-- Ensure the target schema exists
CREATE SCHEMA IF NOT EXISTS sec_financials;

DO $$
BEGIN
    -- Only proceed if the source table exists in analytics
    IF EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_schema = 'analytics' 
          AND table_name = 'pipeline_execution_log'
    ) THEN
        -- If destination table already exists in sec_financials, drop the obsolete source copy
        IF EXISTS (
            SELECT 1 
            FROM information_schema.tables 
            WHERE table_schema = 'sec_financials' 
              AND table_name = 'pipeline_execution_log'
        ) THEN
            DROP TABLE analytics.pipeline_execution_log;
        ELSE
            -- Otherwise, move the table to sec_financials
            ALTER TABLE analytics.pipeline_execution_log SET SCHEMA sec_financials;
        END IF;
    END IF;
END $$;