# AWS Redshift E-commerce Data Warehouse Project

---

## 📘 Project Overview

This project demonstrates how to design and implement a complete Data
Warehouse solution on AWS Redshift using an e-commerce dataset. The
pipeline covers staging, data loading from S3, building dimension and
fact tables, creating materialized views, and generating insights with
charts.

---
## 📂 Project Structure
--
```
AWS-Redshift-Project/
├─ Data/                           # Raw datasets stored in S3
├─ SQL/
│ ├─ 01_create_schemas.sql         # Create schemas & staging tables
│ ├─ 02_load_staging.sql           # COPY commands to load data from S3
│ ├─ 03_transform_dw.sql           # Create dimensions & facts
│ ├─ 04_materialized_views.sql     # Business aggregations
│ ├─ 05_insights.sql               # Analysis queries
├─ Images/
│ ├─ ERD.png                       # Entity-Relationship Diagram
│ ├─ Pipeline.png                  # Data Pipeline Architecture
│ ├─ Charts/                       # Key visualizations
├─ Report/
│ └─ Project_Report.docx           # Full documentation
└─ README.md
```
---

## 🎯 Project Goals
--
- Build a Redshift Data Warehouse for an e-commerce dataset.
- Automate loading from Amazon S3 into staging tables.
- Transform staging into clean star-schema (facts & dimensions).
- Create materialized views for analytics.
- Provide insights with queries and charts.

---

## 📊 Data
--
- Source: Synthetic e-commerce dataset (customers, products, orders,
order_items, web_events).
- Stored in: Amazon S3 bucket (`s3://kommi-redshift-demo-12345/`).
- Size: ~200K records across multiple tables.

---

## ⚡ Quick Start
--
1. Upload raw data to S3.
2. Set up an Amazon Redshift Serverless workgroup.
3. Associate IAM role with S3 read permissions.
4. Run SQL scripts in order:
- 01_create_schemas.sql
- 02_load_staging.sql
- 03_transform_dw.sql
- 04_materialized_views.sql
- 05_insights.sql

---

## 🛠️ Methodology
--
**1. Create Schemas & Staging Tables**
```
Schemas `stg` (staging) and `dw` (data warehouse) were created. Raw data
tables are loaded into staging before transformations.
```
**2. Load Data from S3**
```
COPY commands were used to load CSV files from S3 into staging tables.
Options like `IGNOREHEADER`, `ACCEPTINVCHARS`, and `TRUNCATECOLUMNS`
ensured compatibility.
```
**3. Build DW Dimensions & Facts**
```
Using staging tables, we created star schema:
- Dimensions: `dim_customer`, `dim_product`, `dim_date`
- Facts: `fact_order`, `fact_order_item`, `fact_web_event`
```
**4. Materialized Views**
```
To optimize BI queries, we created materialized views:
- `mv_daily_revenue`: Revenue & orders by day.
- `mv_product_sales`: Units & sales by product/category.
- `mv_customer_lifecycle`: Customer LTV, first/last order.
```
**5. Insights & Charts**
```
SQL queries provided KPIs and trends:
- Monthly revenue and Average Order Value (AOV).
- Revenue by product category.
- Conversion proxy (orders per web event).
Charts were built using Redshift Query Editor v2 visualization tools.
```
---

## 🔐 Governance
--
A read-only BI role can be granted SELECT privileges on the `dw` schema.
Default privileges ensure future tables are queryable by analysts.

---

## 📌 Results
--
- ✅ Data successfully staged from S3 into Redshift.
- ✅ Star schema (facts & dimensions) created.
- ✅ Materialized views accelerated reporting.
- ✅ Insights include daily revenue, top products, customer LTV.

---

## 📊 ERD & Pipeline
--
See `Images/ERD.png` and `Images/Pipeline.png` for detailed
architecture.

---

## 📜 License
--
This project is open-source under the MIT License.
