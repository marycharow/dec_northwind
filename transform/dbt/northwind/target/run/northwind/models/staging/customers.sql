
  
    

        create or replace transient table northwind.RAW_staging.customers
         as
        (
select customer_id,
company_name,
contact_name,
contact_title,
address,
city,
region,
postal_code,
country,
phone,
fax
from airbyte_database.airbyte_schema.customers
        );
      
  