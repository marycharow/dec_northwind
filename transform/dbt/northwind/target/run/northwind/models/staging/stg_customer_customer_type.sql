
  
    

        create or replace transient table DEV.STAGING.stg_customer_customer_type
         as
        (
select customer_id,
customer_type_id
from airbyte_database.airbyte_schema.customer_customer_type
        );
      
  