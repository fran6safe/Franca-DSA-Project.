# 📊 KMS Sales Intelligence Project (2009–2012)

## ✨ Project Overview

This project was executed as part of the *Digital SkillUp Africa (DSA)* Data Analytics training. It focuses on analyzing historical sales data from *Kultra Mega Stores (KMS)* — a retail and corporate supply chain operating across Nigeria from *2009 to 2012*.

The objective was to generate *actionable business insights* using *SQL Server*. KMS management requested help in:

- Evaluating product, customer, and regional performance  
- Identifying cost leakages (especially in shipping and low-spending customers)  
- Recommending data-driven strategies for growth and retention

### 👨‍💻 Role: Data Analyst  
I was responsible for the complete analysis pipeline:
- Data loading and cleaning using SQL Server Management Studio (SSMS)
- Type transformation for performance optimization
- Formulating key business questions
- Writing optimized SQL queries
- Summarizing insights and making recommendations

---

## 🛠 Tools Used

- SQL Server Management Studio (SSMS)  
- Flat File Import Wizard  
- Microsoft Excel (pre-cleaning)  
- GitHub (version control and documentation)

---

## 📈 Business Outcomes

- Identified top and underperforming products and customers  
- Discovered expensive shipping methods and inefficiencies  
- Proposed tailored strategies for marketing, logistics, and customer care

---

## 📥 Data Importation Process

*Source:* CSV file containing order history (2009–2012)  
*Steps:*
1. Imported using SSMS Flat File Import Wizard  
2. Transformed data types for consistency and performance:
   - Sales, Profit, Discount, Shipping_Cost → DECIMAL(10,2)  
   - Quantity, Order_ID, Product Count → INT  
3. Renamed columns and removed empty rows  
4. Verified data integrity through sampling and test queries

📸 Screenshots available in /images

---

## 🔍 Business Questions & SQL Solutions

### 1️⃣ Which product category had the most entries?
sql
SELECT TOP 1 Product_Category, COUNT(*) AS Product_Count
FROM KMS
GROUP BY Product_Category
ORDER BY Product_Count DESC;


---

### 2️⃣ Top 3 and Bottom 3 Regions by Sales
sql
-- Top 3 Regions
SELECT TOP 3 Region, SUM(Sales) AS Total_Sales
FROM KMS
GROUP BY Region
ORDER BY Total_Sales DESC;

-- Bottom 3 Regions
SELECT TOP 3 Region, SUM(Sales) AS Total_Sales
FROM KMS
GROUP BY Region
ORDER BY Total_Sales ASC;


---

### 3️⃣ Total Sales from Ontario
sql
SELECT Region, SUM(Sales) AS Total_Sales
FROM KMS
WHERE Region = 'Ontario'
GROUP BY Region;


---

### 4️⃣ How to Improve Revenue from Bottom 10 Customers
sql
SELECT TOP 10 Customer_Name, SUM(Sales) AS Total_Sales
FROM KMS
GROUP BY Customer_Name
ORDER BY Total_Sales ASC;


💡 *Suggestions:*
- Launch loyalty programs  
- Run reactivation campaigns  
- Offer discounts to low-spending customers  
- Provide personalized support and follow-ups

---

### 5️⃣ Most Expensive Shipping Method
sql
SELECT TOP 1 Ship_Mode, SUM(Shipping_Cost) AS Total_Shipping_Cost
FROM KMS
GROUP BY Ship_Mode
ORDER BY Total_Shipping_Cost DESC;


---

### 6️⃣ Most Valuable Customers & Their Purchases
sql
SELECT Customer_Name, Product_Name, SUM(Sales) AS Total_Sales
FROM KMS
GROUP BY Customer_Name, Product_Name
ORDER BY Total_Sales DESC;


---

### 7️⃣ Highest Revenue from a Small Business Customer
sql
SELECT TOP 1 Customer_Name, SUM(Sales) AS Total_Sales
FROM KMS
WHERE Customer_Segment = 'Small Business'
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;


---

### 8️⃣ Corporate Customer with Most Orders (2009–2012)
sql
SELECT TOP 1 Customer_Name, COUNT(Order_ID) AS Total_Orders
FROM KMS
WHERE Customer_Segment = 'Corporate' AND YEAR(Order_Date) BETWEEN 2009 AND 2012
GROUP BY Customer_Name
ORDER BY Total_Orders DESC;


---

### 9️⃣ Most Profitable Consumer Customer
sql
SELECT TOP 1 Customer_Name, SUM(Profit) AS Total_Profit
FROM KMS
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Name
ORDER BY Total_Profit DESC;


---

### 🔟 Customers Who Returned Products
sql
SELECT Customer_Name, Customer_Segment, Status
FROM KMS
JOIN dbo.Order_Status ON KMS.Order_ID = Order_Status.Order_ID;


---

### 1️⃣1️⃣ Did Shipping Method Match Order Priority?
sql
SELECT Order_Priority, Ship_Mode,
       COUNT(Order_ID) AS Order_Count,
       SUM(Sales - Profit) AS Estimated_Shipping_Cost,
       AVG(DATEDIFF(DAY, Order_Date, Ship_Date)) AS Avg_Ship_Days
FROM KMS
GROUP BY Order_Priority, Ship_Mode
ORDER BY Order_Priority, Ship_Mode;


🧠 *Insight:*  
- Express Air (for urgent orders) was underused  
- Delivery Truck (slow) was overused even for high-priority orders  
➡ Resulted in *increased costs* and *delayed deliveries*

---

## 📊 Summary of Findings

- *Top Category:* Office Supplies  
- *Best Region:* West  
- *Weakest Region:* Nunavut or Territories  
- *Most Profitable Segment:* Consumer  
- *Highest Shipping Cost:* Express Air  
- *Key Insight:* Shipping strategies did not match urgency, leading to inefficiencies

---

## 📁 Repository Structure


kms-sql-analysis/
├── README.md
├── data/
│   └── kms_orders.csv
├── scripts/
│   └── kms_analysis.sql
├── images/
│   ├── flat-file-import.png
│   ├── region-sales-chart.png
│   ├── customer-segmentation.png
│   └── shipping-analysis.png


---

## 🧠 Skills Demonstrated

- SQL Query Design (T-SQL)  
- Data Cleaning & Type Optimization  
- Business Intelligence (BI) Questioning  
- Sales & Customer Segmentation Analysis  
- Shipping Cost Optimization  
- Reporting & Recommendation Framing

---

## 🔗 Connect With Me

*👤 Oladipupo Abidemi Francis*  
[🔗 LinkedIn]()  
[📄 Download SQL Scripts]()

---

## 🚀 Future Improvements

- Build dynamic Power BI dashboards  
- Automate SQL queries via stored procedures  
- Incorporate Python for predictive insights  
- Use CRM data for customer segmentation and targeting
