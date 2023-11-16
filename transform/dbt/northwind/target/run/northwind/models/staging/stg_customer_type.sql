
  
    

        create or replace transient table DEV.STAGING.stg_customer_type
         as
        (
select customer_type_id,
customer_desc
from airbyte_database.airbyte_schema.customer_type
        );
      
  