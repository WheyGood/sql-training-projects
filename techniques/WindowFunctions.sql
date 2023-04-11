/* Window Functions First Exercise */

SELECT p.[FirstName]
	, p.[LastName]
	, e.[JobTitle]
	, e2.[Rate]
	, [AverageRate] = AVG(e2.[Rate]) OVER()
	, [MaximumRate] = MAX(e2.[Rate]) OVER()
	, [DiffFromAvgRate] = e2.[Rate] - AVG(e2.[Rate]) OVER()
	, [PercentOfMaxRate] = (e2.[Rate] / MAX(e2.[Rate]) OVER()) * 100
FROM [AdventureWorks2019].[Person].[Person] as p
JOIN [AdventureWorks2019].[HumanResources].[Employee] as e
ON p.[BusinessEntityID] = e.[BusinessEntityID]
JOIN [AdventureWorks2019].[HumanResources].[EmployeePayHistory] as e2
ON e.[BusinessEntityID] = e2.[BusinessEntityID]
ORDER BY e2.Rate DESC
