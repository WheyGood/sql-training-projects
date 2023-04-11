/* Intro to Subqueries Examples */

SELECT  
		[PurchaseOrderID]
		, [VendorID]
		, [OrderDate]
		, [TaxAmt]
		, [Freight]
		, [TotalDue]
		--, ProductRank
		, DuplicatesAllowed
FROM 
(
	SELECT
		[PurchaseOrderID]
		, [VendorID]
		, [OrderDate]
		, [TaxAmt]
		, [Freight]
		, [TotalDue]
		--, ProductRank = ROW_NUMBER() OVER(PARTITION BY [VendorID] ORDER BY [TotalDue] DESC)
		, DuplicatesAllowed = DENSE_RANK() OVER(PARTITION BY [VendorID] ORDER BY [TotalDue] DESC)
	FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] 
) S
WHERE S.[DuplicatesAllowed] <= 3