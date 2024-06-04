import json
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

with open('results/parsed_result.json') as f:
    base_results = json.load(f)

# df = pd.DataFrame.from_records(base_results)

#Count distribution of correct guess place

correct_guess_dist = {}

for result in base_results:
    if result["CorrectGuessPlace"] not in correct_guess_dist.keys():
        correct_guess_dist[result["CorrectGuessPlace"]] = 0
    else:
        correct_guess_dist[result["CorrectGuessPlace"]] += 1

for key in correct_guess_dist.keys():
    print(str(key) + " - " + str(correct_guess_dist[key]))