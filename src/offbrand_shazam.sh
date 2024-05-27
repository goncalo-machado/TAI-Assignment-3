#!/bin/bash

ncd () {
    local cxy=$1
    local cx=$2
    local cy=$3
    local min=$((cx > cy ? cy : cx))
    local max=$((cx > cy ? cx : cy))
    local top=$((cxy - min))
    local result=$(bc <<< "scale=2;$top / $max")
    echo "$result"
}

while getopts f:c: flag
do
    case "${flag}" in
        f) freqs=${OPTARG};;
        c) compression_method=${OPTARG};;
    esac
done

echo "Freq file: $freqs";
echo "Compression method: $compression_method";

for file in database/freqs/*.freqs; do
    base_name=$(basename "$file" .freqs)
    line=$(grep -F "$base_name" database/bitsNeeded/"$compression_method".json )
    line1="${line##*: }"
    database_bits="${line1%,*}"
    # echo " "
    # echo "$base_name"
    # echo "$line"
    # echo "$database_bits"
    # echo " "


done

# temp="$(ncd 4 3 2)"
# echo $temp
