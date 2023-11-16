
  
    

        create or replace transient table DEV.STAGING.stg_supplier
         as
        (
select supplier_id,
country,
contact_name,
address,
city,
phone,
company_name,
fax,
region,
postal_code,
contact_title
from airbyte_database.airbyte_schema.suppliers
        );
      
  