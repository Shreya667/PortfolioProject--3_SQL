
--Cleaning Data in SQL Queries



Select *
From PortfolioProject.dbo.NashvilleHousing


-- Standardize Date Format


Select saleDateConverted, convert(Date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SaleDate = convert(Date,SaleDate)

-- If it doesn't Update properly

alter table  NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = convert(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
from PortfolioProject.dbo.NashvilleHousing
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, Isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
set PropertyAddress = Isnull (a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null






-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing

SELECT
substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 ) as Address
, substring(PropertyAddress, charindex(',', PropertyAddress) + 1 , len(PropertyAddress)) as Address

from PortfolioProject.dbo.NashvilleHousing


alter table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 )


alter table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) + 1 , len(PropertyAddress))




Select *
from PortfolioProject.dbo.NashvilleHousing





Select OwnerAddress
from PortfolioProject.dbo.NashvilleHousing


Select
parsename(replace(OwnerAddress, ',', '.') , 3)
,parsename(replace(OwnerAddress, ',', '.') , 2)
,parsename(replace(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing



alter table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
set OwnerSplitAddress = parsename(replace(OwnerAddress, ',', '.') , 3)


alter table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
set OwnerSplitCity = parsename(replace(OwnerAddress, ',', '.') , 2)



alter table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
set OwnerSplitState = parsename(replace(OwnerAddress, ',', '.') , 1)



Select *
from PortfolioProject.dbo.NashvilleHousing







-- Changing Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, case when SoldAsVacant = 'Y' then 'Yes'
	   when SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end
from PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	   When SoldAsVacant = 'N' then 'No'
	   else SoldAsVacant
	   end







-- Removing Duplicates

with RowNumCTE as(
Select *,
	row_number() over (
	Partition by ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 order by
					UniqueID
					) row_num

from PortfolioProject.dbo.NashvilleHousing

)
Select *
from RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
from PortfolioProject.dbo.NashvilleHousing



-- Deleting Unused Columns



Select *
from PortfolioProject.dbo.NashvilleHousing


alter table PortfolioProject.dbo.NashvilleHousing
drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
















