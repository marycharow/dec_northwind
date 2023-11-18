{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='order_key',
        on_schema_change='fail',
    )
}}

with stg_order as (
    select
        cast(order_id as integer) as order_id,
        customer_id,
        ship_city,
        ship_postal_code,
        date(required_date) as required_date,
        freight,
        ship_region,
        date(order_date) as order_date,
        date(shipped_date) as shipped_date,
        ship_via,
        ship_address,
        ship_name,
        ship_country,
        cast(updated_at as timestamp) as updated_at
    from {{ ref('stg_order') }}
),

stg_order_detail as (
    select
        cast(order_id as integer) as order_id,
        cast(product_id as integer) as product_id,
        cast(unit_price as numeric(38,2)) as unit_price,
        cast(quantity as integer) as quantity,
        cast(discount as numeric(38,2)) as discount,
        cast(updated_at as timestamp) as updated_at
    from {{ ref('stg_order_detail') }}
),

dim_customer_tier as (
    select 
        customer_tier_key,
        customer_id,
        customer_tier_id,
        customer_tier,
        valid_from,
        valid_to
    from {{ ref('dim_customer_tier') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['stg_order.order_id', 'stg_order_detail.product_id']) }} as order_key,
    {{ dbt_utils.generate_surrogate_key(['stg_order_detail.product_id']) }} as product_key,
    {{ dbt_utils.generate_surrogate_key(['stg_order.customer_id']) }} as customer_key,
    stg_order.order_id,
    stg_order_detail.product_id,
    stg_order_detail.unit_price,
    stg_order_detail.quantity,
    stg_order_detail.unit_price * stg_order_detail.quantity as normal_retail_value,
    stg_order_detail.discount,
    stg_order_detail.discount * stg_order_detail.unit_price * stg_order_detail.quantity as discount_value,
    stg_order_detail.unit_price * stg_order_detail.quantity * (1 - stg_order_detail.discount) as actual_retail_value,
    case when stg_order_detail.discount > 0 then 'Discounted' else 'Regular' end as price_type,
    stg_order.order_date,
    stg_order.shipped_date,
    stg_order.required_date,
    datediff(day, order_date, shipped_date) as days_to_ship,
    dim_customer_tier.customer_tier_key,
    dim_customer_tier.customer_tier,
    stg_order_detail.updated_at
from stg_order
inner join stg_order_detail on stg_order.order_id = stg_order_detail.order_id
left join dim_customer_tier on stg_order.customer_id = dim_customer_tier.customer_id
and stg_order.order_date >= dim_customer_tier.valid_from
and stg_order.order_date < coalesce(dim_customer_tier.valid_to, cast('2999-01-01' as date)) 

{% if is_incremental() %}
    where stg_order_detail.updated_at > (select max(updated_at) from {{ this }})
{% endif %}

