ALTER TABLE analytics.fund_master
    ADD COLUMN reporting_cadence VARCHAR(20) DEFAULT 'ANNUAL',
    ADD COLUMN has_daily_pricing BOOLEAN DEFAULT TRUE,
    ADD COLUMN has_quarterly_holdings BOOLEAN DEFAULT TRUE;