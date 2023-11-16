{{
    config(
        materialized='table'
    )
}}
select category_id,
category_name,
description
from {{ source('airbyte', 'categories') }}