SELECT 
	[PurchaseOrderID]
	, [VendorID]
	, [OrderDate]
	, [TotalDue]
	, NonRejectedItems = 
	(
		SELECT COUNT(*) 
		FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] AS B
		WHERE B.[PurchaseOrderID] = A.[PurchaseOrderID]
		AND B.[RejectedQty] = 0
	)
	, MostExpensiveItem = 
	(
		SELECT MAX(C.[UnitPrice])
		FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] AS C
		WHERE C.[PurchaseOrderID] = A.[PurchaseOrderID]
	)
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] AS A
 		