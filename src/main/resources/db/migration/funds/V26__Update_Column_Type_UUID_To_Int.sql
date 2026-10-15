DO $$
BEGIN
    -- Only run the migration if benchmark_id in benchmark_master is still UUID
    IF EXISTS (
        SELECT 1
        FROM information_schema.columns
        WHERE table_schema = 'analytics'
          AND table_name = 'benchmark_master'
          AND column_name = 'benchmark_id'
          AND data_type = 'uuid'
    ) THEN

        -- 1. Drop ALL foreign key constraints referencing analytics.benchmark_master(benchmark_id)
        ALTER TABLE analytics.fund_master
            DROP CONSTRAINT IF EXISTS fund_master_benchmark_id_fkey;

        -- Find and drop fk_fba_benchmark_master from whichever table owns it
        IF EXISTS (
            SELECT 1 FROM information_schema.table_constraints
            WHERE constraint_schema = 'analytics'
              AND constraint_name = 'fk_fba_benchmark_master'
        ) THEN
            EXECUTE (
                SELECT 'ALTER TABLE ' || table_schema || '.' || table_name || ' DROP CONSTRAINT fk_fba_benchmark_master'
                FROM information_schema.table_constraints
                WHERE constraint_schema = 'analytics'
                  AND constraint_name = 'fk_fba_benchmark_master'
                LIMIT 1
            );
        END IF;

        -- 2. Alter the primary key column in benchmark_master to INT
        ALTER TABLE analytics.benchmark_master
            ALTER COLUMN benchmark_id TYPE INT
            USING NULL;

        -- 3. Alter referencing column in analytics.fund_master to INT
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'analytics'
              AND table_name = 'fund_master'
              AND column_name = 'benchmark_id'
              AND data_type = 'uuid'
        ) THEN
            ALTER TABLE analytics.fund_master
                ALTER COLUMN benchmark_id TYPE INT
                USING NULL;
        END IF;

        -- 4. Alter referencing column in fund_benchmark_association (or fba table) to INT
        IF EXISTS (
            SELECT 1 FROM information_schema.columns
            WHERE table_schema = 'analytics'
              AND table_name = 'fund_benchmark_association'
              AND column_name = 'benchmark_id'
              AND data_type = 'uuid'
        ) THEN
            ALTER TABLE analytics.fund_benchmark_association
                ALTER COLUMN benchmark_id TYPE INT
                USING NULL;
        END IF;

        -- 5. Re-add foreign key constraints
        ALTER TABLE analytics.fund_master
            ADD CONSTRAINT fund_master_benchmark_id_fkey
            FOREIGN KEY (benchmark_id)
            REFERENCES analytics.benchmark_master(benchmark_id)
            ON DELETE SET NULL;

        IF EXISTS (
            SELECT 1 FROM information_schema.tables
            WHERE table_schema = 'analytics'
              AND table_name = 'fund_benchmark_association'
        ) THEN
            ALTER TABLE analytics.fund_benchmark_association
                ADD CONSTRAINT fk_fba_benchmark_master
                FOREIGN KEY (benchmark_id)
                REFERENCES analytics.benchmark_master(benchmark_id)
                ON DELETE CASCADE;
        END IF;

    END IF;
END $$;

-- Idempotent index creation
CREATE INDEX IF NOT EXISTS idx_fund_master_benchmark
    ON analytics.fund_master(benchmark_id);