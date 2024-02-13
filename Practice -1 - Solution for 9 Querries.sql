-- Query 1-- Table name 'users'

CREATE DATABASE query_practice;
USE query_practice;
CREATE TABLE users (user_id INT, user_name VARCHAR (30) NOT NULL, email VARCHAR (50));
INSERT INTO users (user_id,user_name,email) VALUES
(1,'Sumit','sumit@gmail.com'),
(2,'Reshma','reshma@gmail.com'),
(3,'Farhan','farhan@gmail.com'),
(4,'Robin','robin@gmail.com'),
(5,'Robin','robin@gmail.com');

SELECT * FROM users;

-- Write a SQL Query to fetch all the duplicate records in a table.
SELECT u.*,
ROW_NUMBER () OVER () as rn
FROM users u;


SELECT u.*,
ROW_NUMBER () OVER (partition by user_name order by user_id) as rn
FROM users u
order  by user_id;

SELECT user_id,user_name,email
FROM (
	SELECT u.*,
ROW_NUMBER () OVER (partition by user_name order by user_id) as rn
FROM users u
order  by user_id ) x
WHERE x.rn > 1;   

-- Query 2 & Query 3-- Table name 'employee' 

CREATE TABLE employee (emp_id INT, emp_name VARCHAR (50), dept_name VARCHAR (50), salary INT);
INSERT INTO employee (emp_id, emp_name, dept_name, salary) VALUES
(101,'Mohan','Admin',4000),
(102,'Rajkumar','HR',3000),
(103,'Akbar','IT',4000),
(104,'Dorwin','Finance',6500),
(105,'Rohit','HR',3000),
(106,'Rajesh','Finance',5000),
(107,'Preet','HR',7000),
(108,'Mayam','Admin',4000),
(109,'Sanjay','IT',6500),
(110,'Vasudha','IT',7000),
(111,'Melinda','IT',8000),
(112,'Komal','IT',10000),
(113,'Gautham','Admin',2000),
(114,'Manisha','HR',3000),
(115,'Chandani','IT',4500),
(116,'Satya','Finance',6500),
(117,'Adarsh','HR',3500),
(118,'Tejaswi','Finance',5500),
(119,'Cory','HR',8000),
(120,'Monica','Admin',5000),
(121,'Rosalin','IT',6000),
(122,'Ibrahim','IT',8000),
(123,'Vikram','IT',8000),
(124,'Dheeraj','IT',11000);

SELECT * FROM employee;

-- Write a SQL query to fetch the second last record from employee table.
SELECT emp_id,emp_name,dept_name,salary
FROM (
	 SELECT *,
     ROW_NUMBER () OVER ( ORDER BY emp_id DESC) rn
     FROM employee ) x
 WHERE x.rn = 2;    

-- Query 3-- 
-- Write a SQL query to display only the details of employees who either earn the highest salary or the lowest salary in each department from the employee table.
-- SUBQUERY
select e.*,
max(salary) over (partition by dept_name) as max_salary,
min(salary) over (partition by dept_name) as min_salary
from employee e;

-- Main Answer--
SELECT x.* 
FROM employee e
JOIN ( select e.*,
	   max(salary) over (partition by dept_name) as max_salary,
	   min(salary) over (partition by dept_name) as min_salary
	   from employee e) x
ON e.emp_id = x.emp_id
AND (e.salary = x.max_salary OR e.salary = x.min_salary)
ORDER BY x.dept_name, x.salary;

-- Query 4-- Table name 'doctors'
DROP TABLE doctors;
CREATE TABLE doctors (id INT PRIMARY KEY, name VARCHAR (50) NOT NULL, speciality VARCHAR (100), hospital VARCHAR (50), city VARCHAR (50), consultation_fee INT);
SELECT * FROM doctors;

INSERT INTO doctors (id,name,speciality,hospital,city,consultation_fee) VALUES
(1,'Dr.Shashank','Ayurveda','Apollo Hospital','Bangalore',2500),
(2,'Dr.Abdul','Homeopathy','Fortis Hospital','Bangalore',2000),
(3,'Dr.Shwestha','Homeopathy','KMC Hospital','Manipal',1000),
(4,'Dr.Murphy','Dermatology','KMC Hospital','Manipal',1500),
(5,'Dr.Farhana','Physician','Gleneagles Hospital','Bangalore',1700),
(6,'Dr.Maryam','Physician','Gleneagles Hospital','Bangalore',1500); 

SELECT * FROM doctors d;

-- From the doctors table, fetch the details of doctors who work in the same hospital but in different specialty.--
SELECT d1.*
FROM doctors d1
JOIN doctors d2
ON d1.hospital = d2.hospital AND d1.speciality <> d2.speciality AND d1.id <> d2.id;

