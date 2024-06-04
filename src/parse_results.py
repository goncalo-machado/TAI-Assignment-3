import json

results = []
result_dic = {}
with open("results/results.txt", encoding="utf-8") as file:
    for line in file:
        if "Freq file: " in line:
            freq_file = line.removeprefix("Freq file: Samples/freqs/").strip()
            result_dic["File"] = freq_file
            if "Noise" not in freq_file:
                result_dic["Noise"] = 0
            else:
                arr = freq_file.split("_")
                result_dic["Noise"] = float(arr[-1].removesuffix(".txt"))
            arr = freq_file.split("-Interval-")
            arr2 = arr[1].split("_")
            result_dic["Duration"] = int(arr2[1].removesuffix(".txt"))-int(arr2[0])
            result_dic["BaseFile"] = arr[0]
        elif "Compression method: " in line:
            compression_method = line.removeprefix("Compression method: ").strip()
            result_dic["Compression"] = compression_method
        elif line.isspace():
            results.append(result_dic)
            result_dic = {}
        else:
            arr = line.split(" - ")
            if "Top" not in result_dic.keys():
                result_dic["Top"] = {}
            result_dic["Top"][arr[0].strip()] = float(arr[1].strip())

for dict in results:
    counter = 1
    for line in dict["Top"]:
        if line == dict["BaseFile"]:
            break
        counter += 1
    dict["CorrectGuessPlace"] = counter
        
with open('results/parsed_result.json', 'w', encoding="utf-8") as f:
    json.dump(results,f, sort_keys=False, indent=4, ensure_ascii=False)