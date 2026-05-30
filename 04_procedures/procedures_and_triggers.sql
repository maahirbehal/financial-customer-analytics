-- ============================================================
-- FINANCIAL CUSTOMER ANALYTICS SYSTEM
-- File: 04_procedures/stored_procedures_and_triggers.sql
-- Description: Production-style stored procedures for automated
--              reporting and triggers for real-time alerting
-- ============================================================

USE financial_analytics;

-- ============================================================
-- TRIGGER 1: Flag Large Transactions Automatically
-- Business Use: Fraud detection and compliance monitoring
-- Fires on every new transaction above $10,000
-- ============================================================
DROP TRIGGER IF EXISTS flag_large_transaction;

DELIMITER //
CREATE TRIGGER flag_large_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.amount > 10000 THEN
        INSERT INTO alerts (
            transaction_id,
            customer_id,
            alert_type,
            amount,
            flagged_at,
            is_reviewed
        )
        VALUES (
            NEW.transaction_id,
            NEW.customer_id,
            CASE
                WHEN NEW.amount > 50000 THEN 'Critical: High Value Transaction'
                WHEN NEW.amount > 25000 THEN 'Warning: Large Transaction'
                ELSE 'Notice: Elevated Transaction'
            END,
            NEW.amount,
            NOW(),
            FALSE
        );
    END IF;
END //
DELIMITER ;

-- ============================================================
-- TRIGGER 2: Update Account Status on Dormancy
-- Business Use: Keep account status accurate automatically
-- Fires when a transaction is completed — reactivates dormant accounts
-- ============================================================
DROP TRIGGER IF EXISTS reactivate_dormant_account;

DELIMITER //
CREATE TRIGGER reactivate_dormant_account
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    UPDATE accounts
    SET status = 'Active'
    WHERE account_id = NEW.account_id
      AND status = 'Dormant';
END //
DELIMITER ;

-- ============================================================
-- STORED PROCEDURE 1: Generate Monthly Branch Report
-- Business Use: Automate end-of-month branch performance reporting
-- Usage: CALL GenerateMonthlyBranchReport('2024-01-01');
-- ============================================================
DROP PROCEDURE IF EXISTS GenerateMonthlyBranchReport;

DELIMITER //
CREATE PROCEDURE GenerateMonthlyBranchReport(IN report_month DATE)
BEGIN
    DECLARE report_label VARCHAR(7);
    SET report_label = DATE_FORMAT(report_month, '%Y-%m');

    -- Remove existing report for this month to allow re-runs
    DELETE FROM monthly_reports
    WHERE DATE_FORMAT(report_month, '%Y-%m') = report_label;

    -- Insert fresh data
    INSERT INTO monthly_reports (
        branch_id,
        report_month,
        total_transactions,
        total_revenue,
        avg_balance,
        new_customers
    )
    SELECT
        a.branch_id,
        report_month,
        COUNT(t.transaction_id)                     AS total_transactions,
        ROUND(SUM(t.amount), 2)                     AS total_revenue,
        ROUND(AVG(a.balance), 2)                    AS avg_balance,
        COUNT(DISTINCT CASE
            WHEN DATE_FORMAT(c.joined_date, '%Y-%m') = report_label
            THEN c.customer_id
        END)                                        AS new_customers
    FROM transactions t
    JOIN accounts a  ON t.account_id  = a.account_id
    JOIN customers c ON a.customer_id = c.customer_id
    WHERE DATE_FORMAT(t.transaction_date, '%Y-%m') = report_label
      AND t.status = 'Completed'
    GROUP BY a.branch_id;

    -- Return the generated report
    SELECT
        b.branch_name,
        b.city,
        b.region,
        mr.report_month,
        mr.total_transactions,
        mr.total_revenue,
        mr.avg_balance,
        mr.new_customers,
        mr.generated_at
    FROM monthly_reports mr
    JOIN branches b ON mr.branch_id = b.branch_id
    WHERE DATE_FORMAT(mr.report_month, '%Y-%m') = report_label
    ORDER BY mr.total_revenue DESC;
END //
DELIMITER ;

-- Run procedure for the last 6 months
CALL GenerateMonthlyBranchReport('2024-08-01');
CALL GenerateMonthlyBranchReport('2024-07-01');
CALL GenerateMonthlyBranchReport('2024-06-01');
CALL GenerateMonthlyBranchReport('2024-05-01');
CALL GenerateMonthlyBranchReport('2024-04-01');
CALL GenerateMonthlyBranchReport('2024-03-01');

