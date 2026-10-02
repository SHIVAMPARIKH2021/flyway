-- Ensure the target schema exists
CREATE SCHEMA IF NOT EXISTS sec_financials;

-- Move table to the target schema (replace <current_schema> with its current location, e.g. public or analytics)
ALTER TABLE analytics.pipeline_execution_log
    SET SCHEMA sec_financials;