{% snapshot snp_customer_customer_type %}

{{
    config(
        target_schema='SNAPSHOT',
        strategy='check',
        unique_key='customer_id',
        check_cols=['customer_type_id']
    )
}}

select * from {{ source('prod_staging', 'stg_customer_customer_type')}}

{% endsnapshot %}