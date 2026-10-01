CREATE TABLE IF NOT EXISTS analytics.pipeline_execution_log (
    log_id                  BIGSERIAL PRIMARY KEY,
    filing_year             INTEGER NOT NULL,
    filing_quarter          INTEGER NOT NULL CHECK (filing_quarter BETWEEN 1 AND 4),

    -- Ingestion Watermark
    ingestion_status        VARCHAR(20) NOT NULL DEFAULT 'NOT_STARTED'
                            CHECK (ingestion_status IN ('NOT_STARTED', 'IN_PROGRESS', 'COMPLETED', 'FAILED')),
    ingestion_records       INTEGER DEFAULT 0,
    ingestion_started_at    TIMESTAMP,
    ingestion_completed_at  TIMESTAMP,
    ingestion_error         TEXT,

    -- Audit Metadata
    created_by              VARCHAR(50),
    created_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_pipeline_year_quarter UNIQUE (filing_year, filing_quarter)
);

CREATE INDEX IF NOT EXISTS idx_pel_year_quarter
    ON analytics.pipeline_execution_log (filing_year, filing_quarter);