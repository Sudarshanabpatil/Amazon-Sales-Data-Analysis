-- changing tha column name by alter command 
 ALTER TABLE amazon RENAME COLUMN `Invoice ID` TO `invoice_id`; 
 ALTER TABLE amazon RENAME COLUMN `Branch` TO `branch`;
 ALTER TABLE amazon RENAME COLUMN `City` TO `city`;
 ALTER TABLE amazon RENAME COLUMN `Customer type` TO `customer_type`;
 ALTER TABLE amazon RENAME COLUMN `Gender` TO `gender`;
 ALTER TABLE amazon RENAME COLUMN `Product line` TO `product_line`;
 ALTER TABLE amazon RENAME COLUMN `Unit price` TO `unit_price`;
 ALTER TABLE amazon RENAME COLUMN `Quantity` TO `quantity`;
 ALTER TABLE amazon RENAME COLUMN `Tax 5%` TO `VAT`;
 ALTER TABLE amazon RENAME COLUMN `Total` TO `total`;
 ALTER TABLE amazon RENAME COLUMN `Date` TO `date`;
 ALTER TABLE amazon RENAME COLUMN `Time` TO `time`;
 ALTER TABLE amazon RENAME COLUMN `Payment` TO `payment_method`;
 ALTER TABLE amazon RENAME COLUMN `cogs` TO `cogs`;
 ALTER TABLE amazon RENAME COLUMN `gross margin percentage` TO `gross_margin_percentage`;
 ALTER TABLE amazon RENAME COLUMN `gross income` TO `gross_income`;
 ALTER TABLE amazon RENAME COLUMN `Rating` TO `rating`;
 
-- Changing the all columns Data Types --->

alter table amazon modify column invoice_id varchar(30);
alter table amazon modify column branch varchar(5);
alter table amazon modify column city varchar(30);
alter table amazon modify column customer_type varchar(30);
alter table amazon modify column gender varchar(10);
alter table amazon modify column product_line varchar(100);
alter table amazon modify column unit_price decimal(10,2);
alter table amazon modify column quantity int;
alter table amazon modify column VAT FLOAT(6, 4);
alter table amazon modify column total DECIMAL(10, 2);
alter table amazon modify column date date;
alter table amazon modify column time TIMESTAMP;
alter table amazon modify column payment_method varchar(100);
alter table amazon modify column cogs DECIMAL(10, 2);
alter table amazon modify column gross_margin_percentage FLOAT(11, 9);
alter table amazon modify column gross_income DECIMAL(10, 2);
alter table amazon modify column rating float(6, 4);

-- checking data types --->
desc amazon;


-- FETURE ENGINEERING :

-- adding a new column called timeofday based on timing of were morning and evening or afternoon
select time from amazon;

alter table amazon
add column timeofday varchar(20); 


update amazon
set timeofday =
    case
        when(time) >= '06:00:00' and time(time) < '12:00:00' then 'Morning'
        when time(time) >= '12:00:00' and time(time) < '18:00:00' then 'Afternoon'
        else 'Evening'
    end;

select timeofday from amazon;

--  adding a new column called dayname based on date days for which week of the day each branch is busiest -->
select date from amazon;
select dayname(date) from amazon;
select dayname(date) from amazon where dayname(date) in ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');

alter table amazon
add column dayname varchar(20);

update amazon
set dayname = dayname(date) where dayname(date) in ('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday');

select dayname from amazon;


-- adding new column called monthname based on date for determine which month of the year has the most sales and profit.
select monthname(date) from amazon where monthname(date) in ('January','February','March');

alter table amazon
add column monthname varchar(20) ;

update amazon
set monthname = monthname(date) where monthname(date) in ('January','February','March');
-- monthname

select * from amazon;

 -- Exploratory Data Analysis (EDA) and Questions :
 
 -- 1 What is the count of distinct cities in the dataset?
 select count(distinct city) as count_distinct_of_city from amazon;
-- hence there are 3 distinct city are  Yangon Naypyitaw Mandalay

-- 2 For each branch, what is the corresponding city?
select city ,branch from amazon group by city, branch;
-- here for each branch we have corresponding city for Yangon branch is A and Naypyitaw is C and Mandalay is B 

-- 3 What is the count of distinct product lines in the dataset?
 select count(distinct product_line) as count_of_distinct_product_line from amazon;
 select distinct product_line from amazon;
-- there are 6 distinct product_lines are Health and beauty, Electronic accessories, Home and lifestyle, Sports and travel, Food and beverages, Fashion accessories
 
 -- 4 Which payment method occurs most frequently?
select max(payment_method) from amazon;
-- Ewallet payment method is used most frequently

-- 5 Which product line has the highest sales?
select product_line , sum(total) as total_sales from amazon group by product_line order by total_sales desc;

/*
here Food and beverages has highest sales 56144.96
total sales amount for each product line by multiplying the quantity sold by the unit price,
groups the results by product line, sorts them by total sales in descending order,
and limits the result to just one row, giving you the product line with the highest sales.
*/


-- 6 How much revenue is generated each month?
select sum(total) as revenue , monthname from amazon
group by monthname
order by revenue asc;

