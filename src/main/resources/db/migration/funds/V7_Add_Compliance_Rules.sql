INSERT INTO analytics.compliance_rules (
    rule_name,
    pattern,
    is_regex,
    target_strategy,
    priority,
    is_active,
    created_by,
    modified_by,
    created_date,
    modified_date
) VALUES
-- ============================================================================
-- PRIORITY 1: EXCLUSIONS & NEGATIONS (Overrides false positives)
-- ============================================================================
(
    'Negation: Does Not Seek To Replicate',
    '\bdoes not seek to replicate\b',
    TRUE,
    'EXCLUDE',
    10,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Negation: Not An Index Fund',
    '\bnot an index fund\b',
    TRUE,
    'EXCLUDE',
    11,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Negation: Does Not Track',
    '\bdoes not track\b',
    TRUE,
    'EXCLUDE',
    12,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Negation: Not Managed To An Index',
    '\bnot managed to an index\b',
    TRUE,
    'EXCLUDE',
    13,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),

-- ============================================================================
-- PRIORITY 2: CORE PASSIVE RULES (Index tracking / replication phrases)
-- ============================================================================
(
    'Passive: Track Performance of Index',
    '\btracks?(?:ing)?\s+the\s+performance\s+of\b',
    TRUE,
    'PASSIVE',
    20,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Replicate Index/Benchmark',
    '\breplicates?(?:ing)?\s+(?:the\s+)?(?:benchmark|index)\b',
    TRUE,
    'PASSIVE',
    21,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Seeks To Track',
    '\bseeks?\s+to\s+track\b',
    TRUE,
    'PASSIVE',
    22,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Indexing Investment Approach',
    '\bindexing\s+(?:investment\s+)?approach\b',
    TRUE,
    'PASSIVE',
    23,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Corresponds Generally To Index',
    '\bcorresponds?\s+(?:generally\s+)?to\s+(?:the\s+)?(?:price\s+and\s+yield\s+performance|performance|index)\b',
    TRUE,
    'PASSIVE',
    24,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Passively Managed',
    '\bpassively\s+managed\b',
    TRUE,
    'PASSIVE',
    25,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Index Fund Strategy',
    '\bindex\s+fund\b',
    TRUE,
    'PASSIVE',
    26,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Full Replication Technique',
    '\bfull\s+replication\b',
    TRUE,
    'PASSIVE',
    27,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Representative Sampling Technique',
    '\brepresentative\s+sampling\b',
    TRUE,
    'PASSIVE',
    28,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Passive: Track An Underlying Index',
    '\btrack\s+an\s+underlying\s+index\b',
    TRUE,
    'PASSIVE',
    29,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),

-- ============================================================================
-- PRIORITY 3: CORE ACTIVE RULES (Research, stock picking, discretion)
-- ============================================================================
(
    'Active: Actively Managed',
    '\bactively\s+managed\b',
    TRUE,
    'ACTIVE',
    30,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Security Selection',
    '\bsecurity\s+selection\b',
    TRUE,
    'ACTIVE',
    31,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Fundamental Analysis / Research',
    '\bfundamental\s+(?:analysis|research)\b',
    TRUE,
    'ACTIVE',
    32,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Manager Discretion',
    '\bmanager(?:\x27s)?\s+discretion\b',
    TRUE,
    'ACTIVE',
    33,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Research-Driven Strategy',
    '\bresearch[\s-]driven\b',
    TRUE,
    'ACTIVE',
    34,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Stock Selection by Advisor',
    '\bstock\s+selection\b',
    TRUE,
    'ACTIVE',
    35,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Seeks Capital Appreciation by Selecting',
    '\bseeks?\s+capital\s+appreciation\s+by\s+selecting\b',
    TRUE,
    'ACTIVE',
    36,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Manager Uses Bottom-Up or Top-Down',
    '\b(?:bottom-up|top-down)\s+(?:fundamental\s+)?analysis\b',
    TRUE,
    'ACTIVE',
    37,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Active Trading Strategy',
    '\bactive\s+trading\s+strategy\b',
    TRUE,
    'ACTIVE',
    38,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
),
(
    'Active: Seeks To Outperform Benchmark',
    '\bseeks?\s+to\s+outperform\s+(?:the\s+)?(?:benchmark|index)\b',
    TRUE,
    'ACTIVE',
    39,
    TRUE,
    'SYSTEM',
    'SYSTEM',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);