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

-- Expand instance column to handle longer XML filenames safely
ALTER TABLE sec_financials.submissions
    ALTER COLUMN instance TYPE VARCHAR(64);


-- ============================================================================
-- 2. Alter taxonomy_tags (Adjust column widths and drop obsolete fields)
-- ============================================================================
ALTER TABLE sec_financials.taxonomy_tags
    DROP COLUMN IF EXISTS crdr;

ALTER TABLE sec_financials.taxonomy_tags
    ALTER COLUMN version TYPE VARCHAR(40),
    ALTER COLUMN datatype TYPE VARCHAR(40);


-- ============================================================================
-- 3. Alter numeric_facts (Replace corporate period fields with fund dimensions)
-- ============================================================================
-- Drop corporate period and dimension columns
ALTER TABLE sec_financials.numeric_facts
    DROP COLUMN IF EXISTS qtrs,
    DROP COLUMN IF EXISTS dimh,
    DROP COLUMN IF EXISTS coreg,
    DROP COLUMN IF EXISTS durp,
    DROP COLUMN IF EXISTS datp;

-- Add Risk/Return specific dimensions (series, class, measure, etc.)
ALTER TABLE sec_financials.numeric_facts
    ADD COLUMN IF NOT EXISTS series VARCHAR(40),
    ADD COLUMN IF NOT EXISTS class VARCHAR(40),
    ADD COLUMN IF NOT EXISTS measure VARCHAR(128),
    ADD COLUMN IF NOT EXISTS document VARCHAR(128),
    ADD COLUMN IF NOT EXISTS otherdims TEXT;

-- Adjust column lengths for fund taxonomy versions and UOMs
ALTER TABLE sec_financials.numeric_facts
    ALTER COLUMN version TYPE VARCHAR(40),
    ALTER COLUMN uom TYPE VARCHAR(40);

-- If a primary key constraint exists from the corporate schema, drop and recreate it
ALTER TABLE sec_financials.numeric_facts
    DROP CONSTRAINT IF EXISTS pk_numeric_facts;


-- ============================================================================
-- 4. Alter text_disclosures (Add fund dimensions and text-specific metrics)
-- ============================================================================
ALTER TABLE sec_financials.text_disclosures
    DROP COLUMN IF EXISTS qtrs,
    DROP COLUMN IF EXISTS dimh,
    DROP COLUMN IF EXISTS durp,
    DROP COLUMN IF EXISTS datp;

ALTER TABLE sec_financials.text_disclosures
    ADD COLUMN IF NOT EXISTS series VARCHAR(40),
    ADD COLUMN IF NOT EXISTS class VARCHAR(40),
    ADD COLUMN IF NOT EXISTS measure VARCHAR(128),
    ADD COLUMN IF NOT EXISTS document VARCHAR(128),
    ADD COLUMN IF NOT EXISTS otherdims TEXT,
    ADD COLUMN IF NOT EXISTS escaped BOOLEAN DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS srclen INTEGER DEFAULT 0,
    ADD COLUMN IF NOT EXISTS txtlen INTEGER DEFAULT 0;

ALTER TABLE sec_financials.text_disclosures
    ALTER COLUMN version TYPE VARCHAR(40),
    ALTER COLUMN lang TYPE VARCHAR(16),
    ALTER COLUMN context TYPE VARCHAR(128);

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
    ADD COLUMN IF NOT EXISTS negated TEXT,
    ADD COLUMN IF NOT EXISTS negatedterse TEXT;

ALTER TABLE sec_financials.presentation_labels
    ALTER COLUMN version TYPE VARCHAR(40);


-- ============================================================================
-- 6. Alter calculation_relationships (Match cal.tsv layout)
-- ============================================================================
ALTER TABLE sec_financials.calculation_relationships
    DROP COLUMN IF EXISTS fromtag,
    DROP COLUMN IF EXISTS totag,
    DROP COLUMN IF EXISTS weight,
    DROP COLUMN IF EXISTS orderg;

ALTER TABLE sec_financials.calculation_relationships
    ADD COLUMN IF NOT EXISTS grp INTEGER NOT NULL DEFAULT 1,
    ADD COLUMN IF NOT EXISTS negative SMALLINT DEFAULT 0,
    ADD COLUMN IF NOT EXISTS ptag VARCHAR(256) NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS pversion VARCHAR(40) NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS ctag VARCHAR(256) NOT NULL DEFAULT '',
    ADD COLUMN IF NOT EXISTS cversion VARCHAR(40) NOT NULL DEFAULT '';

-- Remove the temporary column defaults once created
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