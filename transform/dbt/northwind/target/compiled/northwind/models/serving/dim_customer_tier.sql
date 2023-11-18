with snp_customer_customer_type as (
    select customer_id,
    cast(customer_type_id as integer) as customer_type_id,
    dbt_valid_from,
    dbt_valid_to
    from PROD.SNAPSHOT.snp_customer_customer_type
),

stg_customer_type as (
    select *
    from PROD.STAGING.stg_customer_type
)

select
    
    
md5(cast(coalesce(cast(snp_customer_customer_type.customer_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(snp_customer_customer_type.customer_type_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(snp_customer_customer_type.dbt_valid_from as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customer_tier_key,
    snp_customer_customer_type.customer_id,
    snp_customer_customer_type.customer_type_id as customer_tier_id,
    stg_customer_type.customer_desc as customer_tier,
    snp_customer_customer_type.dbt_valid_from as valid_from, 
    snp_customer_customer_type.dbt_valid_to as valid_to
from snp_customer_customer_type
left join stg_customer_type on snp_customer_customer_type.customer_type_id=stg_customer_type.customer_type_id