#!/bin/bash

find Samples/bitsNeeded/*.json -type f -print0 | xargs -0 rm
find Samples/bzip2/*.bz2 -type f -print0 | xargs -0 rm
find Samples/freqs/*.txt -type f -print0 | xargs -0 rm
find Samples/gzip/*.gz -type f -print0 | xargs -0 rm
find Samples/zip/*.zip -type f -print0 | xargs -0 rm