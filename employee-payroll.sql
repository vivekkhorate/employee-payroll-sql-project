

CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL
);

CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    age INT,
    gender VARCHAR(10),
    department_id INT,
    joining_date DATE,
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

CREATE TABLE Salary (
    emp_id INT,
    basic_salary DECIMAL(10,2),
    bonus DECIMAL(10,2),
    deduction DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);




INSERT INTO Department VALUES
(1,'HR'),
(2,'IT'),
(3,'Finance'),
(4,'Marketing');

INSERT INTO Employee VALUES
(101,'Amit',25,'Male',2,'2022-01-10'),
(102,'Vivek',24,'Male',1,'2023-03-15'),
(103,'Priya',26,'Female',3,'2021-07-20'),
(104,'Rahul',28,'Male',2,'2020-05-18'),
(105,'Sneha',27,'Female',4,'2022-09-12');

INSERT INTO Salary VALUES
(101,50000,5000,2000),
(102,40000,3000,1000),
(103,60000,6000,3000),
(104,70000,7000,4000),
(105,45000,3500,1500);


-- 1. View All Employees
SELECT * FROM Employee;

-- 2. Calculate Total Salary
SELECT emp_id,
       (basic_salary + bonus - deduction) AS total_salary
FROM Salary;

-- 3. Highest Salary
SELECT emp_id,
       (basic_salary + bonus - deduction) AS total_salary
FROM Salary
ORDER BY total_salary DESC
LIMIT 1;

-- 4. Second Highest Salary
SELECT MAX(total_salary) 
FROM (
    SELECT (basic_salary + bonus - deduction) AS total_salary
    FROM Salary
) AS temp
WHERE total_salary < (
    SELECT MAX(basic_salary + bonus - deduction)
    FROM Salary
);

-- 5. Department-wise Average Salary
SELECT d.department_name,
       AVG(s.basic_salary) AS avg_salary
FROM Employee e
JOIN Department d ON e.department_id = d.department_id
JOIN Salary s ON e.emp_id = s.emp_id
GROUP BY d.department_name;

-- 6. Employees Joined After 2022
SELECT * 
FROM Employee
WHERE joining_date > '2022-01-01';

-- 7. Employees with Salary Above 50,000
SELECT e.name,
       (s.basic_salary + s.bonus - s.deduction) AS total_salary
FROM Employee e
JOIN Salary s ON e.emp_id = s.emp_id
WHERE (s.basic_salary + s.bonus - s.deduction) > 50000;


-- 4. VIEW CREATION


CREATE VIEW salary_view AS
SELECT e.emp_id,
       e.name,
       d.department_name,
       (s.basic_salary + s.bonus - s.deduction) AS total_salary
FROM Employee e
JOIN Department d ON e.department_id = d.department_id
JOIN Salary s ON e.emp_id = s.emp_id;

-- View Data from View
SELECT * FROM salary_view;


-- 5. INDEX CREATION


CREATE INDEX idx_employee_name ON Employee(name);

=
-- 6. STORED PROCEDURE (MySQL)

DELIMITER //

CREATE PROCEDURE GetDepartmentSalary(IN dept_name VARCHAR(50))
BEGIN
    SELECT e.name,
           (s.basic_salary + s.bonus - s.deduction) AS total_salary
    FROM Employee e
    JOIN Department d ON e.department_id = d.department_id
    JOIN Salary s ON e.emp_id = s.emp_id
    WHERE d.department_name = dept_name;
END //

DELIMITER ;

