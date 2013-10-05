#!/bin/sh

set -e

echo "Note: this test is endless"

while true; do
    ./random_json 10 > orig.json
    ./json2 < orig.json | ./2json > roundtripped.json
    ./json_compare orig.json roundtripped.json
    printf '.'
done
