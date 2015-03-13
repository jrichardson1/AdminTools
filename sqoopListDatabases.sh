#!/bin/bash
#---------------------
# CDH version is 5.3.0
# Sqoop version is 1.4.5-cdh5.3.0
# Netezza JDBC driver version is 7.2
#---------------------
# This connect (parcel) is installed: /opt/cloudera/parcels/SQOOP_NETEZZA_CONNECTOR-1.2c5/sqoop-nz-connector-1.2c5.jar
# Configuration file is located at /etc/sqoop/conf/managers.d/connectors and in /etc/sqoop/conf/managers.d/connectors
# Netezza JDBC driver is located at /usr/lib/sqoop/lib/nzjdbc3.jar.
# NPS server can be reached via java -jar /usr/lib/sqoop/lib/nzjdbc3.jar -t -h 192.168.1.173

# What is this and why is it important?
#   /opt/cloudera/parcels/SQOOP_NETEZZA_CONNECTOR/managers.d/ccfn
# Contents:
#   com.cloudera.sqoop.manager.NetezzaManagerFactory={{ROOT}}/sqoop-nz-connector-1.2c5.jar
# This doesn't help.
#  -Dcom.cloudera.sqoop.manager.NetezzaManagerFactory=/opt/cloudera/parcels/SQOOP_NETEZZA_CONNECTOR/sqoop-nz-connector-1.2c5.jar \



# Connect to database "system" on host "192.168.1.173" and list databases
sqoop list-databases \
  --connect jdbc:netezza://192.168.1.173/system \
  --username sqoop \
  --password sqoop 
#  --verbose
  
