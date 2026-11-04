DO $$
BEGIN
TRUNCATE TABLE analytics.staged_filing_benchmark;

ALTER TABLE analytics.staged_filing_benchmark
DROP CONSTRAINT IF EXISTS pk_staged_filing_benchmark;

ALTER TABLE analytics.staged_filing_benchmark
ADD COLUMN IF NOT EXISTS series_id VARCHAR(20) NOT NULL;

ALTER TABLE analytics.staged_filing_benchmark
ADD PRIMARY KEY (accession_number, series_id, benchmark_id);
END $$;