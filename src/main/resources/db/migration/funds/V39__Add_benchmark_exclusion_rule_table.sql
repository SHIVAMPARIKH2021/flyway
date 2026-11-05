-- 1. Create exclusion rules table
CREATE TABLE IF NOT EXISTS analytics.benchmark_exclusion_rules (
    rule_id             SERIAL PRIMARY KEY,
    rule_category       VARCHAR(50)  NOT NULL,
    match_type          VARCHAR(20)  NOT NULL,
    pattern             TEXT         NOT NULL,
    description         VARCHAR(255),
    is_active           BOOLEAN      NOT NULL DEFAULT TRUE,
    created_by          VARCHAR(50)  NOT NULL DEFAULT 'SYSTEM',
    created_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Indexes for fast step-initialization caching
CREATE INDEX IF NOT EXISTS idx_excl_rules_active
    ON analytics.benchmark_exclusion_rules (is_active, match_type);

CREATE INDEX IF NOT EXISTS idx_excl_rules_category
    ON analytics.benchmark_exclusion_rules (rule_category);

-- 3. Populate existing rules from YAML configurations
INSERT INTO analytics.benchmark_exclusion_rules
    (rule_category, match_type, pattern, description)
VALUES
    -- TAX_ADJUSTMENT (Substring / Regex)
    ('TAX_ADJUSTMENT', 'CONTAINS', 'after-tax', 'Catches hyphenated after-tax lines'),
    ('TAX_ADJUSTMENT', 'CONTAINS', 'after tax', 'Catches spaced after tax lines'),
    ('TAX_ADJUSTMENT', 'CONTAINS', 'aftertax', 'Catches concatenated aftertax lines'),
    ('TAX_ADJUSTMENT', 'CONTAINS', 'before tax', 'Catches spaced before tax lines'),
    ('TAX_ADJUSTMENT', 'CONTAINS', 'beforetax', 'Catches concatenated beforetax lines'),
    ('TAX_ADJUSTMENT', 'CONTAINS', 'return without a sales load', 'SEC sales load return adjustment'),
    ('TAX_ADJUSTMENT', 'CONTAINS', 'return with a sales load', 'SEC sales load return adjustment'),

    -- XBRL_SCHEMA_TAG (Exact / Substring)
    ('XBRL_SCHEMA_TAG', 'CONTAINS', 'PerformanceTable', 'Leaked performance table tag names'),
    ('XBRL_SCHEMA_TAG', 'CONTAINS', 'IndexNoDeduction', 'Leaked index no deduction tag names'),
    ('XBRL_SCHEMA_TAG', 'CONTAINS', 'AverageAnnual', 'Leaked average annual return tag names'),
    ('XBRL_SCHEMA_TAG', 'CONTAINS', 'AvgAnnlRtr', 'Leaked abbreviated average annual return tags'),

    -- INTERNAL_TAXONOMY_CODE (Regex / Exact)
    ('INTERNAL_TAXONOMY_CODE', 'REGEX', '^(?:Index)?(?:[A-Z]{1,6}\d{1,5}|Index\d+)(?:Member)?$', 'Filer member codes (LB001, SP001, MS001, RS001, F0001, MATSON1, Index1)'),
    ('INTERNAL_TAXONOMY_CODE', 'REGEX', '^IX[A-Z0-9]{3,5}$', 'Workiva and Donnelley XBRL element hash codes'),
    ('INTERNAL_TAXONOMY_CODE', 'REGEX', '^[A-Z]{2,6}Index\d+$', 'Concatenated filer index tags (AQIndex1, B6FM1)'),
    ('INTERNAL_TAXONOMY_CODE', 'EXACT', 'kavingety', 'BlackRock custom taxonomy member without label linkbase'),

    -- NUMERIC_NOISE (Regex)
    ('NUMERIC_NOISE', 'REGEX', '^[0-9.,%$* -]+$', 'Pure numeric values, percentages, footnote asterisks'),
    ('NUMERIC_NOISE', 'REGEX', '^\d{1,2}/\d{1,2}/\d{2,4}$', 'Footnote date columns (e.g. 5/28/2021)'),
    ('NUMERIC_NOISE', 'REGEX', '^(?:19|20)\d{2}$', 'Standalone 4-digit calendar years'),

    -- TIME_PERIOD_HEADER (Regex)
    ('TIME_PERIOD_HEADER', 'REGEX', '^\d{1,2}[\s-]*(?:years?|yrs?)$', 'Return interval column headers (1 Year, 5 Yrs, 10-Year)'),
    ('TIME_PERIOD_HEADER', 'REGEX', '^(?:since\s+inception|life\s+of\s+fund)$', 'Inception column headers'),

    -- SHARE_CLASS (Regex / Starts With)
    ('SHARE_CLASS', 'REGEX', '^C\d{8,10}$', 'SEC Class identifiers (LegalEntityAxis)'),
    ('SHARE_CLASS', 'REGEX', '^class\s+[a-z0-9]+$', 'Share class row titles (Class A, Class C)'),
    ('SHARE_CLASS', 'EXACT', 'investor class', 'Share class row title'),
    ('SHARE_CLASS', 'REGEX', '^institutional\s+(?:class|shares)$', 'Share class row title'),

    -- FEE_AND_EXPENSE (Starts With / Contains)
    ('FEE_AND_EXPENSE', 'CONTAINS', 'fee waiver', 'Fee table waiver line items'),
    ('FEE_AND_EXPENSE', 'CONTAINS', 'operating expense', 'Operating expense table lines'),
    ('FEE_AND_EXPENSE', 'CONTAINS', '12b-1', '12b-1 distribution and service fees'),
    ('FEE_AND_EXPENSE', 'CONTAINS', 'management fee', 'Management fee table rows'),
    ('FEE_AND_EXPENSE', 'CONTAINS', 'redemption fee', 'Redemption fee lines'),
    ('FEE_AND_EXPENSE', 'STARTS_WITH', 'sales charge', 'Sales charge table rows'),
    ('FEE_AND_EXPENSE', 'STARTS_WITH', 'deferred sales', 'Deferred sales load rows'),
    ('FEE_AND_EXPENSE', 'STARTS_WITH', 'maximum sales charge', 'Maximum sales charge rows');