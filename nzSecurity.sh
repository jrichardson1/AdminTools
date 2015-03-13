#!/bin/bash
# nzSecurity.sh

export NZ_USER=admin
export NZ_PASSWORD=password
export NZ_DATABASE=system

nzsql -c "create group hadoop allow cross join true"
nzsql -c "create user sqoop with password 'sqoop' in group hadoop"

grant database, external table to group hadoop;
grant table, temp table to group hadoop;
grant view to group hadoop;
