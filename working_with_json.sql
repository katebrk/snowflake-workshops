-- JSON DDL Scripts
use database library_card_catalog;
use role sysadmin;

-- Create an Ingestion Table for JSON Data
create table library_card_catalog.public.author_ingest_json
(
  raw_author variant
);

-- Create File Format for JSON Data 
create or replace file format library_card_catalog.public.json_file_format
type = 'JSON' 
compression = 'AUTO' 
enable_octal = FALSE
allow_duplicate = FALSE 
strip_outer_array = TRUE --to ignore the square brackets and load each author into a separate row
strip_null_values = FALSE 
ignore_utf8_errors = FALSE; 

-- see the data using the created file format 
select $1
from @util_db.public.my_internal_stage/author_with_header.json
(file_format => library_card_catalog.public.json_file_format);

-- Copy transformed json into table 
copy into library_card_catalog.public.author_ingest_json
from @util_db.public.my_internal_stage
files = ('author_with_header.json')
file_format = ( format_name = library_card_catalog.public.json_file_format );

-- see the result
select *
from library_card_catalog.public.author_ingest_json;

-- returns AUTHOR_UID value from top-level objects attribute
select raw_author:AUTHOR_UID
from author_ingest_json;

-- returns the data in a way that makes it look like a normalized table
SELECT 
 raw_author:AUTHOR_UID
,raw_author:FIRST_NAME::STRING as FIRST_NAME
,raw_author:MIDDLE_NAME::STRING as MIDDLE_NAME
,raw_author:LAST_NAME::STRING as LAST_NAME
FROM AUTHOR_INGEST_JSON;