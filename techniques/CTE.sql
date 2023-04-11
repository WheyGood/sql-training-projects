WITH Sales AS
(
SELECT 
	 [OrderDate]
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,[TotalDue]
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]
) 

,AvgSalesMinus10 AS (
	SELECT
		OrderMonth
		,TotalSales = SUM([TotalDue])
		FROM Sales
		WHERE OrderRank > 10
		GROUP BY OrderMonth
) 

,Purchases AS (
	SELECT 
		[OrderDate]
		, OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		, [TotalDue]
		, OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader]
)

,AvgPurchasesMinus10 AS (
	SELECT
		OrderMonth
		, TotalPurchases = SUM(TotalDue)
	FROM
		Purchases
	WHERE OrderRank > 10
	GROUP BY OrderMonth
)


SELECT
	A.OrderMonth
	, A.TotalSales
	, B.TotalPurchases
	, Rev = A.TotalSales - B.TotalPurchases
FROM AvgSalesMinus10 A
	JOIN AvgPurchasesMinus10 B
		ON A.OrderMonth = b.OrderMonth
ORDER BY 1