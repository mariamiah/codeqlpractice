#!/bin/bash

# Define a default output file if GITHUB_OUTPUT is not set
OUTPUT_FILE=${GITHUB_OUTPUT:-output.txt}

# Start the marker
echo "BUILD-CONFIG<<EOF" >> $OUTPUT_FILE

# Generate the JSON structure and escape double quotes
echo '["foo", "bar"]' | jq -c 'map({"project": ., "config": (if . == "foo" then "Debug" else "Release" end)}) | {"include": .}' | sed 's/"/\\"/g' >> $OUTPUT_FILE

# End the marker
echo "EOF" >> $OUTPUT_FILE