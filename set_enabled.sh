#!/usr/bin/env bash

enable_filepath="./enabled"

if [ "$#" -ne 1 ]; then
  echo "Usage: set_enabled.sh true|false"
  exit 1
fi

if [ $1 = true ]; then
  touch $enable_filepath
else
  rm -f $enable_filepath
fi
