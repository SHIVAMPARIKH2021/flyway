-- Ensure the CEO job exists; do not force id = 1 if another job holds it
INSERT INTO employee_management.jobs (job_title)
VALUES ('Chief Executive Officer')
ON CONFLICT (job_title) DO NOTHING;

-- Insert location if not present
INSERT INTO public.locations (id, city, state, country)
VALUES (1, 'FrankFurt', 'Hesse', 'Germany')
ON CONFLICT (id) DO NOTHING;

-- Insert department if not present
INSERT INTO employee_management.departments (id, department_name, created_at, created_by, location_id)
VALUES (1, 'Board of Directors', now(), 'System', 1)
ON CONFLICT (id) DO NOTHING;

-- Insert employee referencing the dynamic CEO job_id
INSERT INTO employee_management.employees
(first_name, last_name, email, phone, date_of_birth, hire_date, job_id, department_id, status, created_at, created_by)
SELECT 
    'Shivester', 
    'Parik', 
    'shivester.parik@emfs.com', 
    '1234567890', 
    '1965-12-12', 
    '1995-12-12', 
    j.id, 
    1, 
    'ACTIVE', 
    now(), 
    'System'
FROM employee_management.jobs j
WHERE j.job_title = 'Chief Executive Officer'
ON CONFLICT (email) DO NOTHING;

-- Synchronize sequences so future serial inserts don't collide
SELECT setval(pg_get_serial_sequence('employee_management.jobs', 'id'), COALESCE(max(id), 1)) FROM employee_management.jobs;
SELECT setval(pg_get_serial_sequence('public.locations', 'id'), COALESCE(max(id), 1)) FROM public.locations;
SELECT setval(pg_get_serial_sequence('employee_management.departments', 'id'), COALESCE(max(id), 1)) FROM employee_management.departments;
SELECT setval(pg_get_serial_sequence('employee_management.employees', 'id'), COALESCE(max(id), 1)) FROM employee_management.employees;