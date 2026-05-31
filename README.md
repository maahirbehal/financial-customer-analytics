# Financial Customer Analytics System
### MySQL · Microsoft Excel · End-to-End Analytics Project

![Schema](screenshots/database_schema.png)

---

## What This Project Is

This is a complete, end-to-end financial analytics system I built from scratch using **MySQL and Microsoft Excel** — no tutorials, no guided walkthrough.

It models how a retail bank's analytics team would work with real customer, transaction, loan, and branch data to answer the questions a business actually cares about:

- Which customers are about to churn — and which ones are worth saving?
- Which branches are underperforming relative to their size?
- How is revenue trending month over month?
- Which customers have the highest projected lifetime value?
- Where are the high-risk loans sitting in the portfolio?

The goal was to build something that reflects what a **Business Analyst or Data Analyst does day-to-day** — not just write queries, but connect SQL to business outcomes and communicate findings clearly.

---

## Tech Stack

| Tool | Purpose |
|---|---|
| MySQL 8.0 | Database engine — schema design, queries, procedures, triggers |
| MySQL Workbench | Query execution, EXPLAIN analysis, schema management |
| Microsoft Excel | Executive dashboard — 7 sheets, charts, conditional formatting |
| GitHub | Version control and portfolio documentation |

---

## Project Structure

```
financial-customer-analytics/
│
├── 01_schema/
│   └── create_tables.sql          ← 9 tables, FK constraints, indexes
│
├── 02_data/
│   └── seed_data.sql              ← 100 customers, 600+ transactions, 30 loans
│
├── 03_queries/
│   ├── 01_window_functions.sql    ← Rankings, MoM revenue, running balances
│   └── 02_churn_and_retention.sql ← Churn scoring, cohort retention, CLV
│
├── 04_procedures/
│   └── stored_procedures_and_triggers.sql  ← 2 triggers, 3 stored procedures
│
├── 05_optimisation/
│   └── query_optimisation.sql     ← EXPLAIN before/after, index strategy
│
├── 06_excel/
│   ├── export_queries.sql         ← 7 export-ready queries for Excel
│   └── financial_analytics_dashboard.xlsx  ← Final dashboard
│
├── screenshots/
│   ├── database_schema.png
│   ├── executive_summary.png
│   ├── cohort_heatmap.png
│   ├── churn_report.png
│   ├── branch_performance.png
│   └── explain_optimisation.png
│
└── README.md
```

---

## Database Schema

9 tables in third normal form (3NF), designed for both data integrity and query performance.

| Table | Description |
|---|---|
| `CUSTOMERS` | Demographics, income, segment, join date |
| `BRANCHES` | Locations, regions, headcount, managers |
| `PRODUCTS` | Product catalogue — savings, loans, credit cards, investments |
| `ACCOUNTS` | Links customers to products via a branch |
| `TRANSACTIONS` | Every financial movement — deposits, withdrawals, payments |
| `LOANS` | Loan terms, outstanding balances, repayment status |
| `REPAYMENTS` | Monthly payments with on-time tracking and days late |
| `ALERTS` | Auto-populated by trigger for high-value transactions |
| `MONTHLY_REPORTS` | Auto-populated by stored procedure for branch reporting |

**Key design decisions:**
- `DECIMAL(15,2)` for all monetary values — avoids floating-point precision errors
- Foreign keys indexed on all join columns — transactions and accounts perform well at scale
- `ALERTS` kept separate from `TRANSACTIONS` so fraud monitoring is decoupled from operations
- `is_on_time` and `days_late` stored explicitly in `REPAYMENTS` — risk scoring queries run in a single pass without derived calculations

---

## Analysis — What I Built and Why

### 1. Window Functions
**File:** `03_queries/01_window_functions.sql`

| Query | Function Used | Business Purpose |
|---|---|---|
| Customer spend ranking | `RANK()`, `NTILE()`, `PERCENT_RANK()` | Identify top-tier customers for premium offers |
| MoM revenue growth | `LAG()`, rolling `AVG() OVER` | Spot revenue trends and seasonal patterns |
| Running account balance | `SUM() OVER ROWS BETWEEN` | Simulate internal account statement view |
| Branch revenue share | `SUM() OVER ()` (no partition) | Each branch's % contribution to total portfolio |
| Top 3 spend categories per customer | `RANK() PARTITION BY customer_id` | Personalise product recommendations |

---

### 2. Churn Detection & Retention Analysis
**File:** `03_queries/02_churn_and_retention.sql`

**Churn scoring** — every customer classified into a risk tier based on days since last transaction:

| Risk Level | Threshold | Action |
|---|---|---|
| High Risk | 365+ days inactive | Immediate reactivation campaign |
| Medium Risk | 180–365 days | Targeted outreach |
| Low Risk | 90–180 days | Monitoring |
| Active | < 90 days | Standard engagement |

