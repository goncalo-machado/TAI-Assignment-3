#!/bin/bash
INPUT=$(grep -F 'AJR_-_DRAMA_' database/bitsNeeded/zip.json)
echo "${INPUT%,*} ${INPUT##*: }"