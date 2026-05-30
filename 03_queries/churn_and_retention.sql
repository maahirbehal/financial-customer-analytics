-- ============================================================
-- FINANCIAL CUSTOMER ANALYTICS SYSTEM
-- File: 03_queries/02_churn_and_retention.sql
-- Description: Churn detection, dormancy analysis, and
--              cohort-based customer retention reporting
-- ============================================================

USE financial_analytics;

-- ============================================================
-- QUERY 1: Dormant Customer Detection (Churn Risk)
-- Business Use: Flag customers for reactivation campaigns
-- ============================================================
WITH last_activity AS (
    SELECT
        customer_id,
        MAX(transaction_date)                       AS last_transaction_date,
        COUNT(transaction_id)                       AS lifetime_transactions,
        ROUND(SUM(amount), 2)                       AS lifetime_spend
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
),
dormancy_scored AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name)      AS customer_name,
        c.email,
        c.segment,
        c.city,
        c.state,
        c.joined_date,
        la.last_transaction_date,
        DATEDIFF(CURDATE(), la.last_transaction_date) AS days_inactive,
        la.lifetime_transactions,
        la.lifetime_spend,
        a.balance                                   AS current_balance,
        CASE
            WHEN DATEDIFF(CURDATE(), la.last_transaction_date) > 365 THEN 'High Risk'
            WHEN DATEDIFF(CURDATE(), la.last_transaction_date) > 180 THEN 'Medium Risk'
            WHEN DATEDIFF(CURDATE(), la.last_transaction_date) > 90  THEN 'Low Risk'
            ELSE 'Active'
        END                                         AS churn_risk_level
    FROM customers c
    JOIN last_activity la   ON c.customer_id = la.customer_id
    JOIN accounts a         ON c.customer_id = a.customer_id
    WHERE c.is_active = TRUE
)
SELECT *
FROM dormancy_scored
WHERE churn_risk_level != 'Active'
ORDER BY days_inactive DESC;

-- ============================================================
-- QUERY 2: Churn Risk Summary by Segment
-- Business Use: Allocate retention budget by customer tier
-- ============================================================
WITH last_activity AS (
    SELECT customer_id, MAX(transaction_date) AS last_txn
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
),
churn_classified AS (
    SELECT
        c.customer_id,
        c.segment,
        DATEDIFF(CURDATE(), la.last_txn)            AS days_inactive,
        CASE
            WHEN DATEDIFF(CURDATE(), la.last_txn) > 365 THEN 'High Risk'
            WHEN DATEDIFF(CURDATE(), la.last_txn) > 180 THEN 'Medium Risk'
            WHEN DATEDIFF(CURDATE(), la.last_txn) > 90  THEN 'Low Risk'
            ELSE 'Active'
        END                                         AS churn_risk_level
    FROM customers c
    JOIN last_activity la ON c.customer_id = la.customer_id
)
SELECT
    segment,
    churn_risk_level,
    COUNT(customer_id)                              AS customer_count,
    ROUND(AVG(days_inactive), 0)                    AS avg_days_inactive,
    ROUND(COUNT(customer_id) * 100.0
        / SUM(COUNT(customer_id)) OVER (PARTITION BY segment), 1) AS pct_of_segment
FROM churn_classified
GROUP BY segment, churn_risk_level
ORDER BY segment, 
    CASE churn_risk_level
        WHEN 'High Risk'   THEN 1
        WHEN 'Medium Risk' THEN 2
        WHEN 'Low Risk'    THEN 3
        ELSE 4
    END;

-- ============================================================
-- QUERY 3: Cohort Retention Analysis
-- Business Use: Understand how well each acquisition cohort retains
-- ============================================================
WITH cohort_base AS (
    -- Find each customer's first transaction month (their cohort)
    SELECT
        customer_id,
        DATE_FORMAT(MIN(transaction_date), '%Y-%m')  AS cohort_month
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
),
customer_activity AS (
    -- Get every month each customer was active
    SELECT
        t.customer_id,
        DATE_FORMAT(t.transaction_date, '%Y-%m')     AS activity_month,
        cb.cohort_month
    FROM transactions t
    JOIN cohort_base cb ON t.customer_id = cb.customer_id
    WHERE t.status = 'Completed'
    GROUP BY t.customer_id, DATE_FORMAT(t.transaction_date, '%Y-%m'), cb.cohort_month
),
cohort_size AS (
    -- Count how many customers in each cohort
    SELECT cohort_month, COUNT(DISTINCT customer_id) AS cohort_total
    FROM cohort_base
    GROUP BY cohort_month
)
SELECT
    ca.cohort_month,
    cs.cohort_total,
    ca.activity_month,
    PERIOD_DIFF(
        REPLACE(ca.activity_month, '-', ''),
        REPLACE(ca.cohort_month,   '-', '')
    )                                               AS months_since_acquisition,
    COUNT(DISTINCT ca.customer_id)                  AS active_customers,
    ROUND(
        COUNT(DISTINCT ca.customer_id) * 100.0 / cs.cohort_total
    , 1)                                            AS retention_pct
