-- 1. Accelerate CASCADE deletes from submissions
CREATE INDEX IF NOT EXISTS idx_txt_adsh
    ON sec_financials.text_disclosures(adsh);

CREATE INDEX IF NOT EXISTS idx_lab_adsh
    ON sec_financials.presentation_labels(adsh);

CREATE INDEX IF NOT EXISTS idx_cal_adsh
    ON sec_financials.calculation_relationships(adsh);

-- 2. Accelerate orphan tag cleanup in Step 4
CREATE INDEX IF NOT EXISTS idx_qtt_tag_version
    ON sec_financials.quarter_taxonomy_tags(tag, "version");