-- Write SQL query to fetch the doctors who work in same hospital irrespective of their specialty.--
SELECT d1.*
FROM doctors d1
JOIN doctors d2
ON d1.hospital = d2.hospital  AND d1.id <> d2.id;

-- Write SQL query to fetch the doctors who work in same city & same hsopital  & different of their specialty.--
SELECT d1.*
FROM doctors d1
JOIN doctors d2
ON d1.hospital = d2.hospital AND d1.speciality <> d2.speciality AND d1.id <> d2.id;


-- Write SQL query to fetch the doctors who work in same hsopital  irrespective of their specialty.--
SELECT DISTINCT d1.*
FROM doctors d1
JOIN doctors d2
ON d1.hospital = d2.hospital AND d1.id <> d2.id;     

-- Write SQL query to fetch the doctors who work in different hspital but has same consultation fee.--
SELECT DISTINCT d1.*
FROM doctors d1
JOIN doctors d2
ON d1.hospital <> d2.hospital AND d1.consultation_fee = d2.consultation_fee ;
     
-- Query 5- Table name- 'login_details'--

CREATE TABLE login_details (login_id INT PRIMARY KEY, user_name VARCHAR (50), login_date DATE);

INSERT INTO login_details (login_id , user_name , login_date ) VALUES
(101,'Michael',CURRENT_DATE),
(102,'James',CURRENT_DATE),
(103,'Stewart',CURRENT_DATE+1),
(104,'Stewart',CURRENT_DATE+1),
(105,'Stewart',CURRENT_DATE+1),
(106,'Michael',CURRENT_DATE+2),
(107,'Michael',CURRENT_DATE+2),
(108,'Stewart',CURRENT_DATE+3),
(109,'Stewart',CURRENT_DATE+3),
(110,'James',CURRENT_DATE+4),
(111,'James',CURRENT_DATE+4),
(112,'James',CURRENT_DATE+5),
(113,'James',CURRENT_DATE+6);

SELECT * FROM login_details;

-- Fetch the users who logged in consecutively 3 or more times.--
SELECT *,
CASE WHEN user_name = LEAD (user_name) OVER (ORDER BY login_id)
AND user_name = LEAD (user_name,2) OVER (ORDER BY login_id)
THEN user_name ELSE NULL END AS repeated_names
FROM login_details;

-- Main Answer of Query 5--
SELECT DISTINCT repeated_names
FROM (
SELECT *,
         CASE WHEN user_name = lead (user_name) OVER (ORDER BY login_id)
		 AND user_name = lead (user_name,2) OVER (ORDER BY login_id)
		 THEN user_name ELSE NULL END AS repeated_names 
		 FROM login_details ) x
WHERE x.repeated_names IS NOT NULL;

-- Query 5-- Table name 'students'
CREATE TABLE students (id INT PRIMARY KEY, student_name VARCHAR (50) NOT NULL);
INSERT INTO students (id,student_name) VALUES
(1,'James'),
(2,'Michael'),
(3,'George'),
(4,'Stewart'),
(5,'Robin');

SELECT * FROM students;

-- Write a SQL query to interchange the adjacent student names.--

SELECT *,
CASE WHEN id%2 <> 0 THEN LEAD (student_name,1,student_name) OVER (ORDER BY id)
WHEN id%2 = 0 THEN LAG (student_name) OVER (ORDER BY id) END AS new_student_name
FROM students;

-- Query 7-- Table name 'weather'--
DROP TABLE weather;
CREATE TABLE weather (id INT, city VARCHAR (50), temperature INT, date DATE);
INSERT INTO weather (id,city,temperature,date) VALUES
(1, 'London', -1, ('2024-02-01')),
(2, 'London', -2, ('2024-02-02')),
(3, 'London', 4, ('2024-02-03')),
(4, 'London', 1, ('2024-02-04')),
(5, 'London', -2, ('2024-02-05')),
(6, 'London', -5, ('2024-02-06')),
(7, 'London', -7, ('2024-02-07')),
(8, 'London', 5, ('2024-02-08'));

SELECT * FROM weather;

-- fetch all the records when London had extremely cold temperature for 3 consecutive days or more.--
-- subquery--
SELECT *,
       CASE WHEN temperature < 0
       AND LEAD (temperature) OVER(ORDER BY id) < 0
       AND LEAD (temperature, 2) OVER (ORDER BY id) < 0
       THEN 'Y'
       WHEN temperature < 0
       AND LAG (temperature) OVER(ORDER BY id) < 0
       AND LEAD (temperature) OVER (ORDER BY id) < 0
       THEN 'Y'
       WHEN temperature < 0
       AND LAG (temperature) OVER(ORDER BY id) < 0
       AND LAG (temperature, 2) OVER (ORDER BY id) < 0
       THEN 'Y'
       ELSE null
       END AS Flag
       FROM weather;

