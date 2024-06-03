#!/bin/bash

#Get Freqs files

for filename in StandardSongs/*.wav; do
    base_name=$(basename "$filename" .wav)
    echo "$base_name"
    ./GetMaxFreqs/bin/GetMaxFreqs -v -w database/freqs/"$base_name".txt "$filename"
done

#Compress freqs files

for freqs_file in database/freqs/*.txt; do
    base_name=$(basename "$freqs_file" .txt)
    echo "$base_name"
    
    echo "Compressing with zip"
    zip -j -q -r database/zip/"$base_name".zip "$freqs_file"
    
    echo "Compressing with gzip"
    gzip -k "$freqs_file"
    mv "$freqs_file".gz database/gzip/"$base_name".gz
    
    echo "Compressing with bzip2"
    bzip2 -k "$freqs_file"
    mv "$freqs_file".bz2 database/bzip2/"$base_name".bz2

    echo "Compressing with lzma"
    lzma -z -k -q "$freqs_file"
    mv "$freqs_file".lzma database/lzma/"$base_name".lzma

    echo "Compressing with zstd"
    zstd -q "$freqs_file"
    mv "$freqs_file".zst database/zstd/"$base_name".zst
done

#Create files with bits needed for every type of compressed files

compression_methods=('zip' 'gzip' 'bzip2' 'lzma' 'zstd')
extensions=('zip' 'gz' 'bz2' 'lzma' 'zst')

for i in {0..4}; do
    echo ${compression_methods[$i]}
    unset bits_needed
    declare -A bits_needed

    for filename in database/${compression_methods[$i]}/*; do
        base_name=$(basename "$filename" ${extensions[$i]})
        bits=$(stat -c%s "$filename")
        bits=$(($bits*8))
        bits_needed[$base_name]=$bits
    done

    for key in "${!bits_needed[@]}"; do
        printf '%s\0%s\0' "$key" "${bits_needed[$key]}"
    done |
    jq -RS '
        split("\u0000")
        | . as $a
        | reduce range(0; length/2) as $i 
        ({}; . + {($a[2*$i]): ($a[2*$i + 1]|fromjson? // .)})' >> database/bitsNeeded/${compression_methods[$i]}.json
done

