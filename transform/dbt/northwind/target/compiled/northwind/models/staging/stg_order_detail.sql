
select order_id,
product_id,
unit_price,
quantity,
discount,
_ab_cdc_updated_at as updated_at
from airbyte_database.airbyte_schema.order_details