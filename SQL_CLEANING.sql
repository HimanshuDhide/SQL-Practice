use Portfolio_project

select * from nashville_housing_data

select SaleDate, Convert(Date,SaleDate) 
from nashville_housing_data

select *
from nashville_housing_data where PropertyAddress is null

select *
from nashville_housing_data order by ParcelID

select a.ParcelId,a.PropertyAddress, b.ParcelId,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashville_housing_data a join nashville_housing_data b
on a.ParcelID = b.ParcelId AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

update a
set  PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashville_housing_data a join nashville_housing_data b
on a.ParcelID = b.ParcelId AND a.UniqueID <> b.UniqueID

select propertyaddress from nashville_housing_data where PropertyAddress is null

select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyAddress) -1) as Address,
SUBSTRING(propertyaddress,CHARINDEX(',', propertyAddress) + 1, len(propertyAddress)) as city
from nashville_housing_data


Alter table nashville_housing_data
Add Address nvarchar(255);

Update nashville_housing_data
set Address = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyAddress) -1)

alter table nashville_housing_data
add City nvarchar(100);

update nashville_housing_data
set City= SUBSTRING(propertyaddress,CHARINDEX(',', propertyAddress) + 1, len(propertyAddress))

select address,city from nashville_housing_data

select 
PARSENAME (Replace(OwnerAddress,',','.'),3) as owneraddress,
PARSENAME (Replace(OwnerAddress,',','.'),2) as ownercity,
PARSENAME (Replace(OwnerAddress,',','.'),1) as ownerstate
from nashville_housing_data

alter table nashville_housing_data
add owneraddress_new nvarchar(255);

alter table nashville_housing_data
add ownercity nvarchar(100);

alter table  nashville_housing_data
add ownerstate nvarchar(100);

update nashville_housing_data
set OwnerAddress_new = PARSENAME (Replace(OwnerAddress,',','.'),3)

update nashville_housing_data
set Ownercity = PARSENAME (Replace(OwnerAddress,',','.'),2)

update nashville_housing_data
set Ownerstate = PARSENAME (Replace(OwnerAddress,',','.'),1)

select owneraddress_new, ownercity, ownerstate 
from nashville_housing_data

select distinct(SoldAsVacant), count(soldAsvacant)
from nashville_housing_data
group by SoldAsVacant
order by 2

Select SoldAsVacant,
CASE when SoldAsVacant = '0' Then 'No'
     when SoldAsVacant = '1' Then 'Yes'
END
from nashville_housing_data


ALTER TABLE nashville_housing_data
ALTER COLUMN SoldAsVacant VARCHAR(5);

UPDATE nashville_housing_data
SET SoldAsVacant = 
    CASE 
        WHEN SoldAsVacant = '1' THEN 'Yes'
        WHEN SoldAsVacant = '0' THEN 'No'
        ELSE SoldAsVacant
    END;

select soldasvacant, count(soldasvacant)
from nashville_housing_data
group by SoldAsVacant
order by 2 


select