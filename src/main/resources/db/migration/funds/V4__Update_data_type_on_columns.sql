-- ============================================================================
-- 1. Unbound submissions
-- ============================================================================
ALTER TABLE sec_financials.submissions
    ALTER COLUMN name TYPE TEXT,
    ALTER COLUMN cityba TYPE TEXT,
    ALTER COLUMN zipba TYPE TEXT,
    ALTER COLUMN bas1 TYPE TEXT,
    ALTER COLUMN bas2 TYPE TEXT,
    ALTER COLUMN baph TYPE TEXT,
    ALTER COLUMN cityma TYPE TEXT,
    ALTER COLUMN zipma TYPE TEXT,
    ALTER COLUMN mas1 TYPE TEXT,
    ALTER COLUMN mas2 TYPE TEXT,
    ALTER COLUMN former TYPE TEXT,
    ALTER COLUMN form TYPE TEXT,
    ALTER COLUMN instance TYPE TEXT,
    ALTER COLUMN aciks TYPE TEXT;

-- ============================================================================
-- 2. Unbound taxonomy_tags
-- ============================================================================
ALTER TABLE sec_financials.taxonomy_tags
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT,
    ALTER COLUMN datatype TYPE TEXT;

-- ============================================================================
-- 3. Unbound numeric_facts (Fixes StringDataRightTruncation)
-- ============================================================================
ALTER TABLE sec_financials.numeric_facts
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT,
    ALTER COLUMN uom TYPE TEXT,
    ALTER COLUMN series TYPE TEXT,
    ALTER COLUMN class TYPE TEXT,
    ALTER COLUMN measure TYPE TEXT,      -- Fixes measure overflow
    ALTER COLUMN document TYPE TEXT,
    ALTER COLUMN otherdims TYPE TEXT;

-- ============================================================================
-- 4. Unbound text_disclosures
-- ============================================================================
ALTER TABLE sec_financials.text_disclosures
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT,
    ALTER COLUMN series TYPE TEXT,
    ALTER COLUMN class TYPE TEXT,
    ALTER COLUMN measure TYPE TEXT,
    ALTER COLUMN document TYPE TEXT,
    ALTER COLUMN otherdims TYPE TEXT,
    ALTER COLUMN lang TYPE TEXT,
    ALTER COLUMN context TYPE TEXT;

-- ============================================================================
-- 5. Unbound presentation_labels
-- ============================================================================
ALTER TABLE sec_financials.presentation_labels
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT;

-- ============================================================================
-- 6. Unbound calculation_relationships
-- ============================================================================
ALTER TABLE sec_financials.calculation_relationships
    ALTER COLUMN ptag TYPE TEXT,
    ALTER COLUMN pversion TYPE TEXT,
    ALTER COLUMN ctag TYPE TEXT,
    ALTER COLUMN cversion TYPE TEXT;