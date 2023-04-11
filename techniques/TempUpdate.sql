CREATE TABLE #SalesOrders
(
	 SalesOrderID INT
	,OrderDate DATE
	,TaxAmt MONEY
	,Freight MONEY
	,TotalDue MONEY
	,TaxFreightPercent FLOAT
	,TaxFreightBucket VARCHAR(32)
	,OrderAmtBucket VARCHAR(32)
	,OrderCategory VARCHAR(32)
	,OrderSubcategory VARCHAR(32)
)

INSERT INTO #SalesOrders
(
	 SalesOrderID
	,OrderDate
	,TaxAmt 
	,Freight 
	,TotalDue 
	,OrderCategory
)

SELECT 
	SalesOrderID
	,OrderDate
	,TaxAmt 
	,Freight 
	,TotalDue 
	,OrderCategory = 'Non-Holiday Order'
FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]
WHERE YEAR(OrderDate) = 2013


UPDATE #SalesOrders
SET
TaxFreightPercent = (TaxAmt + Freight) / TotalDue,
OrderAmtBucket = 
	CASE
		WHEN TaxFreightPercent < 0.1 THEN 'Small'
		WHEN TaxFreightPercent < 0.2 THEN 'Medium'
		ELSE 'Large'
	END

UPDATE #SalesOrders
SET TaxFreightBucket =
	CASE
		WHEN TaxFreightPercent < 0.1 THEN 'Small'
		WHEN TaxFreightPercent < 0.2 THEN 'Medium'
		ELSE 'Large'
	END


UPDATE #SalesOrders
SET OrderCategory = 'Holiday'
FROM #SalesOrders
WHERE DATEPART(QUARTER, OrderDate) = 4



UPDATE #SalesOrders
SET OrderSubcategory = OrderCategory + ' - ' + OrderAmtBucket

SELECT * FROM #SalesOrders
DROP TABLE #SalesOrders