import requests
import json
import pandas as pd
from tqdm import tqdm
import itertools
import pickle
import numpy as np

with open('./username_sample.pkl', 'rb') as f:
	username_list = pickle.load(f)

url = 'http://ws.audioscrobbler.com/2.0'

params_inter = {
    "method": "user.getrecenttracks",
    "extended": 1,
    "user": "",
    "limit": 1,
    "api_key": "1a62f2d4937452d62d7426029e4c9997",
    "format": "json",
}

user2id = {}
track2id = {}
album2id = {}
artist2id = {}

track2artist = {}
artist2album = {}

album2track = {}

def push_track2id(str):
    if str not in track2id:
        track2id[str] = len(track2id)

def push_user2id(str):
    if str not in user2id:
        user2id[str] = len(user2id)

def push_album2id(str):
    if str not in album2id:
        album2id[str] = len(album2id)

def push_artist2id(str):
    if str not in artist2id:
        artist2id[str] = len(artist2id)

def push_track2artist(track, artist):
    if track not in track2artist:
        track2artist[track] = artist

def push_artist2album(artist, album):
    if isinstance(album, float) or album == '':
        return
    if artist not in artist2album:
        artist2album[artist] = [album]
    elif album not in artist2album[artist]:
        artist2album[artist].append(album)

def push_album2track(album, track):
    if album not in album2track:
        album2track[album] = [track]
    elif album not in album2track[album]:
        album2track[album].append(album)

for user in username_list:
    push_user2id(user)

# id2item, id2user dict 는 만들기가 까다로움. 업데이트가 까다롭다.

dataframe_list = []
for user, i in tqdm(user2id.items()):
    params_inter["user"] = user
    params_inter["limit"] = 1
    text = requests.get(url, params_inter).text
    text = json.loads(text)
    text = text['recenttracks']
    track = text['track']
    attr = text['@attr']
    params_inter["limit"] = 200
    for page in range(int(attr['totalPages'])):
        params_inter["page"] = page + 1
        text = requests.get(url, params_inter).text
        texts = json.loads(text)['recenttracks']['track']
        texts = pd.DataFrame(texts)
        texts['username'] = user
        texts['user_total'] = attr['total']

        texts['album_name'] = texts['album'].apply(lambda x: x['#text'])

        texts['date_uts'] = texts['date'].apply(lambda x: float('nan') if isinstance(x, float) else x['uts'])
        texts['date_string'] = texts['date'].apply(lambda x: float('nan') if isinstance(x, float) else x['#text'])

        texts['artist_name'] = texts['artist'].apply(lambda x: x['name'])

        texts['name'].apply(lambda x: push_track2id(x))
        texts['album_name'].apply(lambda x: push_album2id(x))
        texts['artist_name'].apply(lambda x: push_artist2id(x))
        texts.apply(lambda x: push_track2artist(x['name'], x['artist_name']), axis=1)
        texts.apply(lambda x: push_artist2album(x['artist_name'], x['album_name']), axis=1)

        texts.drop(columns=['album', 'date', 'artist', 'image', 'mbid', 'url', 'user_total', 'streamable'], inplace=True)
        if '@attr' in list(texts.keys()):
            texts.drop(columns=['@attr'], inplace=True)
        
        dataframe_list.append(texts)
        break

data_csv = pd.concat(dataframe_list, ignore_index=True)
data_csv.rename(columns={'name':'track_name'}, inplace=True)
data_csv.replace('', np.NaN, inplace=True)
data_csv = data_csv.astype({
    'track_name':'string',
    'loved':'int8',
    'username':'string',
    'album_name':'string',
    'date_uts':'string',
    'date_string':'string',
    'artist_name':'string',
})
data_csv.to_csv("interaction_2000.csv", index=False)

params_track = {
    "method": "track.getInfo",
    "track": "",
    "artist": "",
    "api_key": "1a62f2d4937452d62d7426029e4c9997",
    "autocorrect": 0,
    "format": "json",
}

tag2id = {}

def push_tag2id(tags):
    for tag in tags:
        if tag not in tag2id:
            tag2id[tag] = len(tag2id)

