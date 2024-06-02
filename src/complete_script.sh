#!/bin/bash

echo Running fresh_start.sh
./src/fresh_start.sh
echo Running original_to_standard.sh
./src/original_to_standard.sh
echo Running get_test_samples.sh
./src/get_test_samples.sh
echo Running get_noise_samples.sh
./src/get_noise_samples.sh
echo Running create_database_dataset.sh
./src/create_database_dataset.sh
echo Running create_database_test.sh
./src/create_database_test.sh
echo Running get_results.sh
./src/get_results.sh
echo Running parse_results.py
python3 ./src/parse_results.py
echo Running graphs.py
# python3 ./src/graphs.py