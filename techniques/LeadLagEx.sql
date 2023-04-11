 /* Lead and Lag Exercises */

SELECT  p1.[PurchaseOrderID]
      , p1.[OrderDate]
      , p1.[TotalDue]
	  , v1.[Name] as VendorName
	  , p1.[VendorID]
	  , PrevOrderFromVendorAmt = LAG(p1.[TotalDue],1) OVER(PARTITION BY p1.[VendorID] ORDER BY p1.[OrderDate])
	  , p1.[EmployeeID]
	  , NextOrderByEmployeeVendor = LEAD(v1.[Name],1) OVER(PARTITION BY p1.[EmployeeID] ORDER BY p1.[OrderDate])
	  , Next2OrderByEmployeeVendor = LEAD(v1.[Name],2) OVER(PARTITION BY p1.[EmployeeID] ORDER BY p1.[OrderDate])
  FROM [AdventureWorks2019].[Purchasing].[PurchaseOrderHeader] as p1
  JOIN [AdventureWorks2019].[Purchasing].[Vendor] as v1
  ON p1.[VendorID] = v1.[BusinessEntityID]
  WHERE YEAR(p1.[OrderDate]) >= 2013 AND p1.[TotalDue] > 500

  ORDER BY p1.[VendorID], p1.[OrderDate]