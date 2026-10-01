CREATE SCHEMA IF NOT EXISTS analytics;

CREATE TABLE IF NOT EXISTS analytics.benchmark_provider_rules (
    rule_id             SERIAL PRIMARY KEY,
    pattern             VARCHAR(128) NOT NULL,
    provider_name       VARCHAR(64) NOT NULL,
    default_type        VARCHAR(32) NOT NULL DEFAULT 'Broad Market',
    priority            INTEGER NOT NULL DEFAULT 100,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    created_by          VARCHAR(64) NOT NULL DEFAULT 'SYSTEM',
    created_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by          VARCHAR(64) NOT NULL DEFAULT 'SYSTEM',
    updated_at          TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_benchmark_rule_pattern UNIQUE (pattern)
);

CREATE INDEX IF NOT EXISTS idx_bm_rules_active_prio
    ON analytics.benchmark_provider_rules(is_active, priority ASC);

-- Comprehensive Seed Rules covering standard domestic, global, fixed-income, and thematic index providers
INSERT INTO analytics.benchmark_provider_rules
(pattern, provider_name, default_type, priority, created_by, updated_by)
VALUES
-- S&P Dow Jones Indices (Equities, Factor, Multi-Asset, Style)
('SP500|S&P\\s*500|Standard\\s*&\\s*Poor''?s?\\s*500', 'S&P Dow Jones Indices', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('S&P\\s*(Completion|1000|1500|MidCap|SmallCap|Total)', 'S&P Dow Jones Indices', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('S&P\\s*(GSCI|Select|Sector|Target|Global|Dividend|Dividend\\s*Aristocrats)', 'S&P Dow Jones Indices', 'Category / Secondary', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Dow\\s*Jones|DJIA|DJ\\s*U\\.S\\.', 'S&P Dow Jones Indices', 'Broad Market', 25, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('SPGlobal|S&P', 'S&P Dow Jones Indices', 'Broad Market', 90, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- FTSE Russell (Broad, Style, Size, UK, Global)
('Russell\\s*3000', 'FTSE Russell', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Russell\\s*(1000|2000|2500)', 'FTSE Russell', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Russell\\s*(Growth|Value|Defensive|Dynamic|Microcap)', 'FTSE Russell', 'Category / Secondary', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('FTSE\\s*(All-World|Global|Developed|Emerging|100|250|All-Share)', 'FTSE Russell', 'Broad Market', 30, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Russell|FTSE', 'FTSE Russell', 'Broad Market', 95, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- Bloomberg Fixed Income & Commodities (including legacy Barclays/Lehman references)
('Bloomberg\\s*(U\\.?S\\.?|US)?\\s*(Aggregate|Agg)', 'Bloomberg', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Barclays\\s*(U\\.?S\\.?|US)?\\s*(Aggregate|Agg)', 'Bloomberg', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Bloomberg\\s*(Global\\s*Aggregate|Multiverse|Universal)', 'Bloomberg', 'Broad Market', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Bloomberg\\s*(Treasury|Govt|Government|Credit|Corporate|High\\s*Yield|TIPS|MBS|Municipal)', 'Bloomberg', 'Category / Secondary', 25, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Bloomberg\\s*Commodity|BCOM', 'Bloomberg', 'Category / Secondary', 30, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Bloomberg|Barclays', 'Bloomberg', 'Broad Market', 96, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- MSCI (Global Developed, Emerging, Regional, Factor, ESG)
('MSCI\\s*(ACWI|World|All\\s*Country\\s*World)', 'MSCI', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('MSCI\\s*(USA|US\\s*Broad|US\\s*Prime|US\\s*Small)', 'MSCI', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('MSCI\\s*(EAFE|EM|Emerging\\s*Markets|Europe|Pacific)', 'MSCI', 'Broad Market', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('MSCI\\s*(Frontier|Kokusai|Factor|Minimum\\s*Volatility|ESG|Select|Thematic)', 'MSCI', 'Category / Secondary', 25, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('MSCI', 'MSCI', 'Broad Market', 97, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- CRSP (Center for Research in Security Prices - Dominant in Vanguard index mutual funds)
('CRSP\\s*US\\s*Total\\s*Market', 'CRSP', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('CRSP\\s*US\\s*(Large\\s*Cap|Mid\\s*Cap|Small\\s*Cap|Mega\\s*Cap|Micro\\s*Cap)', 'CRSP', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('CRSP\\s*US\\s*(Growth|Value)', 'CRSP', 'Category / Secondary', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('CRSP', 'CRSP', 'Broad Market', 98, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- ICE Data Indices / BofA Merrill Lynch (Fixed Income, Treasuries, High Yield, Preferreds)
('ICE\\s*BofA\\s*(U\\.?S\\.?|US)?\\s*(Broad\\s*Market|Treasury|Master)', 'ICE Data Indices', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('BofA\\s*Merrill\\s*Lynch\\s*(U\\.?S\\.?|US)?\\s*Broad\\s*Market', 'ICE Data Indices', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('ICE\\s*(BofA|U\\.?S\\.?\\s*Treasury|Eurodollar|High\\s*Yield|Preferred|Bond)', 'ICE Data Indices', 'Category / Secondary', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('ICE|BofA|Merrill\\s*Lynch', 'ICE Data Indices', 'Category / Secondary', 99, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- Nasdaq Indices
('Nasdaq-?100|NDX', 'Nasdaq', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Nasdaq\\s*Composite|Nasdaq\\s*Total\\s*Market', 'Nasdaq', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Nasdaq\\s*(Biotechnology|Clean\\s*Edge|Internet|Dividend|Next\\s*Gen)', 'Nasdaq', 'Category / Secondary', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Nasdaq', 'Nasdaq', 'Broad Market', 100, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- Morningstar Indexes
('Morningstar\\s*US\\s*(Market|Large-Mid|Target\\s*Market)', 'Morningstar', 'Broad Market', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Morningstar\\s*(Category|Style|Wide\\s*Moat|Dividend|Sustainability|Sector)', 'Morningstar', 'Category / Secondary', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Morningstar', 'Morningstar', 'Category / Secondary', 101, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- Lipper (Refinitiv / LSEG Peer Averages)
('Lipper\\s*(General\\s*Equity|Core|Large-Cap|Global|Balanced)', 'Lipper', 'Category / Secondary', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Lipper', 'Lipper', 'Category / Secondary', 102, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- Wilshire Associates
('Wilshire\\s*5000', 'Wilshire Associates', 'Broad Market', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Wilshire\\s*(4500|Target|Mid\\s*Cap|Small\\s*Cap|REIT)', 'Wilshire Associates', 'Category / Secondary', 20, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Wilshire', 'Wilshire Associates', 'Broad Market', 103, 'SEED_MIGRATION', 'SEED_MIGRATION'),

-- Short-term Cash, Inflation & Treasury Benchmarks
('ICE\\s*LIBOR|LIBOR|SOFR|Secured\\s*Overnight\\s*Financing\\s*Rate', 'Federal Reserve / ICE', 'Cash / Alternative', 10, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('Fed\\s*Funds|Federal\\s*Funds|U\\.?S\\.?\\s*Treasury\\s*Bill|3-Month\\s*T-Bill', 'U.S. Department of the Treasury', 'Cash / Alternative', 15, 'SEED_MIGRATION', 'SEED_MIGRATION'),
('CPI|Consumer\\s*Price\\s*Index', 'Bureau of Labor Statistics', 'Cash / Alternative', 20, 'SEED_MIGRATION', 'SEED_MIGRATION')
ON CONFLICT (pattern) DO UPDATE SET
    provider_name = EXCLUDED.provider_name,
    default_type  = EXCLUDED.default_type,
    priority      = EXCLUDED.priority,
    updated_at    = CURRENT_TIMESTAMP;