SELECT * FROM mock_interview.retail_sales_data;
select * from retail_sales_data;
select * from region_targets;
-- Write a query to select all columns for products sold in the "North" region.
select * from retail_sales_data
where Region = 'North';
-- Find the total revenue per product
select Product_Name, sum(Units_Sold * Unit_Price) as  revenue
from retail_sales_data
group by Product_Name
order by revenue desc;
-- Retrieve products where Inventory_Stock is less than 100.
select Product_Name, Inventory_Stock 
from retail_sales_data
where Inventory_Stock < 100;
-- List all products sorted by Units_Sold in descending order.
select Product_Name,Units_Sold
from retail_sales_data
order by Units_Sold desc;
-- total units sold per category
select Category, sum(Units_Sold) as total_unit_sold
from retail_sales_data
group by Category;
-- Find the product(s) in the Electronics category with Units_Sold > 150 and Inventory_Stock < 100.
select Product_Name,  Units_Sold, Inventory_Stock
 from retail_sales_data
where  Category = 'Electronics' and Units_Sold > 150 and Inventory_Stock < 100;
-- Write a query to display each product’s Revenue and Stock_Value
select Product_Name , Units_Sold * Unit_Price as revenue,
Inventory_Stock * Unit_Price as Stock_value
from retail_sales_data;
-- Find the product(s) whose Revenue is greater than the average revenue of all products.
with Product_Revenue as 
(select Product_Name,  (Units_Sold * Unit_Price) as revenue
from retail_sales_data)
SELECT
    Product_Name, revenue
FROM
    Product_Revenue
WHERE
    revenue > (
        SELECT
            AVG(revenue)
        FROM
            Product_Revenue
    );
-- Write a query to calculate the total revenue per region and 
-- join it with the region_targets table.

select (Units_Sold * Unit_Price) as revenue , rt.Target_Revenue
from retail_sales_data as r
join region_targets as rt
on r.Region = rt.Region;
-- Write a query to list regions where Total_Revenue < Target_Revenue,
-- and also show the Regional_Manager from region_targets table.

select r.region, sum(r.Units_Sold * r.Unit_Price) as Total_Revenue, rt.Regional_Manager, rt.Target_Revenue
from retail_sales_data as r
join region_targets as rt
on r.Region = rt.Region
GROUP BY r.Region, rt.Target_Revenue, rt.Regional_Manager
HAVING SUM(r.Units_Sold * r.Unit_Price) < rt.Target_Revenue;

-- Write a query to rank all products based on their total revenue (Units_Sold * Unit_Price) in 
-- descending order.
select Product_Name, Category, (Units_Sold * Unit_Price) as total_revenue,
rank() over ( order by (Units_Sold * Unit_Price) desc) as Revenue_rnk
from retail_sales_data;
-- Write a query to rank products within each Region based on total revenue 

select Product_Name, Region, sum(Units_Sold * Unit_Price) as total_revenue,
rank() over ( partition by Region  order by sum(Units_Sold * Unit_Price) desc) as rnk_in_region 
from retail_sales_data
group by Product_Name, Region;
