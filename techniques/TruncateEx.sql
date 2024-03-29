CREATE TABLE #Orders
(
	 OrderDate DATE
	,OrderMonth DATE
	,TotalDue MONEY
	,OrderRank INT
)

--INSERT SALES DATA
INSERT INTO #Orders
(
	 OrderDate
	,OrderMonth
	,TotalDue
	,OrderRank 
)
SELECT 
	 [OrderDate]
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,[TotalDue]
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]

CREATE TABLE #AvgOrdersMinusTop10
(
	 OrderMonth DATE
	,OrderType VARCHAR(32)
	,TotalDue MONEY
)

INSERT INTO #AvgOrdersMinusTop10
(
	 OrderMonth
	,OrderType
	,TotalDue
)
SELECT
	 OrderMonth
	,OrderType = 'Sales'
	,TotalDue = SUM(TotalDue)
FROM #Orders
WHERE OrderRank > 10
GROUP BY OrderMonth

--Empty out #Orders Table
TRUNCATE TABLE #Orders


--INSERT Purchase Data
INSERT INTO #Orders
(
	 OrderDate
	,OrderMonth
	,TotalDue
	,OrderRank 
)

SELECT 
	 [OrderDate]
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,[TotalDue]
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader]

INSERT INTO #AvgOrdersMinusTop10
(
	 OrderMonth
	,OrderType
	,TotalDue
)
SELECT
	 OrderMonth
	,OrderType = 'Purchase'
	,TotalDue = SUM(TotalDue)
FROM #Orders
WHERE OrderRank > 10
GROUP BY OrderMonth



SELECT
	A.OrderMonth
	,TotalSales = A.TotalDue
	,TotalPurchases = B.TotalDue

FROM #AvgOrdersMinusTop10 A
	JOIN #AvgOrdersMinusTop10 B
		ON A.OrderMonth = B.OrderMonth
WHERE A.OrderType = 'Sales'
ORDER BY 1

DROP TABLE #Orders
DROP TABLE #AvgOrdersMinusTop10
