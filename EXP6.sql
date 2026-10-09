-- Create audit log table
CREATE TABLE Employee_Audit (
    Audit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Emp_ID INT NOT NULL,
    Action VARCHAR(50),
    Old_Salary DECIMAL(10, 2),
    New_Salary DECIMAL(10, 2),
    Old_Dept_ID INT,
    New_Dept_ID INT,
    Changed_On TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stored procedure: Transfer employee
DELIMITER //
CREATE PROCEDURE transfer_employee(IN p_emp_id INT, IN p_new_dept_id INT)
BEGIN
    DECLARE emp_exists INT DEFAULT 0;
    DECLARE dept_exists INT DEFAULT 0;
    
    SELECT COUNT(*) INTO emp_exists FROM Employee WHERE Emp_ID = p_emp_id;
    SELECT COUNT(*) INTO dept_exists FROM Department WHERE Dept_ID = p_new_dept_id;
    
    IF emp_exists = 0 THEN
        SELECT 'Error: Employee does not exist' AS Result;
    ELSEIF dept_exists = 0 THEN
        SELECT 'Error: Department does not exist' AS Result;
    ELSE
        UPDATE Employee SET Dept_ID = p_new_dept_id WHERE Emp_ID = p_emp_id;
        SELECT 'Employee transferred successfully' AS Result;
    END IF;
END //
DELIMITER ;

-- Trigger: Salary validation on update
DELIMITER //
CREATE TRIGGER salary_validation BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary < 40000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be less than 40000';
    END IF;
    IF NEW.Salary > 150000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot exceed 150000';
    END IF;
END //
DELIMITER ;

-- Trigger: Audit logging
DELIMITER //
CREATE TRIGGER audit_employee_changes AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO Employee_Audit (Emp_ID, Action, Old_Salary, New_Salary, Old_Dept_ID, New_Dept_ID)
    VALUES (NEW.Emp_ID, 'UPDATE', OLD.Salary, NEW.Salary, OLD.Dept_ID, NEW.Dept_ID);
END //
DELIMITER ;

-- TEST QUERIES

-- Test 1: Valid transfer
CALL transfer_employee(1001, 2);

-- Test 2: Invalid employee
CALL transfer_employee(9999, 2);

-- Test 3: Invalid department
CALL transfer_employee(1001, 99);

-- Test 4: Valid salary update
UPDATE Employee SET Salary = 75000 WHERE Emp_ID = 2001;

-- Test 5: Invalid salary (below minimum) - will fail
UPDATE Employee SET Salary = 30000 WHERE Emp_ID = 2001;

-- Test 6: Invalid salary (above maximum) - will fail
UPDATE Employee SET Salary = 200000 WHERE Emp_ID = 2001;

-- Test 7: Check audit log
SELECT * FROM Employee_Audit ORDER BY Audit_ID DESC;

-- Test 8: Multiple transfers
CALL transfer_employee(1002, 3);
CALL transfer_employee(1002, 4);
CALL transfer_employee(1002, 1);

-- Test 9: View all changes for one employee
SELECT * FROM Employee_Audit WHERE Emp_ID = 1002;