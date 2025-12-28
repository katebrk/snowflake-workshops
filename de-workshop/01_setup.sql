-- 1. DATABASE (TABLE, VIEW, STAGE) SET UP 

-- List of files in stage 
list @uni_kishore/kickoff;

-- Create new file format for json 
create file format FF_JSON_LOGS
    type = JSON
    strip_outer_array = true;

-- Show values from stage in file format 
select $1 
from @uni_kishore/kickoff
(file_format => ff_json_logs);

-- Load the File Into The Table from stage (if file name is not specified, Snowflake will attempt to load all the files in the stage (or the stage/folder location)) 
copy into ags_game_audience.raw.GAME_LOGS 
from @uni_kishore/kickoff
file_format = (format_name = FF_JSON_LOGS);

-- Separate every attribute into its own column and create a view 
create view AGS_GAME_AUDIENCE.RAW.LOGS as
    select 
        RAW_LOG:agent::text as AGENT 
        , RAW_LOG:user_event::text as USER_EVENT
        , RAW_LOG:datetime_iso8601::TIMESTAMP_NTZ as DATETIME_ISO8601    
        , RAW_LOG:user_login::text as USER_LOGIN
        , * -- the original column 
    from GAME_LOGS;

    -- see the view 
select * from AGS_GAME_AUDIENCE.RAW.LOGS;
