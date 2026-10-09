-- Create Department table
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL,
    Location VARCHAR(100) NOT NULL,
    UNIQUE(Dept_ID)
);

-- Create Project table
CREATE TABLE Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(100) NOT NULL,
    Dept_ID INT NOT NULL,
    Budget DECIMAL(12, 2) NOT NULL,
    Start_Date DATE NOT NULL,
    End_Date DATE,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID) ON DELETE CASCADE,
    UNIQUE(Project_ID)
);

-- Create Employee table
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Dept_ID INT NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Hire_Date DATE NOT NULL,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID) ON DELETE CASCADE,
    UNIQUE(Emp_ID)
);

DROP TABLE IF EXISTS Employee_Project;
CREATE TABLE Employee_Project (
    Emp_Project_ID INT PRIMARY KEY,
    Emp_ID INT NOT NULL,
    Project_ID INT NOT NULL,
    Role VARCHAR(100),
    Hours_Allocated INT,
    FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID) ON DELETE CASCADE,
    FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID) ON DELETE CASCADE,
    UNIQUE(Emp_Project_ID)
);

-- Insert Departments (5 departments)
INSERT INTO Department VALUES (1, 'HR', 'Delhi');
INSERT INTO Department VALUES (2, 'IT', 'Bangalore');
INSERT INTO Department VALUES (3, 'Sales', 'Mumbai');
INSERT INTO Department VALUES (4, 'Finance', 'Pune');
INSERT INTO Department VALUES (5, 'Operations', 'Hyderabad');

-- Insert Projects (8 projects)
INSERT INTO Project VALUES (101, 'Cloud Migration', 2, 500000, '2023-01-15', '2024-06-30');
INSERT INTO Project VALUES (102, 'CRM System', 2, 300000, '2023-03-01', '2024-12-31');
INSERT INTO Project VALUES (103, 'Sales Dashboard', 3, 150000, '2023-06-01', '2024-03-31');
INSERT INTO Project VALUES (104, 'HR Portal', 1, 200000, '2023-02-01', '2024-08-31');
INSERT INTO Project VALUES (105, 'Financial Planning Tool', 4, 250000, '2023-04-01', '2024-09-30');
INSERT INTO Project VALUES (106, 'Supply Chain Optimization', 5, 400000, '2023-05-01', '2024-12-31');
INSERT INTO Project VALUES (107, 'Mobile App', 2, 350000, '2023-07-01', '2025-01-31');
INSERT INTO Project VALUES (108, 'Data Analytics Platform', 3, 280000, '2023-08-01', '2024-11-30');

-- Insert Employees (30 employees across 5 departments)
-- HR Department (6 employees)
INSERT INTO Employee VALUES (1001, 'Rajesh Kumar', 1, 45000, '2020-01-10');
INSERT INTO Employee VALUES (1002, 'Priya Singh', 1, 50000, '2019-05-20');
INSERT INTO Employee VALUES (1003, 'Amit Verma', 1, 48000, '2021-03-15');
INSERT INTO Employee VALUES (1004, 'Neha Gupta', 1, 52000, '2020-07-10');
INSERT INTO Employee VALUES (1005, 'Vikram Patel', 1, 46000, '2021-09-05');
INSERT INTO Employee VALUES (1006, 'Anjali Sharma', 1, 49000, '2020-11-12');

-- IT Department (8 employees)
INSERT INTO Employee VALUES (2001, 'Arjun Reddy', 2, 65000, '2018-02-01');
INSERT INTO Employee VALUES (2002, 'Deepika Nair', 2, 70000, '2019-06-15');
INSERT INTO Employee VALUES (2003, 'Rohan Kumar', 2, 62000, '2020-04-20');
INSERT INTO Employee VALUES (2004, 'Ishita Desai', 2, 72000, '2018-08-10');
INSERT INTO Employee VALUES (2005, 'Aditya Singh', 2, 60000, '2021-01-25');
INSERT INTO Employee VALUES (2006, 'Kavya Menon', 2, 68000, '2019-12-05');
INSERT INTO Employee VALUES (2007, 'Suresh Kumar', 2, 55000, '2021-06-30');
INSERT INTO Employee VALUES (2008, 'Pooja Kapoor', 2, 66000, '2020-09-14');

