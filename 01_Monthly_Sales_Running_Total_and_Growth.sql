
   
       --كيف ينمو إجمالي المبيعات المتراكمة شهرياً داخل كل سنة مقارنة بالشهر السابق لها، وما هي نسبة هذا النمو__
WITH MonthlySales AS (
    SELECT 
        YEAR([OrderDate]) AS OrderYear,
        MONTH([OrderDate]) AS OrderMonth,
        SUM([SalesAmount]) AS CurrentMonthSales
    FROM 
        FactInternetSales
    WHERE 
        [OrderDate] IS NOT NULL
    GROUP BY 
        YEAR([OrderDate]), 
        MONTH([OrderDate])
),
RunningTotalSales AS (
   
   
   SELECT 
        OrderYear,
        OrderMonth,
        CurrentMonthSales,
        -- الخطوة 1: حساب المتراكم السنوي أولاً بشكل نظيف
        SUM(CurrentMonthSales) OVER (
            PARTITION BY OrderYear 
            ORDER BY OrderMonth 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS Yearly_Running_Total
    FROM 
        MonthlySales
)
SELECT 
    OrderYear,
    OrderMonth,
    CurrentMonthSales,
    Yearly_Running_Total,
    -- الخطوة 2: حساب المتراكم للشهر السابق (يتحرك داخل نفس السنة بفضل PARTITION BY)
    LAG(Yearly_Running_Total) OVER (
        PARTITION BY OrderYear 
        ORDER BY OrderMonth
    ) AS Previous_Yearly_Running_Total,
    -- الخطوة 3: حساب نسبة نمو المتراكم بدقة بدون تعقيد الأقواس
    CAST (
        (Yearly_Running_Total - LAG(Yearly_Running_Total) OVER (PARTITION BY OrderYear ORDER BY OrderMonth)) * 100.0 
        / NULLIF(LAG(Yearly_Running_Total) OVER (PARTITION BY OrderYear ORDER BY OrderMonth), 0) 
        AS DECIMAL(10,2)
    ) AS PCT_Growth
FROM 
    RunningTotalSales
ORDER BY  
    OrderYear,
    OrderMonth;