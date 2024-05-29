#!/bin/bash

ncd () {
    local cxy=$1
    local cx=$2
    local cy=$3
    local min=$((cx > cy ? cy : cx))
    local max=$((cx > cy ? cx : cy))
    local top=$((cxy - min))
    local result=$(bc <<< "scale=20;$top / $max")
    echo "$result"
}

#Remove temp files
rm -f temp.txt
rm -f temp.zip
rm -f temp.txt.gz
rm -f temp.txt.bz2

while getopts f:c:n: flag
do
    case "${flag}" in
        f) freqs=${OPTARG};;
        c) compression_method=${OPTARG};;
        n) number_results=${OPTARG};;
    esac
done

echo "Freq file: $freqs";
echo "Compression method: $compression_method";

test_base_name=$(basename "$freqs" .txt)

declare -A results

for file in database/freqs/*.txt; do

    #Bits needed to compress database freq file

    database_base_name=$(basename "$file" .txt)
    line=$(grep -F "$database_base_name" database/bitsNeeded/"$compression_method".json )
    line1="${line##*: }"
    database_bits="${line1%,*}"

    #Bits needed to compress test sample freq file

    line=$(grep -F "$test_base_name" Samples/bitsNeeded/"$compression_method".json )
    line1="${line##*: }"
    test_bits="${line1%,*}"

    # echo "TEST BASE NAME - $test_base_name"
    # echo "LINE - $line"

    #Append the two files

    cat database/freqs/"$database_base_name".txt $freqs >> temp.txt 

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

    ncd_result="$(ncd $together_bits $database_bits $test_bits)"

    results[$database_base_name]=$ncd_result

    # echo " "
    # echo "$database_base_name"
    # echo "Test bits - $test_bits"
    # echo "Database bits - $database_bits"
    # echo "Together bits - $together_bits"
    # echo "NCD - $ncd_result"
    # echo " "

done

for k in "${!results[@]}"
do
    echo $k ' - ' ${results["$k"]}
done |
sort -n -k3 |
head -$number_results
