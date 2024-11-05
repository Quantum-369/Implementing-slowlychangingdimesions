# Implementing Slow-Changing Dimensions in a Data Warehouse using Hive and Spark 🏢

[![Hive](https://img.shields.io/badge/Apache-Hive-orange)](https://hive.apache.org/)
[![Spark](https://img.shields.io/badge/Apache-Spark-orange)](https://spark.apache.org/)
[![AWS RDS](https://img.shields.io/badge/AWS-RDS-blue)](https://aws.amazon.com/rds/)
[![AWS EMR](https://img.shields.io/badge/AWS-EMR-blue)](https://aws.amazon.com/emr/)

## 📖 Business Overview

In today's rapidly evolving market landscape, businesses face the challenge of maintaining an accurate and comprehensive historical record of their data. The primary goal of this project is to implement Slowly Changing Dimensions (SCD) within a data warehouse architecture, revolutionizing the way businesses capture and store changes over time in key business data, such as customer information, product details, and sales transactions. This will be achieved by utilizing advanced tools like Apache Hive and Apache Spark.

SCD techniques are critical and indispensable for businesses that require a historical perspective for accurate reporting, trend analysis, and decision-making. The project will focus on deploying a robust data processing and analysis platform supporting different SCD types to handle various data update scenarios efficiently.

## 🎯 Aim

To build a robust data warehousing solution incorporating SCD to handle data changes efficiently and effectively. The project will leverage Hive and Spark for data storage and processing, ensuring the data warehouse can operate with high performance and scalability.

## 🗃️ Dataset Description

The project will use a subset of the AdventureWorks dataset, focusing on entities like customers, products, and sales orders. These entities are prone to changes over time, making them ideal candidates for demonstrating the effectiveness of SCD.

- **Customer**: Tracks changes in customer details like address, contact info, and status.
- **Product**: Monitors modifications in product specifications, categories, and pricing.
- **Sales Order**: Captures updates in order statuses, billing, and shipping details.

## 🛠️ Tech Stack

- **Languages**: SQL for data manipulation, Scala for Spark data processing scripts
- **Services**: AWS RDS, AWS EMR
- **Frameworks**: Hadoop, Hive, Spark, Sqoop, Hue

### AWS Services

- **Amazon RDS**: Simplifies the setup, operation, and scaling of a relational database in the cloud.
- **Amazon EMR**: A cloud-native big data platform for processing vast amounts of data quickly and cost-effectively.

### Big Data Frameworks

- **Apache Hadoop**: An open-source software framework for the storage and large-scale processing of datasets.
- **Apache Hive**: A data warehouse software project built on top of Apache Hadoop for providing data query and analysis.
- **Apache Spark**: A unified analytics engine for big data processing with built-in modules for streaming, SQL, machine learning, and graph processing.
- **Apache Sqoop**: A tool that transfers data between Hadoop and relational databases or mainframes.
- **Hue**: An open-source web interface for Hadoop that supports a suite of data access applications.

## 📋 Implementation Details

1. **Designing SCD Models**: Define the SCD type for each data entity based on the business requirements—Type 1 for overwriting records, Type 2 for keeping full history, and Type 3 for storing previous and current values.
2. **Data Processing Workflows**: Develop Spark scripts to transform and process data as per the SCD logic. This includes extracting data from source systems, applying transformations, and loading the processed data into Hive tables.
3. **Hive Table Configuration**: Configure Hive tables to store historical data and handle SCD. This involves schema design, partitioning strategies, and indexing to optimize data retrieval.
4. **Data Validation and Auditing**: Implement data validation checks to ensure the data's integrity and accuracy. Set up auditing mechanisms to track data changes and process executions.
5. **Performance Optimization**: Utilize Spark's in-memory processing to enhance performance. Optimize Hive queries by tuning configurations, using appropriate file formats, and indexing.

## 🏫 Key Learning Takeaways

1. Understanding the concept of data warehousing using Hive.
2. Comprehending Slowly Changing Dimensions (SCD) and their different types.
3. Exploring the Parquet and ORC file formats.
4. Setting up the AdventureWorks Dataset in AWS RDS.
5. Configuring an AWS EMR cluster for big data services.
6. Transferring data to Hive using Sqoop.
7. Denormalizing data for effective data analysis.
8. Implementing SCD Type 1, 2, and 4 in Hive and Spark.
9. Exploring the differences between ELT and ETL, and their respective use cases.
10. Understanding the concept of a data lake as a storage repository.

---

<div align="center">
Made with ❤️ by HARSHAV
</div>
