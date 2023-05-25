#!/bin/bash

# This script builds api documentation from jsonschema definitions.
# It takes as input the path to a folder containing jsonschema definitions as well as the output folder

# use bash strict mode
set -euo pipefail
IFS=$'\n\t'


# We have two inputs:
# * the folder containing the schemas
# * the output file to write the types to
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input folder> <output_folder>"
  echo "NOTE: the output folder will be deleted and recreated"
  exit 1
fi

INPUT_FOLDER=$1
echo "INPUT_FOLDER=$INPUT_FOLDER"
OUTPUT_FOLDER=$2
echo "OUTPUT_FOLDER=$OUTPUT_FOLDER"

# we'll use a temporary folder to store the output of the schema generator
# since prettier is used for formatting, and because prettier config is a bit hare-brained,
# we create the folder inside the current one
TMP_DIR=$(mktemp -p . -d)

# regardless of the result, we want to remove the temporary folder
function cleanup {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

# To generate the types, we'll build the package's Docker image and run it.
# We'll mount the temporary folder as a volume so we can access the generated types.
# We'll also mount the schemas as a volume since the Dockerfile _only_ contains the schema generator.
# To make sure we don't run into permission issues, we'll run the commands
# inside the container with the same UID and GID as the current user.

# Apparently on linux, UID is read-only, so we can't assign it.
# But on the other hand, we don't need to because it's already set for us.
# TODO: verify whether this is also true on mac.
# UID=$(id -u)
GID=$(id -g)

# now we can build the image
# we use the Dockerfile in the same folder as this script
GENERATE_SCRIPT=$(readlink -f ${BASH_SOURCE[0]})
PRIVATE_MODULES_FOLDER=$(dirname "$GENERATE_SCRIPT")
DOCKERFILE="$PRIVATE_MODULES_FOLDER/Dockerfile.docs"
docker build -t "avascribe-docs-builder" -f "$DOCKERFILE" "$PRIVATE_MODULES_FOLDER"

# need to use absolute paths for the volumes
ABS_INPUT_FOLDER=$(readlink -f "$INPUT_FOLDER")
ABS_TMP_DIR=$(readlink -f "$TMP_DIR")

# and run the container
docker run \
    --rm \
    --user "$UID:$GID" \
    --volume "$ABS_TMP_DIR:/app/build" \
    --volume "$ABS_INPUT_FOLDER/schemas:/app/schemas" \
    --volume "$ABS_INPUT_FOLDER/source:/app/source" \
    "avascribe-docs-builder"

# remove the target folder if it exists
rm -rf "$OUTPUT_FOLDER"

# make sure the parent of the output folder exists
mkdir -p "$(dirname "$OUTPUT_FOLDER")"
# we copy the generated docs to the output folder
# the trap will take care of removing the temporary folder
cp -r "$TMP_DIR" "$OUTPUT_FOLDER"
