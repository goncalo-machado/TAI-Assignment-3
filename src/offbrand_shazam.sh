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

#Remove temp files
rm -f temp.txt
rm -f temp.zip
rm -f temp.txt.gz
rm -f temp.txt.bz2

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

    #Bits needed to compress database freq file

    database_base_name=$(basename "$file" .freqs)
    line=$(grep -F "$database_base_name" database/bitsNeeded/"$compression_method".json )
    line1="${line##*: }"
    database_bits="${line1%,*}"

    #Bits needed to compress test sample freq file

    line=$(grep -F "$test_base_name" Samples/bitsNeeded/"$compression_method".json )
    line1="${line##*: }"
    test_bits="${line1%,*}"

    #Append the two files

    cat database/freqs/"$database_base_name".freqs $freqs >> temp.txt

    case $compression_method in
        "zip") 
            zip -j -r temp.zip temp.txt 
            bits=$(stat -c%s temp.zip)
            rm -f temp.zip
            ;;
        "bzip2") 
            bzip2 -k temp.txt
            bits=$(stat -c%s temp.txt.bz2)
            rm -f temp.txt.bz2;;
        "gzip") 
            gzip -k temp.txt
            bits=$(stat -c%s temp.txt.gz)
            rm -f temp.txt.gz;;
        *) 
            echo "Invalid compression Method"
            exit 1 ;;
    esac

    rm -f temp.txt

    together_bits=$(($bits*8))
    # echo " "
    # echo "$database_base_name"
    # echo "Test bits - $test_bits"
    # echo "Database bits - $database_bits"
    # echo "Together bits - $together_bits"
    # echo " "

    exit
    #TODO: calculate ncd, add to associative array with name of database song and ncd score, show top 5 scores.

done

# temp="$(ncd 4 3 2)"
# echo $temp
