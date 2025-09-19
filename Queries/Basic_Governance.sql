-- create a reader (if you have admin rights)
-- create user bi_user password 'StrongPW1!';
-- create group bi_group; alter group bi_group add user bi_user;

grant usage on schema dw to public;
grant select on all tables in schema dw to public;
alter default privileges in schema dw grant select on tables to public;