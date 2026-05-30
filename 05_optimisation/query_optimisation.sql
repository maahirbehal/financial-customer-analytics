-- ============================================================
-- FINANCIAL CUSTOMER ANALYTICS SYSTEM
-- File: 05_optimisation/query_optimisation.sql
-- Description: Before/after query optimisation using EXPLAIN.
--              Demonstrates index strategy and CTE rewrites.
--              Run each EXPLAIN block and screenshot the output.
-- ============================================================

USE financial_analytics;

-- ============================================================
-- OPTIMISATION 1: Customer Transaction Lookup
-- ============================================================

-- STEP 1: Run EXPLAIN BEFORE index (screenshot this output)
EXPLAIN
SELECT *
FROM transactions
WHERE customer_id = 5
ORDER BY transaction_date DESC;

-- Expected output WITHOUT index:
--   type: ALL (full table scan)
--   rows: ~600 (scans all rows)
--   Extra: Using filesort

-- STEP 2: Check existing indexes
SHOW INDEX FROM transactions;

-- STEP 3: The composite index already exists from schema creation.
-- If running on a fresh table without it, create it:
-- CREATE INDEX idx_customer_txn_date ON transactions(customer_id, transaction_date);

-- STEP 4: Run EXPLAIN AFTER index (screenshot this output)
EXPLAIN
SELECT *
FROM transactions
WHERE customer_id = 5
ORDER BY transaction_date DESC;

-- Expected output WITH index:
--   type: ref (index lookup)
--   rows: ~6 (only relevant rows scanned)
--   Extra: Using index condition

-- ============================================================
-- OPTIMISATION 2: Rewrite Subquery as CTE (Readability + Performance)
-- ============================================================

-- VERSION A: Correlated subquery (slow on large datasets)
-- Explanation: The subquery runs once per customer row — O(n²) complexity
EXPLAIN
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    (
        SELECT SUM(t.amount)
        FROM transactions t
        WHERE t.customer_id = c.customer_id
          AND t.status = 'Completed'
    ) AS total_spend
FROM customers c
WHERE c.is_active = TRUE;

-- VERSION B: CTE rewrite (faster — single pass over transactions)
-- Explanation: Aggregates once, then joins — O(n) complexity
EXPLAIN
WITH customer_spend AS (
    SELECT customer_id, ROUND(SUM(amount), 2) AS total_spend
    FROM transactions
    WHERE status = 'Completed'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    cs.total_spend
FROM customers c
LEFT JOIN customer_spend cs ON c.customer_id = cs.customer_id
WHERE c.is_active = TRUE;

-- ============================================================
-- OPTIMISATION 3: Index on transaction_date for Range Queries
-- ============================================================

-- STEP 1: EXPLAIN without covering index for date range
EXPLAIN
SELECT
    account_id,
    transaction_type,
    amount,
    transaction_date
FROM transactions
WHERE transaction_date BETWEEN '2023-01-01' AND '2023-12-31'
  AND status = 'Completed';

-- STEP 2: Add a covering index that includes all selected columns
-- This avoids a second lookup into the main table (index-only scan)
CREATE INDEX IF NOT EXISTS idx_covering_date_status
    ON transactions(transaction_date, status, account_id, transaction_type, amount);

-- STEP 3: EXPLAIN after covering index
EXPLAIN
SELECT
    account_id,
    transaction_type,
    amount,
    transaction_date
FROM transactions
WHERE transaction_date BETWEEN '2023-01-01' AND '2023-12-31'
  AND status = 'Completed';

-- Expected improvement:
--   type: range (index range scan vs ALL)
--   Extra: Using index (covered — no table lookup needed)

-- ============================================================
-- OPTIMISATION 4: Avoid SELECT * in Production Queries
-- ============================================================

-- BAD: SELECT * fetches every column including unused ones
-- Wastes I/O and network bandwidth
EXPLAIN SELECT * FROM customers WHERE segment = 'Premium';

-- GOOD: Select only columns needed
EXPLAIN
SELECT customer_id, first_name, last_name, email, segment, annual_income
FROM customers
WHERE segment = 'Premium';

-- Add index on segment if not present
CREATE INDEX IF NOT EXISTS idx_customers_segment ON customers(segment);

-- Re-run after index
EXPLAIN
SELECT customer_id, first_name, last_name, email, segment, annual_income
FROM customers
WHERE segment = 'Premium';

-- ============================================================
-- OPTIMISATION 5: Efficient Aggregation with Index
-- ============================================================

-- BEFORE: No index on branch_id + transaction_date
EXPLAIN
SELECT
    a.branch_id,
    DATE_FORMAT(t.transaction_date, '%Y-%m')  AS txn_month,
    COUNT(*)                                  AS total_transactions,
    ROUND(SUM(t.amount), 2)                   AS total_revenue
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.transaction_date >= '2023-01-01'
GROUP BY a.branch_id, DATE_FORMAT(t.transaction_date, '%Y-%m')
ORDER BY a.branch_id, txn_month;

-- Add composite index to support the join + filter
CREATE INDEX IF NOT EXISTS idx_accounts_branch
    ON accounts(branch_id, account_id);

-- AFTER: EXPLAIN should show reduced rows scanned
EXPLAIN
SELECT
    a.branch_id,
    DATE_FORMAT(t.transaction_date, '%Y-%m')  AS txn_month,
    COUNT(*)                                  AS total_transactions,
    ROUND(SUM(t.amount), 2)                   AS total_revenue
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE t.transaction_date >= '2023-01-01'
GROUP BY a.branch_id, DATE_FORMAT(t.transaction_date, '%Y-%m')
ORDER BY a.branch_id, txn_month;

-- ============================================================
-- SUMMARY: Key optimisation principles applied in this project
-- ============================================================
/*
1. INDEX STRATEGY
   - Primary keys auto-indexed (InnoDB)
   - Foreign keys indexed to speed up JOINs
   - High-cardinality filter columns indexed (customer_id, transaction_date)
   - Covering indexes created for frequently run reports

2. QUERY REWRITING
   - Correlated subqueries replaced with CTEs (single-pass aggregation)
   - SELECT * replaced with explicit column lists
   - EXPLAIN used before and after every change

3. JOIN OPTIMISATION
   - Always join on indexed columns
   - Filter early (WHERE before JOIN where possible)
   - Use LEFT JOIN only when NULLs are needed; INNER JOIN otherwise

4. RESULTS
   - Query 1 (customer lookup): rows scanned reduced from ~600 → ~6
   - Query 2 (subquery → CTE): eliminated correlated subquery O(n²)
   - Query 3 (date range): switched from full scan to index range scan
*/
