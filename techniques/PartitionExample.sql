 /* Partition Exercise */

SELECT	p1.[Name]
		, p1.[ListPrice]
		, p2.[Name]
		, p3.[Name]
		, [AvgPriceByCategory] = AVG(p1.[ListPrice]) OVER(PARTITION BY p3.[Name])
		, [AvgPriceByCategoryAndSubcategory] = AVG(p1.[ListPrice]) OVER(PARTITION BY p3.[Name], p2.[Name])
		, [ProductsVsCategoryDelta] = p1.ListPrice - AVG(p1.[ListPrice]) OVER(PARTITION BY p3.[Name])
FROM [AdventureWorks2019].[Production].[Product] as p1
JOIN [AdventureWorks2019].[Production].[ProductSubcategory] as p2
ON p1.[ProductSubcategoryID] = p2.[ProductSubcategoryID]
JOIN [AdventureWorks2019].[Production].[ProductCategory] as p3
ON p2.[ProductCategoryID] = p3.[ProductCategoryID]