FROM customer_activity ca
JOIN cohort_size cs ON ca.cohort_month = cs.cohort_month
GROUP BY ca.cohort_month, cs.cohort_total, ca.activity_month
ORDER BY ca.cohort_month, ca.activity_month;

-- ============================================================
-- QUERY 4: Customer Lifetime Value (CLV) Calculation
-- Business Use: Prioritise high-value customers for retention
-- ============================================================
WITH monthly_customer_revenue AS (
    SELECT
        customer_id,
        DATE_FORMAT(transaction_date, '%Y-%m')       AS txn_month,
        ROUND(SUM(amount), 2)                        AS monthly_revenue
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id, DATE_FORMAT(transaction_date, '%Y-%m')
),
customer_metrics AS (
    SELECT
        customer_id,
        ROUND(AVG(monthly_revenue), 2)               AS avg_monthly_revenue,
        COUNT(DISTINCT txn_month)                    AS active_months,
        ROUND(SUM(monthly_revenue), 2)               AS total_revenue,
        MIN(txn_month)                               AS first_active_month,
        MAX(txn_month)                               AS last_active_month
    FROM monthly_customer_revenue
    GROUP BY customer_id
)
SELECT
    cm.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)          AS customer_name,
    c.segment,
    c.annual_income,
    cm.avg_monthly_revenue,
    cm.active_months,
    cm.total_revenue                                 AS historical_clv,
    -- Projected 12-month CLV
    ROUND(cm.avg_monthly_revenue * 12, 2)            AS projected_12m_clv,
    -- Projected 36-month CLV (discounted at 10% annual rate)
    ROUND(cm.avg_monthly_revenue * 12 * 2.487, 2)   AS projected_36m_clv,
    RANK() OVER (ORDER BY cm.avg_monthly_revenue * 12 DESC) AS clv_rank,
    NTILE(5) OVER (ORDER BY cm.avg_monthly_revenue * 12 DESC) AS clv_quintile
FROM customer_metrics cm
JOIN customers c ON cm.customer_id = c.customer_id
ORDER BY projected_12m_clv DESC;

-- ============================================================
-- QUERY 5: Reactivation Priority List
-- Business Use: Which dormant customers are worth targeting?
-- ============================================================
WITH last_activity AS (
    SELECT
        customer_id,
        MAX(transaction_date)                       AS last_txn_date,
        ROUND(SUM(amount), 2)                       AS lifetime_spend,
        COUNT(*)                                    AS total_transactions
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)          AS customer_name,
    c.email,
    c.segment,
    la.last_txn_date,
    DATEDIFF(CURDATE(), la.last_txn_date)           AS days_inactive,
    la.lifetime_spend,
    la.total_transactions,
    a.balance                                       AS current_balance,
    -- Priority score: higher spend + longer dormancy = higher priority
    ROUND(
        (la.lifetime_spend / 1000) * 0.6
        + (DATEDIFF(CURDATE(), la.last_txn_date) / 30) * 0.4
    , 2)                                            AS reactivation_priority_score,
    RANK() OVER (
        ORDER BY
            (la.lifetime_spend / 1000) * 0.6
            + (DATEDIFF(CURDATE(), la.last_txn_date) / 30) * 0.4
        DESC
    )                                               AS priority_rank
FROM customers c
JOIN last_activity la ON c.customer_id = la.customer_id
JOIN accounts a       ON c.customer_id = a.customer_id
WHERE DATEDIFF(CURDATE(), la.last_txn_date) > 90
  AND c.is_active = TRUE
ORDER BY reactivation_priority_score DESC;
