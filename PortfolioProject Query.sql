/*
Cleaning Data in SQL Queries
*/


Select *
From PortfolioProject.dbo.NashvileHousing


--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvileHousing


Update NashvileHousing

SET SaleDate = CONVERT(Date,SaleDate)

-- If it doesn't Update properly

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvileHousing

SET SaleDateConverted = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From PortfolioProject.dbo.NashvileHousing

--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvileHousing
 a
JOIN PortfolioProject.dbo.NashvileHousing
 b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvileHousing
 a
JOIN PortfolioProject.dbo.NashvileHousing
 b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvileHousing

--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.NashvileHousing



ALTER TABLE NashvileHousing

Add PropertySplitAddress Nvarchar(255);

Update NashvileHousing

SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvileHousing

SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From PortfolioProject.dbo.NashvileHousing






Select OwnerAddress
From PortfolioProject.dbo.NashvileHousing



Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvileHousing




ALTER TABLE NashvileHousing

Add OwnerSplitAddress Nvarchar(255);

Update NashvileHousing

SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvileHousing

Add OwnerSplitCity Nvarchar(255);

Update NashvileHousing

SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvileHousing

Add OwnerSplitState Nvarchar(255);

Update NashvileHousing

SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From PortfolioProject.dbo.NashvileHousing





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


select distinct (SoldAsVacant), count(SoldAsVacant)
from NashvileHousing
group by SoldAsVacant
order by count(SoldAsVacant)


select SoldAsVacant ,
case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from NashvileHousing

update NashvileHousing
set SoldAsVacant =case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

with RowNumberCTE As(
select *,
ROW_NUMBER() over(
partition by ParcelId,
			 PropertyAddress,
			 SaleDate,
			 SalePrice,
			 LegalReference
			 Order by 
			 UniqueID
			 )row_num
from NashvileHousing
)


Select* from RowNumberCTE
where row_num >1


Select *
From PortfolioProject.dbo.NashvileHousing




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From PortfolioProject.dbo.NashvileHousing


ALTER TABLE PortfolioProject.dbo.NashvileHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
