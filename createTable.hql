-- These are my default options.

set hive.cli.print.current.db=true;

-- Set the correct working database.
use database db_name;

-- Create the tables.

CREATE TABLE IF NOT EXISTS table_name (
  string_col STRING COMMENT 'string_col comment',
  float_col FLOAT COMMENT 'float_col comment',
  array_col ARRAY<STRING> COMMENT 'array_col comment',
  map_col MAP<STRING, FLOAT> COMMENT 'Keys are ..., values are ...',
  struct_col STRUCT<a:STRING, b:INT> COMMENT 'struct_col comment'
)
COMMENT 'table description'
TBLPROPERTIES ('creator'='Jeff Richardson', 'created_at'='2015-03-02 00:00:00')
LOCATION '/user/hive/warehouse/db_name/table_name'
;



-- List database tables
show tables;

-- Show table details
describe extended formatted table_name;


