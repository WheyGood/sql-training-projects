/* Flaten Data with Stuff() Example Problems */
SELECT
	SubcategoryName = A.[Name]
	, Products = 
		STUFF(
			(
				SELECT 
					';' + B.[Name]
				FROM [AdventureWorks2019].[Production].[Product] B
				WHERE A.[ProductSubcategoryID] = B.[ProductSubcategoryID]
				--AND B.[ListPrice] > 50
				FOR XML PATH('')
			),1,1,''
		)
FROM [AdventureWorks2019].[Production].[ProductSubcategory] A