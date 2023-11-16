{{
    config(
        materialized='table'
    )
}}
select customer_id,
customer_type_id
from {{ source('airbyte', 'customer_customer_type') }}