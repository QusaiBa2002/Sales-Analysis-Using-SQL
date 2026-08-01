

--تصنيف العملاء الى 4 فئات حسب المبالغ التي دفعوها لشركة وحساب نسبةاسهام كل فئة من اجمالي مبيعات الشركةوعدد عملاء كل فئة

with Customer_sales as (
select C.[CustomerKey] , concat ([FirstName],' ',[LastName]) as Full_Name_Customer,
[Gender] , sum([SalesAmount]) as Total_sales 
from [dbo].[FactInternetSales] F JOIN [dbo].[DimCustomer] C 
ON F.[CustomerKey] =C.[CustomerKey] 
where [Gender] is not null AND C.[CustomerKey] IS NOT NULL
Group by C.[CustomerKey],[FirstName] , [LastName],[Gender] 
having sum([SalesAmount]) > 0 ),

Categories_Customer as (
select   Full_Name_Customer , [Gender] , Total_sales ,
ntile(4) over (order by Total_sales desc ) as Customer_Tiers  , 
sum(Total_sales) over () as Sales_Compnay 
FROM Customer_sales )

select  Full_Name_Customer , [Gender] , Total_sales , 
CASE Customer_Tiers  
WHEN 1 THEN 'Platinum'
WHEN 2 THEN 'Gold'
WHEN 3 THEN 'Silver'
WHEN 4 THEN 'Bronze'  END AS Customer_Segmentation ,
COUNT(*) OVER (PARTITION BY Customer_Tiers ) AS Count_Tiers ,
CAST( SUM(Total_sales) OVER (PARTITION BY Customer_Tiers ) *100.0 
/NULLIF( Sales_Compnay ,0) AS decimal(10,2) ) AS Segment_Share
FROM Categories_Customer
ORDER BY Total_sales DESC 













