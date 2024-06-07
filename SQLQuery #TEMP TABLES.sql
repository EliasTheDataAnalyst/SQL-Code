/*
TOPIC: TEMP TABLES

*/


--CREATE TABLE #TEMP_EMPLOYEE2 (
--EployeeID int,
--JobTitle varchar(100),
--Salary int
--)

--select *
--from #temp_employee

--INSERT INTO #TEMP_EMPLOYEE VALUES (
--'1001', 'HR', '45000'
--)


--DELETE 
--FROM #TEMP_EMPLOYEE
--WHERE SALARY = 4500


DROP TABLE IF EXISTS #TEMP_EMPLOYEE2
CREATE TABLE #TEMP_EMPLOYEE2 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge int,
AvgSalary int
)


INSERT INTO #TEMP_EMPLOYEE2
SELECT JOBTITLE, COUNT(JOBTITLE), AVG(AGE), AVG(SALARY)
FROM SQLTUTORIAL..EMPLOYEEDEMOGRAPHICS DEMO
JOIN SQLTUTORIAL..EMPLOYEESALARY SAL
    ON DEMO.EMPLOYEEID = SAL.EMPLOYEEID
GROUP BY JOBTITLE

SELECT *
FROM #TEMP_EMPLOYEE2