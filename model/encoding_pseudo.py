import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder

########################################## item ##########################################
le = LabelEncoder()
items = set(df['item'])
result = le.fit_transform(items)
keys = le.classes_
values = range(len(keys))
item2id = dict(zip(keys, values))

########################################## Attributes ##########################################

# 0. 아이템 데이터 셋이 있다고 가정
# 0. 컬럼 : [item, f1, f2, f3, f4, f5]
def a2b(df, col) : 
    le = LabelEncoder()
    attributes = set(df[col])
    result = le.fit_transform(attributes)
    keys = le.classes_
    values = sorted(list(set(result)))
    attributes2id = dict(zip(keys, values))
    
    return attributes2id
    
attributes_dict_list = []
attributes = df[['f1','f2','f3','f4','f5']]

for col in attributes.columns : 
    attributes_dict_list.append(a2b(df,col))
    df[col2id] = df[col].apply(a2b(df,col))
    # 하나의 컬럼에 여러개의 attribute가 list로 포함된 경우 => df.explode

# 1. 하나의 임베딩 테이블 => baseline코드가 하나의 리스트를 읽는 형식으로 되어있어 이 방법 사용해야 할 듯
offsets = [0]*len(attributes_dict_list)
for i,dic in enumerate(attributes_dict_list):
    k,v = dic.items()
    offsets[i] = offsets[i] + len(k)
    
for i,offset in enumerate(offsets) : 
    dic = attributes_dict_list[i]
    keys = list(dic.keys())
    values = list(dict.values())+offset
    attributes_dict_list[i] = dict(zip(keys, values))
    
for i in range(len(df.columns)) : 
    df[f'{col}2id'] = df.iloc[:,i].apply(attributes_dict_list[i])

# 2. 여러개의 임베딩 테이블
# 2-1. 하나의 파일
attributes_ids_dic = {}
attributes_ids_dic[col] = df[col2id]
attributes_ids_dic.to_json
# 2-2. n개의 파일
for col in df.columns : 
    json.dump(df[f'{col}2id'].to_json)