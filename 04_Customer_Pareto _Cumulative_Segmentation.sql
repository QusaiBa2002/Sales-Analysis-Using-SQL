


WITH Customer_sales AS (
    SELECT C.[CustomerKey], 
    CONCAT([FirstName], ' ', [LastName]) AS Full_Name_Customer,
     [Gender], SUM([SalesAmount]) AS Total_sales 
    FROM [dbo].[FactInternetSales] F 
    JOIN [dbo].[DimCustomer] C ON F.[CustomerKey] = C.[CustomerKey] 
    WHERE [Gender] IS NOT NULL AND C.[CustomerKey] IS NOT NULL
    GROUP BY C.[CustomerKey], [FirstName], [LastName], [Gender] 
    HAVING SUM([SalesAmount]) > 0 ),

Cumulative_Sales AS (
    SELECT 
        CustomerKey,
        Full_Name_Customer,
        Gender,
        Total_sales,
        SUM(Total_sales) OVER () AS Total_Company_Sales,
        SUM(Total_sales) OVER (
            ORDER BY Total_sales DESC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Running_Customer_Sales
    FROM Customer_sales ),
Percentile_Calc AS (
    SELECT 
        CustomerKey,
        Full_Name_Customer,
        Gender,
        Total_sales,

        CAST((Running_Customer_Sales * 100.0 / Total_Company_Sales) AS DECIMAL(10,2)) AS Cumulative_Pct
    FROM Cumulative_Sales
)
SELECT 
    CASE 
        WHEN Cumulative_Pct <= 20.0 THEN 'Top 20% (VIP)'
        WHEN Cumulative_Pct <= 50.0 THEN 'Top 50% (High Value)'
        WHEN Cumulative_Pct <= 80.0 THEN 'Mid Tier'
        ELSE 'Low Tier'
    END AS Customer_Percentile_Segment,
    COUNT(*) AS Total_Customers,
    SUM(Total_sales) AS Segment_Sales,
    CAST(SUM(Total_sales) * 100.0 / SUM(SUM(Total_sales)) OVER () AS DECIMAL(10,2)) AS Segment_Share_PCT
FROM Percentile_Calc
GROUP BY 
    CASE 
        WHEN Cumulative_Pct <= 20.0 THEN 'Top 20% (VIP)'
        WHEN Cumulative_Pct <= 50.0 THEN 'Top 50% (High Value)'
        WHEN Cumulative_Pct <= 80.0 THEN 'Mid Tier'
        ELSE 'Low Tier' END
ORDER BY Segment_Sales DESC;
