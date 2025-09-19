-- CUSTOMERS
copy stg.customers_raw
from 's3://kommi-redshift-demo-12345/raw/customers.csv'
iam_role 'arn:aws:iam::629143593683:role/RedshiftS3AccessRole'
csv
quote '"'
ignoreheader 1
acceptinvchars
truncatecolumns
fillrecord
dateformat 'auto' timeformat 'auto';

-- PRODUCTS
copy stg.products_raw
from 's3://kommi-redshift-demo-12345/raw/products.csv'
iam_role 'arn:aws:iam::629143593683:role/RedshiftS3AccessRole'
csv
quote '"'
ignoreheader 1
acceptinvchars
truncatecolumns
fillrecord;

-- ORDERS
copy stg.orders_raw
from 's3://kommi-redshift-demo-12345/raw/orders.csv'
iam_role 'arn:aws:iam::629143593683:role/RedshiftS3AccessRole'
csv
quote '"'
ignoreheader 1
acceptinvchars
truncatecolumns
fillrecord
dateformat 'auto' timeformat 'auto';

-- ORDER ITEMS
copy stg.order_items_raw
from 's3://kommi-redshift-demo-12345/raw/order_items.csv'
iam_role 'arn:aws:iam::629143593683:role/RedshiftS3AccessRole'
csv
quote '"'
ignoreheader 1
acceptinvchars
truncatecolumns
fillrecord;

-- WEB EVENTS
copy stg.web_events_raw
from 's3://kommi-redshift-demo-12345/raw/web_events.csv'
iam_role 'arn:aws:iam::629143593683:role/RedshiftS3AccessRole'
csv
quote '"'
ignoreheader 1
acceptinvchars
truncatecolumns
fillrecord
dateformat 'auto' timeformat 'auto';