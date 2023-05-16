#!/bin/bash

set -e
shopt -s globstar

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  echo "Usage: generate_dts.sh input_folder output_file"
  exit 0
fi

if [ ! -d "$1" ]; then
  echo "Error: folder \"$1\" does not exist." >&2
  exit 1
fi

output_dir=$(dirname "$2")
if [ ! -d "$output_dir" ]; then
  mkdir -p "$output_dir"
fi

node index.js $1/**/*.json > "$2"
