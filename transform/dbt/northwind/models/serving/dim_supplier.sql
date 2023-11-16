with stg_supplier as (
    select *
    from {{ ref('stg_supplier') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['stg_supplier.supplier_id']) }} as supplier_key,
    stg_supplier.supplier_id,
    stg_supplier.company_name,
    stg_supplier.contact_name,
    stg_supplier.contact_title,
    stg_supplier.address,
    stg_supplier.city,
    stg_supplier.region,
    stg_supplier.postal_code,
    stg_supplier.country,
    stg_supplier.phone
    from stg_supplier