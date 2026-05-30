-- ============================================================
-- FINANCIAL CUSTOMER ANALYTICS SYSTEM
-- File: 06_excel_exports/export_queries.sql
-- Description: Run each query and export result as CSV.
--              Import each CSV into its matching Excel sheet.
--
-- HOW TO EXPORT IN MySQL Workbench:
--   1. Run the query
--   2. In the result grid, click the Export button (grid icon)
--   3. Save as CSV with the filename shown above each query
-- ============================================================

USE financial_analytics;

-- ============================================================
-- EXPORT 1: executive_summary.csv
-- → Paste into Excel sheet: "Executive Summary"
-- ============================================================
SELECT
    COUNT(DISTINCT c.customer_id)                       AS total_customers,
    SUM(CASE WHEN c.is_active = TRUE THEN 1 ELSE 0 END) AS active_customers,
    COUNT(DISTINCT b.branch_id)                         AS total_branches,
    ROUND(SUM(a.balance), 2)                            AS total_deposits_under_management,
    ROUND(AVG(a.balance), 2)                            AS avg_account_balance,
    COUNT(DISTINCT l.loan_id)                           AS total_loans,
    ROUND(SUM(l.outstanding_balance), 2)                AS total_outstanding_loans,
    COUNT(DISTINCT t.transaction_id)                    AS total_transactions,
    ROUND(SUM(t.amount), 2)                             AS total_transaction_volume,
    ROUND(AVG(t.amount), 2)                             AS avg_transaction_value
FROM customers c
LEFT JOIN accounts     a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON c.customer_id = t.customer_id AND t.status = 'Completed'
LEFT JOIN loans        l ON c.customer_id = l.customer_id
CROSS JOIN branches    b;

