#!/bin/bash

compression_methods=('zip' 'gzip' 'bzip2' )


for test_sample in TestSamples/*/*.wav; do
    for i in {0..2}; do
        ./src/offbrand_shazam.sh -f $test_sample -c ${compression_methods[$i]} -n 5 > results/results_${compression_methods[$i]}.txt
    done
done