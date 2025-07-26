select * 
from [SQL PROJECT1].dbo.nashvilledata

--Standardize Data Format
select Sale_date_converted,convert(date,saledate)
from [SQL PROJECT1].dbo.nashvilledata


alter table nashvilledata
add sale_Date_converted date

update nashvilledata
set sale_Date_converted = convert(date,saledate)

--populate property address data
select * 
from [SQL PROJECT1].dbo.nashvilledata
--where propertyaddress is null
order by parcelid

select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress,isnull(a.propertyaddress,b.propertyaddress)
from [SQL PROJECT1].dbo.nashvilledata a
join [SQL PROJECT1].dbo.nashvilledata b
on a.parcelid=b.parcelid
and a.[uniqueid]<>b.[uniqueid]
where a.propertyaddress is null


update a
set propertyaddress = isnull(a.propertyaddress,b.propertyaddress)
from [SQL PROJECT1].dbo.nashvilledata a
join [SQL PROJECT1].dbo.nashvilledata b
on a.parcelid=b.parcelid
and a.[uniqueid]<>b.[uniqueid]
 where a.propertyaddress is null

 --breaking out address into individual column(address,city,state)
 select propertyaddress
from [SQL PROJECT1].dbo.nashvilledata
--where propertyaddress is null
--order by parcelid
select
substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) as address,
substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress)) as address
from [SQL PROJECT1].dbo.nashvilledata

alter table nashvilledata
add Propertysplitaddress nvarchar(300);

update nashvilledata
set propertysplitaddress = substring(propertyaddress,1,CHARINDEX(',',propertyaddress)-1) 

alter table nashvilledata
add propertysplitcity nvarchar(300);

update nashvilledata
set propertysplitcity = substring(propertyaddress,CHARINDEX(',',propertyaddress)+1,len(propertyaddress))

select *
from [SQL PROJECT1].dbo.nashvilledata


select
PARSENAME (replace(owneraddress,',','.'),3) as ownersplitaddress,
PARSENAME (replace(owneraddress,',','.'),2) as ownersplitcity,
PARSENAME (replace(owneraddress,',','.'),1) as ownersplitstate
from [SQL PROJECT1].dbo.nashvilledata

alter table nashvilledata
add ownersplitaddress nvarchar(300);

update nashvilledata
set ownersplitaddress = PARSENAME (replace(owneraddress,',','.'),3) 

alter table nashvilledata
add ownersplitcity nvarchar(300);

update nashvilledata
set ownersplitcity = PARSENAME (replace(owneraddress,',','.'),2) 

alter table nashvilledata
add ownersplitstate nvarchar(300);

update nashvilledata
set ownersplitstate = PARSENAME (replace(owneraddress,',','.'),1) 



select *
from [SQL PROJECT1].dbo.nashvilledata

--change Y and N to Yes and No in "sold as vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from [SQL PROJECT1].dbo.nashvilledata
group by SoldAsVacant
order by 2

SELECT SoldAsVacant,
       CASE WHEN CAST(SoldAsVacant AS VARCHAR) = '0' THEN 'No'
           WHEN CAST(SoldAsVacant AS VARCHAR) = '1' THEN 'Yes'
          ELSE SoldAsVacant
       END 
from [SQL PROJECT1].dbo.nashvilledata

UPDATE nashvilledata
set soldasvacant = CASE WHEN CAST(SoldAsVacant AS VARCHAR) = '0' THEN 'No'
           WHEN CAST(SoldAsVacant AS VARCHAR) = '1' THEN 'Yes'
          ELSE 'Unknown'
       END AS SoldAsVacant
from [SQL PROJECT1].dbo.nashvilledata

ALTER TABLE [SQL PROJECT1].dbo.nashvilledata
ALTER COLUMN SoldAsVacant VARCHAR(10);

UPDATE [SQL PROJECT1].dbo.nashvilledata
SET SoldAsVacant = 
    CASE 
        WHEN SoldAsVacant = '0' THEN 'No'
        WHEN SoldAsVacant = '1' THEN 'Yes'
        ELSE soldasvacant 
        end;

SELECT DISTINCT SoldAsVacant, COUNT(*) 
FROM [SQL PROJECT1].dbo.nashvilledata
GROUP BY SoldAsVacant;

select *
from [SQL PROJECT1].dbo.nashvilledata



--remove duplicates
with RownumCTE AS(
select *,
row_number() over(
partition by parcelid,
              propertyaddress,
              saleprice,
              saledate,
              legalreference
              order by
              uniqueid
              )row_num
from [SQL PROJECT1].dbo.nashvilledata
--order by parcelid
)
select*
FROM RownumCTE
WHERE row_num>1
order by propertyaddress

select *
from [SQL PROJECT1].dbo.nashvilledata

--delete unused columns

select *
from [SQL PROJECT1].dbo.nashvilledata

alter table [SQL PROJECT1].dbo.nashvilledata
drop column owneraddress, taxdistrict,propertyaddress

alter table [SQL PROJECT1].dbo.nashvilledata
drop column saledate







