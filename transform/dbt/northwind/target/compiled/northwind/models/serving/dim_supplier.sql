with stg_supplier as (
    select cast(supplier_id as integer) as supplier_id,
    country,
    contact_name,
    address,
    city,
    phone,
    company_name,
    fax,
    region,
    postal_code,
    contact_title
    from PROD.STAGING.stg_supplier
)

select
    
    
md5(cast(coalesce(cast(stg_supplier.supplier_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as supplier_key,
    stg_supplier.supplier_id,
    stg_supplier.company_name as supplier_company_name,
    stg_supplier.contact_name as supplier_contact_name,
    stg_supplier.contact_title as supplier_contact_title,
    stg_supplier.address as supplier_address,
    stg_supplier.city as supplier_city,
    stg_supplier.region as supplier_region,
    stg_supplier.postal_code as supplier_postal_code,
    stg_supplier.country as supplier_country,
    stg_supplier.phone as supplier_phone
    from stg_supplier