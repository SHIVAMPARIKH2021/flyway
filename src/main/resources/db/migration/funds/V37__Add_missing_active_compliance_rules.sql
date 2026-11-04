-- Migration: Add missing active management patterns to compliance_rules
INSERT INTO analytics.compliance_rules (priority, rule_name, is_active, is_regex, pattern, target_strategy, created_at, created_by, updated_at, modified_by)
VALUES
    -- 1. Vanguard & Institutional Active Management clauses (107 funds)
    (40, 'ACTIVE: Active management clause', TRUE, TRUE, '(?i)\bactive\s+management(?:\s+(?:approach|strategy|style|technique|process))?\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM'),

    -- 2. Active verbs (actively manages, actively selects, actively allocates) (91 funds)
    (41, 'ACTIVE: Active verbs', TRUE, TRUE, '(?i)\bactively\s+(?:manages?|managing|selects?|selecting|allocates?|allocating)\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM'),

    -- 3. Fundamental research & analysis methodologies (180 funds)
    (42, 'ACTIVE: Research and analysis methodologies', TRUE, TRUE, '(?i)\b(?:bottom-up|top-down)\s+(?:approach|fundamental|research|analysis|stock\s+selection)\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM'),
    (43, 'ACTIVE: Fundamental research and analysis clause', TRUE, TRUE, '(?i)\bfundamental(?:ly)?\s+(?:bottom-up|research|analysis|credit\s+analysis|investment\s+process)\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM'),

    -- 4. SEC Active & frequent trading clause (115 funds)
    (44, 'ACTIVE: Active trading clause', TRUE, TRUE, '(?i)\bactive\s+and\s+frequent\s+trading\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM'),

    -- 5. Discretionary, outperformance, and proprietary models (95 funds)
    (45, 'ACTIVE: Discretionary, outperformance, and proprietary models', TRUE, TRUE, '(?i)\b(?:seeks?\s+to\s+outperform|discretionary\s+(?:management|approach|basis)|proprietary\s+(?:quantitative\s+)?(?:selection\s+)?model)\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM'),

    -- 6. Professional manager selection / asset allocation decisions (773 funds)
    (46, 'ACTIVE: Professional manager selection / asset allocation decisions', TRUE, TRUE, '(?i)\b(?:subadviser|sub-adviser|portfolio\s+managers?|adviser|advisor)\s+(?:independently\s+)?(?:selects?|evaluates?|identifies)\s+(?:and\s+maintains\s+)?(?:a\s+portfolio|securities|investments|stocks|bonds)\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM'),
    (47, 'Professional manager selection / asset allocation decisions', TRUE, TRUE, '(?i)\basset\s+allocation\s+decisions?\s+(?:made\s+by|of)\b', 'ACTIVE', CURRENT_TIMESTAMP, 'SYSTEM', CURRENT_TIMESTAMP, 'SYSTEM')
ON CONFLICT DO NOTHING;