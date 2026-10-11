-- 1. Ingestion Control / Batch Dimension
CREATE TABLE IF NOT EXISTS sec_financials.quarter_config (
    id         SERIAL PRIMARY KEY,
    year       INTEGER NOT NULL,
    quarter    INTEGER NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    is_active  BOOLEAN NOT NULL DEFAULT TRUE,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(50) DEFAULT 'SYSTEM',
    CONSTRAINT uq_quarter_config_year_quarter UNIQUE (year, quarter)
);

-- 2. Submissions: Bind directly to the ingestion batch
ALTER TABLE sec_financials.submissions
    ADD COLUMN IF NOT EXISTS quarter_id INTEGER
    REFERENCES sec_financials.quarter_config(id) ON DELETE CASCADE;

CREATE INDEX IF NOT EXISTS idx_submissions_quarter_id
    ON sec_financials.submissions(quarter_id);

-- 3. Taxonomy Tags: Keep taxonomy_tags purely as the global concept catalog
-- Do NOT put loose quarter/year on the primary entity.
-- Instead, track quarterly provenance via an association bridge table:
CREATE TABLE IF NOT EXISTS sec_financials.quarter_taxonomy_tags (
    quarter_id INTEGER NOT NULL REFERENCES sec_financials.quarter_config(id) ON DELETE CASCADE,
    tag        TEXT NOT NULL,
    version    TEXT NOT NULL,
    PRIMARY KEY (quarter_id, tag, version),
    FOREIGN KEY (tag, version) REFERENCES sec_financials.taxonomy_tags(tag, version) ON DELETE CASCADE
);