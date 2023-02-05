import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import os
import json
import csv
import ast
import pickle
import psycopg2
from sklearn.preprocessing import LabelEncoder

def main(args) : 
    
    # connet DB
    db_connect = psycopg2.connect(
    user="myuser",
    password="mypassword",
    host="34.64.50.61",
    port=5432,
    database="mydatabase",
    )
    # load dataframe form db(new)
    interactions = pd.read_sql("select * from inter;", db_connect)
    interactions = interactions[['track_id','loved','user_id','date_uts']] # [FIXME]
    track_info = pd.read_sql("select * from track_info;", db_connect) # "artist_info" included
    album_info = pd.read_sql("select * from album_info;", db_connect)
    
    # # load csv file(basic)
    args.data_path = args.data_dir + args.data_name # interaction data file -> user, interaction만 있어야 함
    # # data_path = "./data/bk100/raw/"
    # data_lst = os.listdir(data_path+"/raw/")

    # for data in data_lst : 
    #     globals()[f'{data.split("_",1)[0]}'] =  pd.read_csv(os.path.join(data_path+'/raw/',data))
        
    # => albumInfo, interaction, tagInfo, trackinfo, userInfo

    # # column rename(trackinfo)
    # tmp = list(trackinfo.columns)
    # tmp[-3] = 'album_name'
    # trackinfo.columns = tmp

    # # column rename(interaction)
    # tmp = list(interaction.columns)
    # tmp[1] = 'user_name'
    # interaction.columns = tmp

    # # column rename(artist)
    # tmp = list(artist.columns)
    # tmp[1] = 'artist_name'
    # artist.columns = tmp

    # # 1. interaction + album(on = album_name)
    # merge_df = pd.merge(interaction, albumInfo, on = ['album_name','artist_name'], how = 'left')
    # # 2. 1 + track (on = track_name, how = left)
    # merge_df = pd.merge(merge_df, trackinfo, on = ['track_name', 'album_name', 'artist_name'], how = 'left')
    # # 3. 2 + user (on = user_name, how = left)
    # merge_df = pd.merge(merge_df, userInfo, on = 'user_name', how = 'left')
    # # 4. 3 + artist (on = artist_name, how = left)
    # merge_df = pd.merge(merge_df, artist, on = 'artist_name', how = 'left')
    
    tmp = pd.merge(interactions, track_info, on = ['track_id'], how = 'inner')
    merge_df = pd.merge(tmp, album_info, on = ['artist_name','album_name'], how = 'left')

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
    tag_not_null = merge_df['tag'].notnull()
    merge_df.loc[tag_not_null, 'tag'] = merge_df.loc[tag_not_null,'tag'].map(lambda x: list(set(x).intersection(set(tag_list))))
    merge_df.loc[tag_mask,'tag'] = merge_df.loc[tag_mask, 'track_tag_list'].map(lambda x:list(set(x).intersection(set(tag_list))))
    merge_df['tag'] = merge_df['tag'].apply(lambda x:np.nan if x ==[] else x)
    merge_df['tag'] = merge_df['tag'].apply(lambda x:list(set(x)) if x == np.nan else x)

    # 최종 dataframe
    final_df = merge_df[['user_id', 'album_name', 'date_uts', 'artist_name',
        'track_id', 'tag']]
    # tag : 없는 row에 대해서는 drop 하고 학습에 사용
    final_df = final_df.drop(final_df[final_df['album_name'].isnull()].index)
    # album_name : 없는 row에 대해서는 drop 하고 학습에 사용
    final_df = final_df.drop(final_df[final_df['tag'].isnull()].index)
    # sort by [user id & timestamp]
    final_df = final_df.sort_values(by=['user_id','date_uts']).reset_index(drop=True)
    
    # explode
    final_df_explode = final_df.explode('tag')

    # Label Encoding
    def a2b(df, col) : 
        le = LabelEncoder()
        attributes = list(df[col].unique())
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
        
    
        
    # label encoding + offsets -> label 적용(final_df)
    for i,col in enumerate(attributes[['album_name','artist_name','tag']]) : 
        attributes[f'{col}2id'] = attributes[col].map(attributes_dict_list[i])
        final_df_explode[f'{col}2id'] = final_df_explode[col].map(attributes_dict_list[i])
        
    tag_join = final_df_explode.astype(str).groupby("track_id")['tag2id'].apply(set).apply(lambda x:','.join(x))
    tag_join.index = tag_join.index.astype(int)
    tag2id_join = final_df['track_id'].map(tag_join)
    final_df['tag2id_join'] = tag2id_join
    final_df['album_name2id'] = final_df['album_name'].map(attributes_dict_list[0])
    final_df['artist_name2id'] = final_df['artist_name'].map(attributes_dict_list[1])
        
    # join attribute ids(str) -> list
    final_df['attributes_id'] = final_df[['album_name2id','artist_name2id','tag2id_join']].astype(str).apply(lambda x:','.join(x), axis = 1)
    final_df['attributes_id'] = final_df['attributes_id'].str.split(',')

    # # label encoding(track)
    # le = LabelEncoder()
    # final_df['track2id'] = le.fit_transform(final_df['track_name'])
    # # id2track dictionary
    # track_classes = le.classes_
    # track_labels = sorted(final_df['track2id'].unique())
    # id2track_dict = dict(zip(track_labels, track_classes))
    
    # # label encoding(user)
    # le = LabelEncoder()
    # final_df['user2id'] = le.fit_transform(final_df['user_name'])
    # # id2user dictionary
    # user_classes = le.classes_
    # user_labels = sorted(final_df['user2id'].unique())
    # id2user_dict = dict(zip(user_labels, user_classes))
    
    ## save id2track dictionary
    # if not os.path.exists(data_path+"/artifacts") : 
    #     os.mkdir(data_path+"/artifacts")
    # with open(data_path+"/artifacts/id2track_dict.pkl", "wb") as f: 
    #     pickle.dump(id2track_dict, f)
    # with open(data_path+"/artifacts/id2user_dict.pkl", "wb") as f: 
    #     pickle.dump(id2user_dict, f)
    
    
    # conver to json
    attributes_json = json.dumps(dict(zip(final_df['track_id'], final_df['attributes_id'])))
        
    final_df = final_df.sort_values(by=['user_id','date_uts']).reset_index(drop=True)
    interactions = final_df.groupby('user_id')['track_id'].apply(list)
    
    return interactions, attributes_dict_list, attributes_json, args
    
    
def save_artifacts(interactions, attributes_dict_list, attributes_json, args) : 
    
    data_path = args.data_path
    
    # save interactions.txt
    interactions.to_csv(data_path+"/artifacts/interaction.txt", sep=' ', header=False, quoting=csv.QUOTE_NONE, escapechar=' ')
    
    # save 'attributes_dict_list'
    pickle.dump(attributes_dict_list, open(data_path+"/artifacts/attributes_dict_list.pkl", "wb"))
    
    # save attributes
    with open(data_path+"/artifacts/_item2attributes.json", "w") as f : 
        json.dump(attributes_json, f)
    
    # album, artist, tag

