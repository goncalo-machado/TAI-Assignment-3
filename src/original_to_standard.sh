#!/bin/bash
for filename in OriginalSongs/*.wav; do
    base_name=$(basename "$filename")
    base_name="${base_name// /_}"
    echo $base_name
    sox "$filename" -r 44100 StandardSongs/"$base_name"
done