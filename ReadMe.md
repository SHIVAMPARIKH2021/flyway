# Check database exists or not
```Bash
psql -U postgres -tc "SELECT 1 FROM pg_database WHERE datname = 'database_name'" | grep -q 1
```

# If not exists than only run below command manually
- Flyway can not create database, so you need to create database manually before running migration commands.
```SQL
CREATE DATABASE emfs
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'; 
```

# Check loaded configuration
./gradlew dbStatus -Penv=local

# Check migration status
./gradlew flywayInfo -Penv=local

# Commands to Run Flyway on Local
- Open your terminal in the project root folder:

## Step A: Verify connection and loaded credentials
```Bash
./gradlew dbStatus -Penv=local
```
(Check that Database User: emfs_admin is printed from your ```bash~/.gradle/gradle.properties```)

## Step B: Check current migration status (Dry-run / Info)
```Bash
./gradlew flywayInfo -Penv=local
```

## Step C: Execute all pending migrations
```Bash
./gradlew flywayMigrate -Penv=local
```

## Step D: Validate applied scripts against database state
```Bash
./gradlew flywayValidate -Penv=local
```
# ER Diagram

```mermaid
erDiagram
    LOCATIONS ||--o{ DEPARTMENTS : contains
    DEPARTMENTS ||--o{ EMPLOYEES : employs
    JOBS ||--o{ EMPLOYEES : defines
    EMPLOYEES ||--o{ EMPLOYEES : manages
    EMPLOYEES ||--o{ ATTENDANCE : logs
    EMPLOYEES ||--o{ LEAVES : requests
    EMPLOYEES ||--o{ PERFORMANCE_REVIEWS : evaluated_in
    EMPLOYEES ||--o{ PERFORMANCE_REVIEWS : reviews
    EMPLOYEES ||--o{ EMPLOYEE_EDUCATION : achieves
    EMPLOYEES ||--o{ EMPLOYEE_EXPERIENCE : holds
    EMPLOYEES ||--o{ SALARIES : earns
    EMPLOYEES ||--o{ PAYROLL : receives
    EMPLOYEES ||--o{ BANK_DETAILS : owns
    EMPLOYEES ||--o{ TAX_DETAILS : submits
    EMPLOYEES ||--o{ EMPLOYEE_DOCUMENTS : uploads

    LOCATIONS {
        int id PK
        string city
        string state
        string country
    }

    DEPARTMENTS {
        int id PK
        string department_name
        int location_id FK
        string created_by
        string modified_by
    }

    JOBS {
        int id PK
        string job_title
        decimal min_salary
        decimal max_salary
        string created_by
        string modified_by
    }

    EMPLOYEES {
        int id PK
        string first_name
        string last_name
        string email
        string phone
        date date_of_birth
        date hire_date
        int job_id FK
        int department_id FK
        int manager_id FK
        string status
        string created_by
        string modified_by
    }

    ATTENDANCE {
        int id PK
        int employee_id FK
        date attendance_date
        string status
        string created_by
        string modified_by
    }

    LEAVES {
        int id PK
        int employee_id FK
        string leave_type
        date start_date
        date end_date
        string status
        string created_by
        string modified_by
    }

    PERFORMANCE_REVIEWS {
        int id PK
        int employee_id FK
        int reviewer_id FK
        int rating
        string comments
        string created_by
        string modified_by
    }

    EMPLOYEE_EDUCATION {
        int id PK
        int employee_id FK
        string degree
        string institution
        int start_year
        int end_year
        string grade
        string created_by
        string modified_by
    }

    EMPLOYEE_EXPERIENCE {
        int id PK
        int employee_id FK
        string company_name
        string role
        date start_date
        date end_date
        string description
        string created_by
        string modified_by
    }

    SALARIES {
        int id PK
        int employee_id FK
        decimal base_salary
        decimal bonus
        date effective_from
        date effective_to
        string created_by
        string modified_by
    }

    PAYROLL {
        int id PK
        int employee_id FK
        int month
        int year
        decimal gross_salary
        decimal deductions
        decimal net_salary
        string created_by
        string modified_by
    }

    BANK_DETAILS {
        int id PK
        int employee_id FK
        string bank_name
        string account_number
        string ifsc_code
        string created_by
        string modified_by
    }

    TAX_DETAILS {
        int id PK
        int employee_id FK
        string pan_number
        string tax_regime
        decimal deductions_declared
        string created_by
        string modified_by
    }

    EMPLOYEE_DOCUMENTS {
        int id PK
        int employee_id FK
        string document_type
        string document_number
        date expiry_date
        string created_by
        string modified_by
    }
```