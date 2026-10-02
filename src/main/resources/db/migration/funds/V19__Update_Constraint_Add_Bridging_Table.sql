-- 1. Ensure fund_master retains its unique constraint on series_id
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint
        WHERE conname = 'fund_master_series_id_key'
          AND conrelid = 'analytics.fund_master'::regclass
    ) THEN
        ALTER TABLE analytics.fund_master
            ADD CONSTRAINT fund_master_series_id_key UNIQUE (series_id);
    END IF;
END $$;

-- 2. Create the 1:N bridge table for fund-to-benchmark associations
CREATE TABLE IF NOT EXISTS analytics.fund_benchmark_association (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    series_id         VARCHAR(20) NOT NULL,
    benchmark_id      UUID NOT NULL,
    benchmark_name    TEXT,
    is_primary        BOOLEAN DEFAULT FALSE,
    accession_number  VARCHAR(25),
    created_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_fba_fund_master
        FOREIGN KEY (series_id)
        REFERENCES analytics.fund_master(series_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_fba_benchmark_master
        FOREIGN KEY (benchmark_id)
        REFERENCES analytics.benchmark_master(benchmark_id)
        ON DELETE CASCADE
);

-- 3. Composite unique index on (series_id, benchmark_id) in the bridge table
CREATE UNIQUE INDEX IF NOT EXISTS idx_uq_fba_series_benchmark
ON analytics.fund_benchmark_association (series_id, benchmark_id);

-- 4. Fast lookup index by series_id
CREATE INDEX IF NOT EXISTS idx_fba_series_id
ON analytics.fund_benchmark_association (series_id);