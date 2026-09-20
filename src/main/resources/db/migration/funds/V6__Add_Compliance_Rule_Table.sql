CREATE TABLE analytics.compliance_rules (
    rule_id          SERIAL PRIMARY KEY,
    rule_name        VARCHAR(100) NOT NULL,
    pattern          TEXT NOT NULL,                    -- Regex pattern or exact keyword
    is_regex         BOOLEAN NOT NULL DEFAULT FALSE,   -- TRUE = compile as regex; FALSE = plain substring
    target_strategy  VARCHAR(20) NOT NULL,             -- 'PASSIVE', 'ACTIVE', 'EXCLUDE'
    priority         INTEGER NOT NULL DEFAULT 100,     -- Lower number = evaluated first
    is_active        BOOLEAN NOT NULL DEFAULT TRUE,
    created_by       VARCHAR(100) NOT NULL,
    modified_by      VARCHAR(100) NOT NULL,
    created_date     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modified_date    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);