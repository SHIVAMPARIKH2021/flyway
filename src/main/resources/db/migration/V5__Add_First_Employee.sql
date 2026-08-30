insert into employee_management.employees
(first_name, last_name, email, phone, date_of_birth,hire_date, job_id, department_id, manager_id, status, created_at, created_by)
values
('Shivester', 'Parik', 'shivester.parik@emfs.com','1234567890','1965-12-12', '1995-12-12',1,1,0,'ACTIVE',now(),'System');

update employee_management.jobs
set id = 1 where job_title = 'Chief Executive Officer';