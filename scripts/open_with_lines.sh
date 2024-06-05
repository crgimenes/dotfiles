#!/bin/bash

file_path="$1"
line_number=""

if [[ "$1" == *:* ]]; then
  IFS=':' read -r file_path line_number <<< "$1"
fi

if [ -n "$line_number" ]; then
  $EDITOR "$file_path" +"$line_number"
  exit
fi

$EDITOR "$file_path"

