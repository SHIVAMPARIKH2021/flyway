CREATE TYPE employee_management.employee_status_enum AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'ON_LEAVE',
    'RESIGNED',
    'TERMINATED'
);

CREATE TYPE employee_management.attendance_status_enum AS ENUM (
    'PRESENT',
    'ABSENT'
);

CREATE TYPE employee_management.leave_status_enum AS ENUM (
    'PENDING',
    'APPROVED',
    'REJECTED',
    'CANCELLED'
);

CREATE TYPE document_management.document_type_enum AS ENUM (
    'AADHAAR',
    'PAN',
    'PASSPORT',
    'DRIVING_LICENSE',
    'IMMIGRATION_DOCUMENT'
);

CREATE TYPE employee_management.leave_type_enum AS ENUM (
    'SICK',
    'CASUAL',
    'EARNED',
    'UNPAID'
);

CREATE TYPE finance.tax_regime_enum AS ENUM (
    'OLD',
    'NEW'
);

CREATE TYPE document_management.document_status_enum AS ENUM (
    'ACTIVE',
    'EXPIRED',
    'PENDING'
);

-- Tables
CREATE TABLE IF NOT EXISTS locations (
    id SERIAL PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS employee_management.departments (
    id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),
    location_id INT
);

CREATE TABLE IF NOT EXISTS employee_management.jobs (
    id SERIAL PRIMARY KEY,
    job_title VARCHAR(100),
    min_salary DECIMAL(10,2),
    max_salary DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    CONSTRAINT salary_check CHECK (min_salary <= max_salary),
    CONSTRAINT unique_job_title UNIQUE (job_title)
);

CREATE TABLE IF NOT EXISTS employee_management.employees (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    hire_date DATE,
    job_id INT,
    department_id INT,
    manager_id INT,
    status employee_management.employee_status_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    FOREIGN KEY (job_id) REFERENCES employee_management.jobs(id),
    FOREIGN KEY (department_id) REFERENCES employee_management.departments(id),
    FOREIGN KEY (manager_id) REFERENCES employee_management.employees(id)
);

-- Historical table
CREATE TABLE IF NOT EXISTS finance.salaries (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    base_salary DECIMAL(12,2),
    bonus DECIMAL(12,2),
    effective_from DATE,
    effective_to DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS finance.payroll (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    month INT,
    year INT,
    gross_salary DECIMAL(12,2),
    deductions DECIMAL(12,2),
    net_salary DECIMAL(12,2),
    payment_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS finance.bank_details (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    bank_name VARCHAR(100),
    account_number VARCHAR(50),
    ifsc_code VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS finance.tax_details (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    pan_number VARCHAR(20),
    tax_regime finance.tax_regime_enum NOT NULL,
    deductions_declared DECIMAL(12,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    FOREIGN KEY (employee_id) REFERENCES employee_management.employees(id)
);

CREATE TABLE IF NOT EXISTS employee_management.attendance (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    attendance_date TIMESTAMP,
    check_in TIMESTAMP,
    check_out TIMESTAMP,
    status employee_management.attendance_status_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    FOREIGN KEY (employee_id) REFERENCES employee_management.employees(id)
);

CREATE TABLE IF NOT EXISTS employee_management.leaves (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    leave_type employee_management.leave_type_enum NOT NULL,
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    status employee_management.leave_status_enum NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    FOREIGN KEY (employee_id) REFERENCES employee_management.employees(id)
);

CREATE TABLE IF NOT EXISTS employee_management.performance_reviews (
    id SERIAL PRIMARY KEY,
    employee_id INT,
    reviewer_id INT,
    rating INT CONSTRAINT rating_range CHECK (rating BETWEEN 1 AND 5),
    comments TEXT,
    review_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    FOREIGN KEY (employee_id) REFERENCES employee_management.employees(id),
    FOREIGN KEY (reviewer_id) REFERENCES employee_management.employees(id)
);

CREATE INDEX idx_employee_dept ON employee_management.employees(id);
CREATE INDEX idx_payroll_emp ON finance.payroll(id);

CREATE TABLE IF NOT EXISTS employee_management.employee_education (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    degree VARCHAR(100),
    institution VARCHAR(150),
    start_year INT,
    end_year INT,
    grade VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    FOREIGN KEY (employee_id) REFERENCES employee_management.employees(id)
);

CREATE TABLE IF NOT EXISTS employee_management.employee_experience (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    company_name VARCHAR(150),
    role VARCHAR(100),
    start_date DATE,
    end_date DATE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100),

    FOREIGN KEY (employee_id) REFERENCES employee_management.employees(id)
);

CREATE TABLE IF NOT EXISTS document_management.employee_documents (
    id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL,
    document_type document_management.document_type_enum,
    document_number VARCHAR(100),
    uploaded_at TIMESTAMP DEFAULT NULL,
    expiry_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    modified_at TIMESTAMP DEFAULT NULL,
    created_by VARCHAR(100),
    modified_by VARCHAR(100)
);