-- Query 7 Main answer--
SELECT *
FROM (
SELECT *,
       CASE WHEN temperature < 0
       AND LEAD (temperature) OVER(ORDER BY id) < 0
       AND LEAD (temperature, 2) OVER (ORDER BY id) < 0
       THEN 'Y'
       WHEN temperature < 0
       AND LAG (temperature) OVER(ORDER BY id) < 0
       AND LEAD (temperature) OVER (ORDER BY id) < 0
       THEN 'Y'
       WHEN temperature < 0
       AND LAG (temperature) OVER(ORDER BY id) < 0
       AND LAG (temperature, 2) OVER (ORDER BY id) < 0
       THEN 'Y'
       ELSE null
       END AS Flag
       FROM weather ) x
WHERE x.Flag = 'Y';       
       
-- Query 8 -- Table name 'event_category' , 'patient_treatment' , 'physician_speciality' --
CREATE TABLE patient_treatment (id INT, event_name VARCHAR (50), physician_id INT);
CREATE TABLE event_category (event_name VARCHAR (50), category VARCHAR (100));
CREATE TABLE physician_speciality (physician_id INT, speciality VARCHAR (50));  

INSERT INTO patient_treatment (id,event_name,physician_id) VALUES
(1,'Radiation',1000),
(2,'Chemotherapy',2000),
(1,'Biopsy',1000),
(3,'Immunosupressants',2000),
(4,'BTKI',3000),
(5,'Radiation',4000),
(4,'Chemotherapy',2000),
(1,'Biopsy',5000),
(6,'Chemotherapy',6000);

INSERT INTO event_category (event_name, category) VALUES
('Chemotherapy','Procedure'),
('Radiation','Procedure'),
('Immunosuppressants','Prescription'),
('BTKI','Prescription'),
('Biopsy','Test');

INSERT INTO physician_speciality (physician_id, speciality) VALUES
(1000,'Radiologist'),
(2000,'Oncologist'),
(3000,'Hermatologist'),
(4000,'Oncologist'),
(5000,'Pathologist'),
(6000,'Oncologist');

SELECT * FROM patient_treatment;
SELECT * FROM event_category;
SELECT * FROM physician_speciality;

-- write a SQL query to get the histogram of specialties of the unique physicians who have done the procedures but never did prescribe anything.--
SELECT ps.speciality, count(1) as speciality_count
FROM patient_treatment pt
JOIN event_category ec ON ec.event_name = pt.event_name
JOIN physician_speciality ps ON ps.physician_id = pt.physician_id
WHERE ec.category = 'Procedure'
AND pt.physician_id NOT IN (SELECT pt2.physician_id 
								FROM patient_treatment pt2
                                JOIN event_category ec ON ec.event_name = pt.event_name
                                WHERE ec.category IN ('Prescription'))
GROUP BY ps.speciality;                                

-- Query 9--Table name 'patient_logs'--
CREATE TABLE patient_logs (id INT, date date, patient_id INT);
INSERT INTO patient_logs (id, date, patient_id) VALUES
(1,'2020-01-02',100),
(1,'2020-01-27',200),
(2,'2020-01-01',300),
(2,'2020-01-21',400),
(2,'2020-01-21',300),
(2,'2020-01-01',500),
(3,'2020-01-20',400),
(1,'2020-03-04',500),
(3,'2020-01-20',450);

SELECT * FROM patient_logs;

-- Find the top 2 accounts with the maximum number of unique patients on a monthly basis.--

-- First to understand the data we need to convert the date format data into separate months--
SELECT date_format(date,'%M') as month,id, patient_id
FROM patient_logs;

SELECT month,id ,count(1) as no_of_patients
FROM (
      SELECT distinct date_format(date,'%M') as month,id, patient_id
      FROM patient_logs) pl
GROUP BY month,id;

SELECT *,
RANK () OVER (PARTITION BY month ORDER BY no_of_patients DESC, id) as rnk
FROM (
      SELECT month,id ,count(1) as no_of_patients
      FROM (
      SELECT distinct date_format(date,'%M') as month,id, patient_id
      FROM patient_logs) pl
      GROUP BY month,id ) x;
      
-- Main answer for query 9--
SELECT month,id,no_of_patients
FROM (
      SELECT *,
      RANK () OVER (PARTITION BY month ORDER BY no_of_patients DESC, id) as rnk
      FROM (
      SELECT month,id ,count(1) as no_of_patients
      FROM (
      SELECT distinct date_format(date,'%M') as month,id, patient_id
      FROM patient_logs) pl
      GROUP BY month,id ) x
     ) as top_accounts
