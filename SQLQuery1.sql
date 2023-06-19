Create table Employees (employee_id int, employee_name varchar(30), manager_id int)
Truncate table Employees
insert into Employees (employee_id, employee_name, manager_id) values ('1', 'Boss', '1')
insert into Employees (employee_id, employee_name, manager_id) values ('3', 'Alice', '3')
insert into Employees (employee_id, employee_name, manager_id) values ('2', 'Bob', '1')
insert into Employees (employee_id, employee_name, manager_id) values ('4', 'Daniel', '2')
insert into Employees (employee_id, employee_name, manager_id) values ('7', 'Luis', '4')
insert into Employees (employee_id, employee_name, manager_id) values ('8', 'John', '3')
insert into Employees (employee_id, employee_name, manager_id) values ('9', 'Angela', '8')
insert into Employees (employee_id, employee_name, manager_id) values ('77', 'Robert', '1')

SELECT e1.employee_id
FROM Employees e1
JOIN Employees e2
ON e1.manager_id = e2.employee_id
JOIN Employees e3
ON e2.manager_id = e3.employee_id
WHERE e1.employee_id != 1 AND e3.manager_id = 1

WITH CTE AS (
    SELECT employee_id
    FROM Employees
    WHERE manager_id = 1 AND employee_id != 1
    UNION ALL
    SELECT e.employee_id
    FROM CTE c INNER JOIN Employees e ON c.employee_id = e.manager_id
)
SELECT employee_id
FROM CTE
ORDER BY employee_id
OPTION (MAXRECURSION 3);

Drop table if exists T1
Drop table if exists T2
Create table T1(employee_id int)
Create table T2(employee_id int)
insert into T1(employee_id) values ('1'),('2'),(NULL),('3'),('2'),('4'),('4'),('6'),('10');
insert into T2(employee_id) values ('7'),(NULL),(NULL),('3'),('4'),('4'),('2'),('2'),('8');
Select * from T1
Select * from T2

Select count(*) from T1 inner join T2 on T1.employee_id = T2.employee_id;
Select count(*) from T1 full outer join T2 on T1.employee_id = T2.employee_id;
Select count(*) from T1 Left outer join T2 on T1.employee_id = T2.employee_id;
Select count(*) from T1 Right outer join T2 on T1.employee_id = T2.employee_id;
Select count(*) from T1 Left anti join T2 on T1.employee_id = T2.employee_id;

Drop table if exists T1
Drop table if exists T2
Create table T1(employee_id int)
Create table T2(employee_id int)
insert into T1(employee_id) values ('1'),('2'),(NULL),('3'),('2'),('4'),('4'),('6'),('10');
insert into T2(employee_id) values ('7'),(NULL),(NULL),('3'),('4'),('4'),('2'),('2'),('8');

Drop table if exists Customer
CREATE TABLE Customer (
    CustomerID INT,
    Date VARCHAR(6)
);

INSERT INTO Customer (CustomerID, Date)
VALUES (11111, '202212'),(11111, '202210'),(11111, '202209'),(11111, '202301'),(2222, '202201'),(2222, '202205'),(2222, '202204');

DECLARE @date1 VARCHAR(6) = '202201';
DECLARE @date2 VARCHAR(6) = '202212';

SELECT 
    CONVERT(DATE, @date1 + '01', 112), CONVERT(DATE, @date2 + '01', 112);

select c.CustomerID, c.Date, 
min(c.r_date) over(partition by CustomerID) as min_date from (Select CustomerID, Date, CONVERT(Date, cust.Date + '01', 112) as r_date from Customer cust) as c;

with min_diff(cust_id, sales_date, min_date) as 
(select c.CustomerID, c.r_date, min(c.r_date) over(partition by CustomerID) as min_date from (Select CustomerID, CONVERT(Date, cust.Date + '01', 112) as r_date from Customer cust) c)

select md.CustomerID, md.Date, DATEDIFF(MONTH, md.sales_date, min_date) AS DateDiff
from min_diff as md;

select md.CustomerID, md.r_date, (DATEDIFF(YEAR, md.min_date, md.r_date) * 12 + DATEDIFF(MONTH, md.min_date, md.r_date)) AS DateDiff from
((select c.CustomerID, c.r_date, min(c.r_date) over(partition by CustomerID order by CustomerID asc) as min_date from (Select CustomerID, CONVERT(Date, cust.Date + '01', 112) as r_date from Customer cust) c)
) md;

