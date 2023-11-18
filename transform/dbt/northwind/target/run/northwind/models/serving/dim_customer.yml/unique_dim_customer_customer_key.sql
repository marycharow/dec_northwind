select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    customer_key as unique_field,
    count(*) as n_records

from PROD.CURATED.dim_customer
where customer_key is not null
group by customer_key
having count(*) > 1



      
    ) dbt_internal_test