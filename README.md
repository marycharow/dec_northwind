# dec_northwind
Data engineering project for retail data ELT

## 1. OBJECTIVE
Create an ELT pipeline moving data from the sample <a href="https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database">Northwind PostgreSQL database</a> to Snowflake where we curate tables that can be used for reporting and insights.

## 2. SOLUTION ARCHITECTURE
![plot](./readme_images/dec_northwind_solution_architecture.png)

## 3. DIMENSIONAL MODEL
The final curated tables in Snowflake are the following:
![plot](./readme_images/dec_northwind_erd.png)

In addition to these tables, a **one big table** is also created to be used for Preset visualization.

## 4. APPROACH
### Hosting Northwind database on RDS
An RDS instance as shown was created to host the PostgreSQL database.

![plot](./readme_images/dec_northwind_rds.png)

### Enabling CDC on RDS database
Because the Northwind datasets did not have a natural cursor field, CDC was enabled to allow for incremental syncing. This initially caused some hiccups as enabling replication on an RDS database requires slightly different commands, as found <a href="https://stackoverflow.com/questions/61912680/postgres-aws-rds-failed-to-create-replication-users">here</a> - thanks to the instructors for helping troubleshoot this!

### Data Ingestion using Airbyte
Airbyte was used to ingest data from PostgreSQL to Snowflake warehouse.

The **Source** was the RDS PostgreSQL instance containing the Northwind database.

The **Destination** was a Snowflake database named AIRBYTE_DATABASE. 

The replication is incremental as pictured in this Airbyte screenshot, using the _ab_cdc_lsn field created by enabling CDC.

![plot](./readme_images/dec_northwind_airbyte.png)

### Data Curation
1. Airbyte syncs raw tables to a database in the Snowflake account
2. dbt models create staging, snapshot, and serving tables. 
3. The snapshot table of stg_customer_customer_tier is used to implement dim_customer_tier as a slow-changing dimension table. The idea here was that we would like a record for each time a customer changes between Basic and Premium tier so that we always know under what tier was a specific order made. It also allows for analysis on tier migration behaviour (e.g. how long do customers take on average to upgrade to Premium, how long do they stay as Premium).

### Data Tests
1. Each serving table has dbt tests defined in the model's yml file. The unique, not_null, and accepted_values tests were used in various models.
2. An additional singular test was created called discount_range and is stored within the tests folder. As the discount column in the order detail table should only be a value within 0 and 1 (represents the percent discount given in decimal form), the test looks for any records where the discount record is below 0 or above 1.

### DEV and PROD runs
There are 2 Snowflake databases - a PROD and a DEV. 

![plot](./readme_images/dec_northwind_snowflake_databases.png)

All dbt models have the following jinja snippet in their yml files so that the tables are written to either the PROD or DEV database depending on what the target is set as in the profiles yml file.

![plot](./readme_images/dec_northwind_dev_prod.png)

### Workflows
Airflow was used to orchestrate the Airbyte sync and dbt project run.

This required the following setup in Airflow:
1. An Airbyte connection
2. Airflow variables to store the Snowflake dbt user login credentials


### VISUALIZATION
A Preset dashboard was created to visualize key metrics. 

![plot](./readme_images/dec_northwind_preset.png)

This required the creation of some metrics created in the semantic layer including: 
- total orders
- total active Premium customers
- Premium customer sales penetration
- average days to ship
- total units sold
- percent of orders sold on discount

## 5. NEXT STEPS/BACKLOG
A few items that would require further tweaking or I had hoped to complete as part of initial scope but ran out of time:
1. Additional singular tests
2. Split out dbt tasks within Airflow dag to reflect dependencies of models