-- Sales Department (6 employees)
INSERT INTO Employee VALUES (3001, 'Rahul Sharma', 3, 55000, '2019-03-20');
INSERT INTO Employee VALUES (3002, 'Sneha Trivedi', 3, 58000, '2020-05-10');
INSERT INTO Employee VALUES (3003, 'Bhavesh Joshi', 3, 52000, '2021-02-15');
INSERT INTO Employee VALUES (3004, 'Nisha Pant', 3, 56000, '2020-08-20');
INSERT INTO Employee VALUES (3005, 'Manish Bhat', 3, 54000, '2021-04-05');
INSERT INTO Employee VALUES (3006, 'Divya Saxena', 3, 57000, '2019-10-12');

-- Finance Department (5 employees)
INSERT INTO Employee VALUES (4001, 'Sandeep Malhotra', 4, 60000, '2017-07-15');
INSERT INTO Employee VALUES (4002, 'Ritika Arora', 4, 62000, '2019-01-20');
INSERT INTO Employee VALUES (4003, 'Varun Mishra', 4, 58000, '2020-03-10');
INSERT INTO Employee VALUES (4004, 'Preeti Choudhary', 4, 61000, '2018-11-05');
INSERT INTO Employee VALUES (4005, 'Nikhil Aggarwal', 4, 59000, '2021-05-18');

-- Operations Department (5 employees)
INSERT INTO Employee VALUES (5001, 'Sanjay Rao', 5, 50000, '2019-02-14');
INSERT INTO Employee VALUES (5002, 'Geeta Saxena', 5, 51000, '2020-06-20');
INSERT INTO Employee VALUES (5003, 'Prakash Dutta', 5, 49000, '2021-01-10');
INSERT INTO Employee VALUES (5004, 'Swati Jain', 5, 52000, '2020-09-30');
INSERT INTO Employee VALUES (5005, 'Harsh Verma', 5, 48000, '2021-08-15');

-- Insert Employee-Project Assignments
INSERT INTO Employee_Project VALUES (1, 2001, 101, 'Senior Developer', 40);
INSERT INTO Employee_Project VALUES (2, 2002, 101, 'Developer', 35);
INSERT INTO Employee_Project VALUES (3, 2003, 102, 'Developer', 40);
INSERT INTO Employee_Project VALUES (4, 2004, 102, 'Tech Lead', 40);
INSERT INTO Employee_Project VALUES (5, 2005, 107, 'Developer', 30);
INSERT INTO Employee_Project VALUES (6, 2006, 107, 'Developer', 35);
INSERT INTO Employee_Project VALUES (7, 2007, 101, 'Junior Developer', 20);
INSERT INTO Employee_Project VALUES (8, 2008, 102, 'QA Engineer', 40);
INSERT INTO Employee_Project VALUES (9, 3001, 103, 'Business Analyst', 30);
INSERT INTO Employee_Project VALUES (10, 3002, 103, 'Data Analyst', 35);
INSERT INTO Employee_Project VALUES (11, 3003, 108, 'Data Analyst', 40);
INSERT INTO Employee_Project VALUES (12, 3004, 108, 'Business Analyst', 35);
INSERT INTO Employee_Project VALUES (13, 1001, 104, 'Project Manager', 40);
INSERT INTO Employee_Project VALUES (14, 1002, 104, 'HR Specialist', 30);
INSERT INTO Employee_Project VALUES (15, 4001, 105, 'Financial Analyst', 40);
INSERT INTO Employee_Project VALUES (16, 4002, 105, 'Senior Analyst', 40);
INSERT INTO Employee_Project VALUES (17, 4003, 105, 'Analyst', 35);
INSERT INTO Employee_Project VALUES (18, 5001, 106, 'Operations Manager', 40);
INSERT INTO Employee_Project VALUES (19, 5002, 106, 'Coordinator', 35);
INSERT INTO Employee_Project VALUES (20, 5003, 106, 'Assistant', 30);

SELECT * FROM EMPLOYEE_PROJECT;


-- QUERY 1: Simple Selection - All IT Department Employees
SELECT * FROM Employee WHERE Dept_ID = 2;
-- QUERY 2: Projection - Employee Names and Salaries Only
SELECT Emp_Name, Salary FROM Employee;
-- QUERY 3: WHERE with Condition - Employees with Salary > 60000
SELECT Emp_Name, Salary, Dept_ID FROM Employee WHERE Salary > 60000;

-- QUERY 4: AGGREGATE - Total Employees in Each Department
SELECT Dept_ID, COUNT(*) AS Total_Employees FROM Employee GROUP BY Dept_ID;
-- QUERY 5: AGGREGATE with HAVING - Departments with more than 5 employees
SELECT Dept_ID, COUNT(*) AS Total_Employees FROM Employee 
GROUP BY Dept_ID 
HAVING COUNT(*) > 5;

