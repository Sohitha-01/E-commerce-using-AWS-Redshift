-- =========================================================
-- 05_insights.sql  (Amazon Redshift compatible)
-- Chart-friendly aliases kept simple; casts used when helpful.
-- Run any section independently.
-- =========================================================

-- ---------------------------------------------------------
-- A) Monthly revenue (trend)
-- Line chart: X=month, Y=revenue
-- ---------------------------------------------------------
select
  date_trunc('month', order_date) as month,
  sum(revenue)                    as revenue
from dw.fact_order
group by 1
order by 1;

-- ---------------------------------------------------------
-- B) Monthly AOV (average order value)
-- Line chart: X=month, Y=aov
-- ---------------------------------------------------------
select
  date_trunc('month', order_date)       as month,
  sum(revenue) / nullif(count(*), 0)    as aov
from dw.fact_order
group by 1
order by 1;

-- ---------------------------------------------------------
-- C) Daily revenue (ready from MV)
-- Line chart: X=order_date, Y=revenue
-- ---------------------------------------------------------
select
  order_date,
  revenue,
  orders
from dw.mv_daily_revenue
order by order_date;

-- ---------------------------------------------------------
-- D) Top 10 categories by sales (ranking)
-- Horizontal bar: X=sales, Y=category
-- ---------------------------------------------------------
select
  category,
  sum(sales) as sales,
  sum(units) as units
from dw.mv_product_sales
group by category
order by sales desc
limit 10;

-- ---------------------------------------------------------
-- E) Top 10 products by sales (brand — subcategory label)
-- Horizontal bar: X=sales, Y=product_label
-- ---------------------------------------------------------
select
  (brand || ' — ' || subcategory) as product_label,
  sales                           as sales,
  units                           as units
from dw.mv_product_sales
order by sales desc
limit 10;

-- ---------------------------------------------------------
-- F) Top 10 customers by lifetime revenue
-- Bar chart: X=customer, Y=lifetime_revenue (cast to float)
-- If the chart picker is picky, keep exactly two columns.
-- ---------------------------------------------------------
-- Two-column, chart-friendly version:
select
  customer_id           as customer,
  sum(revenue)::float8  as lifetime_revenue
from dw.fact_order
group by 1
order by 2 desc
limit 10;

-- Rich table version (from MV):
select
  customer_id,
  first_order_date,
  last_order_date,
  orders,
  lifetime_revenue
from dw.mv_customer_lifecycle
order by lifetime_revenue desc
limit 10;

-- ---------------------------------------------------------
-- G) Conversion proxy: orders per web-event day
-- Line chart (prefer the ratio only), X=date, Y=orders_per_event
-- ---------------------------------------------------------
with e as (
  select date_trunc('day', event_ts) as d, count(*) as web_events
  from dw.fact_web_event
  group by 1
),
o as (
  select date_trunc('day', order_date) as d, count(*) as orders
  from dw.fact_order
  group by 1
)
select
  e.d,
  (coalesce(o.orders,0)::decimal / nullif(e.web_events,0)) as orders_per_event
from e
left join o using (d)
order by e.d;

-- ---------------------------------------------------------
-- H) Customer recency snapshot
-- How many customers idle >90 days since last order?
-- ---------------------------------------------------------
select
  count(*) as customers_idle_90d
from dw.mv_customer_lifecycle
where datediff(day, last_order_date, current_date) > 90;

-- ---------------------------------------------------------
-- I) Cohort (first-order month vs subsequent activity)
-- Heatmap-ready: X=month_offset, Y=cohort_month, value=active_customers
-- ---------------------------------------------------------
with firsts as (
  select customer_id, date_trunc('month', min(order_date)) as cohort_month
  from dw.fact_order
  group by 1
),
months as (
  select customer_id, date_trunc('month', order_date) as order_month
  from dw.fact_order
  group by 1,2
)
select
  cohort_month,
  datediff(month, cohort_month, order_month) as month_offset,
  count(distinct customer_id)                as active_customers
from firsts
join months using (customer_id)
group by 1,2
order by 1,2;

-- ---------------------------------------------------------
-- J) Product performance by brand (top 10)
-- Horizontal bar: X=sales, Y=brand
-- ---------------------------------------------------------
select
  brand,
  sum(sales) as sales,
  sum(units) as units
from dw.mv_product_sales
group by brand
order by sales desc
limit 10;

-- ---------------------------------------------------------
-- K) Product performance by subcategory (top 10)
-- Horizontal bar: X=sales, Y=subcategory
-- ---------------------------------------------------------
select
  subcategory,
  sum(sales) as sales,
  sum(units) as units
from dw.mv_product_sales
group by subcategory
order by sales desc
limit 10;

