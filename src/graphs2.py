import json
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import numpy as np
from collections import defaultdict

default_acc = {}
noise_acc = {}
compression_acc = {}
duration_acc = {}

with open('results/parsed_result.json') as f:
    base_results = json.load(f)

def calculate_accuracy(data):
    # Initialize dictionaries to count correct guesses and total guesses
    correct_count = defaultdict(int)
    total_count = defaultdict(int)
    
    for entry in data:
        key = (entry['Noise'], entry['Duration'], entry['Compression'])
        total_count[key] += 1
        if entry['CorrectGuessPlace'] == 1:
            correct_count[key] += 1
    
    # Calculate accuracy for each combination of Noise, Duration, and Compression
    accuracy_data = []
    for key in total_count:
        noise, duration, compression = key
        accuracy = correct_count[key] / total_count[key]
        accuracy_data.append({
            'Noise': noise,
            'Duration': duration,
            'Compression': compression,
            'Accuracy': accuracy
        })
    
    return accuracy_data

accuracy_data = calculate_accuracy(base_results)
# Convert to DataFrame for easy plotting
df = pd.DataFrame(accuracy_data)

# Print the DataFrame
print(df)

# # Plotting with seaborn
# sns.set(style="whitegrid")

# # Scatter plot to show Accuracy by Noise
# plt.figure(figsize=(20, 8))
# sns.scatterplot(x='Noise', y='Accuracy', hue='Compression', size='Duration', sizes=(20, 200), data=df)
# plt.title('Accuracy by Noise, Duration, and Compression')
# plt.show()

# # Bar plot to show mean Accuracy by Compression
# plt.figure(figsize=(10, 6))
# sns.barplot(x='Compression', y='Accuracy', data=df, ci=None)
# plt.title('Mean Accuracy by Compression')
# plt.show()

# # Box plot to show Accuracy distribution by Duration
# plt.figure(figsize=(10, 6))
# sns.boxplot(x='Duration', y='Accuracy', data=df)
# plt.title('Accuracy distribution by Duration')
# plt.show()

# # Heatmap to show Accuracy for combinations of Noise and Duration
# heatmap_data = df.pivot_table(values='Accuracy', index='Noise', columns='Duration')
# plt.figure(figsize=(10, 6))
# sns.heatmap(heatmap_data, annot=True, cmap="YlGnBu")
# plt.title('Heatmap of Accuracy by Noise and Duration')
# plt.show()


# def plot_combinations(df, variables, target):
#     combinations = [(variables[i], variables[j]) for i in range(len(variables)) for j in range(i+1, len(variables))]
#     for var1, var2 in combinations:
#         plt.figure(figsize=(10, 6))
#         sns.lineplot(data=df, x=var1, y=target, hue=var2, marker='o')
#         plt.title(f'{target} by {var1} and {var2}')
#         plt.xlabel(var1)
#         plt.ylabel(target)
#         plt.legend(title=var2)
#         plt.show()

# # Variables to plot
# variables = ['Noise', 'Duration', 'Compression']
# target = 'Accuracy'

# # Generate line plots
# plot_combinations(df, variables, target)

# def plot_heatmap(df, index, columns, values, aggfunc='mean'):
#     pivot_table = df.pivot_table(values=values, index=index, columns=columns, aggfunc=aggfunc)
#     plt.figure(figsize=(12, 8))
#     sns.heatmap(pivot_table, annot=True, cmap="YlGnBu", fmt=".2f")
#     plt.title(f'Heatmap of {values} by {index} and {columns} (Mean)')
#     plt.xlabel(columns)
#     plt.ylabel(index)
#     plt.show()

# Variables to plot
# variables = ['Noise', 'Duration', 'Compression']
# target = 'Accuracy'

# Generate heatmaps for every combination of two variables
# for i in range(len(variables)):
#     for j in range(i + 1, len(variables)):
#         plot_heatmap(df, index=variables[i], columns=variables[j], values=target)

g = sns.FacetGrid(df, col="Compression", margin_titles=True, height=4, aspect=1.5)
g.map_dataframe(sns.heatmap, x='Noise', y='Duration', cbar=True, annot=True, cmap='YlGnBu', data=df.pivot_table(values='Accuracy', index='Noise', columns='Duration', aggfunc='median'))
g.set_axis_labels("Noise", "Duration")
g.set_titles(col_template="{col_name}")
plt.show()