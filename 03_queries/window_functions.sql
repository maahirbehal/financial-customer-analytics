-- Financial Customer Analytics System
-- Queries: 01_window_functions.sql
--
-- This file covers the core window function analysis I built for this project.
-- Window functions were the right tool here because I needed rankings, running
-- totals, and period-over-period comparisons without collapsing the underlying rows.
--
-- Queries in this file:
--   1. Customer spend ranking with quartiles (RANK, NTILE, PERCENT_RANK)
--   2. Month-over-month revenue growth (LAG, rolling average)
--   3. Running balance per customer (SUM OVER with ROWS BETWEEN)
--   4. Branch performance ranking (RANK, revenue share %)
--   5. Top 3 spending categories per customer (RANK partitioned by customer)

USE financial_analytics;


-- Query 1: Customer Spend Ranking with Quartiles
--
-- I wanted to go beyond a simple ORDER BY and show where each customer
-- sits relative to the rest of the portfolio. NTILE(4) splits them into
-- quartiles, PERCENT_RANK shows their exact percentile position.
-- This feeds directly into the segment upgrade recommendations.
SELECT
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)          AS customer_name,
    c.segment,
    c.city,
    c.state,
    ROUND(SUM(t.amount), 2)                          AS total_spend,
    COUNT(t.transaction_id)                          AS total_transactions,
    ROUND(AVG(t.amount), 2)                          AS avg_transaction_value,
    RANK()       OVER (ORDER BY SUM(t.amount) DESC)  AS spend_rank,
    DENSE_RANK() OVER (ORDER BY SUM(t.amount) DESC)  AS dense_spend_rank,
    NTILE(4)     OVER (ORDER BY SUM(t.amount) DESC)  AS spend_quartile,
    ROUND(PERCENT_RANK() OVER (ORDER BY SUM(t.amount) DESC) * 100, 1) AS percentile_pct
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name, c.segment, c.city, c.state
ORDER BY total_spend DESC;


-- Query 2: Month-over-Month Revenue Growth
--
-- LAG() lets me pull the previous month's revenue into the current row
-- so I can calculate growth % inline. I also added a 3-month rolling
-- average using ROWS BETWEEN to smooth out any single-month spikes,
-- which is more useful for trend spotting than raw MoM alone.
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(transaction_date, '%Y-%m')        AS txn_month,
        ROUND(SUM(amount), 2)                         AS total_revenue,
        COUNT(transaction_id)                         AS total_transactions,
        COUNT(DISTINCT customer_id)                   AS unique_customers
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
)
SELECT
    txn_month,
    total_revenue,
    total_transactions,
    unique_customers,
    LAG(total_revenue) OVER (ORDER BY txn_month)     AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY txn_month))
        / NULLIF(LAG(total_revenue) OVER (ORDER BY txn_month), 0) * 100
    , 2)                                             AS mom_growth_pct,
    -- 3-month rolling average — smooths out noise better than raw MoM
    ROUND(AVG(total_revenue) OVER (
        ORDER BY txn_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2)                                            AS rolling_3m_avg,
    SUM(total_revenue) OVER (ORDER BY txn_month)     AS cumulative_revenue
FROM monthly_revenue
ORDER BY txn_month;


-- Query 3: Running Balance per Customer
--
-- I built this to simulate what an account statement looks like internally.
-- Deposits and refunds increase the balance; everything else reduces it.
-- ROW_NUMBER gives each transaction a sequence number per customer,
-- which makes it easy to spot unusual jumps in the running total.
SELECT
    t.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)           AS customer_name,
    t.transaction_date,
    t.transaction_type,
    t.amount,
    t.merchant_category,
    ROUND(SUM(
        CASE
            WHEN t.transaction_type IN ('Deposit', 'Refund') THEN  t.amount
            ELSE                                                   -t.amount
        END
    ) OVER (
        PARTITION BY t.customer_id
        ORDER BY t.transaction_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2)                                            AS running_balance,
    ROW_NUMBER() OVER (
        PARTITION BY t.customer_id
        ORDER BY t.transaction_date
    )                                                AS txn_sequence
FROM transactions t
JOIN customers c ON t.customer_id = c.customer_id
WHERE t.status = 'Completed'
ORDER BY t.customer_id, t.transaction_date;


-- Query 4: Branch Performance Ranking
--
-- I added revenue_share_pct using SUM() OVER () with no partition —
-- that gives me the grand total to divide against, so I can see each
-- branch's contribution to the whole portfolio without a subquery.
SELECT
    b.branch_id,
    b.branch_name,
    b.city,
    b.region,
    COUNT(DISTINCT a.customer_id)                    AS total_customers,
    COUNT(t.transaction_id)                          AS total_transactions,
    ROUND(SUM(t.amount), 2)                          AS total_revenue,
    ROUND(AVG(a.balance), 2)                         AS avg_account_balance,
    RANK() OVER (ORDER BY SUM(t.amount) DESC)        AS revenue_rank,
    RANK() OVER (ORDER BY COUNT(DISTINCT a.customer_id) DESC) AS customer_rank,
    ROUND(
        SUM(t.amount) / SUM(SUM(t.amount)) OVER () * 100
    , 2)                                             AS revenue_share_pct
FROM branches b
JOIN accounts      a ON b.branch_id  = a.branch_id
JOIN transactions  t ON a.account_id = t.account_id
WHERE t.status = 'Completed'
GROUP BY b.branch_id, b.branch_name, b.city, b.region
ORDER BY revenue_rank;


-- Query 5: Top 3 Spending Categories per Customer
--
-- RANK() partitioned by customer_id resets the counter for each customer,
-- so I get independent category rankings per person rather than globally.
-- Filtering to rank <= 3 then gives me the top 3 spend categories per customer,
-- which is useful for personalised product recommendations.
WITH category_spend AS (
    SELECT
        customer_id,
        merchant_category,
        ROUND(SUM(amount), 2)                        AS category_total,
        COUNT(*)                                     AS category_count,
        RANK() OVER (
            PARTITION BY customer_id
            ORDER BY SUM(amount) DESC
        )                                            AS category_rank
    FROM transactions
    WHERE status = 'Completed'
      AND merchant_category IS NOT NULL
    GROUP BY customer_id, merchant_category
)
SELECT
    cs.customer_id,
    CONCAT(c.first_name, ' ', c.last_name)           AS customer_name,
    c.segment,
    cs.merchant_category,
    cs.category_total,
    cs.category_count,
    cs.category_rank
FROM category_spend cs
JOIN customers c ON cs.customer_id = c.customer_id
WHERE cs.category_rank <= 3
ORDER BY cs.customer_id, cs.category_rank;
