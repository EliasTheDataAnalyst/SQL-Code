--ONLY USE UNION ON TABLES WITH THE SAME COLUMNS TO GET A CLEAN OUTPUT NOT WHAT YOU SEE BELOW

SELECT EMPLOYEEID, FIRSTNAME, AGE
FROM SQLTutorial.dbo.EMPLOYEEDemographics
UNION
SELECT EMPLOYEEID, JOBTITLE, SALARY
FROM SQLTUTORIAL.DBO.EMPLOYEESALARY
ORDER BY EMPLOYEEID