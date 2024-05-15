
Select * 
FROM PortofolioProject..NashvileeHousing

--Standarize Date Format 

SELECT SaleDate, CONVERT(DATE,SaleDate)
FROM PortofolioProject.dbo.NashvileeHousing

UPDATE NashvileeHousing
SET SaleDate= CONVERT(Date,SaleDate)

ALTER TABLE NashvileeHousing
ADD SaleDateConverted Date;

UPDATE NashvileeHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address data

SELECT *
FROM PortofolioProject.dbo.NashvileeHousing
--WHERE PropertyAddress is null
order by ParcelID

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortofolioProject.dbo.NashvileeHousing a
JOIN PortofolioProject.dbo.NashvileeHousing b
     on a.ParcelID= b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortofolioProject.dbo.NashvileeHousing a
JOIN PortofolioProject.dbo.NashvileeHousing b
     on a.ParcelID= b.ParcelID
	 AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null



--Breaking out Adress into individual columns (Adress,city, State)

SELECT PropertyAddress
FROM PortofolioProject.dbo.NashvileeHousing
--WHERE PropertyAdress is null
--order by  ParceID


SELECT 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress),LEN(PropertyAddress)) as Address
FROM PortofolioProject.dbo.NashvileeHousing


ALTER TABLE NashvileeHousing
ADD PropertSplitAddress nvarchar(255);

UPDATE NashvileeHousing
SET PropertSplitAddress= SUBSTRING(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvileeHousing
ADD PropertSplitCity nvarchar(255);

UPDATE NashvileeHousing
SET PropertSplitCity =SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress),LEN(PropertyAddress)) 

SELECT * FROM PortofolioProject.dbo.NashvileeHousing


SELECT OwnerAddress
FROM PortofolioProject.dbo.NashvileeHousing


SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'), 3)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 2)
,PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM PortofolioProject.dbo.NashvileeHousing


ALTER TABLE NashvileeHousing
ADD OwnerSplitAdress nvarchar(255);

UPDATE NashvileeHousing
SET OwnerSplitAdress=PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

ALTER TABLE NashvileeHousing
ADD OwnerSplitCity  nvarchar(255);

UPDATE NashvileeHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

ALTER TABLE NashvileeHousing
ADD OwnerSplitState nvarchar(255);

UPDATE NashvileeHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

SELECT * 
FROM PortofolioProject.dbo.NashvileeHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortofolioProject.dbo.NashvileeHousing
GROUP BY SoldAsVacant
ORDER BY 2


SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM PortofolioProject.dbo.NashvileeHousing


UPDATE NashvileeHousing
SET SoldAsVacant= CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END





--Remove Duplicates
WITH RowNum AS (
SELECT *,
     ROW_NUMBER() OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  Saleprice,
				  SaleDate,
				  LegalReference
				  ORDER BY 
				    UniqueID
					) row_num
FROM PortofolioProject.dbo.NashvileeHousing
--order by ParcelID
)
SELECT * 
FROM RowNum
WHERE row_num >1
ORDER BY PropertyAddress


 


 --DELETE Unused Columns

 SELECT *
 FROM PortofolioProject.dbo.NashvileeHousing


 ALTER TABLE PortofolioProject.dbo.NashvileeHousing
 DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

 ALTER TABLE PortofolioProject.dbo.NashvileeHousing
 DROP COLUMN SaleDate


