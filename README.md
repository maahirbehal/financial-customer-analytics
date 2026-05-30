# Financial Customer Analytics System

## End-to-End SQL + Excel Analytics Project

This project is an end-to-end **Financial Customer Analytics System** built using **MySQL** and **Microsoft Excel**. It simulates how a retail bank can use customer, account, transaction, loan, and branch data to answer business questions around customer churn, retention, branch performance, revenue growth, and customer lifetime value.

This project uses **synthetic banking data** created for portfolio demonstration purposes.

---

## Project Objective

A retail bank needs a centralised analytics system to answer key business questions:

- Which customers are at risk of churning?
- Which customers are worth prioritising for retention?
- Which branches are underperforming?
- How does revenue change month over month?
- Which customers have the highest projected lifetime value?
- Which customer segments should be targeted for premium products?

The project connects **database design**, **SQL analysis**, **business logic**, and **Excel dashboarding** into one complete analytics workflow.

---

## Tools Used

| Tool | Purpose |
|---|---|
| MySQL | Database creation, data storage, and SQL analysis |
| MySQL Workbench | Query execution and schema management |
| Microsoft Excel | Dashboard creation and data visualisation |
| GitHub | Project documentation and version control |

---

## Project Structure

```text
financial-customer-analytics/
│
├── 01_schema/
│   └── create_tables.sql
│
├── 02_data/
│   └── seed_data.sql
│
├── 03_queries/
│   ├── 01_window_functions.sql
│   └── 02_churn_and_retention.sql
│
├── 04_procedures/
│   └── stored_procedures_and_triggers.sql
│
├── 05_optimisation/
│   └── query_optimisation.sql
│
├── 06_excel/
│   ├── export_queries.sql
│   └── financial_analytics_dashboard.xlsx
│
├── screenshots/
│   ├── executive_summary.png
│   ├── cohort_retention_heatmap.png
│   ├── churn_risk_report.png
│   └── branch_performance.png
│
└── README.md
