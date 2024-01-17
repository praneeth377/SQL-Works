use gdb023;
select * from dim_customer;
select * from dim_product;
select * from fact_gross_price;
select * from fact_manufacturing_cost;
select * from fact_pre_invoice_deductions;
select * from fact_sales_monthly;


# Adding Foreign Key References
alter table fact_gross_price add constraint fk_gp foreign key (product_code) references dim_product(product_code);
alter table fact_manufacturing_cost add constraint fk_mc foreign key (product_code) references dim_product(product_code);
alter table fact_pre_invoice_deductions add constraint fk_pid foreign key (customer_code) references dim_customer(customer_code);
alter table fact_sales_monthly add constraint fk_smp foreign key (product_code) references dim_product(product_code);
alter table fact_sales_monthly add constraint fk_a foreign key (customer_code) references dim_customer(customer_code);


# Requests and Queries

# R1. Provide the list of markets in which customer "Atliq Exclusive" operates its business in the APAC region. 
select distinct market as Markets_List 
from dim_customer where (customer = 'Atliq Exclusive') and (region = 'APAC');

# ------------------------------------------------------------------------------------------------------------------------------- #

# R2. What is the percentage of unique product increase in 2021 vs. 2020?
with t1 as (
select distinct 
(select count(distinct product_code) from fact_gross_price where fiscal_year = 2020) as unique_products_2020, 
(select count(distinct product_code) from fact_gross_price where fiscal_year = 2021) as unique_products_2021
from fact_gross_price)
select *, concat(100*(unique_products_2021 - unique_products_2020)/unique_products_2020,'%') as percentage_chg
from t1;

# ------------------------------------------------------------------------------------------------------------------------------- #

# R3. Provide a report with all the unique product counts for each segment and sort them in descending order of product counts.
select segment, count(product_code) as product_count 
from dim_product group by segment order by product_count desc;

# ------------------------------------------------------------------------------------------------------------------------------- #

# R4. Follow-up: Which segment had the most increase in unique products in 2021 vs 2020?
with t1 as (
select a.segment, 
count(distinct case when b.fiscal_year = 2020 then b.product_code end) as product_count_2020,
count(distinct case when b.fiscal_year = 2021 then b.product_code end) as product_count_2021
from dim_product a inner join fact_gross_price b on a.product_code = b.product_code
group by a.segment)
select *, product_count_2021 - product_count_2020 as difference from t1 order by difference desc;

# ------------------------------------------------------------------------------------------------------------------------------- #

# R5. Get the products that have the highest and lowest manufacturing costs.
create view MC as
select a.product_code, a.product, b.manufacturing_cost 
from dim_product a join fact_manufacturing_cost b on a.product_code = b.product_code;
# select * from MC;

with t1 as (
select 'Highest Cost' as Category, product_code, product, manufacturing_cost from MC order by manufacturing_cost desc limit 1),
t2 as (
select 'Lowest Cost' as Category, product_code, product, manufacturing_cost from MC order by manufacturing_cost limit 1)
select * from t1 union select * from t2;

# ------------------------------------------------------------------------------------------------------------------------------- #

# R6.  Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct 
# for the fiscal year 2021 and in the Indian market.
select a.customer_code, a.customer, round(100*avg(b.pre_invoice_discount_pct),2) as average_discount_percentage
from dim_customer a join fact_pre_invoice_deductions b on a.customer_code = b.customer_code
where (b.fiscal_year = 2021) and (a.market = 'India')
group by a.customer_code, a.customer order by average_discount_percentage desc limit 5;

# ------------------------------------------------------------------------------------------------------------------------------- #

# R7. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. 
# This analysis helps to get an idea of low and high-performing months and take strategic decisions.
select distinct monthname(b.date) as Month, year(b.date) as Year, c.gross_price as Gross_Sales_Amount
from dim_customer a join fact_sales_monthly b on a.customer_code = b.customer_code
join fact_gross_price c on b.product_code = c.product_code
where a.customer = 'Atliq Exclusive';

# ------------------------------------------------------------------------------------------------------------------------------- #

# R8. In which quarter of 2020, got the maximum total_sold_quantity?
# Assuming Indian FY2020,
select * from fact_sales_monthly;
select case
when (year(date) = 2019) and (month(date) between 4 and 6) then 'Q1'
when (year(date) = 2019) and (month(date) between 7 and 9) then 'Q2'
when (year(date) = 2019) and (month(date) between 10 and 12) then 'Q3'
when (year(date) = 2020) and (month(date) between 1 and 3) then 'Q4'
end as Quarters_of_FY2020, 
sum(sold_quantity) as total_sold_quantity
from fact_sales_monthly group by Quarters_of_FY2020 order by total_sold_quantity desc;

# ------------------------------------------------------------------------------------------------------------------------------- #

# R9. Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution?
with t1 as (
select a.channel, sum(c.gross_price) as total_gross_sales from dim_customer a 
join fact_sales_monthly b on a.customer_code = b.customer_code
join fact_gross_price c on b.product_code = c.product_code
where c.fiscal_year = 2021 group by a.channel)
select *, round(100*total_gross_sales/(select sum(total_gross_sales) from t1),2) as percentage_contribution 
from t1 order by percentage_contribution desc;

# ------------------------------------------------------------------------------------------------------------------------------- #

# R10. Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021? 
with t1 as (
select a.division, a.product, sum(b.sold_quantity) as total_sold_quantity, row_number() over(partition by a.division order by sum(b.sold_quantity) desc) as division_rank
from dim_product a join fact_sales_monthly b on a.product_code = b.product_code
where b.fiscal_year = 2021
group by a.division, a.product)
select division, product, total_sold_quantity from t1 where division_rank < 4;
