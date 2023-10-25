use classicmodels;


#........................day 3...............................#
#### question 1
select customernumber,customername,state,creditlimit from customers 
where creditlimit between 50000 and 100000 and state is not null order by creditlimit desc;
#### question 2
select distinct productline from products where productline like '%cars';


#...............................day 4...................................#
#### question 1
select ordernumber,status,ifnull(comments,'-') from orders where status='shipped';
#### question 2
select employeenumber,firstname,jobtitle,
case 
when jobtitle='president'
then 'p'
when jobtitle regexp 'sale manager|sales manager'
THEN 'SM'
when jobtitle='sales rep'
then 'SR'
when jobtitle like '%VP%'
THEN 'VP'
END jobTitle_abbr
from employees order by jobTitle_abbr ;


#........................day 5..........................#
#### question 1
select * from payments;
select year(paymentDate),min(amount) from payments group by year(paymentDate) order by year(paymentDate);
#### question 2
select * from orders;
with s as (select year(orderdate) year,
Quarter(orderdate) q,
count(distinct customernumber) as uq,count(status) as total from orders group by year(orderdate),quarter(orderdate))
select year,
case when q=1 then 'Q1'
	when q=2 then 'Q2'
    when q=3 then 'Q3'
    when q=4 then 'Q4'
    end Quarter,uq as 'Unique customers',total 'Total Orders' from s;
##### question 3
select * from payments;
desc payments;
select monthname(paymentdate) month,replace(format(round(sum(amount),-3),0),',000','K') 'formatted amount' from payments group by monthname(paymentdate) 
having sum(amount) between 500000 and 1000000 order by sum(amount) desc;



#.............................................Day 6.............................................#
##### Question 1 , create journey table
create table journey(Bus_ID int not null,Bus_Name varchar(15) not null,Source_Station varchar(15) not null,
Destination varchar(15) not null,Email varchar(15) unique);
desc journey;

##### question 2, create vendors table
create table vendor(Vendor_ID int primary key,Name varchar(15) not null,Email varchar(15),Country varchar(15) default 'N/A');
DESC VENDOR;

##### question 3, create movies table
create table movie(Movie_ID int primary key,Name varchar(15) not null,Release_Year char(4) default '-',Cast varchar(15) Not null,
Gender ENUM('MALE','FEMALE'),No_of_shows INT CHECK (NO_OF_SHOWS>0));

##### question 4, 
# a) create product table
create table Product(product_id int primary key auto_increment,product_name varchar(10) not null unique,supplier_id int,foreign key(supplier_id) references suppliers(supplier_id));
desc product;
# b) create supplier table
create table Suppliers(supplier_id int primary key auto_increment,supplier_name varchar(10),location varchar(10));
desc suppliers;
# c) create Stock
create table stock(id int primary key auto_increment,product_id int,foreign key(product_id) references product(product_id),balance_stock int);
desc stock;

#...............................................day 7..................................................#
# question 1
select * from employees;
select * from customers;
select employeeNumber,concat(firstname,' ',lastname) 'sales person',count(distinct customernumber) unique_customers 
from employees join customers on employeenumber=salesrepemployeenumber group by employeeNumber order by unique_customers desc;
#question 2
SELECT
    c.customerNumber,
    c.customerName,
    p.productCode,
    p.productName,
    SUM(od.quantityOrdered) AS Ordered_Quantity,
    SUM(p.quantityInStock) AS Total_Inventory,
    SUM(od.quantityOrdered) - SUM(p.quantityInStock) AS Left_Qty
FROM
    Customers AS c
JOIN
    Orders AS o ON c.customerNumber = o.customerNumber
JOIN
    OrderDetails AS od ON o.orderNumber = od.orderNumber
JOIN
    Products AS p ON od.productCode = p.productCode
GROUP BY
    c.customerNumber, p.productCode
ORDER BY
    c.customerNumber;
#####Question 3
-- Create the 'Laptop' table
CREATE TABLE Laptop (
    Laptop_Name VARCHAR(50)
);

-- Insert laptop brand names into the 'Laptop' table
INSERT INTO Laptop (Laptop_Name)
VALUES
    ('Dell'),
    ('HP'),
    ('Lenovo');

-- Create the 'Colours' table
CREATE TABLE Colours (
    Colour_Name VARCHAR(50)
);

-- Insert example colors into the 'Colours' table
INSERT INTO Colours (Colour_Name)
VALUES
    ('Red'),
    ('Blue'),
    ('Green');

-- Perform a cross join between the 'Laptop' and 'Colours' tables
SELECT * FROM Laptop
CROSS JOIN Colours;

##### Question 4
CREATE TABLE Project (
    EmployeeID INT,
    FullName VARCHAR(8),
    Gender VARCHAR(6),
    ManagerID INT
);

