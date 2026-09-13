-- Raw staging table in sec_financials
CREATE TABLE IF NOT EXISTS sec_financials.company_tickers_mf (
    cik       INTEGER NOT NULL,
    series_id VARCHAR(10) NOT NULL,
    class_id  VARCHAR(10) NOT NULL,
    symbol    VARCHAR(10) NOT NULL,
    CONSTRAINT pk_company_tickers_mf PRIMARY KEY (class_id)
);

CREATE INDEX IF NOT EXISTS idx_mf_series_id ON sec_financials.company_tickers_mf(series_id);
CREATE INDEX IF NOT EXISTS idx_mf_symbol ON sec_financials.company_tickers_mf(symbol);

-- Share Class table in analytics (supports multiple tickers per fund series)
CREATE TABLE IF NOT EXISTS analytics.fund_classes (
    class_id   VARCHAR(10) PRIMARY KEY,
    series_id  VARCHAR(10) NOT NULL REFERENCES analytics.fund_master(series_id) ON DELETE CASCADE,
    ticker     VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_analytics_ticker ON analytics.fund_classes(ticker);

ALTER TABLE analytics.fund_master
    ADD COLUMN IF NOT EXISTS primary_ticker VARCHAR(10),
    ADD COLUMN IF NOT EXISTS updated_by VARCHAR(50) DEFAULT NULL;

ALTER TABLE analytics.benchmark_master
    ADD COLUMN IF NOT EXISTS updated_by VARCHAR(50) DEFAULT NULL;

ALTER TABLE analytics.fund_reporting
    ADD COLUMN IF NOT EXISTS updated_by VARCHAR(50) DEFAULT NULL;

ALTER TABLE analytics.holding
    ADD COLUMN IF NOT EXISTS updated_by VARCHAR(50) DEFAULT NULL;