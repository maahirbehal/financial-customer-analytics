-- Financial Customer Analytics System
-- Schema: create_tables.sql
--
-- I designed this schema to model a retail bank's core operations.
-- The goal was to keep it normalised (3NF) while making sure the
-- tables would actually perform well on larger datasets — hence the
-- explicit indexes on columns I knew I'd be filtering and joining on.
--
-- Table overview:
--   branches       → physical branch locations and metadata
--   customers      → account holders with demographic and income data
--   products       → the bank's product catalogue (savings, loans, etc.)
--   accounts       → links customers to products via a branch
--   transactions   → every financial movement on an account
--   loans          → active and historical loan records
--   repayments     → monthly loan payments, including late payment tracking
--   alerts         → auto-populated by a trigger when large transactions occur
--   monthly_reports → auto-populated by a stored procedure for branch reporting

CREATE DATABASE IF NOT EXISTS financial_analytics;
USE financial_analytics;


-- Branches
-- I included region as an ENUM so I can group by geography easily in reports
-- without needing a separate lookup table for something this simple.
CREATE TABLE branches (
    branch_id       INT AUTO_INCREMENT PRIMARY KEY,
    branch_name     VARCHAR(100) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    state           VARCHAR(100) NOT NULL,
    region          ENUM('North', 'South', 'East', 'West', 'Central') NOT NULL,
    manager_name    VARCHAR(100) NOT NULL,
    headcount       INT NOT NULL DEFAULT 0,
    opened_date     DATE NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Customers
-- segment and joined_date are the two columns I query most often in
-- churn and retention analysis, so I indexed both upfront.
CREATE TABLE customers (
    customer_id     INT AUTO_INCREMENT PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(150) NOT NULL UNIQUE,
    phone           VARCHAR(20),
    date_of_birth   DATE NOT NULL,
    gender          ENUM('Male', 'Female', 'Other') NOT NULL,
    occupation      VARCHAR(100),
    annual_income   DECIMAL(15,2),
    city            VARCHAR(100),
    state           VARCHAR(100),
    segment         ENUM('Premium', 'Standard', 'Basic') NOT NULL DEFAULT 'Standard',
    joined_date     DATE NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_segment (segment),
    INDEX idx_joined_date (joined_date)
);


-- Products
-- Kept this table lean — it's mostly a reference table that accounts join to.
-- interest_rate and monthly_fee are nullable because not every product type has them.
CREATE TABLE products (
    product_id      INT AUTO_INCREMENT PRIMARY KEY,
    product_name    VARCHAR(100) NOT NULL,
    product_type    ENUM('Savings', 'Checking', 'Credit Card', 'Mortgage', 'Personal Loan', 'Investment') NOT NULL,
    interest_rate   DECIMAL(5,2),
    monthly_fee     DECIMAL(8,2) DEFAULT 0.00,
    min_balance     DECIMAL(15,2) DEFAULT 0.00,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Accounts
-- This is the central linking table — every transaction traces back here.
-- I used ON DELETE CASCADE on customer_id so that if a customer is removed,
-- their accounts clean up automatically. Foreign keys on branch and product
-- are intentionally restricted (no cascade) to protect reference integrity.
CREATE TABLE accounts (
    account_id      INT AUTO_INCREMENT PRIMARY KEY,
    customer_id     INT NOT NULL,
    branch_id       INT NOT NULL,
    product_id      INT NOT NULL,
    account_number  VARCHAR(20) NOT NULL UNIQUE,
    balance         DECIMAL(15,2) NOT NULL DEFAULT 0.00,
    currency        VARCHAR(3) NOT NULL DEFAULT 'USD',
    status          ENUM('Active', 'Dormant', 'Closed', 'Suspended') NOT NULL DEFAULT 'Active',
    opened_date     DATE NOT NULL,
    closed_date     DATE,
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (branch_id)   REFERENCES branches(branch_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id),
    INDEX idx_customer_id (customer_id),
    INDEX idx_branch_id (branch_id),
    INDEX idx_status (status)
);


-- Transactions
-- The heaviest table in the system — this is where most of my queries land.
-- I indexed customer_id, account_id, transaction_date, and transaction_type
-- because those four columns appear in almost every WHERE clause I wrote.
-- Using DECIMAL(15,2) for amount to avoid any floating-point precision issues
-- with financial data.
CREATE TABLE transactions (
    transaction_id      INT AUTO_INCREMENT PRIMARY KEY,
    account_id          INT NOT NULL,
    customer_id         INT NOT NULL,
    transaction_type    ENUM('Deposit', 'Withdrawal', 'Transfer', 'Payment', 'Refund', 'Fee') NOT NULL,
    amount              DECIMAL(15,2) NOT NULL,
    merchant_category   VARCHAR(100),
    description         VARCHAR(255),
    transaction_date    DATETIME NOT NULL,
    status              ENUM('Completed', 'Pending', 'Failed', 'Reversed') NOT NULL DEFAULT 'Completed',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (account_id)  REFERENCES accounts(account_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_account_id (account_id),
    INDEX idx_customer_id (customer_id),
    INDEX idx_transaction_date (transaction_date),
    INDEX idx_transaction_type (transaction_type)
);


-- Loans
-- Tracks both the original loan terms and the current outstanding balance,
-- which lets me calculate repayment progress without scanning the repayments table.
-- status is especially important here — I use it to filter delinquent customers
-- in the risk assessment stored procedure.
CREATE TABLE loans (
    loan_id             INT AUTO_INCREMENT PRIMARY KEY,
    customer_id         INT NOT NULL,
    branch_id           INT NOT NULL,
    loan_type           ENUM('Personal', 'Mortgage', 'Auto', 'Business', 'Student') NOT NULL,
    principal_amount    DECIMAL(15,2) NOT NULL,
    interest_rate       DECIMAL(5,2) NOT NULL,
    term_months         INT NOT NULL,
    monthly_payment     DECIMAL(15,2) NOT NULL,
    outstanding_balance DECIMAL(15,2) NOT NULL,
    disbursement_date   DATE NOT NULL,
    maturity_date       DATE NOT NULL,
    status              ENUM('Active', 'Paid Off', 'Defaulted', 'Delinquent') NOT NULL DEFAULT 'Active',
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (branch_id)   REFERENCES branches(branch_id),
    INDEX idx_customer_id (customer_id),
    INDEX idx_status (status)
);


-- Repayments
-- I added is_on_time and days_late as explicit columns rather than deriving them
-- at query time — it makes the risk scoring queries much cleaner and faster.
CREATE TABLE repayments (
    repayment_id        INT AUTO_INCREMENT PRIMARY KEY,
    loan_id             INT NOT NULL,
    customer_id         INT NOT NULL,
    amount_paid         DECIMAL(15,2) NOT NULL,
    payment_date        DATE NOT NULL,
    payment_method      ENUM('Bank Transfer', 'Direct Debit', 'Cash', 'Cheque') NOT NULL,
    is_on_time          BOOLEAN NOT NULL DEFAULT TRUE,
    days_late           INT DEFAULT 0,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (loan_id)     REFERENCES loans(loan_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    INDEX idx_loan_id (loan_id),
    INDEX idx_payment_date (payment_date)
);


-- Alerts
-- I deliberately kept this table separate from transactions.
-- It gets populated automatically by a trigger (see 04_procedures/),
-- so the transactions table stays clean and alerts can be reviewed
-- independently by a compliance or fraud team.
CREATE TABLE alerts (
    alert_id        INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id  INT NOT NULL,
    customer_id     INT NOT NULL,
    alert_type      VARCHAR(100) NOT NULL DEFAULT 'Large Transaction',
    amount          DECIMAL(15,2) NOT NULL,
    flagged_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_reviewed     BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (customer_id)    REFERENCES customers(customer_id)
);


-- Monthly Reports
-- This table is populated by the GenerateMonthlyBranchReport stored procedure.
-- The UNIQUE constraint on (branch_id, report_month) means the procedure can
-- safely delete and re-insert if a report needs to be regenerated.
CREATE TABLE monthly_reports (
    report_id           INT AUTO_INCREMENT PRIMARY KEY,
    branch_id           INT NOT NULL,
    report_month        DATE NOT NULL,
    total_transactions  INT DEFAULT 0,
    total_revenue       DECIMAL(15,2) DEFAULT 0.00,
    avg_balance         DECIMAL(15,2) DEFAULT 0.00,
    new_customers       INT DEFAULT 0,
    generated_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (branch_id) REFERENCES branches(branch_id),
    UNIQUE KEY unique_branch_month (branch_id, report_month)
);


-- Quick check to confirm all tables were created as expected
SELECT
    TABLE_NAME,
    TABLE_ROWS,
    CREATE_TIME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'financial_analytics'
ORDER BY TABLE_NAME;
