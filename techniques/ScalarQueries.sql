SELECT 
	[BusinessEntityID]
	, [JobTitle]
	, [VacationHours]
	, MaxVacationHours = (SELECT MAX(VacationHours) FROM [AdventureWorks2019].HumanResources.[Employee])
	, PercencentOfVacHours = (VacationHours*1.0 / (SELECT MAX(VacationHours) FROM [AdventureWorks2019].HumanResources.[Employee])) * 100.0
FROM [AdventureWorks2019].HumanResources.[Employee]
WHERE ((VacationHours*1.0 / (SELECT MAX(VacationHours) FROM [AdventureWorks2019].HumanResources.[Employee])) * 100.0) > 80.0