
    
    

select
    customer_tier_key as unique_field,
    count(*) as n_records

from PROD.CURATED.dim_customer_tier
where customer_tier_key is not null
group by customer_tier_key
having count(*) > 1


