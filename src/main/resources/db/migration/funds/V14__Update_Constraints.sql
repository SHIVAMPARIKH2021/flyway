ALTER TABLE analytics.fund_master
    DROP CONSTRAINT IF EXISTS fund_master_pkey,
    DROP CONSTRAINT IF EXISTS uq_fund_master_series_benchmark;

ALTER TABLE analytics.fund_master
    ADD CONSTRAINT uq_fund_master_series_benchmark
    UNIQUE NULLS NOT DISTINCT (series_id, benchmark_id);