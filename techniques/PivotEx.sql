/* Pivot Example Problems */
SELECT
*
FROM
(
SELECT 
	  [JobTitle]
	, [VacationHours]
	, [Gender]
FROM  [AdventureWorks2019].[HumanResources].[Employee]
) A

PIVOT(
AVG(VacationHours)
FOR [JobTitle] IN ([Sales Representative],[Buyer],[Janitor])
) B