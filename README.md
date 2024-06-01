# TAI-Assignment-3
Repository for Lab Work 3 for TAI

## How to Run

In order to obtain results, the following steps must be done in order:
 - Place all songs that will be used as the dataset into the __OriginalSongs__ directory, with the songs being in the .wav format
 - Make sure that you are in the root directory of the repository
 - Run complete_script.sh . Example: ./src/complete_script.sh 

The results will be created in the __results__ directory.

The complete_script.sh file will standardize the songs to the required format, pick random songs to create test samples with 10, 20 and 40 seconds interval and with noise, create the databases for both the songs and the test samples, obtain results with all test samples and create graphs with the results.