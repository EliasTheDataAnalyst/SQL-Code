/*
--TOPIC:DATA CLEANING.
--USING THE FOLLOWING COMANDS - convert,Update,ISNULL,Substring,CHARINDEX,LEN,PARSENAME,REPLACE,ROWNUM AND DROP COLUMN.
*/


select *
from DataCleaning..Nashville_Housing_Data

--..................................................................................................................

--Standardize Date Format


select saledateConverted, convert(date,saledate)
from  DataCleaning..Nashville_Housing_Data


Update Nashville_Housing_Data
Set SaleDate = convert(date,saledate)


Alter Table DataCleaning..Nashville_Housing_Data
Add saledateConverted Date


Update DataCleaning..Nashville_Housing_Data 
Set SaleDateConverted = convert(date,saledate)

--..................................................................................................................

--Populate Property Address data


select  *
from  DataCleaning..Nashville_Housing_Data
--Where  PropertyAddress is Null
Order by parcelid


select  a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from DataCleaning..Nashville_Housing_Data a
Join DataCleaning..Nashville_Housing_Data b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where  a.PropertyAddress is Null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from DataCleaning..Nashville_Housing_Data a
Join SheetCleaning..Nashville_Housing_Data b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where  a.PropertyAddress is Null

--..........................................................................................................................

--Breaking Out Address Into Individuals Colunms (Address, City, State)

select  PropertyAddress
from  DataCleaning..Nashville_Housing_Data
--Where  PropertyAddress is Null
--Order by parcelid

select
Substring(PropertyAddress, 1, CHARINDEX(',', propertyAddress) -1 ) Address
, Substring(PropertyAddress, CHARINDEX(',', propertyAddress) + 1 , LEN(PropertyAddress)) Address
--,CHARINDEX(',', propertyAddress)
from  DataCleaning..Nashville_Housing_Data

--OR USE THE METHOD BELOW

Alter Table DataCleaning..Nashville_Housing_Data
Add PropertySplitAddress nvarchar(255);


Update DataCleaning..Nashville_Housing_Data 
Set PropertySplitAddress = Substring(PropertyAddress, 1, CHARINDEX(',', propertyAddress) -1 )

Alter Table DataCleaning..Nashville_Housing_Data
Add PropertySplitCity Nvarchar(255);


Update DataCleaning..Nashville_Housing_Data 
Set PropertySplitCity = Substring(PropertyAddress, CHARINDEX(',', propertyAddress) + 1 , LEN(PropertyAddress))

--WORKS THE SAME AS METHOD FROM THE ABOVE

select owneraddress
from DataCleaning..Nashville_Housing_Data

select
PARSENAME(REPLACE(Owneraddress, ',', '.') , 3)
,PARSENAME(REPLACE(Owneraddress, ',', '.') , 2)
,PARSENAME(REPLACE(Owneraddress, ',', '.') , 1)
from DataCleaning..Nashville_Housing_Data

Alter Table DataCleaning..Nashville_Housing_Data
Add OwnerSplitAddress nvarchar(255);

--OR USE THE METHOD BELOW

Update DataCleaning..Nashville_Housing_Data 
Set OwnerSplitAddress = PARSENAME(REPLACE(Owneraddress, ',', '.') , 3)

Alter Table DataCleaning..Nashville_Housing_Data
Add OwnerSplitCity Nvarchar(255);


Update DataCleaning..Nashville_Housing_Data 
Set OwnerSplitCity = PARSENAME(REPLACE(Owneraddress, ',', '.') , 2)

Alter Table DataCleaning..Nashville_Housing_Data
Add OwnerSplitState Nvarchar(255);


Update DataCleaning..Nashville_Housing_Data 
Set OwnerSplitState = PARSENAME(REPLACE(Owneraddress, ',', '.') , 1)



----.......................................................................................................................

--CHANGE Y AND NTO YES AND NO IN 'SOLD VACCANT' FLIELD


Select Distinct(soldAsvacant), Count(soldAsvacant)
from DataCleaning..Nashville_Housing_Data
group by soldAsvacant
Order by 2

Select soldAsvacant
CASE  
     When soldAsvacant 'Y' Then 'YES'
     When soldAsvacant 'N' Then 'NO'
	 ELSE soldAsvacant
	 END
from DataCleaning..Nashville_Housing_Data

Update DataCleaning..Nashville_Housing_Data
SET soldAsvacant = CASE  
     When soldAsvacant = 'Y' Then 'YES'
     When soldAsvacant =  'N' Then 'NO'
	 ELSE soldAsvacant
	 END

--......................................................................................................................

--REMOVING DUPLICATES

WITH RownumCTE AS(
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				     UniqueId
					 ) ROW_NUM

From DataCleaning..Nashville_Housing_Data
--Order By ParcelId
)
SELECT *
from RowNumCTE
Where ROW_NUM > 1
--ORDER BY PropertyAddress

--.....................................................................................................................

--DELETE UNUSED COLUMNS

ALTER TABLE DataCleaning..Nashville_Housing_Data
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE DataCleaning..Nashville_Housing_Data
DROP COLUMN SaleDate

