import requests
from tqdm import tqdm
import pickle
import json
import pandas as pd

# 샘플용 artist 목록 => 추후 수정
with open("./tag_artist_dict.pkl", "rb") as f: 
    tag_artist_dict = pickle.load(f)
    
artists = list(tag_artist_dict.values())[0]

########################## 본문 ##########################
def get_artist_info(artist) : 
    url = "http://ws.audioscrobbler.com/2.0/"
    params_artist = {
        "method": "artist.getInfo",
        "artist": f"{artist}",
        "api_key": "1a62f2d4937452d62d7426029e4c9997",
        "autocorrect": 0,
        "format": "json",
    }
    result = requests.get(url, params_artist).json()
    
    return result

def create_df(result) : 
        
    try : 
        image = result['artist']['image']
        image_dict = {item["size"]:item["#text"] for item in image}
    except KeyError : 
        image_dict = {"small":None,"medium":None,"large":None,"extralarge":None,"mega":None,'':None}
    try : 
        mbid = result['artist']['mbid']
    except KeyError : 
        mbid = None
    try : 
        name = result['artist']['name']
    except KeyError : 
        name = None
        
    image_dict['mbid'] = mbid
    image_dict['name'] = name
    dictionary = image_dict
        
    tmp = pd.DataFrame.from_dict([dictionary])
    
    return tmp
    
    
artist_df = pd.DataFrame()
for artist in artists : 
    result = get_artist_info(artist)
    artist_df = artist_df.append(create_df(result))
    
artist_df = artist_df[['mbid','name','small','medium','large','extralarge','mega','']]

artist_df.to_csv("./artist.csv", index = False)