#!/bin/bash
ls StandardSongs |sort -R |tail -20 |while read file; do
    echo "$file"
    base_name=$(basename "$file" .wav)

    song_length=$(soxi -D StandardSongs/"$file")
    
    song_length_int=${song_length%.*} 

    echo "Song length - $song_length_int"

    start_timestamp=$(shuf -i 0-$(($song_length_int - 20)) -n 1)

    end_timestamp=$(($start_timestamp + 20))

    echo "Interval for sample: [$start_timestamp,$end_timestamp]"

    sox StandardSongs/"$file" TestSamples/"$base_name"-Interval-"$start_timestamp"_"$end_timestamp".wav trim "$start_timestamp" "$end_timestamp"
done