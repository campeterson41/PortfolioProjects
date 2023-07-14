-- Data Cleaning in MySQL


-- 1. Set blank cells to NULL for ease of cleaning data
UPDATE NashvilleHousing
SET UniqueID = NULL
WHERE UniqueID = '';

UPDATE NashvilleHousing
SET ParcelID = NULL
WHERE ParcelID = '';

UPDATE NashvilleHousing
SET LandUse = NULL
WHERE LandUse = '';

UPDATE NashvilleHousing
SET PropertyAddress = NULL
WHERE PropertyAddress = '';

UPDATE NashvilleHousing
SET SaleDate = NULL
WHERE SaleDate = '';

UPDATE NashvilleHousing
SET SalePrice = NULL
WHERE SalePrice = '';

UPDATE NashvilleHousing
SET LegalReference = NULL
WHERE LegalReference = '';

UPDATE NashvilleHousing
SET SoldAsVacant = NULL
WHERE SoldAsVacant = '';

UPDATE NashvilleHousing
SET OwnerName = NULL
WHERE OwnerName = '';

UPDATE NashvilleHousing
SET OwnerAddress = NULL
WHERE OwnerAddress = '';

UPDATE NashvilleHousing
SET TaxDistrict = NULL
WHERE TaxDistrict = '';

UPDATE NashvilleHousing
SET LandValue = NULL
WHERE LandValue = '';

UPDATE NashvilleHousing
SET BuildingValue = NULL
WHERE BuildingValue = '';

UPDATE NashvilleHousing
SET TotalValue = NULL
WHERE TotalValue = '';

UPDATE NashvilleHousing
SET LandUse = NULL
WHERE LandUse = '';

UPDATE NashvilleHousing
SET YearBuilt = NULL
WHERE YearBuilt = '';

UPDATE NashvilleHousing
SET Bedrooms = NULL
WHERE Bedrooms = '';

UPDATE NashvilleHousing
SET FullBath = NULL
WHERE FullBath = '';

UPDATE NashvilleHousing
SET HalfBath = NULL
WHERE HalfBath = '';


-- 2. Standardize Date Format
SELECT SaleDate, DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'), '%Y-%m-%d') AS ConvertedDate
FROM NashvilleHousing
ORDER BY ConvertedDate DESC;

UPDATE NashvilleHousing
SET SaleDate = DATE_FORMAT(STR_TO_DATE(SaleDate, '%M %d, %Y'), '%Y-%m-%d');


-- 3. Populate Property Address Data
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
FROM Nashvillehousing a
JOIN Nashvillehousing b
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;

UPDATE NashvilleHousing AS a
JOIN NashvilleHousing AS b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress IS NULL;


-- 4. Breaking up address data into individual columns
SELECT
    PropertyAddress,
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS Address,
    TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS City
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD COLUMN Address VARCHAR(255),
ADD COLUMN City VARCHAR(255);

UPDATE NashvilleHousing
SET
    Address = SUBSTRING_INDEX(PropertyAddress, ',', 1),
    City = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1));

SELECT
    OwnerAddress,
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -1), ' ', -1) AS State
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing
ADD COLUMN State VARCHAR(255);

UPDATE NashvilleHousing
SET
    State = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', -1), ' ', -1);


-- 5. Change 'Y' to 'Yes' and 'N' to 'No' for 'SoldAsVacant' column
SELECT 
    CASE SoldAsVacant
        WHEN 'Y' THEN 'Yes'
        WHEN 'N' THEN 'No'
        ELSE SoldAsVacant
    END AS SoldAsVacant_updated
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE SoldAsVacant
    WHEN 'Y' THEN 'Yes'
    WHEN 'N' THEN 'No'
    ELSE SoldAsVacant
    END;


-- 6. Removing duplicate rows
SELECT *
FROM NashvilleHousing
WHERE (ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference) IN (
    SELECT ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
    FROM NashvilleHousing
    GROUP BY ParcelID, PropertyAddress, SaleDate, SalePrice, LegalReference
    HAVING COUNT(*) > 1
);

SELECT a.*
FROM (
    SELECT a.UniqueID
    FROM NashvilleHousing a
    INNER JOIN NashvilleHousing b
        ON a.ParcelID = b.ParcelID
        AND a.PropertyAddress = b.PropertyAddress
        AND a.SaleDate = b.SaleDate
        AND a.SalePrice = b.SalePrice
        AND a.LegalReference = b.LegalReference
    WHERE a.UniqueID > b.UniqueID
    ORDER BY a.UniqueID
    LIMIT 1000
) AS deletions
JOIN NashvilleHousing a ON a.UniqueID = deletions.UniqueID;

DELETE a
FROM (
    SELECT a.UniqueID
    FROM NashvilleHousing a
    INNER JOIN NashvilleHousing b
        ON a.ParcelID = b.ParcelID
        AND a.PropertyAddress = b.PropertyAddress
        AND a.SaleDate = b.SaleDate
        AND a.SalePrice = b.SalePrice
        AND a.LegalReference = b.LegalReference
    WHERE a.UniqueID > b.UniqueID
    ORDER BY a.UniqueID
    LIMIT 1000
) AS deletions
JOIN NashvilleHousing a ON a.UniqueID = deletions.UniqueID;


-- 7. Deleting Unused Columns
ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress;
