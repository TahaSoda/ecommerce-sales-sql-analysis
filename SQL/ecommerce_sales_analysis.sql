-- Total Profit, Sales, Quantity, and Order Count
SELECT 
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    SUM(Quantity) AS Total_Quantity_Sold,
    COUNT(OrderID) AS Total_Orders
FROM ecommerce_sales;

SELECT 
    DATE_FORMAT(OrderDate, '%m') AS Month_Num,
    DATE_FORMAT(OrderDate, '%b') AS Month_Name,
    SUM(Sales) AS Monthly_Sales,
    SUM(Profit) AS Monthly_Profit
FROM ecommerce_sales
GROUP BY Month_Num, Month_Name
ORDER BY Month_Num;

SELECT 
    Region, 
    SUM(Sales) AS Total_Sales
FROM ecommerce_sales
GROUP BY Region
ORDER BY Total_Sales DESC;

SELECT 
    Category, 
    SUM(Sales) AS Total_Sales
FROM ecommerce_sales
GROUP BY Category
ORDER BY Total_Sales DESC; 

SELECT 
    Product, 
    SUM(Sales) AS Total_Sales
FROM ecommerce_sales
GROUP BY Product
ORDER BY Total_Sales DESC
LIMIT 10;

SELECT 
    CustomerID, 
    COUNT(OrderID) AS Order_Frequency,
    SUM(Sales) AS Total_Spent,
    SUM(Profit) AS Total_Profit_Contribution
FROM ecommerce_sales
GROUP BY CustomerID
ORDER BY Total_Profit_Contribution DESC
LIMIT 10;

WITH MonthlySales AS (
    SELECT 
        DATE_FORMAT(OrderDate, '%Y-%m') AS YearMonth,
        SUM(Sales) AS Current_Month_Sales
    FROM ecommerce_sales
    GROUP BY YearMonth
)
SELECT 
    YearMonth,
    ROUND(Current_Month_Sales, 2) AS Sales,
    ROUND(LAG(Current_Month_Sales) OVER (ORDER BY YearMonth), 2) AS Previous_Month_Sales,
    ROUND(((Current_Month_Sales - LAG(Current_Month_Sales) OVER (ORDER BY YearMonth)) / 
        LAG(Current_Month_Sales) OVER (ORDER BY YearMonth)) * 100, 
    2) AS Growth_Percentage
FROM MonthlySales;

SELECT 
    Product,
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS Profit_Margin_Percent
FROM ecommerce_sales
GROUP BY Product, Category
HAVING Total_Sales > 5000 
ORDER BY Profit_Margin_Percent DESC;


SELECT Region, Category, Total_Sales
FROM (
    SELECT 
        Region, 
        Category, 
        SUM(Sales) AS Total_Sales,
        RANK() OVER (PARTITION BY Region ORDER BY SUM(Sales) DESC) AS Sales_Rank
    FROM ecommerce_sales
    GROUP BY Region, Category
) AS Regional_Rankings
WHERE Sales_Rank = 1;


