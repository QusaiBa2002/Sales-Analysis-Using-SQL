#  AdventureWorks E-Commerce Sales & Customer Analytics (SQL)

Welcome to the **AdventureWorks Sales & Customer Analytics** project repository. This project demonstrates advanced SQL data analysis skills applied to real-world business scenarios using the `AdventureWorksDW` sample database in Microsoft SQL Server (SSMS).

---

##  Project Overview | نبذة عن المشروع
يقدم هذا المشروع تحليلاً شاملاً لأداء المبيعات وسلوك العملاء لشركة تجارة إلكترونية، مع التركيز على استخراج رؤى استراتيجية تدعم اتخاذ القرار التجاري، وذلك باستخدام تقنيات SQL المتقدمة مثل **CTEs**, **Window Functions (LAG, NTILE)**, و **Cumulative Calculations**.

---

##  Tech Stack & Tools
* **Database Engine:** Microsoft SQL Server (SSMS)
* **Dataset:** `AdventureWorksDW`
* **SQL Techniques:** CTEs, Window Functions (`LAG`, `SUM() OVER`, `NTILE`), Conditional Logic (`CASE`), Data Cleaning (`NULLIF`, `IS NOT NULL`).

---

##  Repository Structure & Key Analysis | هيكل المشروع والتحليلات

### 1) `01_Yearly_Running_Total_and_Growth.sql`
* **Objective:** Track yearly cumulative sales performance and measure YoY progress month by month.
* **Key Technique:** `SUM() OVER(PARTITION BY ... ORDER BY ...)` & `LAG()`.
* **Business Insight:** Identifies seasonal revenue accumulation and tracks baseline growth trajectory across financial years.

### 2) `02_MoM_Sales_Growth_and_Status.sql`
* **Objective:** Measure Month-over-Month (MoM) revenue growth rate and automatically classify performance status.
* **Key Technique:** `LAG() OVER()`, `NULLIF()`, and `CASE` statements (`Growth`, `Decline`, `Stable`).
* **Business Insight:** Detects immediate revenue fluctuations, highlighting high-performing months and operational dips.


### 03)_Customer_Tier_Equal_Distribution_Segmentation.sql
Objective: Perform customer segmentation by dividing the total customer base into 4 equally sized strategic tiers based on their spending.
Key Technique: Multi-level CTEs, NTILE(4) OVER(ORDER BY ... DESC), and Window Aggregations (COUNT() OVER() / SUM() OVER()).
Business Insight: Evaluates the revenue contribution and density of each tier (Platinum, Gold, Silver, Bronze). This helps executives visualize the disproportionate power of high-value customers (proving that the top 25% of customers generate the vast majority of sales) and optimize marketing budget allocation.

### 04) `04_Customer_Pareto_Cumulative_Segmentation.sql`
* **Objective:** Perform customer segmentation based on Pareto Principle (Cumulative Revenue Contribution).
* **Key Technique:** Multi-level CTEs, `SUM() OVER(ORDER BY ... ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)`.
* **Business Insight:** Categorizes customers into strategic tiers (`Top 20% VIP`, `Top 50% High Value`, `Mid Tier`, `Low Tier`) to optimize retention programs and targeted marketing campaigns.

### 05) #  Market Basket Analysis (Cross-Selling Analytics)

## Overview
This project performs a **Market Basket Analysis** on the `AdventureWorksDW` database to identify product affinities and purchasing patterns. By analyzing customer transaction history, the query pinpoints the top 10 product pairs most frequently bought together within a single invoice (`SalesOrderNumber`).

This analysis helps e-commerce and retail businesses optimize product placement, design bundle strategies, and build targeted cross-selling campaigns.

---

 Business Problem
Understanding which products are bought together enables businesses to:
* **Increase Average Order Value (AOV):** By recommending complementary products at checkout.
* **Optimize Inventory & Logistics:** By bundling items that are naturally purchased together.
* **Enhance Marketing Campaigns:** By tailoring promotions and cross-selling ads to specific product pairs.
  __ __ __
 How to Run the Queries
1. Restore the `AdventureWorksDW` database in SQL Server Management Studio (SSMS).
2. Ensure you execute the `USE AdventureWorksDW;` command prior to running any query.
3. Run the `.sql` scripts in order (`01`, `02`, `03`) to inspect the analysis.

---

 Author: Qusai  
 Focus: Data Analytics & Business Intelligence
