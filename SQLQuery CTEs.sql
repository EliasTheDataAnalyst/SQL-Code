/*
TOPIC: CTEs
*/

WITH CTE_EMPLOYEE AS (
SELECT FIRSTNAME, LASTNAME, GENDER, SALARY
, COUNT(GENDER) OVER (PARTITION  BY GENDER) TOTALGENDER
, AVG(SALARY) OVER (PARTITION BY GENDER) AVGSALARY
FROM SQLTUTORIAL..EMPLOYEEDEMOGRAPHICS DEMO
JOIN SQLTUTORIAL..EMPLOYEESALARY SAL
ON DEMO.EMPLOYEEID = SAL.EMPLOYEEID
WHERE SALARY > '45000'
)
SELECT *
FROM CTE_EMPLOYEE