CREATE SCHEMA IF NOT EXISTS sec_financials;
SET search_path TO sec_financials;

-- 1. Submissions (sub.tsv)
CREATE TABLE sec_financials.submissions (
    adsh       CHAR(20) NOT NULL,
    cik        INTEGER NOT NULL,
    name       VARCHAR(150) NOT NULL,
    sic        SMALLINT,
    countryba  CHAR(2),
    stprba     CHAR(2),
    cityba     VARCHAR(30),
    zipba      VARCHAR(10),
    bas1       VARCHAR(40),
    bas2       VARCHAR(40),
    baph       VARCHAR(20),
    countryma  CHAR(2),
    stprma     CHAR(2),
    cityma     VARCHAR(30),
    zipma      VARCHAR(10),
    mas1       VARCHAR(40),
    mas2       VARCHAR(40),
    countryinc CHAR(3),
    stprinc    CHAR(2),
    ein        INTEGER,
    former     VARCHAR(150),
    changed    DATE,
    afs        CHAR(5),
    wksi       BOOLEAN,
    fye        CHAR(4),
    form       VARCHAR(10) NOT NULL,
    period     DATE NOT NULL,
    fy         SMALLINT NOT NULL,
    fp         CHAR(2) NOT NULL,
    filed      DATE NOT NULL,
    accepted   TIMESTAMP NOT NULL,
    prevrpt    BOOLEAN,
    detail     BOOLEAN,
    instance   VARCHAR(32) NOT NULL,
    nciks      SMALLINT NOT NULL,
    aciks      VARCHAR(120),
    CONSTRAINT pk_submissions PRIMARY KEY (adsh)
);

-- 2. Taxonomy Tags (tag.tsv)
CREATE TABLE sec_financials.taxonomy_tags (
    tag        VARCHAR(256) NOT NULL,
    version    VARCHAR(20) NOT NULL,
    custom     BOOLEAN NOT NULL,
    abstract   BOOLEAN NOT NULL,
    datatype   VARCHAR(20),
    iord       CHAR(1),
    crdr       CHAR(1),
    tlabel     TEXT,
    doc        TEXT,
    CONSTRAINT pk_taxonomy_tags PRIMARY KEY (tag, version)
);

-- 3. Numeric Facts (num.tsv)
CREATE TABLE sec_financials.numeric_facts (
    adsh       CHAR(20) NOT NULL,
    tag        VARCHAR(256) NOT NULL,
    version    VARCHAR(20) NOT NULL,
    ddate      DATE NOT NULL,
    qtrs       SMALLINT NOT NULL,
    uom        VARCHAR(20) NOT NULL,
    dimh       CHAR(32) NOT NULL DEFAULT '0x00000000000000000000000000000000',
    iprx       SMALLINT NOT NULL DEFAULT 0,
    value      NUMERIC(28, 4),
    footnote   TEXT,
    footlen    INTEGER NOT NULL DEFAULT 0,
    dimn       SMALLINT NOT NULL DEFAULT 0,
    coreg      VARCHAR(256),
    durp       NUMERIC(6, 4),
    datp       NUMERIC(6, 4),
    dcml       SMALLINT,
    CONSTRAINT pk_numeric_facts PRIMARY KEY (adsh, tag, version, ddate, qtrs, uom, dimh, iprx),
    CONSTRAINT fk_num_submissions FOREIGN KEY (adsh) REFERENCES sec_financials.submissions(adsh) ON DELETE CASCADE
);

-- 4. Text Disclosures (txt.tsv)
CREATE TABLE sec_financials.text_disclosures (
    adsh       CHAR(20) NOT NULL,
    tag        VARCHAR(256) NOT NULL,
    version    VARCHAR(20) NOT NULL,
    ddate      DATE NOT NULL,
    qtrs       SMALLINT NOT NULL,
    iprx       SMALLINT NOT NULL DEFAULT 0,
    lang       VARCHAR(10),
    dimh       CHAR(32) NOT NULL DEFAULT '0x00000000000000000000000000000000',
    dimn       SMALLINT NOT NULL DEFAULT 0,
    durp       NUMERIC(6, 4),
    datp       NUMERIC(6, 4),
    dcml       SMALLINT,
    value      TEXT,
    footnote   TEXT,
    footlen    INTEGER NOT NULL DEFAULT 0,
    context    VARCHAR(256),
    CONSTRAINT pk_text_disclosures PRIMARY KEY (adsh, tag, version, ddate, qtrs, iprx, dimh),
    CONSTRAINT fk_txt_submissions FOREIGN KEY (adsh) REFERENCES sec_financials.submissions(adsh) ON DELETE CASCADE
);

-- 5. Presentation Labels (lab.tsv)
CREATE TABLE sec_financials.presentation_labels (
    adsh       CHAR(20) NOT NULL,
    tag        VARCHAR(256) NOT NULL,
    version    VARCHAR(20) NOT NULL,
    label      TEXT NOT NULL,
    role       VARCHAR(512),
    lang       VARCHAR(10),
    CONSTRAINT pk_presentation_labels PRIMARY KEY (adsh, tag, version, label),
    CONSTRAINT fk_lab_submissions FOREIGN KEY (adsh) REFERENCES sec_financials.submissions(adsh) ON DELETE CASCADE
);

-- 6. Calculation Relationships (cal.tsv)
CREATE TABLE sec_financials.calculation_relationships (
    adsh       CHAR(20) NOT NULL,
    arc        VARCHAR(100) NOT NULL,
    version    VARCHAR(20) NOT NULL,
    fromtag    VARCHAR(256) NOT NULL,
    totag      VARCHAR(256) NOT NULL,
    weight     NUMERIC(4, 2) NOT NULL,
    orderg     NUMERIC(10, 4),
    CONSTRAINT pk_calculation_relationships PRIMARY KEY (adsh, arc, version, fromtag, totag),
    CONSTRAINT fk_cal_submissions FOREIGN KEY (adsh) REFERENCES sec_financials.submissions(adsh) ON DELETE CASCADE
);