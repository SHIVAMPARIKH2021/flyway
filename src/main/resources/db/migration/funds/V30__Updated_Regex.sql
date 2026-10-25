-- 1. Update Rule 1 to match written-out numbers and spaced variations
-- Covers: "S P Five Hundred", "S&P 500", "S P 500", "Standard & Poor's Five Hundred", "SP500"
UPDATE analytics.benchmark_provider_rules
SET pattern = 'SP\s*500|S\s*&?\s*P\s*(?:500|Five\s*Hundred)|Standard\s*&?\s*Poor''?s?\s*(?:500|Five\s*Hundred)',
    updated_by = 'MANUAL_MIGRATION',
    updated_at = CURRENT_TIMESTAMP
WHERE rule_id = 1;

-- 2. Update Rule 11 to match space-separated "U S" without periods
-- Covers: "Bloomberg U S Aggregate Bond Index", "Bloomberg U.S. Agg", "Bloomberg Aggregate", "Bloomberg US Aggregate"
UPDATE analytics.benchmark_provider_rules
SET pattern = 'Bloomberg\s*(?:U\.?\s*S\.?|US)?\s*(?:Aggregate|Agg)',
    updated_by = 'MANUAL_MIGRATION',
    updated_at = CURRENT_TIMESTAMP
WHERE rule_id = 11;