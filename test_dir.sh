#!/bin/bash

set -e

echo "Note: this test is endless"

D="$(mktemp -d)"

trap "rm -Rf \"$D\"" EXIT

FS=$(df "$D" | tail -n -1 | cut -d' ' -f 1)

if [ "$FS" != "tmpfs" ]; then
    echo "Note: Usage of tmpfs is recommended for this test (and for json2dir actuallly)"
    echo "You can set TMPDIR to some tmpfs location"
fi

while true; do
    rm -Rf "$D"
    ./random_json 6 > orig.json
    ./json2dir orig.json "$D"
    ./dir2json "$D" roundtripped.json
    ./json_compare orig.json roundtripped.json
    printf '.'
done
