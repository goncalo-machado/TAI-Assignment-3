#!/bin/bash

compression_methods=('zip' 'gzip' 'bzip2' )

for i in {0..2}; do
    for test_sample in Samples/freqs/*.txt; do
        ./src/offbrand_shazam.sh -f $test_sample -c ${compression_methods[$i]} -n 10 >> results/results.txt
        echo "" >> results/results.txt
    done
done