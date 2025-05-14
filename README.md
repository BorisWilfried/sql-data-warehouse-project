# sql-data-warehouse-project
Building a modern datawarehouse with SQL Server, including ETL Process, data modeling and Analytics

# 👋 Welcome!

Hi there! 👨‍💻  
I'm excited to share this data engineering project where I apply practical ETL techniques using real-world data sources.  
If you're curious about how data flows from raw inputs to polished business insights using the **Bronze, Silver, and Gold** method — you're in the right place!

Feel free to explore the code, give feedback, or contribute!

## 📋 Overview

This repository contains a modular ETL pipeline for processing data from two key business systems: **CRM** and **ERP**.  
It follows the **Medallion Architecture** (Bronze → Silver → Gold) to ensure clean separation between raw, transform, and business-ready data.

The pipeline includes:
- Extraction of raw data into the Bronze layer.
- Cleansing and transformation in the Silver layer.
- Aggregation and modeling in the Gold layer for analytics and reporting.

The goal of this project is to clean, integrate, and prepare data for advanced analytics or reporting.

## 📊 Architecture: Bronze → Silver → Gold
🔸 Bronze Layer
Raw ingestion layer. Data is extracted from CRM and ERP systems and stored in its original format (CSV, JSON, or other).

🔹 Silver Layer
Cleansed and transformed data. Includes type casting, null value handling, deduplication, and basic normalization.

🏅 Gold Layer
Business-level aggregated data. This layer is optimized for analytics, dashboards, and reports. Includes joins, summaries, and calculated KPIs.

## 🧱 Technologies Used

SQL (for transformations and queries)
Git & GitHub (version control)

## 🗂️ Data Sources
CRM System
Contains customer profiles, contact information, and interactions.

ERP System
Includes orders, inventory, financial transactions, and logistics data.

## ⚙️ ETL Workflow
Extract

Read data from source files or mock APIs.
Store them into the Bronze layer as-is.

Transform

Clean and normalize data in the Silver layer.
Handle missing data, standardize formats.

Load

Merge CRM & ERP data in the Gold layer.
Generate KPIs like total sales, customer value, product turnover.

## 📌 Features

Modular ETL pipeline

Clear data lineage and traceability
Scalable architecture
Extensible to other sources (e.g., web logs, IoT, etc.)

## 🧾 License
This project is licensed under the MIT License.
See the LICENSE file for details.

## 🙋 About Me
I'm a Bachelor student in Informatik with a strong interest in everything related to Databases (Datenbanken). I enjoy building clean, scalable data pipelines and learning how to transform raw data into actionable insights.
