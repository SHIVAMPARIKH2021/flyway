ALTER TABLE analytics.fund_master
    DROP CONSTRAINT IF EXISTS fund_master_benchmark_id_fkey;


ALTER TABLE analytics.benchmark_master
    ALTER COLUMN benchmark_id TYPE UUID
    USING benchmark_id::uuid;

ALTER TABLE analytics.fund_master
    ALTER COLUMN benchmark_id TYPE UUID
    USING benchmark_id::uuid;

ALTER TABLE analytics.fund_master
    ADD CONSTRAINT fund_master_benchmark_id_fkey
    FOREIGN KEY (benchmark_id)
    REFERENCES analytics.benchmark_master(benchmark_id)
    ON DELETE SET NULL;


CREATE INDEX IF NOT EXISTS idx_fund_master_benchmark
    ON analytics.fund_master(benchmark_id);