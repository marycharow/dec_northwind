
  
    

        create or replace transient table PROD.CURATED.dim_product
         as
        (with stg_product as (
    select cast(product_id as integer) as product_id,
    product_name,
    cast(unit_price as numeric(38,2)) as unit_price,
    cast(reorder_level as integer) as reorder_level,
    cast(discontinued as integer) as discontinued,
    cast(category_id as integer) as category_id,
    cast(units_in_stock as integer) as units_in_stock,
    cast(units_on_order as integer) as units_on_order,
    quantity_per_unit,
    cast(supplier_id as integer) as supplier_id
    from PROD.STAGING.stg_product
),

stg_category as(
    select cast(category_id as integer) as category_id,
    category_name,
    description
    from PROD.STAGING.stg_category
)

select
    
    
md5(cast(coalesce(cast(stg_product.product_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as product_key,
    stg_product.product_id,
    stg_product.product_name,
    stg_category.category_name,
    stg_product.reorder_level,
    stg_product.discontinued,
    stg_product.units_in_stock,
    stg_product.units_on_order,
    
    
md5(cast(coalesce(cast(stg_product.supplier_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as supplier_key
from stg_product
left join stg_category on stg_product.category_id = stg_category.category_id
        );
      
  