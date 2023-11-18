
  
    

        create or replace transient table PROD.CURATED.preset_obt
         as
        (with fact_order as (
    select * from PROD.CURATED.fact_order
),

dim_product as (
    select * from PROD.CURATED.dim_product
),

dim_supplier as (
    select * from PROD.CURATED.dim_supplier
),

dim_customer as (
    select * from PROD.CURATED.dim_customer
)

select
    fact_order."ORDER_ID",
  fact_order."UNIT_PRICE",
  fact_order."QUANTITY",
  fact_order."NORMAL_RETAIL_VALUE",
  fact_order."DISCOUNT",
  fact_order."DISCOUNT_VALUE",
  fact_order."ACTUAL_RETAIL_VALUE",
  fact_order."PRICE_TYPE",
  fact_order."ORDER_DATE",
  fact_order."SHIPPED_DATE",
  fact_order."REQUIRED_DATE",
  fact_order."DAYS_TO_SHIP",
  fact_order."CUSTOMER_TIER",
  fact_order."UPDATED_AT",
    dim_product."PRODUCT_NAME",
  dim_product."CATEGORY_NAME",
  dim_product."REORDER_LEVEL",
  dim_product."DISCONTINUED",
  dim_product."UNITS_IN_STOCK",
  dim_product."UNITS_ON_ORDER",
    dim_supplier."SUPPLIER_ID",
  dim_supplier."SUPPLIER_COMPANY_NAME",
  dim_supplier."SUPPLIER_CONTACT_NAME",
  dim_supplier."SUPPLIER_CONTACT_TITLE",
  dim_supplier."SUPPLIER_ADDRESS",
  dim_supplier."SUPPLIER_CITY",
  dim_supplier."SUPPLIER_REGION",
  dim_supplier."SUPPLIER_POSTAL_CODE",
  dim_supplier."SUPPLIER_COUNTRY",
  dim_supplier."SUPPLIER_PHONE",
    dim_customer."CUSTOMER_COMPANY_NAME",
  dim_customer."CUSTOMER_CONTACT_NAME",
  dim_customer."CUSTOMER_CONTACT_TITLE",
  dim_customer."CUSTOMER_ADDRESS",
  dim_customer."CUSTOMER_CITY",
  dim_customer."CUSTOMER_REGION",
  dim_customer."CUSTOMER_POSTAL_CODE",
  dim_customer."CUSTOMER_COUNTRY",
  dim_customer."CUSTOMER_PHONE"
from fact_order
left join dim_product on fact_order.product_key = dim_product.product_key
left join dim_supplier on dim_product.supplier_key = dim_supplier.supplier_key
left join dim_customer on fact_order.customer_key = dim_customer.customer_key
        );
      
  