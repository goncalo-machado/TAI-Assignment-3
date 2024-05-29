#!/bin/bash

find database/bitsNeeded/*.json -type f -print0 | xargs -0 rm
find database/bzip2/*.bz2 -type f -print0 | xargs -0 rm
find database/freqs/*.txt -type f -print0 | xargs -0 rm
find database/gzip/*.gz -type f -print0 | xargs -0 rm
find database/zip/*.zip -type f -print0 | xargs -0 rm