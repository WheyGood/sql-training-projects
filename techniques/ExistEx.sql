/* Exists Example Problems */
SELECT
	 A.[PurchaseOrderID]
	,A.[OrderDate]
	,A.[SubTotal]
	,A.[TaxAmt]
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] A
WHERE EXISTS 
(
SELECT
1
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] B
WHERE B.[PurchaseOrderID] = A.[PurchaseOrderId]
AND B.[OrderQty] > 500
)
ORDER BY 1

--Problem 2
SELECT
	 A.*
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] A
WHERE EXISTS 
(
SELECT
1
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] B
WHERE B.[PurchaseOrderID] = A.[PurchaseOrderId]
AND B.[OrderQty] > 500
AND B.[UnitPrice] > 50
)
ORDER BY 1

--Problem 3
SELECT
	 A.*
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] A
WHERE NOT EXISTS 
(
SELECT
1
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderDetail] B
WHERE B.[PurchaseOrderID] = A.[PurchaseOrderId]
AND B.[RejectedQty] > 0
)
ORDER BY 1
