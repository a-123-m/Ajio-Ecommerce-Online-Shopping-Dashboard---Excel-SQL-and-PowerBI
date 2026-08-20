# Ajio Ecommerce Online Shopping Dashboard - Excel, SQL and PowerBI
An interactive AJIO Ecommerce Online Shopping Analytics Dashboard that provides a holistic view of sales, customers, products, orders, returns and payments. It combines key performance metrics, trends, comparisons and AI-powered insights to identify business patterns, highlight top-performing areas and uncover opportunities for improvement.
<p align="center">
<img width="600" height="230" alt="image" src="https://github.com/user-attachments/assets/f9765dbc-e394-4934-a5b8-8b33a69f8d04" />
</p>

## 📖 Project Overview
This project analyzes Ajio's online shopping data to uncover trends in sales, customer behavior, product performance, and order fulfillment. The goal was to build a fully interactive Power BI dashboard backed by a clean, query-tested SQL data layer and an Excel-based exploratory model.
The project presents a complete BI workflow I followed:

**Synthetic Data Generation → Data Understanding and Exploration → Creation of Data Dictionary → Data Profiling & Initial Cleaning in Excel → Advanced Data Cleaning & Transformation in SQL → Creation of SQL Views for BI Analysis → Importing SQL Views into Power BI using Import Mode → Data Modelling → Date Table creation → DAX → Understanding Brand Guidelines → Generating Power BI Theme → Designing Dashboard Pages → Interactive Visualisation → Advanced Analytics → Business Insights**

The final solution consists of an interactive Power BI report that allows users to explore:
* Executive Sales performance
* Customer and Product Analysis
* Returns and Payment Analysis
* Drill through Product categories
* Advanced AI analysis - Decomposition tree
* Overall Business Insights

> **Note:** The dataset used in this project is synthetic and created solely for this portfolio project. It is not official Ajio business data.

## 🛠️ Tools & Technologies
| Tool | Purpose |
|---|---|
| **Excel** | Data profiling, quick exploratory analysis, validation and initial data cleaning |
| **Google docs** | Creation of Data Dictionary |
| **SQL (PostgreSQL)** | Creation of fact and dimension tables, Advanced Data cleaning, aggregation, joins, transformation and creation of BI views |
| **Canva** | Creation of PowerBI backgrounds |
| **Power BI (Power Query / DAX / Data Modeling)** | Data modelling, KPI development, interactive dashboards, drill-throughs, slicers and advanced visualisation |

## 📊 Dashboard Preview
<img width="1323" height="740" alt="Screenshot 2026-08-20 203151" src="https://github.com/user-attachments/assets/0108e3d2-e104-4d67-b76b-40daeb6353fe" />
<img width="1321" height="739" alt="Screenshot 2026-08-20 203224" src="https://github.com/user-attachments/assets/2f462730-aa16-4d18-94b2-202fa2c25a67" />
<img width="1324" height="736" alt="Screenshot 2026-08-20 203310" src="https://github.com/user-attachments/assets/792c6a62-269e-454b-8369-75e5004827a8" />
<img width="1325" height="737" alt="Screenshot 2026-08-20 203331" src="https://github.com/user-attachments/assets/59025f2b-9106-4c70-89f2-4bea76a740c3" />
<img width="1327" height="740" alt="Screenshot 2026-08-20 203359" src="https://github.com/user-attachments/assets/304f79fe-09a3-403b-adc0-c7eaa5a18dc3" />
<img width="1330" height="742" alt="Screenshot 2026-08-20 203424" src="https://github.com/user-attachments/assets/953544dd-02ee-4807-83a0-c94cacd19893" />
<img width="1321" height="734" alt="Screenshot 2026-08-20 203446" src="https://github.com/user-attachments/assets/7384c3ce-a316-4981-b5ab-a30082cf7d6f" />
<img width="1318" height="734" alt="Screenshot 2026-08-20 203513" src="https://github.com/user-attachments/assets/de55513c-463e-4527-923e-97ade71ab8cd" />

