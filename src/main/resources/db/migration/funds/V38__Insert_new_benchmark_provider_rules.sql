INSERT INTO analytics.benchmark_provider_rules
(pattern, provider_name, default_type, priority, is_active, created_by, created_at, updated_by, updated_at)
values
('(?i)\b(?:s\s*(?:&|and)\s*p|standard\s*(?:&|and)\s*poor|dow\s*jones|s\s*p\b|sp(?=\d{2,4}))', 'S&P Dow Jones Indices', 'Broad Market', 1, true, 'SEED_MIGRATION', CURRENT_TIMESTAMP, 'SEED_MIGRATION', CURRENT_TIMESTAMP),
('(?i)\b(?:m\s*s\s*c\s*i|msci\w*)', 'MSCI', 'Broad Market', 2, true, 'SEED_MIGRATION', CURRENT_TIMESTAMP, 'SEED_MIGRATION', CURRENT_TIMESTAMP),
('(?i)\b(?:russell\w*|f\s*t\s*s\s*e|ftse\w*)', 'FTSE Russell', 'Broad Market', 3, true, 'SEED_MIGRATION', CURRENT_TIMESTAMP, 'SEED_MIGRATION', CURRENT_TIMESTAMP),
('(?i)\b(?:i\s*c\s*e|ice\w*|bofa|merrill\s*lynch)', 'ICE Data Services', 'Broad Market', 4, true, 'SEED_MIGRATION', CURRENT_TIMESTAMP, 'SEED_MIGRATION', CURRENT_TIMESTAMP),
('(?i)\b(?:bloomberg\w*|barclays\w*)', 'Bloomberg', 'Broad Market', 5, true, 'SEED_MIGRATION', CURRENT_TIMESTAMP, 'SEED_MIGRATION', CURRENT_TIMESTAMP);