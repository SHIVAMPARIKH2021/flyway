alter table analytics.fund_reporting
add column created_by varchar(20),
add column updated_at timestamp;

alter table analytics.holding
add column updated_at timestamp,
add column created_by varchar(20),
add column created_at timestamp;

alter table analytics.fund_master
add column created_by varchar(20);

alter table analytics.fund_classes
add column updated_by varchar(20),
add column created_by varchar(20),
add column updated_at timestamp;

alter table analytics.compliance_rules
rename column created_date to created_at;
alter table analytics.compliance_rules
rename column modified_date to updated_at;

alter table analytics.benchmark_master
add column created_by varchar(20),
add column created_at timestamp,
add column updated_at timestamp;