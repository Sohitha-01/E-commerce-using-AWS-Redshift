-- duplicates by natural key
select product_id, count(*) c from dw.dim_product group by 1 having count(*)>1;
-- invalid foreign keys
select count(*) missing_products
from dw.fact_order_item i
left join dw.dim_product p on p.product_id=i.product_id
where p.product_id is null;