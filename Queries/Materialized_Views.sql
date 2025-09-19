-- =========================================================
-- 04_materialized_views.sql  (Amazon Redshift compatible)
-- NOTE: Redshift MVs do NOT allow COUNT(DISTINCT ...).
--       Drop before create to avoid "already exists" errors.
-- =========================================================

-- 1) Daily revenue (orders are 1 row per order in dw.fact_order)
drop materialized view if exists dw.mv_daily_revenue;

create materialized view dw.mv_daily_revenue as
select
  order_date,
  sum(revenue) as revenue,
  count(*)     as orders
from dw.fact_order
group by order_date;

-- 2) Product sales (include labels from dim_product)
drop materialized view if exists dw.mv_product_sales;

create materialized view dw.mv_product_sales as
select
  i.product_id,
  p.category,
  p.subcategory,
  p.brand,
  sum(i.qty)            as units,
  sum(i.extended_price) as sales
from dw.fact_order_item i
join dw.dim_product p
  on i.product_id = p.product_id
group by i.product_id, p.category, p.subcategory, p.brand;

-- 3) Customer lifecycle (order grain → count(*) is order count)
drop materialized view if exists dw.mv_customer_lifecycle;

create materialized view dw.mv_customer_lifecycle as
select
  customer_id,
  min(order_date) as first_order_date,
  max(order_date) as last_order_date,
  count(*)        as orders,
  sum(revenue)    as lifetime_revenue
from dw.fact_order
group by customer_id;

-- ---------------------------------------------------------
-- Refresh all MVs (run after loading facts/dims)
-- ---------------------------------------------------------
refresh materialized view dw.mv_daily_revenue;
refresh materialized view dw.mv_product_sales;
refresh materialized view dw.mv_customer_lifecycle;

-- ---------------------------------------------------------
-- Quick sanity checks (optional)
-- ---------------------------------------------------------
select * from dw.mv_daily_revenue      order by order_date desc limit 10;
select * from dw.mv_product_sales      order by sales desc      limit 10;
select * from dw.mv_customer_lifecycle order by lifetime_revenue desc limit 10;
