{{
    config(
        severity = 'warn'
    )
}}
select
    *
from {{ ref('stg_order_detail') }} 
where
    discount < 0 or discount > 1