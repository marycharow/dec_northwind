
  create or replace   view NORTHWIND.prod_CURATED.dim_customer
  
   as (
    with stg_customer as (
    select *
    from northwind.prod_staging.stg_customer
)

select
    
    
md5(cast(coalesce(cast(stg_customer.customer_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customer_key,
    stg_customer.company_name,
    stg_customer.contact_name,
    stg_customer.contact_title,
    stg_customer.address,
    stg_customer.city,
    stg_customer.region,
    stg_customer.postal_code,
    stg_customer.country,
    stg_customer.phone
from stg_customer
  );

