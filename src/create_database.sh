#!/bin/bash
# for filename in StandardSongs/*.wav; do
#     base_name=$(basename "$filename" .wav)
#     echo "$base_name"
#     ./GetMaxFreqs/bin/GetMaxFreqs -v -w Database/Freqs/"$base_name".freqs "$filename"
# done

for freqs_file in database/freqs/*.freqs; do
    base_name=$(basename "$freqs_file" .freqs)
    echo "$base_name"
    echo "Compressing with zip"
    zip -j -r database/zip/"$base_name".zip "$freqs_file"
    # echo "Compressing with gzip"

    # echo "Compressing with bzip2"

done