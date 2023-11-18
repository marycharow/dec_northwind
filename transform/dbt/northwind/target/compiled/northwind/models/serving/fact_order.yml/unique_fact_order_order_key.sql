
    
    

select
    order_key as unique_field,
    count(*) as n_records

from PROD.CURATED.fact_order
where order_key is not null
group by order_key
having count(*) > 1


