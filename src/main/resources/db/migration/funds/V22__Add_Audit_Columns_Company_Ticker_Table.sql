ALTER TABLE sec_financials.company_tickers_mf
    ADD COLUMN IF NOT EXISTS is_active   BOOLEAN NOT NULL DEFAULT TRUE,
    ADD COLUMN IF NOT EXISTS first_seen  TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ADD COLUMN IF NOT EXISTS last_seen   TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- Natural unique constraint to enable idempotent upserts:
-- One CIK + Series + Class owns a Symbol
CREATE UNIQUE INDEX IF NOT EXISTS uq_company_tickers_mf_identity
ON sec_financials.company_tickers_mf (cik, series_id, class_id, symbol);

CREATE INDEX IF NOT EXISTS idx_company_tickers_mf_active
ON sec_financials.company_tickers_mf (symbol, is_active);