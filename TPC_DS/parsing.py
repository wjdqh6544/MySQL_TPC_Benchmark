import pandas as pd
import re
import os

path = './res/'
list = os.listdir(path)
list = [f for f in list if f.endswith(".out")]
df = pd.DataFrame({})

def parsing(targetFile, index_label):
    elapsed_list = []
    file = open(targetFile, 'r')
    rep = 0
    for line in file:
        match = re.search(r'Repeat:\s*(\d+)/\d+.*?(\d+)\.sql\s*\(Elapsed:\s*(-?\d+)\s*NanoSec\.\)', line)
        
        if match:
            rep = match.group(1)
            elapsed_list.append(match.group(3))
            index_label.append(match.group(2))
    df_tmp = pd.DataFrame({
        f'Elapsed({rep})': elapsed_list
    })
    
    return f"Elapsed({rep})", df_tmp
    
for file in list:
    indexList = []
    col, val = parsing(path + file, indexList)
    df[col] = val

df.index = indexList
df.to_excel(path + 'res.xlsx', index=True)