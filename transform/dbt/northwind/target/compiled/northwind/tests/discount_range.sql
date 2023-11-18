
select
    *
from PROD.STAGING.stg_order_detail 
where
    discount < 0 or discount > 1