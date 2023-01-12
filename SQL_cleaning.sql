/* Cleaning Data with SQL Project */
--Clean Nashville Housing Data Sale and House Data

--Query and Check the Data Source
SELECT * 
FROM NashvilleHouseData..Nashville;

--Fix the Sale date
UPDATE NashvilleHouseData..Nashville
SET [SaleDate] = CONVERT(Date, SaleDate)

--Populate Property Address if NULL
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHouseData..Nashville a JOIN NashvilleHouseData..Nashville b
ON a.ParcelID = b.ParcelID AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM NashvilleHouseData..Nashville a JOIN NashvilleHouseData..Nashville b
ON a.ParcelID = b.ParcelID AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL


--Remove comma from Property Address and split the column into two (split the string before and after comma)
SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) AS Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress)) AS Address2
FROM NashvilleHouseData..Nashville

ALTER TABLE NashvilleHouseData..Nashville
ADD PropertySplitAddress Nvarchar(255);

UPDATE NashvilleHouseData..Nashville
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE NashvilleHouseData..Nashville
ADD PropertySplitCity Nvarchar(255);

UPDATE NashvilleHouseData..Nashville
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(PropertyAddress))


--Fix the Owner Address (Split the string into three parts)
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM NashvilleHouseData..Nashville

ALTER TABLE NashvilleHouseData..Nashville
ADD OwnerSplitAddress Nvarchar(255)
ALTER TABLE NashvilleHouseData..Nashville
ADD OwnerSplitCity Nvarchar(255)
ALTER TABLE NashvilleHouseData..Nashville
ADD OwnerSplitState Nvarchar(255)

UPDATE NashvilleHouseData..Nashville
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)
UPDATE NashvilleHouseData..Nashville
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2) 
UPDATE NashvilleHouseData..Nashville
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--Convert Bit Values to 'Yes' and 'No' in the Vacant Column
SELECT DISTinct(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHouseData..Nashville
GROUP BY SoldAsVacant

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 1 THEN 'Yes' ELSE 'No' END AS SoldAsVacant
FROM NashvilleHouseData..Nashville

ALTER TABLE NashvilleHouseData..Nashville ALTER COLUMN SoldAsVacant Nvarchar(255);

UPDATE NashvilleHouseData..Nashville
SET SoldAsVacant = CASE WHEN SoldAsVacant = 1 THEN 'Yes' ELSE 'No' END


--Remove Duplicates (Not always advised)
WITH RowNumCTE AS (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference ORDER BY UniqueID) row_num
		--FROM NashvilleHouseData..Nashville
		--ORDER BY ParcelID
	FROM NashvilleHouseData..Nashville
)
DELETE
FROM RowNumCTE
WHERE row_num > 1


--Delete Unused Columns (NEVER TO RAW DATA, use a View)
SELECT * 
FROM NashvilleHouseData..Nashville
 
ALTER TABLE NashvilleHouseData..Nashville
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress