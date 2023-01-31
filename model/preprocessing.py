import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import json
import csv
import ast
import pickle
from sklearn.preprocessing import LabelEncoder

def main(args) : 
    # load csv files

    data_path = args.data_dir + args.data_name # interaction data file -> user, interaction만 있어야 함
    # data_path = "./data/bk100/raw/"
    data_lst = os.listdir(data_path+"/raw/")

    for data in data_lst : 
        globals()[f'{data.split("_",1)[0]}'] =  pd.read_csv(os.path.join(data_path+'/raw/',data))
        
    # => albumInfo, interaction, tagInfo, trackinfo, userInfo

    # column rename(trackinfo)
    tmp = list(trackinfo.columns)
    tmp[-3] = 'album_name'
    trackinfo.columns = tmp

    # column rename(interaction)
    tmp = list(interaction.columns)
    tmp[1] = 'user_name'
    interaction.columns = tmp

    # column rename(artist)
    tmp = list(artist.columns)
    tmp[1] = 'artist_name'
    artist.columns = tmp

    # 1. interaction + album(on = album_name)
    merge_df = pd.merge(interaction, albumInfo, on = ['album_name','artist_name'], how = 'left')
    # 2. 1 + track (on = track_name, how = left)
    merge_df = pd.merge(merge_df, trackinfo, on = ['track_name', 'album_name', 'artist_name'], how = 'left')
    # 3. 2 + user (on = user_name, how = left)
    merge_df = pd.merge(merge_df, userInfo, on = 'user_name', how = 'left')
    # 4. 3 + artist (on = artist_name, how = left)
    merge_df = pd.merge(merge_df, artist, on = 'artist_name', how = 'left')

    # age : 0 밖에 없음 -> "drop" => 연령대별 추천 불가능
    # gender : 0 밖에 없음 -> "drop"
    # registered : user_name개수와 동일 -> "drop"
    # playcount : 학습에 사용되는 user가 heavy or light user인지 여부는 중요하지 않음 -> "drop"
    # country : "drop"
    
    # track_tag_list : tag_list에 들어있는 tag만 추출해 tag의 결측치를 채운후 drop
    tag_list = ["jazz", "pop", "dance", "rock", "electronic", "rap", "hip-hop", "country", "blues", "classical", "k-pop",
            "metal","rnb", "reggae", "acoustic", "indie", "alternative", "punk", "hardcore", "soul"]
    
    # tag 결측치 채우기
    tag_mask = (merge_df['tag'].isnull())&(merge_df['track_tag_list'].notnull())
    merge_df.loc[tag_mask,'tag'] = merge_df.loc[tag_mask, 'track_tag_list'].map(lambda x:ast.literal_eval(x) if x != None else x).map(lambda x:list(set(x).intersection(set(tag_list))))
    merge_df['tag'] = merge_df['tag'].apply(lambda x:np.nan if x ==[] else x)

    # 최종 dataframe
    final_df = merge_df[['user_name', 'album_name', 'date_uts', 'artist_name',
        'track_name', 'tag']]
    final_df['tag']=final_df['tag'].apply(lambda x:ast.literal_eval(x) if type(x)==str else x)

    # tag : 없는 row에 대해서는 drop 하고 학습에 사용
    no_tags = final_df[final_df.tag.isnull()].index
    final_df = final_df.drop(no_tags)

    # album_name : 없는 row에 대해서는 drop 하고 학습에 사용
    no_album = final_df[final_df.album_name.isnull()].index
    final_df = final_df.drop(no_album)
    final_df = final_df.sort_values(by=['user_name','date_uts']).reset_index(drop=True)
    
    # explode
    final_df_explode = final_df.explode('tag')

    # Label Encoding
    def a2b(df, col) : 
        le = LabelEncoder()
        attributes = list(df.explode('tag')[col].unique())
        result = le.fit_transform(attributes)
        keys = le.classes_
        values = sorted(list(result))
        attributes2id = dict(zip(keys, values))
        
        return attributes2id
        
    attributes_dict_list = []
    attributes = final_df_explode[['album_name','artist_name','tag']]

    # label encoding -> label 적용
    for col in attributes.columns : 
        attributes_dict_list.append(a2b(attributes,col))
        attributes[f'{col}2id'] = attributes[col].map(attributes_dict_list[-1])
    
    # offsets 생성        
    offsets = [0]*len(attributes_dict_list)
    for i,dic in enumerate(attributes_dict_list):
        k = dic.keys()
        if i < len(offsets)-1 : 
            offsets[i+1] = offsets[i] + len(k)
    
    # label encoding + offsets
    for i,offset in enumerate(offsets) : 
        dic = attributes_dict_list[i]
        keys = list(dic.keys())
        values = list(dic.values())
        values = list(map(lambda x:x+offset+1, values))
        attributes_dict_list[i] = dict(zip(keys, values))
        
    # save 'attributes_dict_list'
    pickle.dump(attributes_dict_list, open(data_path+"/artifacts/attributes_dict_list.pkl", "wb"))
        
    # label encoding + offsets -> label 적용
    for i,col in enumerate(attributes[['album_name','artist_name','tag']]) : 
        attributes[f'{col}2id'] = attributes[col].map(attributes_dict_list[i])
        final_df_explode[f'{col}2id'] = final_df_explode[col].map(attributes_dict_list[i])
        
    tag2id_join = final_df['track_name'].map(final_df_explode.astype(str).groupby("track_name")['tag2id'].apply(lambda x:','.join(x)))
    final_df['tag2id_join'] = tag2id_join
    final_df['album_name2id'] = final_df['album_name'].map(attributes_dict_list[0])
    final_df['artist_name2id'] = final_df['artist_name'].map(attributes_dict_list[1])
        
    # attribute ids to json file
    final_df['attributes_id'] = final_df[['album_name2id','artist_name2id','tag2id_join']].astype(str).apply(lambda x:','.join(x), axis = 1)
    final_df['attributes_id'] = final_df['attributes_id'].str.split(',')

    # label encoding(track)
    le = LabelEncoder()
    final_df['track2id'] = le.fit_transform(final_df['track_name'])
    # id2track dictionary
    track_classes = le.classes_
    track_labels = sorted(final_df['track2id'].unique())
    id2track_dict = dict(zip(track_labels, track_classes))
    
    # label encoding(user)
    le = LabelEncoder()
    final_df['user2id'] = le.fit_transform(final_df['user_name'])
    # id2user dictionary
    user_classes = le.classes_
    user_labels = sorted(final_df['user2id'].unique())
    id2user_dict = dict(zip(user_labels, user_classes))
    
    # save id2track dictionary
    if not os.path.exists(data_path+"/artifacts") : 
        os.mkdir(data_path+"/artifacts")
    with open(data_path+"/artifacts/id2track_dict.pkl", "wb") as f: 
        pickle.dump(id2track_dict, f)
    with open(data_path+"/artifacts/id2user_dict.pkl", "wb") as f: 
        pickle.dump(id2user_dict, f)
    
    # conver to json
    attributes_json = json.dumps(dict(zip(final_df['track2id'], final_df['attributes_id'])))
        
    final_df = final_df.sort_values(by=['user_name','date_uts']).reset_index(drop=True)
    interactions = final_df.groupby('user2id')['track2id'].apply(list)
    
    # svae interactions.txt
    interactions.to_csv(data_path+"/artifacts/interaction.txt", sep=' ', header=False, quoting=csv.QUOTE_NONE, escapechar=' ')
    
    # save attributes
    with open(data_path+"/artifacts/_item2attributes.json", "w") as f : 
        json.dump(attributes_json, f)
    # with open("./data/bk100/artifacts/id2track_dict.pkl", "wb") as f: 
    #     pickle.dump(id2track_dict, f)
    
        
if __name__ == "__main__" : 
    main()

