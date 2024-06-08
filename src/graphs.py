import csv
import json
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np

with open('results/parsed_result.json') as f:
    base_results = json.load(f)

res = {}

for result in base_results:
    n = str(result["Noise"])    
    d = str(result["Duration"])
    c = str(result["Compression"])
    if result["CorrectGuessPlace"] != 1:
        continue
    if (n,d,c) not in res.keys():
        res[(n,d,c)] = 1
    else:
        res[(n,d,c)] += 1

acc = []

noise = ["0","0.02","0.04","0.08","0.16","0.32","0.64"]
compression = ["zip", "gzip", "bzip2", "lzma", "zstd"]
duration = ["10", "20", "40"]

for n in noise:
    for d in duration:
        for c in compression:
            acc.append({"Noise":n,"Compression":c,"Duration":d,"Top1":0})

counter = 0

for n in noise:
    for d in duration:
        for c in compression:
            acc[counter]["Top1"] = res[(n,d,c)]
            counter += 1

counter = 0

for n in noise:
    for d in duration:
        for c in compression:
            acc[counter]["Top1"] = round(acc[counter]["Top1"] / 30, 3)
            counter += 1

keys = acc[0].keys()

with open(".\\results\\accuracy.csv",'w', newline='') as csv_file:
    dict_writer = csv.DictWriter(csv_file, keys)
    dict_writer.writeheader()
    dict_writer.writerows(acc)

n_list = []
d_list = []
c_list = []

for idx,n in enumerate(noise):
    n_list.append([])
for idx,d in enumerate(duration):
    d_list.append([])
for idx,c in enumerate(compression):
    c_list.append([])

for dic in acc:
    for idx, n in enumerate(noise):
        if dic["Noise"] == n:
            n_list[idx].append(dic)
    for idx,d in enumerate(duration):
        if dic["Duration"] == d:
            d_list[idx].append(dic)
    for idx,c in enumerate(compression):
        if dic["Compression"] == c:
            c_list[idx].append(dic)
        
n_pds = []
d_pds = []
c_pds = []

for idx,n in enumerate(noise):
    n_pds.append(pd.DataFrame.from_dict(n_list[idx]))
for idx,d in enumerate(duration):
    d_pds.append(pd.DataFrame.from_dict(d_list[idx]))
for idx,c in enumerate(compression):
    c_pds.append(pd.DataFrame.from_dict(c_list[idx]))

plt.figure(1,figsize=(20,15))

for idx,n in enumerate(noise):
    subplot = 420 + idx + 1
    plt.subplot(subplot)
    p = sns.lineplot(x='Compression', y='Top1', hue='Duration',data=n_pds[idx],linestyle='-', marker='o', markersize=10)
    plt.xlabel('Compression')
    plt.ylabel('Accuracy (%)')
    plt.title('Noise ' + n)
    plt.ylim((0.5, 1.1))

plt.subplots_adjust(wspace=0.2,hspace=0.46, right=0.72,top=0.94)

plt.savefig('./results/noise.png')

plt.figure(2,figsize=(20,4))

for idx,d in enumerate(duration):
    subplot = 130 + idx + 1
    plt.subplot(subplot)
    p = sns.lineplot(x='Noise', y='Top1', hue='Compression',data=d_pds[idx],linestyle='-', marker='o', markersize=10)
    plt.xlabel('Noise')
    plt.ylabel('Accuracy (%)')
    plt.title('Duration ' + d)
    plt.ylim((0.5, 1.1))

plt.savefig('./results/duration.png')

plt.figure(3,figsize=(20,15))

for idx,c in enumerate(compression):
    subplot = 320 + idx + 1
    plt.subplot(subplot)
    p = sns.lineplot(x='Noise', y='Top1', hue='Duration',data=c_pds[idx],linestyle='-', marker='o', markersize=10)
    plt.xlabel('Noise')
    plt.ylabel('Accuracy (%)')
    plt.title('Compression ' + c)
    plt.ylim((0.5, 1.1))

plt.subplots_adjust(hspace=0.34)

plt.savefig('./results/compression.png')
