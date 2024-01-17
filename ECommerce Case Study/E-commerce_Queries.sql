use casestudy;
-- Adding Foriegn Constraints
ALTER TABLE ONLINE_CUSTOMER ADD CONSTRAINT FK_CUSTOMER_ADDRESS foreign key (ADDRESS_ID) references ADDRESS(ADDRESS_ID);
ALTER TABLE PRODUCT ADD CONSTRAINT FK_PRODUCT_CLASS foreign key (PRODUCT_CLASS_CODE) references PRODUCT_CLASS(PRODUCT_CLASS_CODE);
ALTER TABLE ORDER_HEADER ADD CONSTRAINT FK_ORDER_SHIPPER foreign key (SHIPPER_ID) references SHIPPER(SHIPPER_ID);
ALTER TABLE ORDER_HEADER ADD CONSTRAINT FK_ORDER_CUSTOMER foreign key (CUSTOMER_ID) references ONLINE_CUSTOMER(CUSTOMER_ID);
ALTER TABLE ORDER_ITEMS ADD CONSTRAINT FK_PRODUCT foreign key (PRODUCT_ID) references PRODUCT(PRODUCT_ID);
ALTER TABLE ORDER_ITEMS ADD CONSTRAINT FK_ORDER foreign key (ORDER_ID) references ORDER_HEADER(ORDER_ID);

----- Questions -----

-- 1. Display the product details as per the following criteria and sort them in descending order of category:
#a.  If the category is 2050, increase the price by 2000   
#b.  If the category is 2051, increase the price by 500
#c.  If the category is 2052, increase the price by 600

-- Query #1
select PRODUCT_ID, PRODUCT_DESC, PRODUCT_CLASS_CODE, PRODUCT_PRICE, PRODUCT_QUANTITY_AVAIL, LEN, WIDTH, HEIGHT, WEIGHT,  
if(PRODUCT_CLASS_CODE = 2050, PRODUCT_PRICE+2000, IF(PRODUCT_CLASS_CODE = 2051, PRODUCT_PRICE+500, if(PRODUCT_CLASS_CODE = 2052, PRODUCT_PRICE+600, PRODUCT_PRICE)))
as ADJUSTED_PRICE from PRODUCT order by PRODUCT_CLASS_CODE DESC;

-- Query #2
select PRODUCT_ID, PRODUCT_DESC, PRODUCT_CLASS_CODE, PRODUCT_PRICE, PRODUCT_QUANTITY_AVAIL, LEN, WIDTH, HEIGHT, WEIGHT,
case
when PRODUCT_CLASS_CODE = 2050 then PRODUCT_PRICE+2000
when PRODUCT_CLASS_CODE = 2051 then PRODUCT_PRICE+500
when PRODUCT_CLASS_CODE = 2052 then PRODUCT_PRICE+600
else PRODUCT_PRICE
end as ADJUSTED_PRICE
from PRODUCT order by PRODUCT_CLASS_CODE DESC;


-- 2. List the product description, class description and price of all products which are shipped.
select * from product;
select * from product_class;
select * from order_items;
select * from order_header;

select a.PRODUCT_DESC, b.PRODUCT_CLASS_DESC, a.PRODUCT_PRICE from
product_class b inner join product a on a.PRODUCT_CLASS_CODE = b.PRODUCT_CLASS_CODE
inner join order_items c on a.PRODUCT_ID = c.PRODUCT_ID
inner join order_header d on d.ORDER_ID = c.ORDER_ID where d.ORDER_STATUS = 'Shipped';

 
-- 3. Show inventory status of products as below as per their available quantity:
#a. For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, show 'Enough stock'
#b. For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
#c. Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
#For all categories, if available quantity is 0, show 'Out of stock'.
select b.PRODUCT_DESC, a.PRODUCT_CLASS_DESC, b.PRODUCT_QUANTITY_AVAIL,
CASE
WHEN a.PRODUCT_CLASS_DESC IN ('Electronics','Computer') THEN 
IF(b.PRODUCT_QUANTITY_AVAIL >= 31, 'Enough stock', IF(b.PRODUCT_QUANTITY_AVAIL BETWEEN 11 AND 30, 'In stock',
IF(b.PRODUCT_QUANTITY_AVAIL BETWEEN 1 AND 10, 'Low stock', IF(b.PRODUCT_QUANTITY_AVAIL = 0, 'Out of stock', 'NA'))))

WHEN a.PRODUCT_CLASS_DESC IN ('Clothes','Stationery') THEN 
IF(b.PRODUCT_QUANTITY_AVAIL >= 81, 'Enough stock', IF(b.PRODUCT_QUANTITY_AVAIL BETWEEN 21 AND 80, 'In stock',
IF(b.PRODUCT_QUANTITY_AVAIL BETWEEN 1 AND 20, 'Low stock', IF(b.PRODUCT_QUANTITY_AVAIL = 0, 'Out of stock', 'NA'))))
 
ELSE IF(b.PRODUCT_QUANTITY_AVAIL >= 51, 'Enough stock', IF(b.PRODUCT_QUANTITY_AVAIL BETWEEN 16 AND 50, 'In stock',
IF(b.PRODUCT_QUANTITY_AVAIL BETWEEN 1 AND 15, 'Low stock', IF(b.PRODUCT_QUANTITY_AVAIL = 0, 'Out of stock', 'NA'))))

END AS INVENTORY_STATUS
FROM product_class a inner join product b on a.PRODUCT_CLASS_CODE = b.PRODUCT_CLASS_CODE;


-- 4. List customers from outside Karnataka who haven’t bought any toys or books
select * from online_customer;
select * from address;
select * from product_class;

select distinct a.ADDRESS_ID, b.CUSTOMER_FNAME, b.CUSTOMER_LNAME, b.CUSTOMER_EMAIL, b.CUSTOMER_PHONE, a.STATE, b.CUSTOMER_ID, f.PRODUCT_CLASS_DESC  from address a 
inner join online_customer b on a.ADDRESS_ID = b.ADDRESS_ID
inner join order_header c on c.CUSTOMER_ID = b.CUSTOMER_ID
inner join order_items d on d.ORDER_ID = c.ORDER_ID
inner join product e on e.PRODUCT_ID = d.PRODUCT_ID
inner join product_class f on f.PRODUCT_CLASS_CODE = e.PRODUCT_CLASS_CODE
where ((f.PRODUCT_CLASS_DESC not in ('Toys','Books')) and (a.STATE <> 'Karnataka'));