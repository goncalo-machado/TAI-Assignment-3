#!/bin/bash

for test_sample in TestSamples/Original/*.wav; do
    base_name=$(basename "$test_sample" .wav)
    echo "$base_name"

    for noise_volume in 0.02 0.04 0.08 0.16 0.32; do
        sox "$test_sample" -p synth whitenoise vol $noise_volume | sox -m "$test_sample" - TestSamples/Noise/"$base_name"_Noise_"$noise_volume".wav
    done
done