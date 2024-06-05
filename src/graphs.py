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

top1 = 0
top3 = 0
top5 = 0
top10 = 0
total = 0

for key, value in correct_guess_dist.items():
    if key <= 10:
        top10 += value
    if key <= 5:
        top5 += value
    if key <= 3:
        top3 += value
    if key <= 1:
        top1 += value
    total += value

print(top1/total)
print(top3/total)
print(top5/total)
print(top10/total)
print(total/total)