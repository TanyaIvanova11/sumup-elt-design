Goal of the project:
The goal of this project is to showcase an end to end ELT pipeline from a data source to any data warehouse using and to build data models to answer the following
questions: 
● Top 10 stores per transacted amount
● Top 10 products sold
● Average transacted amount per store typology and country
● Percentage of transactions per device type
● Average time for a store to perform its 5 first transactions

The steps of the ELT pipeline, which are presented in this repository are based on dbt modeling, leveraging SQL queries, with the assumption that they will be executed on a cloud based warehouse (e.g. Snowflake).

Pre-design step: A staring point of the ELT pipeline design is to have a good initial understanding about the type of data sources that are available on the one hand and on the other had a good understanding about the end goal of the analysis/reporting required. In the given case we have three data sources have been made available, which are all related to one another and need to be combined in order for us to get to the final data output. As part of the pre-design step also few initial data checks have been preformed, for example uniqueness, not-nullness, detection of acceopted values limits, aiming to identify edge cases or data quality inconcistancies that potantially need to be addressed during the data transformation process. When performing the mentioned tests on the data for this take home challange, non of the mentioned cases have been detected. 

Design step: The following graph is used for a better visialisation of the implmented ELT pipeline design, with a focus on the transformation part of it. 
....

- Data extraction and loading: For this project the raw data is provided in the form of .csv files and the way chosen to load it into the data warehouse and make is available for the transformation step is by creating dbt seeds out the files. This approach however would not be recomanded in case of larger volumes of data because csv files have row limits (up to ~1 million rows). Alternative ways to perform the extraction and load steps would depend on the source of the raw data and the data producers. A good example for creating a ELT pipeline at scale is to have the raw data stored into a cloud based object storage (e.g. S3 buckts in AWS)from where an external or in-house build tool can access the data, turn it into tables (in case it's saved in other format, e.g. .JSON) and loads it into a staging raw data table in the data warehouse. It's important to have a well defined data loading policy (how often a check for new available data will be performed and when will it be reacing the data warehouse) and implement freshness tests to monitor this process. 

- Transformation: This step of the data pipeline is performed via the core data models layer. The chosen approach here is to implement a denormalized data warehouse design. The data models are devided in two sub-folders: one for dimentional tables and one for fact tables. For the 'transactions' data we create a fact table since it contains data about a business process and event related to it. For the 'devices' and 'stores' data, we choose to create dim tables, because they give further descriptive information about the data in fact table. The materialization type chosen for the fact and row tables here is 'table'. This materialization provides faster quering and is more suitable when there are queries running on top of it (e.g. the queries provided in folder 'analyses' or when a BI tool is quering from these tables). If there is a big data flow expected to come in, then it would makes sense to incrementalise the table (espefially the fact table) and load only cuncks of data into it over time.
Since the we have a small set of data source tables, to simplify the design we will use the fact model as sort of a one big table, where we join all data sources and create a data set which contains all information required to performed the end-goal analysis (the quearies stored in 'analyses' folder).

- Analysis: SQL queries which all query data from the transactions fact table (fact_transaction). The are all materialied as view because are simple, meaning should not require big computational resourses and the output doesn't need to be stored as a separate table. If this data outputs are needed accross a big data organisation, it is abvaisable to move this analysis and queries to a BI tool. This would provide the business or non-technical users the posibility to self-serve their data analytics needs. 

Additional steps: 
- Orchestration: 
 Airflow dag, dbt cloud:
  dim_store > dim_device > fact_transactions
- Testing: To insure the data quality provided by the data models, it is a good practice to implement tests on top of the created tables. dbt provides a handy way of doing so by adding tests as part of the model's configuration in the folder's .yml file. (for reference, see models/core/dim/schema.yml, rows 10-12 and 20-22)
- Documentation: 

Output step:
- results from the queries
