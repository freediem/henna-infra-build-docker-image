#!/bin/bash

BASH_SOURCE="-bash"
if [[ "$0" == "$BASH_SOURCE" ]]; then
  echo "$0: Please source this file."
  echo "e.g. source ./get-setenv.sh configurations/dev.tfvars"
  return 1
fi

SOURCE_FILE='../scripts/setenv'
if [ -f $SOURCE_FILE ]; then
  status_code=true
else
  status_code=false
fi

if $status_code; then
  source $SOURCE_FILE $1
else
  echo "ERROR: Not able to access setenv"
fi
