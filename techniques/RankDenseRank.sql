/* Rank and Dense Rank Exercise */

SELECT	p1.[Name] as Item
		, p1.[ListPrice]
		, p2.[Name] as SubCategory
		, p3.[Name] as Category
		, PriceRank = ROW_NUMBER() OVER(ORDER BY p1.[ListPrice] DESC)
		, CategoryByPriceRank = ROW_NUMBER() OVER(PARTITION BY p3.[Name] ORDER BY p1.[ListPrice] DESC)
		, CASE
			WHEN ROW_NUMBER() OVER(PARTITION BY p3.[Name] ORDER BY p1.[ListPrice] DESC) <=  5 THEN 'Yes'
			ELSE 'No'
		END AS Top5PriceInCategory
		, CategoryPriceRankWithRank = RANK() OVER(PARTITION BY p3.[Name] ORDER BY p1.[ListPrice] DESC)
		, CategoryPriceRankWithDenseRank = DENSE_RANK() OVER(PARTITION BY p3.[Name] ORDER BY p1.[ListPrice] DESC)
		, CASE
			WHEN DENSE_RANK() OVER(PARTITION BY p3.[Name] ORDER BY p1.[ListPrice] DESC) <=  5 THEN 'Yes'
			ELSE 'No'
		END AS NewTop5PriceInCategory
FROM [AdventureWorks2019].[Production].[Product] as p1
JOIN [AdventureWorks2019].[Production].[ProductSubcategory] as p2
ON p1.[ProductSubcategoryID] = p2.[ProductSubcategoryID]
JOIN [AdventureWorks2019].[Production].[ProductCategory] as p3
ON p2.[ProductCategoryID] = p3.[ProductCategoryID]