SELECT* FROM 
sales.retail.bright_coffee
LIMIT 10;


--When the shop was opened 
SELECT MIN(transaction_time) AS opening_hour 
FROM sales.retail.bright_coffee;

--Closing time 
SELECT MAX(transaction_time) AS closing_hour
FROM sales.retail.bright_coffee


--Check categorical columns 
--Only 3 
SELECT DISTINCT product_category
FROM  sales.retail.bright_coffee;



--Check categorical columns 
SELECT DISTINCT store_location 
FROM  sales.retail.bright_coffee;


--When the shop was opened 
SELECT MIN(transaction_date) AS shop_opening_date 
FROM sales.retail.bright_coffee;

--Fisrt operating date 
SELECT MAX(transaction_date) AS last_operating_date
FROM sales.retail.bright_coffee


--Get the day name so i can calculate revenue by name of day
--Cla reveneue comparison using day names
SELECT transaction_date,DAYNAME(transaction_date) AS day_name,
--Use case 
CASE when day_name IN('Sun','Sat') THEN 'Weekend'
ELSE ('Weekday')
END AS day_classification,
FROM sales.retail.bright_coffee;


--to allow to compare revenue for different months 
--I wantto transform the time to morning afternoon, evenining ,night
SELECT transaction_date,MONTHNAME(transaction_date) AS month_name,
transaction_time,
CASE 
WHEN transaction_time between '06:00:00' AND '11:59:59' THEN 'Morning(06:00-12:00)'
WHEN transaction_time between '12:00:00' AND '16:59:59' THEN 'Afternnon (12:00-17:00)'
WHEN transaction_time between '17:00:00' AND '21:00:00' THEN 'Evening (17:00-21:00)'
END AS time_classification,
HOUR(transaction_time) AS hour_of_day,

--categorical date 
store_location,
product_category,
product_detail,
product_type,


--IDS(just count them )
COUNT (DISTINCT transaction_id) as number_of_sales,


--Calculate 
--Revenue calculation
SUM(transaction_qty*unit_price) AS revenue

FROM sales.retail.bright_coffee
GROUP BY ALL ;


-- This query creates a detailed breakdown of sales activity.
-- To find out the total number of sales (transactions) for each specific hour of each specific day of the week.

SELECT
    -- Get the full name of the day 
    DAYNAME(transaction_date) AS day_name,
    
    -- Get the hour of the day as a number 
    HOUR(transaction_time) AS hour_of_day,
    
    -- Count the number of unique transactions that occurred in this slot
    COUNT(DISTINCT transaction_id) AS total_sales

FROM sales.retail.bright_coffee

-- groups all rows into buckets.
-- To create a separate bucket for each unique combination of a day and an hour
-- (e.g.,"All sales from Mondays at 9 AM", "All sales from Tuesdays at 9 AM", etc.)
GROUP BY day_name, hour_of_day

-- Order the final results to make them easy to read in a table
ORDER BY
    -- 1. Sort by the hour of the day first (so 7 AM appears before 8 AM)
    hour_of_day,
    
    -- 2. For each hour, sort the days in their correct calendar order.
    -- This CASE statement is necessary because sorting by 'day_name'
    -- alphabetically would give you (Friday, Monday, Saturday...), which is not useful.
    CASE
        WHEN day_name = 'Monday' THEN 1
        WHEN day_name = 'Tuesday' THEN 2
        WHEN day_name = 'Wednesday' THEN 3
        WHEN day_name = 'Thursday' THEN 4
        WHEN day_name = 'Friday' THEN 5
        WHEN day_name = 'Saturday' THEN 6
        WHEN day_name = 'Sunday' THEN 7
    END;