ALTER TABLE analytics.fund_master
    ADD COLUMN IF NOT EXISTS coverage_tier VARCHAR(25) NOT NULL DEFAULT 'ANNUAL_PROSPECTUS'
        CHECK (coverage_tier IN ('ANNUAL_PROSPECTUS', 'QUARTERLY_PORTFOLIO', 'DAILY_REALTIME'));

COMMENT ON COLUMN analytics.fund_master.coverage_tier IS
'Defines UI refresh expectation: ANNUAL_PROSPECTUS (MFRR N-1A), QUARTERLY_PORTFOLIO (N-PORT holdings), DAILY_REALTIME (ETF Baskets/Daily NAV)';