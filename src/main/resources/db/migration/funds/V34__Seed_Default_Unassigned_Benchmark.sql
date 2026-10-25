-- Seed the canonical fallback record with benchmark_id = 0
INSERT INTO analytics.benchmark_master (
    benchmark_id,
    benchmark_name,
    benchmark_provider,
    benchmark_type,
    created_by,
    updated_by,
    created_at,
    updated_at
) VALUES (
    0,
    'Not Disclosed / New Inception',
    'Unassigned',
    'Unassigned',
    'SYSTEM_SEED',
    'SYSTEM_SEED',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
)
ON CONFLICT (benchmark_name) DO UPDATE SET
    benchmark_provider = EXCLUDED.benchmark_provider,
    benchmark_type     = EXCLUDED.benchmark_type,
    updated_at         = CURRENT_TIMESTAMP;

-- If benchmark_id is an IDENTITY column, ensure the sequence doesn't conflict with future auto-increments
SELECT setval(
    pg_get_serial_sequence('analytics.benchmark_master', 'benchmark_id'),
    COALESCE((SELECT MAX(benchmark_id) FROM analytics.benchmark_master WHERE benchmark_id > 0), 1),
    true
);