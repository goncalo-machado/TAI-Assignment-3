#!/bin/bash

./src/fresh_start.sh
./src/original_to_standard.sh
./src/get_test_samples.sh
./src/get_noise_samples.sh
./src/create_database_dataset.sh
./src/create_database_test.sh
./src/get_results.sh
python3 ./src/parse_results.py
# python3 ./src/graphs.py