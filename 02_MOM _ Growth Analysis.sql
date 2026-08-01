

 --احسب مبيعات الشهر الحالي وقارن نسبة نموه بشهر السابق له  هل هو في انخفاض ام نمو --
WITH MONTH_SALES AS (
    SELECT 
        YEAR([OrderDate]) AS OrderYear,
        MONTH([OrderDate]) AS OrderMonth,
        SUM([SalesAmount]) AS total_sales
    FROM FactInternetSales 
    WHERE [OrderDate] IS NOT NULL 
    GROUP BY YEAR([OrderDate]), MONTH([OrderDate])
    HAVING SUM([SalesAmount]) > 0 
)
SELECT 
    OrderYear, 
    OrderMonth, 
    total_sales,
    LAG(total_sales) OVER (ORDER BY OrderYear, OrderMonth) AS Previous_Month,   
    CAST(
        (total_sales - LAG(total_sales) OVER (ORDER BY OrderYear, OrderMonth)) * 100.0 
   / NULLIF(LAG(total_sales) OVER (ORDER BY OrderYear, OrderMonth), 0)  AS DECIMAL(10,2) ) AS PCT_MONTH_Growth,
    
    CASE 
        WHEN LAG(total_sales) OVER (ORDER BY OrderYear, OrderMonth) IS NULL THEN 'First Month'
        WHEN total_sales > LAG(total_sales) OVER (ORDER BY OrderYear, OrderMonth) THEN 'Growth'
        WHEN total_sales < LAG(total_sales) OVER (ORDER BY OrderYear, OrderMonth) THEN 'Decline'
        ELSE 'Stable'
    END AS Sales_Status
FROM MONTH_SALES
ORDER BY OrderYear, OrderMonth;
