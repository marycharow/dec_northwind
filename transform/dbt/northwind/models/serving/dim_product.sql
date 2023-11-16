with stg_product as (
    select *
    from {{ ref('stg_product') }}
),

stg_category as(
    select *
    from {{ ref('stg_category') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['stg_product.product_id']) }} as product_key,
    stg_product.product_id,
    stg_product.product_name,
    stg_category.category_name,
    stg_product.reorder_level,
    stg_product.discontinued,
    stg_product.units_in_stock,
    stg_product.units_on_order,
    {{ dbt_utils.generate_surrogate_key(['stg_product.supplier_id']) }} as supplier_key
from stg_product
left join stg_category on stg_product.category_id = stg_category.category_id