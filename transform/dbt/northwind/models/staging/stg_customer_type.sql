{{
    config(
        materialized='table'
    )
}}
select customer_type_id,
customer_desc
from {{ source('airbyte', 'customer_type') }}