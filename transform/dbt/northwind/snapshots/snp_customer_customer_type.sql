{% snapshot snp_customer_customer_type %}

{{
    config(
        strategy='check',
        unique_key='customer_id',
        check_cols=['customer_type_id']
    )
}}

select * from {{ source('sources', 'customer_customer_type')}}

{% endsnapshot %}