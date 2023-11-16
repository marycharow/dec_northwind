
  
    

        create or replace transient table DEV.STAGING.stg_category
         as
        (
select category_id,
category_name,
description
from airbyte_database.airbyte_schema.categories
        );
      
  