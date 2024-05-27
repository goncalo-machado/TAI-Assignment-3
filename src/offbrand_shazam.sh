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

test_base_name=$(basename "$freqs" .freqs)

for file in database/freqs/*.freqs; do
    database_base_name=$(basename "$file" .freqs)
    line=$(grep -F "$database_base_name" database/bitsNeeded/"$compression_method".json )
    line1="${line##*: }"
    database_bits="${line1%,*}"


    line=$(grep -F "$test_base_name" Samples/bitsNeeded/"$compression_method".json )
    line1="${line##*: }"
    test_bits="${line1%,*}"
    # echo " "
    # echo "$database_base_name"
    # echo "Test bits - $test_bits"
    # echo "Database bits - $database_bits"
    # echo " "

    #TODO: Append two freq files, compress with chosen method, get bits, remove file, calculate ncd, add to associative array with name of database song and ncd score, show top 5 scores.

done

# temp="$(ncd 4 3 2)"
# echo $temp
