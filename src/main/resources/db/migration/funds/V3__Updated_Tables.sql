-- ============================================================================
-- 1. Alter submissions (Drop corporate fields, add prospectus date fields)
-- ============================================================================
ALTER TABLE sec_financials.submissions
    DROP COLUMN IF EXISTS sic,
    DROP COLUMN IF EXISTS period,
    DROP COLUMN IF EXISTS fy,
    DROP COLUMN IF EXISTS fp,
    DROP COLUMN IF EXISTS afs,
    DROP COLUMN IF EXISTS wksi,
    DROP COLUMN IF EXISTS prevrpt,
    DROP COLUMN IF EXISTS detail;

ALTER TABLE sec_financials.submissions
    ADD COLUMN IF NOT EXISTS pdate DATE,
    ADD COLUMN IF NOT EXISTS effdate DATE;

-- Expand variable-length columns to TEXT
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
-- 2. Alter taxonomy_tags (Unbound types and drop obsolete fields)
-- ============================================================================
ALTER TABLE sec_financials.taxonomy_tags
    DROP COLUMN IF EXISTS crdr;

ALTER TABLE sec_financials.taxonomy_tags
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT,
    ALTER COLUMN datatype TYPE TEXT;


-- ============================================================================
-- 3. Alter numeric_facts (Unbound dimensions and tags)
-- ============================================================================
ALTER TABLE sec_financials.numeric_facts
    DROP COLUMN IF EXISTS qtrs,
    DROP COLUMN IF EXISTS dimh,
    DROP COLUMN IF EXISTS coreg,
    DROP COLUMN IF EXISTS durp,
    DROP COLUMN IF EXISTS datp;

-- Add dimensions as unbounded TEXT
ALTER TABLE sec_financials.numeric_facts
    ADD COLUMN IF NOT EXISTS series TEXT,
    ADD COLUMN IF NOT EXISTS class TEXT,
    ADD COLUMN IF NOT EXISTS measure TEXT,
    ADD COLUMN IF NOT EXISTS document TEXT,
    ADD COLUMN IF NOT EXISTS otherdims TEXT;

-- Convert existing columns to TEXT to prevent truncation
ALTER TABLE sec_financials.numeric_facts
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT,
    ALTER COLUMN uom TYPE TEXT;

ALTER TABLE sec_financials.numeric_facts
    DROP CONSTRAINT IF EXISTS pk_numeric_facts;


-- ============================================================================
-- 4. Alter text_disclosures (Unbound all text & context columns)
-- ============================================================================
ALTER TABLE sec_financials.text_disclosures
    DROP COLUMN IF EXISTS qtrs,
    DROP COLUMN IF EXISTS dimh,
    DROP COLUMN IF EXISTS durp,
    DROP COLUMN IF EXISTS datp;

ALTER TABLE sec_financials.text_disclosures
    ADD COLUMN IF NOT EXISTS series TEXT,
    ADD COLUMN IF NOT EXISTS class TEXT,
    ADD COLUMN IF NOT EXISTS measure TEXT,
    ADD COLUMN IF NOT EXISTS document TEXT,
    ADD COLUMN IF NOT EXISTS otherdims TEXT,
    ADD COLUMN IF NOT EXISTS escaped BOOLEAN DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS srclen INTEGER DEFAULT 0,
    ADD COLUMN IF NOT EXISTS txtlen INTEGER DEFAULT 0;

-- Convert version, lang, and context to TEXT (resolves line 82 error)
ALTER TABLE sec_financials.text_disclosures
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT,
    ALTER COLUMN lang TYPE TEXT,
    ALTER COLUMN context TYPE TEXT;

ALTER TABLE sec_financials.text_disclosures
    DROP CONSTRAINT IF EXISTS pk_text_disclosures;


-- ============================================================================
-- 5. Alter presentation_labels (Match lab.tsv layout)
-- ============================================================================
ALTER TABLE sec_financials.presentation_labels
    DROP COLUMN IF EXISTS label,
    DROP COLUMN IF EXISTS role,
    DROP COLUMN IF EXISTS lang;

ALTER TABLE sec_financials.presentation_labels
    ADD COLUMN IF NOT EXISTS std TEXT,
    ADD COLUMN IF NOT EXISTS terse TEXT,
    ADD COLUMN IF NOT EXISTS "verbose" TEXT,
    ADD COLUMN IF NOT EXISTS total TEXT,
    ADD COLUMN IF NOT EXISTS negated TEXT,
    ADD COLUMN IF NOT EXISTS negatedterse TEXT;

ALTER TABLE sec_financials.presentation_labels
    ALTER COLUMN tag TYPE TEXT,
    ALTER COLUMN version TYPE TEXT;


-- ============================================================================
-- 6. Alter calculation_relationships (Match cal.tsv layout)
-- ============================================================================
ALTER TABLE sec_financials.calculation_relationships
    DROP COLUMN IF EXISTS version,
    DROP COLUMN IF EXISTS fromtag,
    DROP COLUMN IF EXISTS totag,
    DROP COLUMN IF EXISTS weight,
    DROP COLUMN IF EXISTS orderg;

ALTER TABLE sec_financials.calculation_relationships
    ADD COLUMN IF NOT EXISTS grp INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS negative SMALLINT DEFAULT 0,
    ADD COLUMN IF NOT EXISTS ptag TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS pversion TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS ctag TEXT NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS cversion TEXT NOT NULL DEFAULT '';

ALTER TABLE sec_financials.calculation_relationships
    ALTER COLUMN grp DROP DEFAULT,
    ALTER COLUMN ptag DROP DEFAULT,
    ALTER COLUMN pversion DROP DEFAULT,
    ALTER COLUMN ctag DROP DEFAULT,
    ALTER COLUMN cversion DROP DEFAULT;


-- ============================================================================
-- 7. Add Indexing for Series/Class Lookups
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_sec_financials_num_series_class
    ON sec_financials.numeric_facts(series, class);

CREATE INDEX IF NOT EXISTS idx_sec_financials_num_tag
    ON sec_financials.numeric_facts(tag);

CREATE INDEX IF NOT EXISTS idx_sec_financials_num_adsh
    ON sec_financials.numeric_facts(adsh);