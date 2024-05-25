#!/bin/bash

#Get Freqs files

for filename in StandardSongs/*.wav; do
    base_name=$(basename "$filename" .wav)
    echo "$base_name"
    ./GetMaxFreqs/bin/GetMaxFreqs -v -w database/freqs/"$base_name".freqs "$filename"
done

#Compress freqs files

for freqs_file in database/freqs/*.freqs; do
    base_name=$(basename "$freqs_file" .freqs)
    echo "$base_name"
    
    echo "Compressing with zip"
    zip -j -r database/zip/"$base_name".zip "$freqs_file"
    
    echo "Compressing with gzip"
    gzip -k "$freqs_file"
    mv "$freqs_file".gz database/gzip/"$base_name".gz
    
    echo "Compressing with bzip2"
    bzip2 -k "$freqs_file"
    mv "$freqs_file".bz2 database/bzip2/"$base_name".bz2
done

#Create files with bits needed for every type of compressed files

compression_methods=('zip' 'gzip' 'bzip2' )
extensions=('zip' 'gz' 'bz2')

for i in {0..2}; do
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