-- Insert the provided data into the "Project" table
INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID)
VALUES
    (1, 'Pranaya', 'Male', 3),
    (2, 'Priyanka', 'Female', 1),
    (3, 'Preety', 'Female', NULL),
    (4, 'Anurag', 'Male', 1),
    (5, 'Sambit', 'Male', 1),
    (6, 'Rajesh', 'Male', 3),
    (7, 'Hina', 'Female', 3);
    
select m.fullname Manager_Name,e.fullname Emp_Name from project e join project m on m.employeeid=e.managerid;

#...........................................day 8............................................#
-- Create the 'facility' table
CREATE TABLE facility (
    Facility_ID INT,
    Name VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);
#### 1) add primary key and auto_increment
alter table facility modify column facility_id int primary key auto_increment;
#### 2) add column city after name 
alter table facility add column city varchar(100) not null after name;
desc facility;

#.......................................................day 9.............................................................#
-- Create the 'university' table
CREATE TABLE University (
    ID INT,
    Name VARCHAR(255)
);

-- Insert the provided data into the 'University' table with single quotes
INSERT INTO University (ID, Name)
VALUES
    (1, '       Pune          University     '),
    (2, '  Mumbai          University     '),
    (3, '     Delhi   University     '),
    (4, 'Madras University'),
    (5, 'Nagpur University');
    select * from university;
    set sql_safe_updates=0;

-- Update the 'Name' column 
set sql_safe_updates=0;
UPDATE University
SET Name = replace(Name,' ','');
update university 
set name =replace(name,'University',' University');


#### Finally we have all the names with no middle spaces
select * from university;


#.............................................................day 10...........................................................#
#### notes : understand that tables are related through joins,total number of product code = total products sold,
#### here value = count (product code)
#####first extract year wise count(productcode) by joining orderdetails and order by count(productcode) in desc.
select year(orderdate) year,count(productcode) count from orders o join orderdetails od on o.ordernumber=od.ordernumber group by year(orderdate) order by count(productcode) desc;
#####use common table expression to alter the above result columns ###use subquery in column to get sum(count) #use concat to join columns
with s as (select YEAR(o.orderdate) AS year,
    COUNT(od.productcode) count
    FROM orders o
INNER JOIN orderdetails od ON o.ordernumber = od.ordernumber
GROUP BY YEAR(o.orderdate))
select year,concat(count,'(',floor((count/(select sum(count) from s))*100),'%)') value from s order by count desc;
#### use the above to create a view with check options
create view products_status as with s as (select YEAR(o.orderdate) AS year,
    COUNT(od.productcode) count
    FROM orders o
INNER JOIN orderdetails od ON o.ordernumber = od.ordernumber
GROUP BY YEAR(o.orderdate))
select year,concat(count,'(',floor((count/(select sum(count) from s))*100),'%)') value from s order by count desc;

##### finally we create a view products_status

select * from products_status;

#..............................................................day 11............................................................#
####notes: print the output as message
select * from customers;

delimiter //
create procedure GetCustomerLevel(x int)
begin
declare y decimal(10,2);
select creditlimit into y from customers where customernumber=x;
if y>100000
then 
select 'Platinum' as output;
elseif y>=25000 and y<=100000
then 
select 'Gold' as output;
else 
select 'Silver' as output;
end if;
end //
delimiter ;

call getcustomerlevel(113);
call getcustomerlevel(112);
call getcustomerlevel(103);

#Question 2
select * from payments;  ## paymentdate and amount column is in here 
select * from customers; ## country column is in here                   ## custumernumber column is common in both
### recap round(),format(),replace()
#### now create table using joins ### use group by ### use having clause to match condition
select year(p.paymentdate) as year,c.country as country,replace(format(round(sum(p.amount),-3),-3),',000','K') amount
from 
customers c 
join 
payments p 
on
c.customernumber=p.customernumber
group by
year,country having year='2004' and country='usa';

###create stored procedure using  the above query
delimiter //
create procedure Get_Country_payments(in x year,in y varchar(10))
begin
select year(p.paymentdate) as year,c.country as country,replace(format(round(sum(p.amount),-3),-3),',000','K') amount
from 
customers c 
join 
payments p 
on
c.customernumber=p.customernumber
group by
year,country
having 
year=x and country=y;
end //
delimiter ;
call Get_country_payments('2003','France');

#........................................................day 12............................................................#
#Question 1
select * from orders;
with s as (select
year(orderdate) year,MONTH(orderdate) mm,
count(ordernumber) as Total_Orders,
concat(
floor((
(count(orderdate)-lag(count(orderdate)) over(order by year(orderdate),month(orderdate)))
/
lag(count(ordernumber)) over(order by year(orderdate),month(orderdate)))*
100),
'%') as YoY_Change
 
from orders group by year(orderdate),month(orderdate))
select year,
case
when mm=1 then 'January'
when mm=2 then 'February'
when mm=3 then 'March'
when mm=4 then 'April'
when mm=5 then 'May'
when mm=6 then 'June'
when mm=7 then 'JULY'
when mm=8 then 'August'
WHEN mm=9 THEN 'September'
WHEN mm=10 THEN 'October'
WHEN mm=11 THEN 'November'
WHEN mm=12 THEN 'December'
END Month,Total_orders,yoy_change as '%_YoY_Change' from s;

