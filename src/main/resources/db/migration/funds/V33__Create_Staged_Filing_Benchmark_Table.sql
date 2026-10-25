-- Create staging table for filing-to-benchmark resolution across batch steps
CREATE TABLE IF NOT EXISTS analytics.staged_filing_benchmark (
    accession_number VARCHAR(25) NOT NULL,
    benchmark_id     INT NOT NULL,
    created_at       TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_staged_filing_benchmark
        PRIMARY KEY (accession_number, benchmark_id),

    CONSTRAINT fk_sfb_benchmark_master
        FOREIGN KEY (benchmark_id)
        REFERENCES analytics.benchmark_master(benchmark_id)
        ON DELETE CASCADE
);

-- Fast lookup index for step 3 loading
CREATE INDEX IF NOT EXISTS idx_sfb_accession_number
    ON analytics.staged_filing_benchmark (accession_number);