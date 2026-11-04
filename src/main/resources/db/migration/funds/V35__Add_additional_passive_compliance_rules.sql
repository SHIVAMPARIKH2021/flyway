INSERT INTO analytics.compliance_rules (rule_name, priority, is_active, is_regex, pattern, target_strategy, created_by, modified_by, created_at, updated_at)
VALUES
    ('PASSIVE: Match the performance', 14, TRUE, TRUE, '(?i)\bmatch(?:es|ing)?\s+the\s+performance\s+of\b', 'PASSIVE', 'SYSTEM', 'SYSTEM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('PASSIVE: Correlation between performance and index', 15, TRUE, TRUE, '(?i)\bcorrelation\s+between\s+its\s+performance\b', 'PASSIVE', 'SYSTEM', 'SYSTEM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('PASSIVE: Proportion to weight', 16, TRUE, TRUE, '(?i)\bin\s+proportion\s+to\s+their\s+weighting\b', 'PASSIVE', 'SYSTEM', 'SYSTEM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
    ('PASSIVE: Seeks to match', 17, TRUE, TRUE, '(?i)\bseeks?\s+to\s+match\b', 'PASSIVE', 'SYSTEM', 'SYSTEM', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
ON CONFLICT DO NOTHING;