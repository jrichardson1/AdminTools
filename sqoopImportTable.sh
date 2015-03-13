#!/bin/bash

sqoop list-databases \
  --connect jdbc:netezza://192.168.1.173/system \
  --username sqoop \
  --password sqoop 