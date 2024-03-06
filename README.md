Goal of the project:
The goal of this project is to showcase an end to end ELT pipeline from a data source to any data warehouse and to build data models to answer the following questions:
- Top 10 stores per transacted amount
- Top 10 products sold
- Average transacted amount per store typology and country
- Percentage of transactions per device type
- Average time for a store to perform its 5 first transactions

The steps of the ELT pipeline, which are presented in this repository are based on dbt modeling, leveraging SQL queries, with the assumption that they will be executed on a cloud based warehouse (e.g. Snowflake).

Pre-design step: A starting point of the ELT pipeline design is to have a good initial understanding about the type of data sources that are available on the one hand and on the other hand a good understanding about the analysis/reporting required. In the given case we have three data sources that have been made available. They are all related to one another and need to be combined in order for us to get the final data output. As part of the pre-design step also few initial data checks have been performed, for example uniqueness, not-nullness, detection of accepted values limits, aiming to identify edge cases or data quality inconsistencies that potentially need to be addressed during the data transformation process. When performing the mentioned tests on the provided data sets, none of the mentioned cases have been detected.

Design step: The following graph is used for a better visualisation of the implemented ELT pipeline design, with a focus on the transformation part of it.

![image](https://github.com/TanyaIvanova11/sumup-elt-design/assets/161938037/8536fac1-7f4b-4850-b39b-710f09af70f7)


- Data extraction and loading: For this project the raw data is provided in the form of .csv files and the way chosen to load it into the data warehouse and make it available for the transformation step is by creating dbt seeds out the files. This approach however would not be recommended in case of larger volumes of data because csv files have row limits (up to ~1 million rows) and are not easy to handle when new records are frequently added. Alternative ways to perform the extraction and load steps would depend on the source of the raw data and the data producers. A good example for creating a ELT pipeline at scale is to have the raw data stored into a cloud based object storage (e.g. S3 buckets in AWS)from where an external or in-house build tool can access the data, turn it into tables (in case it's saved in other format, e.g. .JSON) and loads it into a staging raw data tables in the data warehouse. It's important to have a well defined data loading policy (how often a check for new available data will be performed and when will the new data be loaded into the data warehouse) and implement freshness tests to monitor this process.

- Transformation: This step of the data pipeline is performed via the core data models layer. The chosen approach here is to implement a denormalized data warehouse design. The data models are divided in two sub-folders: one for dimensional tables and one for fact tables. For the 'transactions' data we create a fact table since it contains data about a business process and events related to it. For the 'devices' and 'stores' data, we choose to create dim tables, because they give further descriptive information about the data in the fact table. The materialization type chosen for the fact and row tables here is 'table'. This materialization provides faster querying and is more suitable when there are queries running on top of it (e.g. the queries provided in folder 'analyses' or when a BI tool is querying from these tables). If there is a big data flow expected to come in, then it would makes sense to incrementalize the tables (especially the fact table) and load only chunks of data into it over time.
Since the we have a small set of data source tables, to simplify the design we will use the fact model as sort of a one big table, where we join all data sources and create a data set which contains all information required to performed the end-goal analysis (the queries stored in 'analyses' folder).

- Analyses models: SQL queries which all query data from the fact_transaction table. The are all materialised as view because are simple, meaning should not require big computational resources and the output doesn't need to be stored as a separate table. If this data outputs are needed across a big data organisation, it is advaisable to move this analysis and queries to a BI tool. This would provide the business or non-technical users the possibility to self-serve their data analytics needs.

Additional steps:
- Testing: To insure the data quality provided by the data models, it is a good practice to implement tests on top of the created tables. dbt provides a handy way of doing so by adding tests as part of the model's configuration in the folder's .yml file. (for reference, see models/core/dim/schema.yml, rows 10-12 and 20-22).

- Documentation: This part is essential for maintaining transparency and providing a clear understanding about the data models, their lineage, and business logic embedded within them. During the model setup in the yml files we add a description of each data model/seed itself, as well as descriptions for their columns (as example, see seeds/schema.yml, rows 9-16).

- Automated data model refreshes: Updating models at regular intervals ensures that organisational insights are based on the latest data. Automating this step is important because it reduces manual effort and increases the agility in responding to business needs. There are different ways to set up this part of the data pipeline workflow. One option would be using orchestration tools like Apache Airflow where we can define the order in which predefined tasks, containing dbt commands, are executed. Another option is using dbt Cloud where jobs and their schedules can be created via an UI in a user-friendly way.

Answers to the above stated analysis questions: The results are provided in the form of screenshot of the Snowflake UI.
- Top 10 stores per transacted amount
  ![image](https://github.com/TanyaIvanova11/sumup-elt-design/assets/161938037/8cc1daf2-4b31-4843-a78f-c6974378d415)

- Top 10 products sold
  ![image](https://github.com/TanyaIvanova11/sumup-elt-design/assets/161938037/5df3e659-e78f-4700-9532-99f35951a615)

- Average transacted amount per store typology and country (sample)
  ![image](https://github.com/TanyaIvanova11/sumup-elt-design/assets/161938037/acd1874a-b282-4941-8319-a5574e0c75bf)

- Percentage of transactions per device type
  ![image](https://github.com/TanyaIvanova11/sumup-elt-design/assets/161938037/b0ae5231-dcc3-4233-ae79-4c22dbd72057)

- Average time for a store to perform its 5 first transactions
  ![image](https://github.com/TanyaIvanova11/sumup-elt-design/assets/161938037/acb8ead3-cc11-481c-935e-b7969b48d5c5)