WHERE top_accounts.rnk < 3;     
     
-- Query 10a-- Table name 'weather'--
CREATE TABLE weather_details (id INT PRIMARY KEY, city VARCHAR (50) NOT NULL, temperature INT NOT NULL, day date NOT NULL);
INSERT INTO weather_details (id, city, temperature, day) VALUES
(1,'London', -1, '2021-01-01'),
(2,'London', -2, '2021-01-02'),
(3,'London', 4, '2021-01-03'),
(4,'London', 1, '2021-01-04'),
(5,'London', -2, '2021-01-05'),
(6,'London', -5, '2021-01-06'),
(7,'London', -7, '2021-01-07'),
(8,'London', 5, '2021-01-08'),
(9,'London', -20, '2021-01-09'),
(10,'London', 20, '2021-01-10'),
(11,'London', 22, '2021-01-11'),
(12,'London', -1, '2021-01-12'),
(13,'London', -2, '2021-01-13'),
(14,'London', -2, '2021-01-14'),
(15,'London', -4, '2021-01-15'),
(16,'London', -9, '2021-01-16'),
(17,'London', 0, '2021-01-17'),
(18,'London', -10, '2021-01-18'),
(19,'London', -11, '2021-01-19'),
(20,'London', -12, '2021-01-20'),
(21,'London', -11, '2021-01-21');

SELECT * FROM weather_details;

SELECT id,city,temperature,date_format(day,'%M') as Day
FROM weather_details;

-- SQL Query to fetch “N” consecutive records where  temperature is below zero &  when the table has a primary key.--
SELECT *, id - ROW_NUMBER () OVER (ORDER BY id) AS diff
		   FROM weather_details wd
           WHERE wd.temperature < 0;

SELECT  *,
           COUNT(*) OVER ( PARTITION BY diff ORDER BY diff ) AS cnt
           FROM 
           (SELECT *, id - ROW_NUMBER () OVER (ORDER BY id) AS diff
		   FROM weather_details wd
           WHERE wd.temperature < 0) t2;

-- Query 10a Final answer--

WITH 
        t1 AS 
           ( SELECT *, id - ROW_NUMBER () OVER (ORDER BY id) AS diff
		   FROM weather_details wd
           WHERE wd.temperature < 0),
		t2 AS
           ( SELECT  *,
           COUNT(*) OVER ( PARTITION BY diff ORDER BY diff ) AS cnt
           FROM t1 )
SELECT id, city, temperature, day,cnt
FROM t2
WHERE t2.cnt = 5;           

-- Query 10b Table name 'vw_waeather' --
CREATE VIEW vw_weather AS SELECT city, temperature FROM weather_details;

SELECT * FROM vw_weather;

-- Finding n consecutive records where temperature is below zero. And table does not have primary key.--

-- Here we dont have id column as primary key so we need to  mention in it in with clause & rest the syntax will remain same as for 10a--

WITH 
        w AS
           ( SELECT *, ROW_NUMBER () OVER () as id
           FROM vw_weather ),
        t1 AS 
           ( SELECT *, id - ROW_NUMBER () OVER (ORDER BY id) AS diff
		   FROM weather_details wd
           WHERE wd.temperature < 0),
		t2 AS
           ( SELECT  *,
           COUNT(*) OVER ( PARTITION BY diff ORDER BY diff ) AS cnt
           FROM t1 )
SELECT id, city, temperature, day
FROM t2
WHERE t2.cnt = 5; 

-- Query 10c Table name 'orders' --
DROP TABLE orders;
CREATE TABLE orders ( order_id VARCHAR (20) PRIMARY KEY, order_date date NOT NULL);

INSERT INTO orders ( order_id, order_date ) VALUES
('ORD1001', '2021-01-01'),
('ORD1002', '2021-02-01'),
('ORD1003', '2021-02-02'),
('ORD1004', '2021-02-03'),
('ORD1005', '2021-03-01'),
('ORD1006', '2021-06-01'),
('ORD1007', '2021-12-25'),
('ORD1008', '2021-12-26');

SELECT * FROM orders;

-- Query 10c-- Finding n consecutive records with consecutive date value.--

WITH 
      t1 AS
            ( SELECT *, ROW_NUMBER () OVER (ORDER BY order_date) as rn,
             order_date - ROW_NUMBER () OVER (ORDER BY order_date)  AS diff
             FROM orders ),
	  t2 AS 
			( SELECT *, COUNT(1) OVER (PARTITION BY diff) AS cnt
              FROM t1)
SELECT order_id, order_date
FROM t2
WHERE t2.cnt = 3;              