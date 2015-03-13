#!/bin/bash

sqoop codegen \
  --connect jdbc:netezza://192.168.1.173/travel \
  --username sqoop \
  --password sqoop \
  --table cities \
  --class-name Cities
  