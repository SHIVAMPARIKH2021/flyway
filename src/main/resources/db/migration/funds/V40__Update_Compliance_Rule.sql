UPDATE analytics.compliance_rules
SET target_strategy = 'ACTIVE'
WHERE target_strategy = 'EXCLUDE'
  AND is_active = TRUE;