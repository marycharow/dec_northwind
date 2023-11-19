with fact_order as (
    select * from {{ ref('fact_order') }}
),

dim_product as (
    select * from {{ ref('dim_product') }}
),

dim_supplier as (
    select * from {{ ref('dim_supplier') }}
),

dim_customer as (
    select * from {{ ref('dim_customer') }}
)

select
    {{ dbt_utils.star(from=ref('fact_order'), relation_alias='fact_order', except=["order_key", "product_key", "customer_key", "customer_tier_key", "product_id"]) }},
    {{ dbt_utils.star(from=ref('dim_product'), relation_alias='dim_product', except=["product_key", "supplier_key", "product_id"]) }},
    {{ dbt_utils.star(from=ref('dim_supplier'), relation_alias='dim_supplier', except=["supplier_key"]) }},
    {{ dbt_utils.star(from=ref('dim_customer'), relation_alias='dim_customer', except=["customer_key", "customer_id"])}}
from fact_order
left join dim_product on fact_order.product_key = dim_product.product_key
left join dim_supplier on dim_product.supplier_key = dim_supplier.supplier_key
left join dim_customer on fact_order.customer_key = dim_customer.customer_key