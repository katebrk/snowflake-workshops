-- 1
-- Create table 
create or replace table garden_plants.veggies.vegetable_details_soil_type
( plant_name varchar(25)
 ,soil_type number(1,0)
);

-- Create a file format 
create file format garden_plants.veggies.PIPECOLSEP_ONEHEADROW 
    type = 'CSV'--csv is used for any flat file (tsv, pipe-separated, etc)
    field_delimiter = '|' --pipes as column separators
    skip_header = 1 --one header row to skip
    ;

-- Load data from stage
copy into vegetable_details_soil_type
from @util_db.public.my_internal_stage
files = ( 'VEG_NAME_TO_SOIL_TYPE_PIPE.txt')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.PIPECOLSEP_ONEHEADROW );

-- 2
-- Create another file format
create file format garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW 
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = ',' --commas as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' --this means that some values will be wrapped in double-quotes bc they have commas in them
    ;

-- Explore the data in the file 
--The data in the file, with no FILE FORMAT specified
select $1
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv;

--Same file but with one of the file formats we created earlier  
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW);

--Same file but with the other file format we created earlier
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.PIPECOLSEP_ONEHEADROW );

-- Create file format that uses tabs as separators
create or replace file format garden_plants.veggies.L9_CHALLENGE_FF 
    TYPE = 'CSV'--csv for comma separated files
    FIELD_DELIMITER = '\t' --commas as column separators
    SKIP_HEADER = 1 --one header row  
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' --this means that some values will be wrapped in double-quotes bc they have commas in them
    ;

-- See the data in format 
select $1, $2, $3
from @util_db.public.my_internal_stage/LU_SOIL_TYPE.tsv
(file_format => garden_plants.veggies.L9_CHALLENGE_FF);

-- Create new table
create or replace table GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE(
SOIL_TYPE_ID number,	
SOIL_TYPE varchar(15),
SOIL_DESCRIPTION varchar(75)
 );

 -- Load data from stage
copy into GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE
from @util_db.public.my_internal_stage
files = ( 'LU_SOIL_TYPE.tsv')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.L9_CHALLENGE_FF );

-- Check how it's loaded
select *
from GARDEN_PLANTS.VEGGIES.LU_SOIL_TYPE;

-- 3
-- Load new table into stage 
-- Create new table
create or replace table GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT(
plant_name varchar(75),	
UOM varchar(1),
Low_End_of_Range number,
High_End_of_Range number
 );

 --The data in the file, with no FILE FORMAT specified
select $1,$2,$3,$4
from @util_db.public.my_internal_stage/veg_plant_height.csv;

-- another file format 
select $1,$2,$3,$4
from @util_db.public.my_internal_stage/veg_plant_height.csv
(file_format => garden_plants.veggies.COMMASEP_DBLQUOT_ONEHEADROW );

 -- Load data from stage using file format 
copy into GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT
from @util_db.public.my_internal_stage
files = ( 'veg_plant_height.csv')
file_format = ( format_name=GARDEN_PLANTS.VEGGIES.COMMASEP_DBLQUOT_ONEHEADROW );

-- Check loaded table
select *
from GARDEN_PLANTS.VEGGIES.VEGETABLE_DETAILS_PLANT_HEIGHT;