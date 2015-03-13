-- These are my default options.
set hive.cli.print.current.db=true;


-- List existing databases in case it already exists.
show databases;

create database if not exists db_name
location 'db_path'
comment 'db_comment'
with dbproperties ('creator' = 'Jeff Richardson', 'date' = '2015-03-02')
;

describe database extended db_name;

show databases;
