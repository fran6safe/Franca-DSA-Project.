Create Database [Kultra_Mega_Stores_Inventory_DB]

-----Import Tables---
---CSV Table 1. [dbo].[KMS Sql Case Study]
---CSV table 2. [dbo].[Order_Status]

------------Tables........
Select * From [dbo].[KMS Sql Case Study]

Select * From [dbo].[Order_Status]

------- Create Table View -------

CREATE VIEW vw_dbokmsdboord
AS
SELECT
    kms.[Row_ID],
    kms.[Order_ID],
    kms.[Order_Date],
    kms.[Order_Priority],
    kms.[Order_Quantity],
    kms.[Sales],
    kms.[Discount],
    kms.[Ship_Mode],
    kms.[Shipping_Cost],
    kms.[Customer_Name],
    kms.[Province],
    kms.[Region],
    kms.[Customer_Segment],
    kms.[Product_Category],
    kms.[Product_Sub_Category],
    kms.[Product_Name],
    kms.[Product_Container],
    kms.[Product_Base_Margin],
    kms.[Ship_Date],
    ord.[status]
From [dbo].[KMS Sql Case Study] kms
inner join [dbo].[Order_Status] ord
on kms.Order_ID = ord.Order_ID

-----Select View------
Select * From [dbo].[vw_dbokmsdboord]

------Update View------

UPDATE [dbo].[vw_dbokmsdboord]
SET [Product_Base_Margin] = COALESCE([Product_Base_Margin], 0.00)
WHERE [Product_Base_Margin] IS NULL


----Question 1: Which product category had the highest sales?

Select Top 1
      Product_Category,
	  Sum(Sales) As Total_Sales
From [dbo].[vw_dbokmsdboord]
Group by Product_Category
Order by Total_Sales Desc

-----Answer: Product Category = (Technology) --- Sales = $605,426.04
---////////////////////////////////////////////////////////////////////////////////

----Question 2: What are the top 3 and bottom 3 regions in terms of sales------

--Top 3

select Top 3
      Region,
	  Sum(Sales) As Total_Sales
From [dbo].[vw_dbokmsdboord]
Group by  Region
Order by Total_Sales Desc

---Answer: Top 3 Regions; Ontario = $471,161.63 / West = $375,122.37 / Prarie = $296,732.24 
      -----//////////////////----
--Bottom 3

select Top 3
      Region,
	  Min(Sales) As Total_Sales
From [dbo].[KMSORDER]
Group by Region
Order by Total_Sales Asc

---Answer: B0ttom 3 Regions; Ontario = $4.94, West = $5.06, Prarie $5.63
----//////////////////////////////////////////////////////////////////----------

----Quest 3: What were the total sales of appliances in Ontario?

SELECT Region,
    SUM(Sales) AS Total_Sales
FROM [dbo].[vw_dbokmsdboord]
WHERE Region = 'Ontario'
  And Product_Sub_Category = 'appliances'
Group By Region

---Answer: = Total Sales of Appliances in Ontario = $17,648.37
----//////////////////////////////////////////////////////////////////////--------

-----Select View------
Select * From [dbo].[vw_dbokmsdboord]

----- Question 4: Advise the management of KMS on what to do to increase the revenue from the bottom 10 customer

Select Top 10
      Customer_Name,
	  Sum(Sales) As Total_Revenue
From [dbo].[vw_dbokmsdboord]
Group by Customer_Name
Order by Total_Revenue Asc

--------- BOTTOM 10 CUSTOMERS-----------------------
--Customer Name          Total Sales

--John Grady       =     $5.06
--Frank Atkinson   =     $10.48
--Sean Wendt       =     $12.80
--Sandra Glassco   =     $16.24
--Katherine Hughes =     $17.77 
--Bobby Elias      =     $22.56
--Noel Staavos     =     $24.91
--Thomas Boland    =     $28.01
--Brad Eason       =     $435.17
--Theresa Swint    =     $38.51
---------//////////////////////////////////////////////--------------------------

---Answer: MY ADVISE TO THE MANAGEMENT OF KMS IN ORDER TO INCREASE THE REVENUE FROM THE BOTTOM 10 CUSTOMERS......................
------- a- Identify the bottom 10 customers by total sales.
--------b- Analyze purchase patterns and feedback.
--------c- Offer targeted promotions or loyalty incentives.
--------d- Assign dedicated account managers or support for better engagement.
--------e- Upsell or cross-sell complementary products.
--------f- Improve delivery timelines and customer service.

