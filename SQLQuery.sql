-- Sales Analysis 

-- Total sales by year
SELECT [Year],
		SUM(sales) AS Total_Sales
FROM superstore
GROUP BY [YEAR]
ORDER BY [Year] DESC

-- Total Profit by Year
SELECT [Year],
		CAST(SUM(Profit) As int) AS Profit
FROM superstore
GROUP BY [Year]
ORDER BY [Year] DESC

-- Profit by Region
SELECT Region,
		CAST(SUM(Profit) As int) AS Profit
FROM superstore
GROUP BY Region
ORDER BY SUM(Profit) DESC

-- Profit by Category
SELECT Sub_Category,
	   CAST(SUM(Profit)AS int) AS Profit_Value
FROM superstore
GROUP BY Sub_Category
ORDER BY CAST(SUM(Profit)AS int) DESC

-- Top Loss- Making Product
SELECT 
    Product_Name,
    CAST(SUM(Profit) AS INT) AS Profit_Value
FROM superstore
GROUP BY Product_Name
HAVING SUM(Profit) < 1
ORDER BY Profit_Value ASC;

-- Top 10 Product by Sales
SELECT TOP 10 
	   Product_Name, 
	   SUM(Sales) TotalSales
FROM superstore
GROUP BY Product_Name
ORDER BY TotalSales DESC

-- Top 10 Product by Profit
SELECT TOP 10
	   Product_Name, 
	   CAST(SUM(Profit)AS int) AS Profit_Value
FROM superstore
GROUP BY Product_Name
ORDER BY Profit_Value DESC

-- Product With Higher Sales by lower Profit
SELECT 
    Product_Name,
    SUM(Sales) AS TotalSales,
    CAST(SUM(Profit)AS int) AS TotalProfit
FROM superstore
GROUP BY Product_Name
HAVING SUM(Profit) < 2
ORDER BY TotalSales DESC;

-- Sub_Category Contribution By Total Sales(%)
SELECT
    Sub_Category,
    SUM(Sales) AS Category_Sales,
    CAST(ROUND(
        SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (),
        2
    )AS int) AS Contribution_Percentage
FROM superstore
GROUP BY Sub_Category
ORDER BY Contribution_Percentage DESC;

-- Top 10 Customer by Sales
SELECT TOP 10
       Customer_Name,
       SUM(Sales) As Total_Sales
FROM superstore
GROUP BY Customer_Name
ORDER BY SUM(Sales) DESC

-- Top 10 Customer by Profit
SELECT TOP 10
       Customer_Name,
       CAST(SUM(Profit)AS int) As Total_Profit
FROM superstore
GROUP BY Customer_Name
ORDER BY SUM(Profit) DESC

-- Sales by Customer Segment in %
SELECT 
    Segment,
    SUM(Sales) AS Total_Sales,
    CAST(
        SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER ()
        AS INT
    ) AS Contribution_Percentage
FROM superstore
GROUP BY Segment
ORDER BY Total_Sales DESC

--How do different customer segments contribute to sales and profit, 
WITH SegmentAnalysis AS (
    SELECT 
        Segment,
        SUM(Sales) AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        SUM(Profit) * 100.0 / SUM(Sales) AS Profit_Margin,
        AVG(Discount) AS Avg_Discount
    FROM superstore
    GROUP BY Segment
)
SELECT *
FROM SegmentAnalysis
WHERE 
    Profit_Margin < 10   -- low profit
    AND Avg_Discount > 2  -- high discount
ORDER BY Profit_Margin ASC;

-- Repeat VS One-Time Customers Analysic in %
SELECT * FROM superstore
WITH CustomerOrders AS (
    SELECT 
        Customer_ID,
        COUNT(DISTINCT Order_ID) AS OrderCount,
        SUM(Sales) AS TotalSales
    FROM superstore
    GROUP BY Customer_ID
)
SELECT 
    CASE 
        WHEN OrderCount = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END AS Customer_Type, 
    COUNT(Customer_ID) AS Customer_Count,
    SUM(TotalSales) AS Total_Sales,
    CAST(
        ROUND(SUM(TotalSales) * 100.0 / SUM(SUM(TotalSales)) OVER (), 0)
        AS INT
    ) AS Contribution_Percentage
FROM CustomerOrders
GROUP BY 
    CASE 
        WHEN OrderCount = 1 THEN 'One-Time'
        ELSE 'Repeat'
    END
ORDER BY Total_Sales DESC;

-- Sales By State
SELECT [State],
        SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY [State]
ORDER BY Total_Sales DESC

--Top 5 Cities By Sales
SELECT TOP 5
       City,
       SUM(Sales) AS Total_Sales
FROM superstore
GROUP BY City
ORDER BY Total_Sales DESC

--How does profit vary across different discount levels
SELECT 
    CASE 
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END AS Discount_Level,
    SUM(Sales) AS Total_Sales,
    SUM(Profit) AS Total_Profit,
    CAST(
        ROUND(SUM(Profit) * 100.0 / SUM(Sales), 0)
        AS INT
    ) AS Profit_Margin_Percentage
FROM superstore
GROUP BY 
    CASE 
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount > 0 AND Discount <= 0.2 THEN 'Low Discount'
        WHEN Discount > 0.2 AND Discount <= 0.5 THEN 'Medium Discount'
        ELSE 'High Discount'
    END
ORDER BY Total_Profit DESC;
