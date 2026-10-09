-- VIEW 1: Department Salary Summary
CREATE VIEW Department_Salary_Summary AS
SELECT 
    d.Dept_ID,
    d.Dept_Name,
    COUNT(e.Emp_ID) AS Employee_Count,
    SUM(e.Salary) AS Total_Salary,
    AVG(e.Salary) AS Avg_Salary,
    MIN(e.Salary) AS Min_Salary,
    MAX(e.Salary) AS Max_Salary
FROM Department d
LEFT JOIN Employee e ON d.Dept_ID = e.Dept_ID
GROUP BY d.Dept_ID, d.Dept_Name;

-- VIEW 2: Employee Hierarchy View
CREATE VIEW Employee_Hierarchy AS
SELECT 
    e.Emp_ID,
    e.Emp_Name,
    e.Salary,
    d.Dept_Name,
    COUNT(ep.Project_ID) AS Projects_Assigned,
    CASE 
        WHEN e.Salary >= 70000 THEN 'Senior'
        WHEN e.Salary >= 55000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS Level
FROM Employee e
JOIN Department d ON e.Dept_ID = d.Dept_ID
LEFT JOIN Employee_Project ep ON e.Emp_ID = ep.Emp_ID
GROUP BY e.Emp_ID, e.Emp_Name, e.Salary, d.Dept_Name;

-- VIEW 3: Project Assignment View
CREATE VIEW Project_Assignment AS
SELECT 
    p.Project_ID,
    p.Project_Name,
    COUNT(DISTINCT ep.Emp_ID) AS Total_Employees,
    SUM(ep.Hours_Allocated) AS Total_Hours,
    AVG(ep.Hours_Allocated) AS Avg_Hours,
    p.Budget,
    d.Dept_Name
FROM Project p
LEFT JOIN Employee_Project ep ON p.Project_ID = ep.Project_ID
LEFT JOIN Department d ON p.Dept_ID = d.Dept_ID
GROUP BY p.Project_ID, p.Project_Name, p.Budget, d.Dept_Name;

-- VIEW 4: High Earners View
CREATE VIEW High_Earners AS
SELECT 
    e.Emp_ID,
    e.Emp_Name,
    e.Salary,
    d.Dept_Name,
    (SELECT AVG(Salary) FROM Employee WHERE Dept_ID = e.Dept_ID) AS Dept_Avg_Salary,
    e.Salary - (SELECT AVG(Salary) FROM Employee WHERE Dept_ID = e.Dept_ID) AS Salary_Above_Avg
FROM Employee e
JOIN Department d ON e.Dept_ID = d.Dept_ID
WHERE e.Salary > (SELECT AVG(Salary) FROM Employee WHERE Dept_ID = e.Dept_ID);



-- Query views
SELECT * FROM Department_Salary_Summary ORDER BY Avg_Salary DESC;

SELECT * FROM Employee_Hierarchy ORDER BY Level DESC, Salary DESC;

SELECT * FROM Project_Assignment ORDER BY Total_Employees DESC;

SELECT * FROM High_Earners ORDER BY Salary DESC;

ALTER TABLE Employee ADD COLUMN Manager_ID INT;

-- Update sample manager assignments
UPDATE Employee SET Manager_ID = 2001 WHERE Emp_ID IN (2003, 2005, 2007);
UPDATE Employee SET Manager_ID = 2002 WHERE Emp_ID IN (2004, 2006, 2008);
UPDATE Employee SET Manager_ID = 1001 WHERE Emp_ID IN (1002, 1003, 1004);
UPDATE Employee SET Manager_ID = 3001 WHERE Emp_ID IN (3002, 3004, 3006);
UPDATE Employee SET Manager_ID = 4001 WHERE Emp_ID IN (4002, 4003, 4004);
UPDATE Employee SET Manager_ID = 5001 WHERE Emp_ID IN (5002, 5003, 5004);


-- RECURSIVE CTE 1: Employee Reporting Hierarchy
WITH RECURSIVE Employee_Chain AS (
    SELECT 
        Emp_ID,
        Emp_Name,
        Manager_ID,
        Salary,
        1 AS Level
    FROM Employee
    WHERE Manager_ID IS NULL
    
    UNION ALL
    
    SELECT 
        e.Emp_ID,
        e.Emp_Name,
        e.Manager_ID,
        e.Salary,
        ec.Level + 1
    FROM Employee e
    INNER JOIN Employee_Chain ec ON e.Manager_ID = ec.Emp_ID
)
SELECT 
    REPEAT('  ', Level - 1) AS Hierarchy,
    Emp_Name,
    Salary,
    Level
FROM Employee_Chain
ORDER BY Level, Emp_Name;

-- RECURSIVE CTE 2: Display reporting chain with path
WITH RECURSIVE Report_Path AS (
    SELECT 
        Emp_ID,
        Emp_Name,
        Manager_ID,
        CAST(Emp_Name AS CHAR(500)) AS Report_Chain,
        1 AS Depth
    FROM Employee
    WHERE Manager_ID IS NULL
    
    UNION ALL
    
    SELECT 
        e.Emp_ID,
        e.Emp_Name,
        e.Manager_ID,
        CONCAT(rp.Report_Chain, ' -> ', e.Emp_Name),
        rp.Depth + 1
    FROM Employee e
    INNER JOIN Report_Path rp ON e.Manager_ID = rp.Emp_ID
    WHERE rp.Depth < 10
)
SELECT 
    Emp_ID,
    Emp_Name,
    Report_Chain,
    Depth
FROM Report_Path
ORDER BY Depth, Report_Chain;

-- RECURSIVE CTE 3: Direct and indirect reports count
WITH RECURSIVE Team_Structure AS (
    SELECT 
        Emp_ID,
        Emp_Name,
        Manager_ID,
        1 AS Direct_Reports
    FROM Employee
    WHERE Manager_ID IS NOT NULL
    
    UNION ALL
    
    SELECT 
        e.Emp_ID,
        e.Emp_Name,
        e.Manager_ID,
        ts.Direct_Reports + 1
    FROM Employee e
    INNER JOIN Team_Structure ts ON e.Manager_ID = ts.Emp_ID
)
SELECT 
    Emp_ID,
    Emp_Name,
    COUNT(DISTINCT Manager_ID) AS Report_Levels
FROM Team_Structure
GROUP BY Emp_ID, Emp_Name
ORDER BY Report_Levels DESC;



-- Test UPDATE through view (may fail depending on view structure)
UPDATE Department_Salary_Summary SET Avg_Salary = 60000 WHERE Dept_ID = 1;

-- Test DELETE through view (may fail)
DELETE FROM Employee_Hierarchy WHERE Emp_ID = 1001;

-- View updatability depends on: single table, no aggregates, no JOINs
-- These views have aggregates/JOINs, so they are READ-ONLYa