-- revenue is generated by each month is --> February is 97219.58 , March is 109455.74 and January is 116292.11
-- highest revenue made in the month of January revenue is  116292.11

-- 7 In which month did the cost of goods sold reach its peak?
select sum(cogs) as cost_of_goods_sold, monthname from amazon
group by monthname 
order by cost_of_goods_sold desc;
-- in January month cogs is reached its peak by 110754.16 

-- 8 Which product line generated the highest revenue?
select product_line, sum(total) as revenue from amazon group by product_line 
order by revenue asc limit 3;
-- Food and beverages product line generated 56144.96 highest revenue 

-- 9 In which city was the highest revenue recorded?
select city,sum(total) as revenue from amazon 
group by city
order by revenue desc
limit 1;
-- in Naypyitaw city was the highest revenue recorded 110568.86

 -- 10 Which product line incurred the highest Value Added Tax?
select product_line , sum(VAT) as value_added_tax from amazon
group by product_line 
order by value_added_tax desc
limit 1;
-- Food and beverages product_line incurred the highest Value Added Tax 2673.5640

-- 11 For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
 SELECT 
    product_line,
    SUM(total) AS total_sales,
    AVG(total) AS average_sales,
    CASE 
        WHEN SUM(total) > AVG(total) THEN 'Good'
        ELSE 'Bad'
    END AS sales_performance
FROM 
    amazon
GROUP BY 
    product_line
ORDER BY 
    total_sales DESC;

        
select * from amazon;

-- 12 Identify the branch that exceeded the average number of products sold.
SELECT branch, COUNT(product_line) AS num_products_sold
FROM amazon
GROUP BY branch
HAVING num_products_sold > (SELECT AVG(num_products_sold) FROM (SELECT COUNT(product_line) AS num_products_sold FROM amazon GROUP BY branch) AS avg_sales);
select branch, COUNT(product_line) AS num_products_sold from amazon group by branch;
-- Branch A is the exceeded the average number of products sold.

-- 13 Which product line is most frequently associated with each gender?
-- select product_line ,max(gender) as maximum_gender from amazon
-- group by product_line;


SELECT gender, product_line, COUNT(*) AS frequency
FROM amazon 
GROUP BY gender, product_line
ORDER BY gender, frequency DESC;

-- product line is most frequently associated with each gender Health and beauty Electronic accessories, Home and lifestyle, Sports and travel, Food and beverages, Fashion accessories,

-- 14 Calculate the average rating for each product line.
select product_line, avg(rating) as avg_rating from amazon group by product_line order by avg_rating desc;

-- 15 Count the sales occurrences for each time of day on every weekday.
select distinct timeofday,dayname,count(total) as sales_count from amazon group by timeofday,dayname order by sales_count desc ;

-- 16 Identify the customer type contributing the highest revenue.
select customer_type ,sum(total) as revenue from amazon group by customer_type;
-- Member customer type has highest revenue 164223.81

-- 17 Determine the city with the highest VAT percentage.
select city, VAT from amazon order by VAT desc limit 1;
--  City Naypyitaw had highest VAT 49.6500

-- 18 Identify the customer type with the highest VAT payments.
select customer_type, sum(VAT) as VAT from amazon group by customer_type order by VAT desc limit 1;
-- Customer type member has highest VAT 49.6500

-- 19 What is the count of distinct customer types in the dataset?
select count(distinct customer_type) as dist_customer_type from amazon;
-- there are 2  count of distinct customer types in the dataset

-- 20 What is the count of distinct payment methods in the dataset?
select count(distinct payment_method) as dist_payment_method from amazon;
-- there are 3 count of distinct payment methods in the dataset

-- 21 Which customer type occurs most frequently?
select max(customer_type) as max_customer_type from amazon;
-- Normal customer type occurs most frequently

-- 22 Identify the customer type with the highest purchase frequency.
select customer_type , sum(total) as total from amazon group by customer_type order by total desc;
-- customer_type Member	has  highest purchase frequency 1042.65

-- 23 Determine the predominant gender among customers.
select gender , count(*) as gender_count from amazon group by gender order by gender_count desc ;
-- Female predominant gender among customers is 501

-- 24 Examine the distribution of genders within each branch.
select gender , branch , count(*) as gender_count from amazon group by branch,gender order by branch, gender_count desc;

-- 25 Identify the time of day when customers provide the most ratings.
select timeofday ,max(rating) as most_ratings from amazon group by timeofday;
-- Afternoon 10.0000 , Morning	10.0000 ,Evening 10.0000

-- 26 Determine the time of day with the highest customer ratings for each branch.
select branch,timeofday , max(rating) as highest_ratings  from amazon group by branch,timeofday;

-- 27 Identify the day of the week with the highest average ratings.
select timeofday ,avg(rating) as average_ratings from amazon group by timeofday order by average_ratings desc ;
-- Afternoon 6.99337121

-- 28 Determine the day of the week with the highest average ratings for each branch.
select branch ,timeofday,avg(rating) as highest_avg_ratings from amazon group by branch,timeofday order by highest_avg_ratings desc ;

-- Analysis List ---> Insights
-- PPT Presentaion
