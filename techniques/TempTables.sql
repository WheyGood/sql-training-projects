SELECT 
	 [OrderDate]
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,[TotalDue]
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
INTO #Sales
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]


SELECT
	OrderMonth
	,TotalSales = SUM([TotalDue])
INTO #AvgSalesMinus10
FROM #Sales
WHERE OrderRank > 10
GROUP BY OrderMonth


SELECT 
	[OrderDate]
	, OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	, [TotalDue]
	, OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
INTO #Purchases
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader]


SELECT
	OrderMonth
	, TotalPurchases = SUM(TotalDue)
INTO #AvgPurchasesMinus10
FROM #Purchases
	WHERE OrderRank > 10
	GROUP BY OrderMonth


SELECT
	A.OrderMonth
	, A.TotalSales
	, B.TotalPurchases
	, Rev = A.TotalSales - B.TotalPurchases
FROM #AvgSalesMinus10 A
	JOIN #AvgPurchasesMinus10 B
		ON A.OrderMonth = b.OrderMonth
ORDER BY 1

DROP TABLE #Sales
DROP TABLE #AvgSalesMinus10
DROP TABLE #AvgPurchasesMinus10
DROP TABLE #Purchases 