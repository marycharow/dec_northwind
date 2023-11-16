
  
    

        create or replace transient table DEV.STAGING.stg_order_detail
         as
        (
select order_id,
product_id,
unit_price,
quantity,
discount
from airbyte_database.airbyte_schema.order_details
        );
      
  