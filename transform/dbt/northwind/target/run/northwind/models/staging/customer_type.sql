
  
    

        create or replace transient table northwind.RAW_staging.customer_type
         as
        (
select customer_type_id,
customer_desc
from airbyte_database.airbyte_schema.customer_type
        );
      
  