-----Select View------
Select * From [dbo].[vw_dbokmsdboord]

---Question 5: KMS incurred the most shipping cost using which shipping method?

Select Top 1
      Order_Priority, Ship_Mode,
	  Sum(Shipping_Cost) As Total_Cost
From [dbo].[KMSORDER]
Group by Order_Priority, Ship_Mode
Order by Total_Cost Desc

---Answer: Order_Priority = (Low) / Shiping Method = Delevery Struck / Shipping Cost = $1,659.14
-----///////////////////////////////////////////////////////////////////////------------

------Question 6: Who are the most valuable customers, and what products or services do they typically purchase?

WITH CustomerRevenue AS (
    SELECT
        Customer_Name,
        Customer_Segment,
        SUM(Sales) AS Total_Revenue
    FROM [dbo].[vw_dbokmsdboord]
    GROUP BY Customer_Name, Customer_Segment
),
CustomerProductRevenue AS (
    SELECT 
        Customer_Name,
        Product_Name,
		Order_Quantity,
        SUM(Sales) AS Product_Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_Name 
            ORDER BY SUM(Sales) DESC, Product_Name DESC
        ) AS Product_Rank
    FROM [dbo].[vw_dbokmsdboord]
    GROUP BY Customer_Name, Product_Name, Order_Quantity
)
SELECT TOP 5
    cr.Customer_Name,
    cr.Customer_Segment,
    cpr.Product_Name AS Top_Product,
	cpr.Order_Quantity,
    cr.Total_Revenue
FROM CustomerRevenue cr
JOIN CustomerProductRevenue cpr 
    ON cr.Customer_Name = cpr.Customer_Name 
    AND cpr.Product_Rank = 1
ORDER BY cr.Total_Revenue DESC

