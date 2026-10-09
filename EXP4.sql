-- QUERY 1: INNER JOIN - Employees and their Departments
SELECT e.Emp_Name, e.Salary, d.Dept_Name, d.Location
FROM Employee e
INNER JOIN Department d ON e.Dept_ID = d.Dept_ID
ORDER BY d.Dept_Name;

-- QUERY 2: LEFT JOIN - All Employees with Projects (if assigned)
SELECT e.Emp_Name, e.Salary, p.Project_Name, ep.Role
FROM Employee e
LEFT JOIN Employee_Project ep ON e.Emp_ID = ep.Emp_ID
LEFT JOIN Project p ON ep.Project_ID = p.Project_ID
ORDER BY e.Emp_Name;

-- QUERY 3: Self-Join - Employees in same Department
SELECT e1.Emp_Name AS Employee1, e2.Emp_Name AS Employee2, d.Dept_Name
FROM Employee e1
INNER JOIN Employee e2 ON e1.Dept_ID = e2.Dept_ID AND e1.Emp_ID < e2.Emp_ID
INNER JOIN Department d ON e1.Dept_ID = d.Dept_ID
ORDER BY d.Dept_Name, e1.Emp_Name;

-- QUERY 4: Subquery - Employees earning more than department average
SELECT e.Emp_Name, e.Salary, d.Dept_Name
FROM Employee e
JOIN Department d ON e.Dept_ID = d.Dept_ID
WHERE e.Salary > (SELECT AVG(Salary) FROM Employee WHERE Dept_ID = e.Dept_ID)
ORDER BY d.Dept_Name, e.Salary DESC;

-- QUERY 5: Correlated Subquery - Employee with highest salary in each department
SELECT e.Emp_Name, e.Salary, d.Dept_Name
FROM Employee e
JOIN Department d ON e.Dept_ID = d.Dept_ID
WHERE e.Salary = (SELECT MAX(Salary) FROM Employee WHERE Dept_ID = e.Dept_ID)
ORDER BY d.Dept_Name;

-- QUERY 6: EXISTS - Employees assigned to projects
SELECT e.Emp_Name, e.Salary
FROM Employee e
WHERE EXISTS (SELECT 1 FROM Employee_Project ep WHERE ep.Emp_ID = e.Emp_ID)
ORDER BY e.Emp_Name;

-- QUERY 7: NOT EXISTS - Employees NOT assigned to any project
SELECT e.Emp_Name, e.Salary, d.Dept_Name
FROM Employee e
JOIN Department d ON e.Dept_ID = d.Dept_ID
WHERE NOT EXISTS (SELECT 1 FROM Employee_Project ep WHERE ep.Emp_ID = e.Emp_ID)
ORDER BY e.Emp_Name;

-- QUERY 8: IN with Subquery - Employees in IT or Sales departments
SELECT e.Emp_Name, e.Salary, d.Dept_Name
FROM Employee e
JOIN Department d ON e.Dept_ID = d.Dept_ID
WHERE e.Dept_ID IN (SELECT Dept_ID FROM Department WHERE Dept_Name IN ('IT', 'Sales'))
ORDER BY d.Dept_Name;

-- QUERY 9: INTERSECT - Employees in both high salary and project assignment
SELECT e.Emp_Name FROM Employee e WHERE e.Salary > 60000
INTERSECT
SELECT e.Emp_Name FROM Employee e WHERE EXISTS (SELECT 1 FROM Employee_Project ep WHERE ep.Emp_ID = e.Emp_ID);

-- QUERY 10: EXCEPT - Employees with high salary but NOT assigned to projects
SELECT e.Emp_Name, e.Salary FROM Employee e WHERE e.Salary > 60000 
EXCEPT
SELECT e.Emp_Name, e.Salary FROM Employee e WHERE EXISTS (SELECT 1 FROM Employee_Project ep WHERE ep.Emp_ID = e.Emp_ID);

-- QUERY 11: 3-Table JOIN - Employee, Department, Project info
SELECT e.Emp_Name, d.Dept_Name, p.Project_Name, ep.Role, ep.Hours_Allocated
FROM Employee e
INNER JOIN Department d ON e.Dept_ID = d.Dept_ID
INNER JOIN Employee_Project ep ON e.Emp_ID = ep.Emp_ID
INNER JOIN Project p ON ep.Project_ID = p.Project_ID
ORDER BY d.Dept_Name, e.Emp_Name;

-- QUERY 12: LEFT JOIN with aggregation
SELECT d.Dept_Name, COUNT(e.Emp_ID) AS Employee_Count, AVG(e.Salary) AS Avg_Salary
FROM Department d
LEFT JOIN Employee e ON d.Dept_ID = e.Dept_ID
GROUP BY d.Dept_ID, d.Dept_Name
ORDER BY Employee_Count DESC;

-- QUERY 13: Subquery in FROM clause - Department salary statistics
SELECT dept_stats.Dept_Name, dept_stats.Avg_Salary, dept_stats.Max_Salary, dept_stats.Employee_Count
FROM (
    SELECT d.Dept_Name, AVG(e.Salary) AS Avg_Salary, MAX(e.Salary) AS Max_Salary, COUNT(e.Emp_ID) AS Employee_Count
    FROM Department d
    LEFT JOIN Employee e ON d.Dept_ID = e.Dept_ID
    GROUP BY d.Dept_ID, d.Dept_Name
) dept_stats
ORDER BY dept_stats.Avg_Salary DESC;

-- QUERY 14: Multiple condition JOIN - Employees and projects with budget > 300000
SELECT e.Emp_Name, p.Project_Name, p.Budget, ep.Role
FROM Employee e
INNER JOIN Employee_Project ep ON e.Emp_ID = ep.Emp_ID
INNER JOIN Project p ON ep.Project_ID = p.Project_ID
WHERE p.Budget > 300000
ORDER BY p.Budget DESC, e.Emp_Name;

-- QUERY 15: Self-Join - Pair employees from different departments with same salary range
SELECT e1.Emp_Name AS Emp1, d1.Dept_Name AS Dept1, e2.Emp_Name AS Emp2, d2.Dept_Name AS Dept2, e1.Salary
FROM Employee e1
INNER JOIN Department d1 ON e1.Dept_ID = d1.Dept_ID
INNER JOIN Employee e2 ON e1.Salary = e2.Salary AND e1.Emp_ID < e2.Emp_ID AND e1.Dept_ID != e2.Dept_ID
INNER JOIN Department d2 ON e2.Dept_ID = d2.Dept_ID
ORDER BY e1.Salary DESC;