trackInfo_dataframe_list = []
for i, (track, artist) in enumerate(tqdm(track2artist.items())):
    params_track['track'] = track
    params_track['artist'] = artist
    track = requests.get(url, params_track).text
    track = json.loads(track)['track']

    track['artist_name'] = track['artist']['name']
    # if 'mbid' in list(track['artist'].keys()):     
    #     track['artist_mbid'] = track['artist'].apply(lambda x: x['mbid'])
    # else:
    #     track['artist_mbid'] = np.nan
    track['artist_url'] = track['artist']['url']

    # track['tag'] = track['toptags'].apply(lambda x: x['tag']) # 태그가 다 없음
    track['tag'] = list(pd.DataFrame(track['toptags']['tag']).apply(lambda x: (x['name']), axis=1))
    # print(track['tag'])
    push_tag2id(track['tag'])

    # track['toptags'].apply(lambda x: push_tag2id(x['tag']), axis=1)
    # track['tag'] = track['toptags'].apply(lambda x: x['tag'] if x != list([]) else np.nan)
    
    if 'album' in list(track.keys()):
        track['album_title'] = track['album']['title']
    #     track['album_url'] = track['album'].apply(lambda x: x['image'][-1]['#text'])
    #     track['album_artist'] = track['album'].apply(lambda x: x['artist'])
    #     track.drop(columns=['album'], inplace=True)
    else:
        track['album_title'] = np.nan
    #     track['album_url'] = np.nan
    #     track['album_artist'] = np.nan

    track = pd.DataFrame([track])
    if 'album' in list(track.keys()):
        track.drop(columns=['album'], inplace=True)
    
    if 'wiki' in list(track.keys()):
        track.drop(columns=['wiki'], inplace=True)

    if 'mbid' in list(track.keys()):
        track.drop(columns=['mbid'], inplace=True)
    track['streamable_text'] = track['streamable'].apply(lambda x: x['#text'])
    track['streamable_fulltrack'] = track['streamable'].apply(lambda x: x['fulltrack'])
    track.drop(columns=['artist', 'streamable', 'toptags'], inplace=True)
    trackInfo_dataframe_list.append(track)

    if i > 200:
        break

trackInfo_csv = pd.concat(trackInfo_dataframe_list, ignore_index=True)
trackInfo_csv.rename(columns={'name':'track_name', 'tag':'track_tag_list'}, inplace=True)
trackInfo_csv = trackInfo_csv.astype({
    'track_name':'string',
    'url':'string',
    'duration':'int32',
    'listeners':'int32',
    'playcount':'int32',
    'artist_name':'string',
    'artist_url':'string',
    'track_tag_list':'object',
    'album_title':'string',
    'artist_url':'string',
    'streamable_text':'int8',
    'streamable_fulltrack':'int8'
})
trackInfo_csv.to_csv("trackinfo_50.csv", index=False)


params_album = {
    "method": "album.getInfo",
    "album": "",
    "artist" : "",
    "api_key": "1a62f2d4937452d62d7426029e4c9997",
    "autocorrect": 0,
    "format": "json",
}

