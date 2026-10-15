ALTER TABLE analytics.benchmark_master
ADD COLUMN IF NOT EXISTS accession_number VARCHAR(20);

ALTER TABLE analytics.fund_master
ADD COLUMN IF NOT EXISTS accession_number VARCHAR(20);