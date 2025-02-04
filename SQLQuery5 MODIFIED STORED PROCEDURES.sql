USE [SQLTutorial]
GO
/****** Object:  StoredProcedure [dbo].[Temp_Employee]    Script Date: 5/24/2024 4:40:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


ALTER PROCEDURE [dbo].[Temp_Employee]
@JobTitle nvarchar(100)
AS
Create table #temp_Employee (
JobTitle Varchar(100),
EmployeesPerJob int ,
AvgAge int,
AvgSalary int
)

INSERT INTO #temp_employee 
SELECT JobTitle, COUNT(JobTitle), AVG(AGE), AVG(Salary)
FROM SQLTUTORIAL..EMPLOYEEDEMOGRAPHICS DEMO
JOIN SQLTUTORIAL..EMPLOYEESALARY SAL
     ON DEMO.EMPLOYEEID = SAL.EMPLOYEEID
	 WHERE JobTitle = @JobTitle
GROUP BY JobTitle

SELECT *
FROM #temp_employee