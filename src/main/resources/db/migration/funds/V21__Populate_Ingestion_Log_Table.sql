insert into sec_financials.pipeline_execution_log
(filing_year,filing_quarter,ingestion_status,ingestion_started_at,ingestion_completed_at,created_by,created_at)
values(2024,4,'COMPLETED',now()::timestamp,now()::timestamp ,'System User', now()::timestamp),
(2025,1,'COMPLETED',now()::timestamp,now()::timestamp ,'System User', now()::timestamp),
(2025,2,'COMPLETED',now()::timestamp,now()::timestamp ,'System User', now()::timestamp),
(2025,3,'COMPLETED',now()::timestamp,now()::timestamp ,'System User', now()::timestamp),
(2025,4,'COMPLETED',now()::timestamp,now()::timestamp ,'System User', now()::timestamp),
(2026,1,'COMPLETED',now()::timestamp,now()::timestamp ,'System User', now()::timestamp),
(2026,2,'COMPLETED',now()::timestamp,now()::timestamp ,'System User', now()::timestamp);