-- ============================================================
-- STORED PROCEDURE 2: Customer Risk Assessment Report
-- Business Use: Identify delinquent loan customers for collections
-- Usage: CALL CustomerRiskReport();
-- ============================================================
DROP PROCEDURE IF EXISTS CustomerRiskReport;

DELIMITER //
CREATE PROCEDURE CustomerRiskReport()
BEGIN
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name)      AS customer_name,
        c.email,
        c.segment,
        l.loan_id,
        l.loan_type,
        l.outstanding_balance,
        l.status                                    AS loan_status,
        COUNT(r.repayment_id)                       AS total_payments,
        SUM(CASE WHEN r.is_on_time = FALSE THEN 1 ELSE 0 END) AS late_payments,
        ROUND(
            SUM(CASE WHEN r.is_on_time = FALSE THEN 1 ELSE 0 END)
            / COUNT(r.repayment_id) * 100
        , 1)                                        AS late_payment_pct,
        MAX(r.days_late)                            AS max_days_late,
        CASE
            WHEN l.status = 'Defaulted'                                    THEN 'CRITICAL'
            WHEN l.status = 'Delinquent'                                   THEN 'HIGH'
            WHEN SUM(CASE WHEN r.is_on_time = FALSE THEN 1 ELSE 0 END)
                 / COUNT(r.repayment_id) > 0.3                             THEN 'MEDIUM'
            ELSE 'LOW'
        END                                         AS risk_level
    FROM customers c
    JOIN loans l      ON c.customer_id = l.customer_id
    LEFT JOIN repayments r ON l.loan_id = r.loan_id
    GROUP BY
        c.customer_id, c.first_name, c.last_name, c.email, c.segment,
        l.loan_id, l.loan_type, l.outstanding_balance, l.status
    ORDER BY
        CASE
            WHEN l.status = 'Defaulted'  THEN 1
            WHEN l.status = 'Delinquent' THEN 2
            ELSE 3
        END,
        late_payment_pct DESC;
END //
DELIMITER ;

CALL CustomerRiskReport();

-- ============================================================
-- STORED PROCEDURE 3: Segment Upgrade Recommendations
-- Business Use: Automatically identify customers ready to upgrade
-- Usage: CALL SegmentUpgradeReport();
-- ============================================================
DROP PROCEDURE IF EXISTS SegmentUpgradeReport;

DELIMITER //
CREATE PROCEDURE SegmentUpgradeReport()
BEGIN
    WITH customer_stats AS (
        SELECT
            t.customer_id,
            ROUND(SUM(t.amount), 2)                 AS total_spend,
            ROUND(AVG(a.balance), 2)                AS avg_balance,
            COUNT(t.transaction_id)                 AS txn_count
        FROM transactions t
        JOIN accounts a ON t.account_id = a.account_id
        WHERE t.status = 'Completed'
        GROUP BY t.customer_id
    )
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name)      AS customer_name,
        c.email,
        c.annual_income,
        c.segment                                   AS current_segment,
        cs.total_spend,
        cs.avg_balance,
        cs.txn_count,
        CASE
            WHEN c.segment = 'Basic'     AND (cs.total_spend > 20000 OR cs.avg_balance > 5000)  THEN 'Upgrade to Standard'
            WHEN c.segment = 'Standard'  AND (cs.total_spend > 80000 OR cs.avg_balance > 50000) THEN 'Upgrade to Premium'
            ELSE 'No change recommended'
        END                                         AS recommendation
    FROM customers c
    JOIN customer_stats cs ON c.customer_id = cs.customer_id
    HAVING recommendation != 'No change recommended'
    ORDER BY cs.total_spend DESC;
END //
DELIMITER ;

CALL SegmentUpgradeReport();

-- ============================================================
-- VIEW ALERTS generated by trigger
-- ============================================================
SELECT
    al.alert_id,
    al.alert_type,
    al.amount,
    al.flagged_at,
    al.is_reviewed,
    CONCAT(c.first_name, ' ', c.last_name)          AS customer_name,
    c.segment,
    t.transaction_type,
    t.merchant_category
FROM alerts al
JOIN customers c    ON al.customer_id    = c.customer_id
JOIN transactions t ON al.transaction_id = t.transaction_id
ORDER BY al.flagged_at DESC;