**Cohort retention analysis** — groups customers by their first transaction month, then tracks what percentage stay active in each subsequent month. Output feeds the colour-coded heatmap in the Excel dashboard.

**Customer Lifetime Value (CLV)** — calculated at three horizons:
- Historical CLV (actual spend to date)
- Projected 12-month CLV (avg monthly spend × 12)
- Projected 36-month CLV (discounted at 10% annual rate)

**Reactivation priority score** — dormant customers ranked by a weighted formula combining lifetime spend and recency, so retention budget goes to the most valuable inactive customers first.

---

### 3. Stored Procedures & Triggers
**File:** `04_procedures/stored_procedures_and_triggers.sql`

| Object | Type | What It Does |
|---|---|---|
| `flag_large_transaction` | Trigger | Fires on INSERT — logs any transaction > $10,000 into `ALERTS` with severity classification |
| `reactivate_dormant_account` | Trigger | Fires on INSERT — resets account status to Active when a dormant account transacts |
| `GenerateMonthlyBranchReport` | Stored Procedure | Populates `MONTHLY_REPORTS` for any given month — idempotent, safe to re-run |
| `CustomerRiskReport` | Stored Procedure | Returns all loan customers with late payment % and risk classification |
| `SegmentUpgradeReport` | Stored Procedure | Identifies Basic → Standard and Standard → Premium upgrade candidates |

---

### 4. Query Optimisation
**File:** `05_optimisation/query_optimisation.sql`

Every performance improvement is documented with `EXPLAIN` output before and after the change.

| Optimisation Applied | Before | After |
|---|---|---|
| Index on `customer_id` + `transaction_date` | Full table scan — ~600 rows | Index ref scan — ~6 rows |
| Correlated subquery → CTE rewrite | O(n²) — runs once per customer row | O(n) — single aggregation pass |
| Date range filter with covering index | Full scan | Index range scan, no table lookup |
| Explicit column selection vs `SELECT *` | Full row fetch | Reduced I/O — only needed columns |

This section deliberately goes beyond what most junior portfolios include. Knowing that a query is slow is basic. Knowing why — and being able to prove the fix — is what production SQL looks like.

---

## Excel Dashboard

7-sheet executive dashboard built entirely from SQL export queries.

![Executive Summary](screenshots/executive_summary.png)

| Sheet | Chart Type | What It Shows |
|---|---|---|
| Executive Summary | KPI cards | Total customers, deposits, loan book, transaction volume, key insights |
| MoM Growth | Line chart (dual series) | Monthly revenue with 3-month rolling average overlay |
| Customer Segments | Pie + segmented table | Distribution and avg balance by Premium / Standard / Basic tier |
| Churn Report | Colour-coded risk table | Every at-risk customer with risk level badges in red / amber / yellow |
| Branch Performance | Horizontal bar chart | Revenue, customers, and revenue per staff member by branch |
| Cohort Heatmap | Conditional formatting grid | Retention % — green (high) → red (low) |
| Top Customers | Horizontal bar chart | Top 20 customers ranked by projected 12-month CLV |

![Cohort Heatmap](screenshots/cohort_heatmap.png)
![Churn Report](screenshots/churn_report.png)
![Branch Performance](screenshots/branch_performance.png)

---

## How to Run This Project

**Requirements:** MySQL 8.0+, MySQL Workbench, Microsoft Excel

```bash
# Run files in this exact order in MySQL Workbench

01_schema/create_tables.sql              # Creates database and all 9 tables
02_data/seed_data.sql                    # Loads all data
03_queries/01_window_functions.sql       # Run and review results
03_queries/02_churn_and_retention.sql    # Run and review results
04_procedures/stored_procedures.sql      # Creates triggers and procedures
05_optimisation/query_optimisation.sql   # Run EXPLAIN blocks — screenshot before/after
06_excel/export_queries.sql              # Export each result as CSV for Excel
```

To export results in MySQL Workbench: run a query → right-click the result grid → **Export Recordset to an External File** → save as CSV → import into the matching Excel sheet.

---

## Skills Demonstrated

```
Database Design      → Normalised schema (3NF), FK constraints, index strategy
Advanced SQL         → Window functions, CTEs, subqueries, aggregations
Automation           → Stored procedures, triggers, idempotent reporting
Query Optimisation   → EXPLAIN analysis, covering indexes, CTE rewrites
Business Analysis    → Churn modelling, CLV, cohort analysis, risk scoring
Data Visualisation   → 7-sheet Excel dashboard, charts, conditional formatting
Documentation        → Inline comments written as first-person code narrative
```

---

## About Me

I'm an early-career analyst actively looking for **Business Analyst**, **Data Analyst**, and **IT Support** roles (entry-level and internships). I've completed 2 internships and built this project to demonstrate that I can work with real business data — not just write queries, but understand what they're for.

📧 [Connect with me on LinkedIn](www.linkedin.com/in/maahir-behal-720392242)