-- QUERY 6: SUM and AVERAGE - Department-wise Salary Statistics
SELECT 
    Dept_ID, 
    COUNT(*) AS Employee_Count,
    SUM(Salary) AS Total_Salary,
    AVG(Salary) AS Average_Salary
FROM Employee
GROUP BY Dept_ID
ORDER BY Average_Salary DESC;

-- QUERY 7: CASE Expression - Salary Classification
SELECT 
    Emp_Name,
    Salary,
    CASE 
        WHEN Salary >= 70000 THEN 'High'
        WHEN Salary >= 55000 THEN 'Medium'
        ELSE 'Low'
    END AS Salary_Grade
FROM Employee
ORDER BY Salary DESC;

-- QUERY 8: JOIN with GROUP BY - Employees per Project
SELECT 
    p.Project_Name,
    COUNT(ep.Emp_ID) AS Employee_Count,
    AVG(e.Salary) AS Avg_Salary
FROM Project p
JOIN Employee_Project ep ON p.Project_ID = ep.Project_ID
JOIN Employee e ON ep.Emp_ID = e.Emp_ID
GROUP BY p.Project_ID, p.Project_Name
ORDER BY Employee_Count DESC;

-- QUERY 9: CASE with Aggregates - Salary Grade Distribution
SELECT 
    CASE 
        WHEN Salary >= 70000 THEN 'High'
        WHEN Salary >= 55000 THEN 'Medium'
        ELSE 'Low'
    END AS Salary_Grade,
    COUNT(*) AS Count,
    AVG(Salary) AS Average
FROM Employee
GROUP BY Salary_Grade;

-- QUERY 10: Complex - Department Name with Employee Info
SELECT 
    d.Dept_Name,
    e.Emp_Name,
    e.Salary,
    COUNT(ep.Project_ID) AS Projects_Assigned
FROM Department d
JOIN Employee e ON d.Dept_ID = e.Dept_ID
LEFT JOIN Employee_Project ep ON e.Emp_ID = ep.Emp_ID
GROUP BY d.Dept_ID, d.Dept_Name, e.Emp_ID, e.Emp_Name, e.Salary
ORDER BY d.Dept_Name, e.Salary DESC;

-- QUERY 11: ORDER BY Multiple Columns
SELECT 
    Emp_Name,
    Dept_ID,
    Salary,
    Hire_Date
FROM Employee
ORDER BY Dept_ID ASC, Salary DESC;

-- QUERY 12: MAX and MIN - Salary Range per Department
SELECT 
    Dept_ID,
    MAX(Salary) AS Highest_Salary,
    MIN(Salary) AS Lowest_Salary,
    MAX(Salary) - MIN(Salary) AS Salary_Range
FROM Employee
GROUP BY Dept_ID
ORDER BY Salary_Range DESC;

-- QUERY 13: HAVING with Multiple Conditions
SELECT 
    Dept_ID,
    COUNT(*) AS Employee_Count,
    AVG(Salary) AS Avg_Salary
FROM Employee
GROUP BY Dept_ID
HAVING COUNT(*) >= 5 AND AVG(Salary) > 55000
ORDER BY Avg_Salary DESC;

-- QUERY 14: Project Assignment with Hours Analysis
SELECT 
    p.Project_Name,
    COUNT(DISTINCT ep.Emp_ID) AS Total_Employees,
    SUM(ep.Hours_Allocated) AS Total_Hours,
    AVG(ep.Hours_Allocated) AS Avg_Hours_Per_Employee
FROM Project p
JOIN Employee_Project ep ON p.Project_ID = ep.Project_ID
GROUP BY p.Project_ID, p.Project_Name
ORDER BY Total_Hours DESC;

-- QUERY 15: Employee Details with Department and Project Count
SELECT 
    e.Emp_Name,
    d.Dept_Name,
    e.Salary,
    CASE 
        WHEN Salary >= 70000 THEN 'Senior'
        WHEN Salary >= 55000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS Level,
    COUNT(ep.Project_ID) AS Projects
FROM Employee e
JOIN Department d ON e.Dept_ID = d.Dept_ID
LEFT JOIN Employee_Project ep ON e.Emp_ID = ep.Emp_ID
GROUP BY e.Emp_ID, e.Emp_Name, d.Dept_Name, e.Salary
ORDER BY e.Salary DESC;