----Answer: We have our Top 5, having that the (top product that are being purchased are as follow:

------Customer_Name       Customer_Segment    Top_Product                                                            Total_Revenue                         

---1---John Lucas          Small Business      Chromcraft Bull-Nose Wood 48" x 96" Rectangular Conference Tables      $37,919.43
---2---Lycoris Saunders    Corporate           Bretford CR8500 Series Meeting Room Furniture                          $30,948.18
---3---Peter Fuller        Corporate           Panasonic KX-P3626 Dot Matrix Printer                                  $26,485.12
---4---Julia West          Home Office         Riverside Palais Royal Lawyers Bookcase, Royale Cherry Finish          $26,443.02
---5---Darren Budd         Home Office         Sharp AL-1530CS Digital Copier                                         $26,382.21
-----------------//////////////////////////////////////////////////////////////////////////////////////////////////////-------------------------
-----Select View------
Select * From [dbo].[vw_dbokmsdboord]

---Question 7: Which (Small business customer) had the highest sales?

WITH CustomerRevenue AS (
    SELECT 
        Customer_Name,
        Customer_Segment,
        SUM(Sales) AS Total_Revenue
    FROM [dbo].[vw_dbokmsdboord]
	Where Customer_Segment = 'Small Business'
    GROUP BY Customer_Name, Customer_Segment
),
CustomerProductRevenue AS (
    SELECT 
        Customer_Name,
        Product_Name,
		Order_Quantity,
        SUM(Sales) AS Product_Revenue,
        ROW_NUMBER() OVER (
            PARTITION BY Customer_Name 
            ORDER BY SUM(Sales) DESC, Product_Name DESC
        ) AS Product_Rank
    FROM [dbo].[vw_dbokmsdboord]
    GROUP BY Customer_Name, Product_Name, Order_Quantity
)
SELECT TOP 1
    cr.Customer_Name,
    cr.Customer_Segment,
    cpr.Product_Name AS Top_Product,
	cpr.Order_Quantity,
    cr.Total_Revenue
FROM CustomerRevenue cr
JOIN CustomerProductRevenue cpr 
    ON cr.Customer_Name = cpr.Customer_Name 
    AND cpr.Product_Rank = 1
ORDER BY cr.Total_Revenue DESC

---Answer: The Custormer_Segment = (Small Business) / Customer_Name = (John Lucas) / Total_Revenue = $37,919.43
----------////////////////////////////////////////////////////////////////////////////-----------------------------------
-----Select View------
Select * From [dbo].[vw_dbokmsdboord]


----Question 8: Which (Corporate Customer) placed the most (number of orders) in (2009 – 2012)?

SELECT TOP 1
   Customer_Segment, Customer_Name,
    SUM(Order_Quantity) AS Total_Orders
FROM [dbo].[vw_dbokmsdboord]
WHERE Customer_Segment = 'Corporate'
    AND Ship_Date BETWEEN '2009-01-01' AND '2012-12-31'
GROUP BY Customer_Segment, Customer_Name
ORDER BY Total_Orders DESC

----Answer: The corporate customer with the most placed order in 2009 - 2012 Is; Customer_Name = Erin Creighton, Total_Orders = 261
--------//////////////////////////////////////////////////////////////////////////////-------------------------------------////////////


---Question 9: Which (Consumer customer) was the (most profitable one)?

SELECT TOP 1
    Customer_Segment, Customer_Name,
    SUM(Sales) AS Total_Revenue
FROM [dbo].[vw_dbokmsdboord]
WHERE Customer_Segment = 'Consumer'
GROUP BY Customer_Segment, Customer_Name
ORDER BY Total_Revenue Desc

---Answer: The most profitable (Consumer Customer); Customer_Name = Darren Budd / Profitability = $23,034.35
--------------------------///////////////////////////////////////////////////////////////////////////////-----------------

-----Select View------
Select * From [dbo].[vw_dbokmsdboord]

----Question 10: Which customer returned items? And what segment do they belong to?

SELECT TOP 872
   Customer_Name, Customer_Segment,
    max([Status]) AS Total_Returned_Items
FROM [dbo].[vw_dbokmsdboord]
GROUP BY Customer_Segment, Customer_Name, [Status]
ORDER BY Total_Returned_Items Desc

----Answer: Customers that (Returned Items) According to their (Segment);

  --- Customer_Name         Customer_Segment    Total_Returned_Items

--1---Christy Brittain	    Consumer	        Returned
--2---Charles Crestani	    Consumer	        Returned
--3---Carlos Soltero	    Consumer	        Returned
--4---Carl Weiss	        Consumer	        Returned
--5---Brian Stugart	        Consumer	        Returned
--6---Brendan Sweed	        Consumer	        Returned
--7---Becky Castell	        Consumer	        Returned
--8---Anthony O'Donnell  	Consumer	        Returned
--9---Annie Thurman	        Consumer	        Returned
--10--Anne Pryor	        Consumer	        Returned......................
------------------//////////////////////////////////////////////////////////////////////////----------------------------

-----Question 11....

---If the delivery truck is the most economical but the slowest shipping method and 
---Express Air is the fastest but the most expensive one, do you think the company 
---appropriately spent shipping costs based on the Order Priority? (Explain your answer)

-----Select View------
Select * From [dbo].[vw_dbokmsdboord]


SELECT  
    Order_Priority,  
    Ship_Mode,  
    SUM(Shipping_Cost) AS Total_Cost  
FROM   [dbo].[KMSORDER]
WHERE Ship_Mode IN ('Express Air', 'Delivery Truck')  
GROUP BY Order_Priority, Ship_Mode  
ORDER BY Ship_Mode, Total_Cost DESC

----Answer: Based on Order Priority				Ship Mode					Total Cost

-----		Low									Delivery Truck				$1,659.14
-----		High								Delivery Truck				$1,274.98
-----		Not	Specified						Delivery Truck				$1,040.76
-----		Medium								Delivery Truck				$925.25
-----		Critical							Delivery Truck				$829.01
-----		Low									Express Air					$289.95
-----		Not	Specified						Express Air					$257.40
-----		Critical							Express Air					$195.19
-----		Medium								Express Air					$167.27
-----		High								Express Air					$108.92

------Was shipping cost appropriately spent based on Order Priority?
----a- Appropriate spending depends on matching high-priority orders with fast (Express Air) shipping and low-priority orders with economical (Delivery Truck) methods.
----b- If there are mismatches (e.g., urgent items shipped via Delivery Truck), the spending is inappropriate.
----c- A proper audit of the data would confirm alignment.
