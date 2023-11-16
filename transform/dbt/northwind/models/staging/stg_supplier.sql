{{
    config(
        materialized='table'
    )
}}
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
from {{ source('airbyte', 'suppliers') }}