###QUESTION 2
-- Create the emp_udf table
CREATE TABLE emp_udf (
    Emp_ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL
);

-- Insert data into the emp_udf table
INSERT INTO emp_udf (Name, DOB)
VALUES
    ("Piyush", "1990-03-30"),
    ("Aman", "1992-08-15"),
    ("Meena", "1998-07-28"),
    ("Ketan", "2000-11-21"),
    ("Sanjay", "1995-05-21");
    select * from emp_udf;
    -- Step 1: Create the user-defined function (UDF)
DELIMITER //
CREATE FUNCTION Calculate_Age(DOB DATE) RETURNS VARCHAR(255)
BEGIN
    DECLARE years INT;
    DECLARE months INT;
    DECLARE age VARCHAR(25);
    
    SET years = TIMESTAMPDIFF(YEAR, DOB, CURDATE());
    SET months = TIMESTAMPDIFF(MONTH, DOB, CURDATE()) - (years * 12);
    
    SET age = CONCAT(years, ' years ', months, ' months');
    
    RETURN age;
END //
DELIMITER ;

-- Step 2: Use the UDF in a SELECT statement
SELECT Name, Calculate_Age(DOB) AS Age FROM emp_udf;

#........................................................Day 13.......................................................................#
#### question 1
select * from customers;    ####
select * from orders;       #### 'orders' table contain information about only those who have placed orders, rest of them are left behind in thecustomers table
####using joins
select c.customernumber,c.customername from customers c left join orders o on c.customernumber=o.customernumber where o.customernumber is null;
####using subquery
select customernumber,customername from customers where customernumber not in(select customernumber from orders);

####Question 2
###full outer join = left join   "UNION All"   right join
select c.customernumber,c.customername,count(o.ordernumber) Total_Orders from customers c left join orders o on c.customernumber=o.customernumber group by customernumber
union
select c.customernumber,c.customername,count(o.ordernumber) Total_Orders from customers c right join orders o on c.customernumber=o.customernumber group by customernumber;

#### Question 3
select * from orderdetails;
with s as (select ordernumber,quantityordered,dense_rank() over(partition by ordernumber order by quantityordered desc) rnk from orderdetails)
select ordernumber,quantityordered from s where rnk=2;
#### Question 4
with s as (select ordernumber,count(productcode) count from orderdetails group by ordernumber)
select max(count) as 'Max(Total)',min(count) as 'Min(Total)' from s;
####Question 5

SELECT avg(buyprice) FROM products;
###### extract productline of whose buyprice>avg(buyprice) i.e., 54.3951
SELECT productLine,buyprice 
FROM products where buyprice>(select avg(buyprice) from products);
###### now use cte to find the count of productline
with s as (SELECT productLine,buyprice 
FROM products where buyprice>(select avg(buyprice) from products))
select productline,count(productline) total from s group by productline;


#........................................................Day 14.........................................................................#
CREATE TABLE Emp_EH(
    EmpID INT primary key,                         #1062 duplicate entry
    EmpName varchar(20) not null,                     #1048 null
    email varchar(20) not null);
    
    drop table emp_eh;
    
    
    ### To handle error create a table
    create table fraud(serial_number int primary key auto_increment,
    duplicate_login_emp_id varchar(20),
    message varchar(20) default 'error detected',
    time_of_detection time);
    
    delimiter //
    create procedure error(in id int,in name varchar(20),in mail varchar(20))
    begin
    declare continue handler for 1048,1062
    begin
    insert into fraud(duplicate_login_emp_id,time_of_detection) values(id,now());
    select 'Error has occured, because duplicate empid or null name/mail' as warning;
    end ;
    insert into emp_eh(empid,empname,email) values(id,name,mail);
    end //
    delimiter ;

#    drop procedure error;
#   truncate table fraud;
#    truncate table emp_eh;

####stored procedure for error handle , use>> call error(empid,empname,email)
call error(4,'fir','@rt');
call error(4,'sid','@tru');
call error(8,null,'billy@mail');
call error(13,'ip',null);
call error(89,null,null);
select * from emp_eh;
select * from fraud;

#........................................................day 15..................................#

CREATE TABLE EMP_BIT(NAME VARCHAR(20),OCCUPATION VARCHAR(20),WORKING_DATE DATE,WORKING_HOURS int);
##### CREATE AFTER INSERT TRIGGER ON EMP_BIT
DELIMITER $$
USE `classicmodels`$$
CREATE DEFINER = CURRENT_USER TRIGGER `classicmodels`.`emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW
BEGIN
declare working_hours int default 0;
set new.working_hours=abs(new.working_hours);
END$$
DELIMITER ;
##### insert all the values given in the assignment
INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

select * from emp_bit;




















