albumInfo_dataframe_list = []
for i, (artist, albums) in enumerate(tqdm(artist2album.items())):
    params_album['artist'] = artist
    for album in albums:
        params_album['album'] = album
        album = requests.get(url, params_album).text
        try:
            album = json.loads(album)['album']
        except:
            print(album)
            print(artist, albums, album, params_album)
        
        album['tag'] = album['tags']
        # print(album['image'][-1])
        album['image'] = album['image'][-1]['#text']
        # print(album['wiki'])

        try:
            album['published'] = album['wiki']['published']
            # album['summary'] = album['wiki']['summary']
            album['content'] = album['wiki']['content']
            album = pd.DataFrame([album])
            album.drop(columns = ['wiki'], inplace=True)
        except:
            # album['summary'] = np.nan
            album['content'] = np.nan
            album = pd.DataFrame([album])

        # display(pd.DataFrame(album['tracks'].item()['track']))
        # album['track'] = list(album['tracks']['track'].apply(lambda x: (x['name'], x['artist']['name'])))
        # print(pd.DataFrame(album['tracks'].item()['track']))
        # print(album['tags'][0])
        try:
            if isinstance(album['tracks'].item()['track'], list):
                album['track'] = [list(pd.DataFrame(album['tracks'].item()['track']).apply(lambda x: (x['name'], x['artist']['name']), axis=1))]
            else:
                album['track'] = [list(pd.DataFrame([album['tracks'].item()['track']]).apply(lambda x: (x['name'], x['artist']['name']), axis=1))]
            album.drop(columns=['tracks'], inplace=True)
        except:
            album['track'] = np.nan # album 을 조회했는데 tracks 가 없는 경우..?
        try:
            album['tag'] = [list(pd.DataFrame(album['tags'].item()['tag']).apply(lambda x: (x['name']), axis=1))]
        except:
            album['tag'] = np.nan
            break
        albumInfo_dataframe_list.append(album)
        album.drop(columns=['tags', 'mbid'], inplace=True)
    if i > 200:
        break

albumInfo_csv = pd.concat(albumInfo_dataframe_list, ignore_index=True)
albumInfo_csv.rename(columns={'artist':'artist_name', 'name':'album_name'}, inplace=True)
albumInfo_csv.replace('', np.NaN, inplace=True)
albumInfo_csv = albumInfo_csv.astype({
    'artist_name':'string',
    'album_name':'string',
    'image':'string',
    'listeners':'int32',
    'playcount':'int32',
    'url':'string',
    'tag':'object',
    'content':'string',
    'track':'object',
    'published':'string',
})
albumInfo_csv.to_csv("albumInfo_50.csv", index=False)

params_user = {
    "method": "user.getInfo",
    "user": "",
    "api_key": "1a62f2d4937452d62d7426029e4c9997",
    "format": "json",
}

userInfo_dataframe_list = []
for user, i in tqdm(user2id.items()):
    params_user['user'] = user
    user = requests.get(url, params_user).text
    user = json.loads(user)['user']
    user['image'] = user['image'][-1]['#text']
    user['registered'] = user['registered']['unixtime']
    user = pd.DataFrame([user])
    
    userInfo_dataframe_list.append(user)

userInfo_csv = pd.concat(userInfo_dataframe_list, ignore_index=True)
userInfo_csv.replace('None', np.NaN, inplace=True)
userInfo_csv.replace('', np.NaN, inplace=True)
userInfo_csv = userInfo_csv.astype({
    'name':'string',
    'age':'int',
    'subscriber':'int',
    'realname':'string',
    'bootstrap':'int',
    'playcount':'int',
    'artist_count':'int',
    'playlists':'int',
    'track_count':'int',
    'album_count':'int',
    'image':'string',
    'realname':'string',
    'registered':'string', # ?
    'country':'string',
    'gender':'string',
    'url':'string',
    'type':'string',
})
userInfo_csv.to_csv("userInfo_10.csv", index=False)

params_tag = {
    "method": "tag.getInfo",
    "tag": "",
    "api_key": "1a62f2d4937452d62d7426029e4c9997",
    "format": "json",
}

tagInfo_dataframe_list = []
for tag, i in tqdm(tag2id.items()):
    params_tag['tag'] = tag
    tag = requests.get(url, params_tag).text
    tag = json.loads(tag)['tag']
    # print(tag.keys())
    tag['summary'] = tag['wiki']['summary']
    tag['content'] = tag['wiki']['content']
    tag = pd.DataFrame([tag])
    tag.drop(columns=['wiki'], inplace=True)
    
    tagInfo_dataframe_list.append(tag)

tagInfo_csv = pd.concat(tagInfo_dataframe_list, ignore_index=True)
tagInfo_csv.replace('', np.NaN, inplace=True)
tagInfo_csv = tagInfo_csv.astype({
    'name':'string',
    'total':'int',
    'reach':'int',
    'summary':'string',
    'content':'string',
})
tagInfo_csv.to_csv("tagInfo.csv", index=False)