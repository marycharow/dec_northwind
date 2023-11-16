{{
    config(
        materialized='table'
    )
}}
select order_id,
product_id,
unit_price,
quantity,
discount
from {{ source('airbyte', 'order_details') }}