## 🎥 Dashboard Walkthrough

https://github.com/user-attachments/assets/a81d1885-79dd-4435-8ea2-2bd7421e54b9


## 🤖 AI-Powered Analytics
I incorporated **AI-powered visual - Decomposition Tree** to perform deeper data analysis on questions like : 
* What drives Sales?
* What drives Order Returns?
<img width="1072" height="327" alt="image" src="https://github.com/user-attachments/assets/b298eedd-32cd-44b7-9db5-0cc303bea555" />
<img width="1062" height="337" alt="image" src="https://github.com/user-attachments/assets/16b9cba8-3ccf-4c32-a234-ae5c1024aad2" />


## 🎛️ Interactive Power BI Features
    ├── Slicers
    ├── Filters
    ├── Bookmarks
    ├── Field Parameters
    ├── Drill Through
    ├── Page Navigation

## 🔄 Project Workflow

### 1. Synthetic Data Generation

Created a realistic synthetic dataset for Ajio to simulate a real-world business scenario, including relevant dimensions, transactions, metrics and business attributes required for analysis of Ajio ecommerce online shopping website.

### 2. Data Understanding, Exploration and creation of Data Dictionary

Reviewed the dataset to understand its structure, columns, data types, relationships, business context and key analytical requirements. Created a Data dictionary for all the tables in dataset.

### 3. Data Profiling in Excel

Performed initial data profiling in Excel to identify:
* Missing and blank values
* Duplicate records
* Inconsistent values
* Incorrect data types
* Outliers and unusual records
* Data quality issues

### 4. Initial Data Cleaning in Excel

Performed few basic cleaning steps in Excel like removing duplicates, standardizing date and text formats etc.

### 5. Advanced Data Cleaning & Transformation in SQL

Loaded the data into PostgreSQL and performed more advanced transformations including:

* Deduplication
* Data type corrections
* Handling missing values
* Standardisation
* Filtering and transformation
* Aggregation
* Data validation
* Joins
* Exploratory SQL queries
> View ajiosql.sql file for the complete SQL script

### 6. Creation of BI Views

Created SQL views containing clean, structured and analysis-ready data. These views acted as the primary data source for the Power BI report.

### 7. Importing Data into Power BI

Connected Power BI to the SQL views and imported the required datasets using Import Mode for efficient reporting and analysis.

### 8. Data Modelling

Designed the Power BI data model by:

* Creating relationships between tables
* Organising dimension and fact tables
* Optimising the model for reporting
<img width="1707" height="712" alt="datamodel" src="https://github.com/user-attachments/assets/ff337ac3-7f98-4278-a50e-6454c581cc7b" />

#### FACT TABLES
* Fact Sales
* Fact Returns
* Fact Payments
      
#### DIMENSION TABLES
* Dim customer
* Dim coupon
* Dim order_status
* Dim payment
* Dim product
* Dim seller
* Dim date

### 9. Date Table Creation

Created a dedicated Date table to support time-based analysis and consistent date filtering across the report.
``` dax
dim_Date = ADDCOLUMNS(CALENDARAUTO(),
"Year",YEAR([Date]),
"Month no",MONTH([Date]),
"Month",FORMAT([Date],"mmm"),
"Quarter","Q"& QUARTER([Date]),
"Day no",WEEKDAY([Date],2),
"Day",FORMAT([Date],"ddd")
)
```

### 10. DAX Development

