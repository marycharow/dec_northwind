
  
    

        create or replace transient table DEV.STAGING.stg_order
         as
        (
select order_id,
customer_id,
ship_city,
ship_postal_code,
required_date,
freight,
ship_region,
order_date,
shipped_date,
ship_via,
ship_address,
ship_name,
ship_country
from airbyte_database.airbyte_schema.orders
where _ab_cdc_deleted_at is null
        );
      
  