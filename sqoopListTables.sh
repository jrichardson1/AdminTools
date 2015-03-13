#!/bin/bash

sqoop list-tables \
  --connect jdbc:netezza://192.168.1.173/travel \
  --username sqoop \
  --password sqoop