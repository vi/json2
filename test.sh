#!/bin/sh

set -e

echo "Note: this test is endless"

while true; do
    ./random_json 10 > orig.json
    python3 ./json2 < orig.json | python3 ./2json > roundtripped.json
    ./json_compare orig.json roundtripped.json
    printf '.'
done
