#!/bin/bash

# This script verifies that types defined as jsonschema are in sync with the typescript definitions
# This will be run as part of the CI process, and will fail if the types are not in sync
# We define the types as "in sync" if and only if re-generating the types results in a byte-by-byte identical file

# use bash strict mode
set -euo pipefail
IFS=$'\n\t'


# We have two inputs:
# * the folder containing the schemas
# * the output file to write the types to
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <input folder> <output_file>"
  exit 1
fi

INPUT_FOLDER=$1
OUTPUT_FILE=$2

# we'll use a temporary .d.ts file to store the output of the schema generator
# since prettier is used for formatting, and because prettier config is a bit hare-brained,
# we create the folder inside the current one
TMP_FOLDER=$(mktemp -p . -d)
TMP_FILE="$TMP_FOLDER/index.d.ts"

# regardless of the result, we want to remove the temporary folder
function cleanup {
    rm -rf "$TMP_FOLDER"
}
trap cleanup EXIT

# we call the generate-types script to generate the types
# it is located in the same folder as the verify-types script, so we can just construct the path
VERIFY_SOURCE=$(readlink -f ${BASH_SOURCE[0]})
SCRIPT_FOLDER=$(dirname "$VERIFY_SOURCE")
GENERATE_SCRIPT="$SCRIPT_FOLDER/generate-types.bash"

# we let the generate-types script do the actual work
$GENERATE_SCRIPT "$INPUT_FOLDER" "$TMP_FILE"

# Now we can compare the generated types with the existing ones.
# We use diff for that, which will exit with 0 if the files are identical and
# with 1 if they are different.
# We use colors, because IF there is a difference, we want to see it.
# We also use the -u flag to show the differences with unified context.
diff -u "$OUTPUT_FILE" "$TMP_FILE"
