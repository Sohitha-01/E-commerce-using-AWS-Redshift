-- schemas for raw loads and analytics
create schema if not exists stg;
create schema if not exists dw;
-- 1) customers
create table if not exists stg.customers_raw (
  customer_id varchar,
  created_at  timestamp,
  full_name   varchar,
  email       varchar,
  city        varchar,
  state       varchar,
  country     varchar
);

-- 2) products
create table if not exists stg.products_raw (
  product_id  varchar,
  category    varchar,
  subcategory varchar,
  brand       varchar,
  price       decimal(12,2),
  active_flag boolean
);

-- 3) orders
create table if not exists stg.orders_raw (
  order_id     varchar,
  customer_id  varchar,
  order_ts     timestamp,
  channel      varchar,
  coupon_code  varchar,
  total_amount decimal(12,2)
);

-- 4) order_items
create table if not exists stg.order_items_raw (
  order_id   varchar,
  product_id varchar,
  qty        int,
  item_price decimal(12,2)
);

-- 5) web_events
create table if not exists stg.web_events_raw (
  event_ts    timestamp,
  customer_id varchar,
  session_id  varchar,
  event_type  varchar,
  product_id  varchar,
  page_path   varchar
);