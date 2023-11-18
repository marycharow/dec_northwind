with stg_customer as (
    select customer_id,
    company_name,
    contact_name,
    contact_title,
    address,
    city,
    region,
    postal_code,
    country,
    phone,
    fax
    from PROD.STAGING.stg_customer
)

select
    
    
md5(cast(coalesce(cast(stg_customer.customer_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customer_key,
    stg_customer.customer_id,
    stg_customer.company_name as customer_company_name,
    stg_customer.contact_name as customer_contact_name,
    stg_customer.contact_title as customer_contact_title,
    stg_customer.address as customer_address,
    stg_customer.city as customer_city,
    stg_customer.region as customer_region,
    stg_customer.postal_code as customer_postal_code,
    stg_customer.country as customer_country,
    stg_customer.phone as customer_phone
from stg_customer