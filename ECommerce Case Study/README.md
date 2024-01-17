# Case Study: E-Commerce Retail Store Analysis

## Introduction
In the context of a mini project, I have examined the schema of an e-commerce retail store. My focus has been on conducting insightful manipulations on densely connected tables within the schema. The aim is to derive valuable insights related to the store's sales and product analytics, customer engagement, and shipment logistics. Throughout this analysis, I have utilized a range of SQL functions, spanning from basic clauses to complex case expressions, to extract and analyze the required information. This case study provides a comprehensive exploration of the intricacies within the e-commerce retail environment.

## Schema Description
The schema comprises 8 interconnected tables, establishing relationships through foreign keys. Here's a brief overview of key tables:

* Product: Stores essential information such as product_id, name, available quantity, and pricing for each product available in the store.
* Product_Class_Code: Contains data classifying products into categories such as clothes, electronics, toys, etc.
* Online_Customer: Holds details about customers, including names, emails, phone numbers, website usernames, and gender.
* Address: Connected to the Online_Customer table via the 'Customer_Id' primary key, it provides information about customer addresses.
* Order_Header: Central to the schema, it records details of orders placed by customers and acts as a bridge between the Online_Customer and Product tables.
* Shipper: Contains information about shipment IDs and details of the shippers responsible for delivering products to customers. This table is linked to the Order_Header table through the header_id foreign key.

Check out the [ER-Diagram](https://github.com/praneeth377/E-Commerce-CaseStudy_SQL/blob/main/ER_Diagram.png)

## Analysis - Query Optimization and Performance Evaluation
Throughout the analysis, I employed a series of strategic queries to extract valuable insights from the interconnected tables:
* Inventory Status: Utilizing queries, I systematically assessed inventory statuses based on available quantities of products, offering a clear view of stock levels.
* Customer Segmentation: By querying specific regions, I discovered detailed customer profiles. Additionally, delving into their product preferences within distinct categories unveiled insightful patterns of interest.
* Popular Products and Shipment Metrics: By intricately examining the schema, I formulated queries to identify popular products based on shipment data. Moreover, I looked into the frequency of order placements on a daily basis, providing a comprehensive understanding of the store's operational tempo.
* Sales Analytics: The manipulation of tables enabled an in-depth exploration of sales analytics, revealing trends in customer behavior, popular product categories, and the overall effectiveness of the retail store's sales strategies.


## Conclusion
In conclusion, this case study has equipped me with valuable skills in querying and analyzing complex relational databases, particularly in the context of an e-commerce retail store. These skills will undoubtedly prove instrumental in future fieldwork, allowing for more informed decision-making and strategic planning within the dynamic landscape of e-commerce analytics.
