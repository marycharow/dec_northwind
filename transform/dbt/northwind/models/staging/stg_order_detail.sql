{{
    config(
        materialized='table'
    )
}}
select order_id,
product_id,
unit_price,
quantity,
discount,
_ab_cdc_updated_at as updated_at
from {{ source('airbyte', 'order_details') }}