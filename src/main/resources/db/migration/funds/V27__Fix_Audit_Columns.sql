CREATE OR REPLACE PROCEDURE analytics.drop_audit_constraints_and_defaults()
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
    v_sql TEXT;
BEGIN
    FOR r IN (
        SELECT
            c.table_schema,
            c.table_name,
            c.column_name,
            c.is_nullable,
            c.column_default
        FROM information_schema.columns c
        JOIN information_schema.tables t
          ON c.table_schema = t.table_schema
         AND c.table_name = t.table_name
        WHERE c.table_schema = 'analytics'
          AND t.table_type = 'BASE TABLE'
          AND c.column_name IN ('created_by', 'created_at', 'updated_by', 'updated_at')
        ORDER BY c.table_name, c.column_name
    )
    LOOP
        -- 1. Remove NOT NULL constraint if present
        IF r.is_nullable = 'NO' THEN
            v_sql := format(
                'ALTER TABLE %I.%I ALTER COLUMN %I DROP NOT NULL',
                r.table_schema,
                r.table_name,
                r.column_name
            );
            RAISE NOTICE 'Executing: %', v_sql;
            EXECUTE v_sql;
        END IF;

        -- 2. Remove default value if present
        IF r.column_default IS NOT NULL THEN
            v_sql := format(
                'ALTER TABLE %I.%I ALTER COLUMN %I DROP DEFAULT',
                r.table_schema,
                r.table_name,
                r.column_name
            );
            RAISE NOTICE 'Executing: %', v_sql;
            EXECUTE v_sql;
        END IF;
    END LOOP;

    RAISE NOTICE 'Completed audit column constraint and default removal for schema: analytics';
END;
$$;