select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
select
    *
from PROD.STAGING.stg_order_detail 
where
    discount < 0 or discount > 1
      
    ) dbt_internal_test