-- ============================================================
-- EXPORT 2: monthly_revenue_trend.csv
-- → Paste into Excel sheet: "MoM Growth"
-- → Create a Line Chart: X = Month, Y = Revenue + Growth %
-- ============================================================
WITH monthly AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m')          AS month,
        ROUND(SUM(amount), 2)                           AS revenue,
        COUNT(*)                                        AS transactions,
        COUNT(DISTINCT customer_id)                     AS unique_customers
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
)
SELECT
    month,
    revenue,
    transactions,
    unique_customers,
    LAG(revenue) OVER (ORDER BY month)                  AS prev_month_revenue,
    ROUND(
        (revenue - LAG(revenue) OVER (ORDER BY month))
        / NULLIF(LAG(revenue) OVER (ORDER BY month), 0) * 100
    , 2)                                                AS mom_growth_pct,
    ROUND(AVG(revenue) OVER (
        ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                                               AS rolling_3m_avg,
    ROUND(SUM(revenue) OVER (ORDER BY month), 2)        AS cumulative_revenue
FROM monthly
ORDER BY month;

-- ============================================================
-- EXPORT 3: customer_segments.csv
-- → Paste into Excel sheet: "Customer Segments"
-- → Create a Pie Chart for segment distribution
-- → Create a Bar Chart for avg balance by segment
-- ============================================================
SELECT
    c.segment,
    c.state,
    COUNT(DISTINCT c.customer_id)                       AS customer_count,
    ROUND(AVG(c.annual_income), 2)                      AS avg_annual_income,
    ROUND(AVG(a.balance), 2)                            AS avg_balance,
    ROUND(SUM(a.balance), 2)                            AS total_balance,
    ROUND(SUM(t.amount), 2)                             AS total_spend,
    ROUND(AVG(t.amount), 2)                             AS avg_transaction_value,
    COUNT(t.transaction_id)                             AS total_transactions
FROM customers c
LEFT JOIN accounts     a ON c.customer_id = a.customer_id
LEFT JOIN transactions t ON c.customer_id = t.customer_id AND t.status = 'Completed'
GROUP BY c.segment, c.state
ORDER BY c.segment, total_balance DESC;

-- ============================================================
-- EXPORT 4: churn_report.csv
-- → Paste into Excel sheet: "Churn Report"
-- → Create a Bar Chart: Days Inactive by Risk Level
-- ============================================================
WITH last_activity AS (
    SELECT customer_id, MAX(transaction_date) AS last_txn
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)              AS customer_name,
    c.email,
    c.segment,
    c.city,
    c.state,
    la.last_txn                                         AS last_transaction_date,
    DATEDIFF(CURDATE(), la.last_txn)                    AS days_inactive,
    a.balance                                           AS current_balance,
    CASE
        WHEN DATEDIFF(CURDATE(), la.last_txn) > 365 THEN 'High Risk'
        WHEN DATEDIFF(CURDATE(), la.last_txn) > 180 THEN 'Medium Risk'
        WHEN DATEDIFF(CURDATE(), la.last_txn) > 90  THEN 'Low Risk'
        ELSE 'Active'
    END                                                 AS churn_risk
FROM customers c
JOIN last_activity la ON c.customer_id = la.customer_id
JOIN accounts a       ON c.customer_id = a.customer_id
ORDER BY days_inactive DESC;

-- ============================================================
-- EXPORT 5: branch_performance.csv
-- → Paste into Excel sheet: "Branch Performance"
-- → Create a Clustered Bar Chart: Revenue + Customers by Branch
-- ============================================================
SELECT
    b.branch_name,
    b.city,
    b.region,
    b.headcount,
    COUNT(DISTINCT a.customer_id)                       AS total_customers,
    COUNT(t.transaction_id)                             AS total_transactions,
    ROUND(SUM(t.amount), 2)                             AS total_revenue,
    ROUND(AVG(a.balance), 2)                            AS avg_account_balance,
    ROUND(SUM(t.amount) / b.headcount, 2)               AS revenue_per_employee,
    RANK() OVER (ORDER BY SUM(t.amount) DESC)           AS revenue_rank
FROM branches b
JOIN accounts     a ON b.branch_id = a.branch_id
JOIN transactions t ON a.account_id = t.account_id AND t.status = 'Completed'
GROUP BY b.branch_id, b.branch_name, b.city, b.region, b.headcount
ORDER BY total_revenue DESC;

-- ============================================================
-- EXPORT 6: cohort_retention.csv
-- → Paste into Excel sheet: "Cohort Heatmap"
-- → Use Conditional Formatting on retention_pct column
--   (green = high retention, red = low)
-- ============================================================
WITH cohort_base AS (
    SELECT customer_id, DATE_FORMAT(MIN(transaction_date), '%Y-%m') AS cohort_month
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
),
activity AS (
    SELECT
        t.customer_id,
        DATE_FORMAT(t.transaction_date, '%Y-%m')        AS activity_month,
        cb.cohort_month
    FROM transactions t
    JOIN cohort_base cb ON t.customer_id = cb.customer_id
    WHERE t.status = 'Completed'
    GROUP BY t.customer_id, DATE_FORMAT(t.transaction_date, '%Y-%m'), cb.cohort_month
),
cohort_size AS (
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_total
    FROM cohort_base
    GROUP BY cohort_month
)
SELECT
    a.cohort_month,
    cs.cohort_total,
    a.activity_month,
    PERIOD_DIFF(
        REPLACE(a.activity_month, '-', ''),
        REPLACE(a.cohort_month,   '-', '')
    )                                                   AS month_number,
    COUNT(DISTINCT a.customer_id)                       AS active_customers,
    ROUND(COUNT(DISTINCT a.customer_id) * 100.0 / cs.cohort_total, 1) AS retention_pct
FROM activity a
JOIN cohort_size cs ON a.cohort_month = cs.cohort_month
GROUP BY a.cohort_month, cs.cohort_total, a.activity_month
ORDER BY a.cohort_month, a.activity_month;

-- ============================================================
-- EXPORT 7: top_customers.csv
-- → Paste into Excel sheet: "Top Customers"
-- → Create a Sorted Bar Chart: Top 20 by CLV
-- ============================================================
WITH spend AS (
    SELECT customer_id,
           ROUND(SUM(amount), 2)          AS total_spend,
           COUNT(*)                       AS total_transactions,
           ROUND(AVG(amount), 2)          AS avg_transaction,
           COUNT(DISTINCT DATE_FORMAT(transaction_date, '%Y-%m')) AS active_months
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)              AS customer_name,
    c.segment,
    c.occupation,
    c.annual_income,
    c.city,
    c.state,
    s.total_spend,
    s.total_transactions,
    s.avg_transaction,
    s.active_months,
    ROUND(s.total_spend / NULLIF(s.active_months, 0), 2) AS avg_monthly_spend,
    ROUND(s.total_spend / NULLIF(s.active_months, 0) * 12, 2) AS projected_annual_clv,
    a.balance                                           AS current_balance,
    RANK() OVER (ORDER BY s.total_spend DESC)           AS spend_rank
FROM customers c
JOIN spend s   ON c.customer_id = s.customer_id
JOIN accounts a ON c.customer_id = a.customer_id
ORDER BY s.total_spend DESC
LIMIT 20;
