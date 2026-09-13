CREATE SCHEMA IF NOT EXISTS analytics;

-- 1. Benchmark Master
CREATE TABLE IF NOT EXISTS analytics.benchmark_master (
    benchmark_id       VARCHAR(64) PRIMARY KEY,
    benchmark_name     TEXT NOT NULL UNIQUE,
    benchmark_provider VARCHAR(64),
    benchmark_type     VARCHAR(32) DEFAULT 'Broad Market'
);

-- 2. Fund Master
CREATE TABLE IF NOT EXISTS analytics.fund_master (
    fund_id               BIGSERIAL PRIMARY KEY,
    series_id             VARCHAR(10) NOT NULL UNIQUE,
    cik                   INTEGER NOT NULL,
    fund_name             TEXT NOT NULL,
    fund_family           TEXT,
    investment_objective  TEXT,
    strategy_narrative    TEXT,
    strategy_type         VARCHAR(20) NOT NULL, -- 'ACTIVE', 'PASSIVE', 'HYBRID', 'UNKNOWN'
    benchmark_id          VARCHAR(64) REFERENCES analytics.benchmark_master(benchmark_id),
    benchmark_name        TEXT,
    created_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Reporting Period / AUM
CREATE TABLE IF NOT EXISTS analytics.fund_reporting (
    report_id          BIGSERIAL PRIMARY KEY,
    series_id          VARCHAR(10) NOT NULL REFERENCES analytics.fund_master(series_id) ON DELETE CASCADE,
    report_date        DATE NOT NULL,
    net_assets         NUMERIC(18, 2),
    report_year        SMALLINT NOT NULL,
    report_quarter     SMALLINT NOT NULL,
    created_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_fund_reporting UNIQUE (series_id, report_year, report_quarter)
);

-- 4. Holdings
CREATE TABLE IF NOT EXISTS analytics.holding (
    holding_id         BIGSERIAL PRIMARY KEY,
    report_id          BIGINT NOT NULL REFERENCES analytics.fund_reporting(report_id) ON DELETE CASCADE,
    security_name      TEXT NOT NULL,
    cusip              VARCHAR(9),
    ticker             VARCHAR(10),
    issuer             TEXT,
    country            VARCHAR(3),
    currency           VARCHAR(3),
    shares             NUMERIC(18, 4),
    market_value       NUMERIC(18, 2),
    weight_percentage  NUMERIC(6, 4)
);

-- Supporting Indexes for API Queries
CREATE INDEX IF NOT EXISTS idx_fund_master_cik ON analytics.fund_master(cik);
CREATE INDEX IF NOT EXISTS idx_fund_master_strategy ON analytics.fund_master(strategy_type);
CREATE INDEX IF NOT EXISTS idx_fund_master_benchmark ON analytics.fund_master(benchmark_id);
CREATE INDEX IF NOT EXISTS idx_holding_report_id ON analytics.holding(report_id);