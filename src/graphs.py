import json
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

default_acc = {}
noise_acc = {}
compression_acc = {}
duration_acc = {}

with open('results/parsed_result.json') as f:
    base_results = json.load(f)

# df = pd.DataFrame.from_records(base_results)

# General Accuracy

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

default_acc = {"Top1":top1,"Top3":top3,"Top5":top5,"Top10":top10}

# Accuracy

total = 0

for result in base_results:
    noise = result["Noise"]
    correct_guess_place = result["CorrectGuessPlace"]
    if noise not in noise_acc.keys():
        noise_acc[noise] = {"Top1":0, "Top3":0, "Top5":0, "Top10":0, "Total":0}
    if correct_guess_place <= 1:
        noise_acc[noise]["Top1"] += 1
    if correct_guess_place <= 3:
        noise_acc[noise]["Top3"] += 1
    if correct_guess_place <= 5:
        noise_acc[noise]["Top5"] += 1
    if correct_guess_place <= 10:
        noise_acc[noise]["Top10"] += 1
    noise_acc[noise]["Total"] += 1
        
for noise, item in noise_acc.items():
    for top, value in noise_acc[noise].items():
        noise_acc[noise][top] = value/noise_acc[noise]["Total"]
print(noise_acc)

# Accuracy By Compression

total = 0

for result in base_results:
    compression = result["Compression"]
    correct_guess_place = result["CorrectGuessPlace"]
    if compression not in compression_acc.keys():
        compression_acc[compression] = {"Top1":0, "Top3":0, "Top5":0, "Top10":0, "Total":0}
    if correct_guess_place <= 1:
        compression_acc[compression]["Top1"] += 1
    if correct_guess_place <= 3:
        compression_acc[compression]["Top3"] += 1
    if correct_guess_place <= 5:
        compression_acc[compression]["Top5"] += 1
    if correct_guess_place <= 10:
        compression_acc[compression]["Top10"] += 1
    compression_acc[compression]["Total"] += 1
        
for compression, item in compression_acc.items():
    for top, value in compression_acc[compression].items():
        compression_acc[compression][top] = value/compression_acc[compression]["Total"]
# print(compression_acc)

# Accuracy By Duration

total = 0

for result in base_results:
    duration = result["Duration"]
    correct_guess_place = result["CorrectGuessPlace"]
    if duration not in duration_acc.keys():
        duration_acc[duration] = {"Top1":0, "Top3":0, "Top5":0, "Top10":0, "Total":0}
    if correct_guess_place <= 1:
        duration_acc[duration]["Top1"] += 1
    if correct_guess_place <= 3:
        duration_acc[duration]["Top3"] += 1
    if correct_guess_place <= 5:
        duration_acc[duration]["Top5"] += 1
    if correct_guess_place <= 10:
        duration_acc[duration]["Top10"] += 1
    duration_acc[duration]["Total"] += 1
        
for duration, item in duration_acc.items():
    for top, value in duration_acc[duration].items():
        duration_acc[duration][top] = value/duration_acc[duration]["Total"]
# print(duration_acc)

#Graphs

noise_acc_list = []
compression_acc_list = []
duration_acc_list = []

for key, value in noise_acc.items():
    temp_dic = value
    temp_dic["Noise"] = key
    noise_acc_list.append(temp_dic)

# print(noise_acc_list)

noise_pd = pd.DataFrame.from_dict(noise_acc_list)
# compression_pd = pd.DataFrame.from_dict(compression_acc)
# duration_pd = pd.DataFrame.from_dict(duration_acc)

# print(noise_pd.head())

noise_pd = pd.melt(noise_pd, id_vars=['Noise'],value_vars=['Top1','Top3','Top5','Top10'])

# print(noise_pd.head(10))

plt.figure(1,figsize=(12,6))
p1 = sns.lineplot(x='variable', y='value',hue='Noise',data=noise_pd,linestyle='-', marker='o', markersize=10)
plt.xlabel('Dataset')
plt.ylabel('Accuracy (%)')
plt.title('Alpha = 1')

plt.show()