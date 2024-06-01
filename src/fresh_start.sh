#!/bin/bash

# Delete songs

find StandardSongs/*/*.wav -type f -print0 | xargs -0 rm
find TestSamples/*/*.wav -type f -print0 | xargs -0 rm

# Delete Databases

find */bitsNeeded/*.json -type f -print0 | xargs -0 rm
find */bzip2/*.bz2 -type f -print0 | xargs -0 rm
find */freqs/*.txt -type f -print0 | xargs -0 rm
find */gzip/*.gz -type f -print0 | xargs -0 rm
find */zip/*.zip -type f -print0 | xargs -0 rm

#Delete Results

find results/* -type f -print0 | xargs -0 rm