Created separate DAX measures and calculations for business KPIs, including aggregations, percentages, comparisons, trends and other analytical metrics required for the 3 report pages.
Some of the Key DAX measures created are as follows:
1. Total sales = SUM('public fact_sales_view'[total_amount])
2. Total orders = DISTINCTCOUNT('public fact_sales_view'[order_id])
3. Total customers = DISTINCTCOUNT('public fact_sales_view'[customer_id])
4. Units sold = SUM('public fact_sales_view'[quantity])
5. AOV = DIVIDE([Total sales],[Total orders],0)
6. Total products = DISTINCTCOUNT('public fact_sales_view'[product_id])
7. Avg customer spent = DIVIDE([Total sales],[Total customers],0)
8. Returned orders = CALCULATE(DISTINCTCOUNT('public fact_returns_view'[order_id]),'public dim_order_status_view'[order_status]="Returned")
9. Return rate = DIVIDE([Returned orders],[Total orders],0)
10. Payment success rate = 
VAR _totalpayments = COUNTROWS('public fact_payments_view')
VAR success = CALCULATE(COUNTROWS('public fact_payments_view'),'public fact_payments_view'[payment_status]="Success")
var result = DIVIDE(success,_totalpayments,0)
RETURN result
11. Payment failure rate = 
VAR _totalpayments = COUNTROWS('public fact_payments_view')
VAR failure = CALCULATE(COUNTROWS('public fact_payments_view'),'public fact_payments_view'[payment_status]="Failed")
var result = DIVIDE(failure,_totalpayments,0)
RETURN result

### 11. Understanding Brand Guidelines
Reviewed the brand guidelines to understand the required:

* Colours
* Typography
* Visual hierarchy
* Branding elements
* Overall design language

### 12. Power BI Theme Development by generating custom PowerBI theme for Ajio

Converted the brand guidelines into a custom Power BI theme to maintain consistent colours, fonts, formatting and visual styling throughout the report.

### 13. Dashboard Page Design

Designed individual dashboard pages with a clear visual hierarchy and logical information flow, focusing on usability, readability and business requirements.

### 14. Interactive Visualisation

Added interactive Power BI features such as:
* Slicers
* Filters
* Drill-throughs
* Tooltips
* Bookmarks
* Field parameters
* Page navigation
* Interactive charts and KPI cards

This allowed users to explore the data dynamically.

### 15. Advanced AI Analytics
Created a decomposition tree to analyze the following 2 key questions:
1. What drives Sales?
2. What drives Order Returns?

### 16. Business Insights
Interpreted the analytical results and translated them into meaningful KPI and visual insights to support decision-making.

# 📄 Report Pages

| Page | Focus |
|------|-------|
| **Executive Sales Overview** | A high-level view of sales performance, growth trends and key business drivers |
| **Customers and Products** | Exploring customer behavior and product performance |
| **Returns and Payments** | Exploring return patterns and payment trends |
| **AI advanced analytics** | Using AI visuals like Decomposition Tree for further analysis |
| **Insights** | Exploring overall insights across all the three report pages |

## 💡 Key Insights

1. Executive Sales Overview
<img width="1095" height="600" alt="image" src="https://github.com/user-attachments/assets/d9927a03-fd5b-44d4-9e2d-fbff602e011c" />

2. Customers and Products Analysis
<img width="1092" height="587" alt="image" src="https://github.com/user-attachments/assets/b32f244e-4e45-4bbe-8a91-f594727098f2" />

3. Returns and Payments Analysis
<img width="1090" height="502" alt="image" src="https://github.com/user-attachments/assets/2e61914e-3a3b-4ad6-9064-8e0f548aa565" />

<br>
<p>If you found this project helpful, consider giving it a ⭐ on GitHub!<br> Thank you❤️</p>
<div>
  <h2>Connect with Me</h2>
<a href="mailto:aiswarya2000mohan@gmail.com">
  <img src="https://img.shields.io/badge/-Gmail-red?style=for-the-badge&logo=gmail&logoColor=white" alt="Gmail">
</a>
<a href="https://www.linkedin.com/in/aiswarya-mohan-950948221/">
  <img src="https://img.shields.io/badge/-LinkedIn-blue?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
</a>
</div>
