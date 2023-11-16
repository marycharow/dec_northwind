with stg_customer as (
    select *
    from {{ ref('stg_customer') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['stg_customer.customer_id']) }} as customer_key,
    stg_customer.company_name,
    stg_customer.contact_name,
    stg_customer.contact_title,
    stg_customer.address,
    stg_customer.city,
    stg_customer.region,
    stg_customer.postal_code,
    stg_customer.country,
    stg_customer.phone
from stg_customer