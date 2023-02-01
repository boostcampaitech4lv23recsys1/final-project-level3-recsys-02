import requests
import json
import pandas as pd
from tqdm import tqdm
import pickle
import numpy as np
import multiprocessing as mp
from multiprocessing import Pool
import itertools
import os
from time import sleep
import json
import numpy as np
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--user', type=str)
parser.add_argument('--api', type=str)
parser.add_argument('--ver', type=str)
parser.add_argument('--user_sampling', type=int)
parser.add_argument('--phase', type=int)
args = parser.parse_args()

os.chdir('/opt/ml/final/API')
dirname = f'ver_{args.ver}'
if not os.path.isdir(dirname):
    os.makedirs(dirname)

# with open('./listeners_20k.npy', 'rb') as f:
# 	username_list = pickle.load(f)

username_list = np.load('./listeners_20k.npy')

print(len(username_list))
username_list = username_list[:args.user_sampling]

url = 'http://ws.audioscrobbler.com/2.0'

params_inter = {
    "method": "user.getrecenttracks",
    "extended": 1,
    "user": "",
    "limit": 1,
    "api_key": f"{args.api}",
    "format": "json",
}
params_track = {
    "method": "track.getInfo",
    "track": "",
    "artist": "",
    "api_key": f"{args.api}",
    "autocorrect": 0,
    "format": "json",
}
params_tag = {
    "method": "tag.getInfo",
    "tag": "",
    "api_key": f"{args.api}",
    "format": "json",
}
params_album = {
    "method": "album.getInfo",
    "album": "",
    "artist" : "",
    "api_key": f"{args.api}",
    "autocorrect": 0,
    "format": "json",
}
params_artist = {
    "method": "artist.getInfo",
    "artist": "",
    "api_key": f"{args.api}",
    "autocorrect": 0,
    "format": "json",
}

params_user = {
    "method": "user.getInfo",
    "user": "",
    "api_key": f"{args.api}",
    "format": "json",
}

userInfo_dataframe_list = []
albumInfo_dataframe_list = []
trackInfo_dataframe_list = []
dataframe_list = []
tagInfo_dataframe_list = []

user2id = {}
track2id = {}
album2id = {}
artist2id = {}

track2artist = {}
artist2album = {}

album2track = {}

tag2id = {}

def push_user2id(str):
    if str not in user2id:
        user2id[str] = len(user2id)

def push_album2track(album, track):
    if album not in album2track:
        album2track[album] = [track]
    elif album not in album2track[album]:
        album2track[album].append(album)

for user in username_list:
    push_user2id(user)

# id2item, id2user dict 는 만들기가 까다로움. 업데이트가 까다롭다.

def list_split(arr, n):
    return_list = []
    len_n = len(arr)//n
    for c, i in enumerate(range(0, len(arr), len_n)):
        if c == n-1:
            return_list.append(arr[i:])
            break
        else:
            return_list.append(arr[i: i+len_n])
        
    return return_list

def interaction(users):
    # print(users)
    function_dataframe_list_tmp = []
    tmp_track2artist = set()
    tmp_artist2album = set()
    tmp_track2id = set()
    tmp_album2id = set()
    tmp_artist2id = set()

    def push_track2artist(track, artist):
        tmp_track2artist.add((track, artist))

    def push_artist2album(artist, album):
        if isinstance(album, float) or album == '':
            return
        tmp_artist2album.add((artist, album))

    def push_track2id(str):
        tmp_track2id.add(str)

    def push_album2id(str):
        tmp_album2id.add(str)

    def push_artist2id(str):
        tmp_artist2id.add(str)
    
    for i, user_id in enumerate(tqdm(users)):
        # print(user_id[0], user_id[1])
        params_inter["user"] = user_id[0]
        params_inter["limit"] = 1
        text = requests.get(url, params_inter).text
        text = json.loads(text)

        try:
            text = text['recenttracks']
            attr = text['@attr']
        except:
            try:
                if text['error'] == 17: # {'message': 'Login: User required to be logged in', 'error': 17}
                    sleep(1)
                    continue
                elif text['error'] == 8: # {"message":"Operation failed - Most likely the backend service failed. Please try again.","error":8}
                    sleep(1)
                    continue
            except:
                print('break!!-loop1')
                print(text, '-loop1')
                return {'dataframe_list':function_dataframe_list_tmp,
                    'track2artist':tmp_track2artist,
                    'artist2album':tmp_artist2album,
                    'track2id':tmp_track2id,
                    'album2id':tmp_artist2id,
                    'artist2id':tmp_artist2id}


        params_inter["limit"] = 200
        for page in range(int(attr['totalPages'])):
            params_inter["page"] = page + 1
            text = requests.get(url, params_inter).text
            try:
                texts = json.loads(text)['recenttracks']['track']
            except:
                text = json.loads(text)
                try:
                    if text['error'] == 8: # {"message":"Operation failed - Most likely the backend service failed. Please try again.","error":8}
                        print(text['error'], '-loop2')
                        sleep(1)
                        break
                    elif text['error'] == 6: # {"message":"User not found","error":6}
                        print(text['error'], '-loop2')
                        sleep(1)
                        break
                except:
                    print('break!!-loop2')
                    print(text, '-loop2')
                    sleep(1)
                    break
            texts = pd.DataFrame(texts)
            texts['username'] = user_id[0]
            # texts['user_total'] = attr['total']
            texts['album_name'] = texts['album'].apply(lambda x: x['#text'])
            texts['date_uts'] = texts['date'].apply(lambda x: -1 if isinstance(x, float) else x['uts'])
            # texts['date_string'] = texts['date'].apply(lambda x: float('nan') if isinstance(x, float) else x['#text'])
            texts['artist_name'] = texts['artist'].apply(lambda x: x['name'])
            texts['track_name'] = texts['name']

            texts['track_name'].apply(lambda x: push_track2id(x))
            texts['album_name'].apply(lambda x: push_album2id(x))
            texts['artist_name'].apply(lambda x: push_artist2id(x))
            texts.apply(lambda x: push_track2artist(x['name'], x['artist_name']), axis=1)
            texts.apply(lambda x: push_artist2album(x['artist_name'], x['album_name']), axis=1)

            texts.drop(columns=['album', 'date', 'artist', 'image', 'mbid', 'url', 'streamable', 'name'], inplace=True)
            if '@attr' in list(texts.keys()):
                texts.drop(columns=['@attr'], inplace=True)
            
            function_dataframe_list_tmp.append(texts)
            break
        if i % 4 == 0:
            sleep(1)
    return {'dataframe_list':function_dataframe_list_tmp,
    'track2artist':tmp_track2artist,
    'artist2album':tmp_artist2album,
    'track2id':tmp_track2id,
    'album2id':tmp_artist2id,
    'artist2id':tmp_artist2id}

def trackinfo(tracks):
    tmp_tag2id = set()
    def push_tag2id(tags):
        for tag in tags:
            tmp_tag2id.add(tag)

    function_dataframe_list_tmp = []
    for i, (track, artist) in enumerate(tqdm(tracks)):
        params_track['track'] = track
        params_track['artist'] = artist
        track = requests.get(url, params_track).text

        try:
            track = json.loads(track)['track']
        except:
            try:
                track = json.loads(track)
                try:
                    if track['error'] == 6: # {"error":6,"message":"Track not found","links":[]}
                        # print('track:', track, 'artist:', artist)
                        continue
                    elif track['error'] == 29: #{'message': 'Rate Limit Exceeded - This application has made too many requests in a short period. If this is your API key, see https://www.last.fm/api/tos#4.4 for information about raising the limit.', 'error': 29}
                        sleep(10)
                        continue
                    elif track['error'] == 8: #{'message': 'Operation failed - Most likely the backend service failed. Please try again.', 'error': 8}
                        continue
                except:
                    print('break!!')
                    print(track, '2')
                    return {'dataframe_list':function_dataframe_list_tmp, 'tag2id':tmp_tag2id}
            except:
                print(track, '3')
                continue

        # if 'mbid' in list(track['artist'].keys()):
        #     track['artist_mbid'] = track['artist'].apply(lambda x: x['mbid'])
        # else:
        #     track['artist_mbid'] = np.nan
        track['artist_name'] = track['artist']['name']
        track['artist_url'] = track['artist']['url']

        # track['tag'] = track['toptags'].apply(lambda x: x['tag']) # 태그가 다 없음
        track['tags'] = list(pd.DataFrame(track['toptags']['tag']).apply(lambda x: (x['name']), axis=1))
        push_tag2id(track['tags'])
        if len(track['tags']) == 0:
            track['tags'] = np.nan
        # track['tags'] = {i: tmp[i] for i in range(0, len(tmp))}
        # print(track['tag'])
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
        track.drop(columns=['artist', 'streamable', 'toptags', 'url'], inplace=True)
        function_dataframe_list_tmp.append(track)

        if i % 4 == 0:
            sleep(1)
    return {'dataframe_list':function_dataframe_list_tmp, 'tag2id':tmp_tag2id}

def albuminfo(artist2album):
    function_dataframe_list_tmp = []
    # print(len(artist2album))
    for i, (artist, album_) in enumerate(tqdm(artist2album)):
        params_album['artist'] = artist
        # for album in albums:
        params_album['album'] = album_
        album = requests.get(url, params_album).text

        try:
            album = json.loads(album)['album']
        except:
            try:
                album = json.loads(album)
                try:
                    if album['error'] == 6: # {'message': 'Album not found', 'error': 6}
                        # print(album, '2')
                        continue
                except:
                    print('break!!')
                    print(album, '3')
                    return {'dataframe_list':function_dataframe_list_tmp}
            except:
                print(album, '4')
                continue
        
        # album['tag'] = album['tags']
        # print(album['image'][-1])
        try:
            album['image'] = album['image'][-1]['#text']
        except:
            print(album, '1234')
        # print(album['wiki'])
        # print(album.keys())

        try:
            album['tag'] = list(pd.DataFrame(album['tags']['tag']).apply(lambda x: (x['name']), axis=1))
            # album['tag'] = {i: tmp[i] for i in range(0, len(tmp))}
        except:
            album['tag'] = np.nan

        try:
            album['published'] = album['wiki']['published']
            # album['summary'] = album['wiki']['summary']
            # album['content'] = album['wiki']['content']
            album = pd.DataFrame([album])
            album.drop(columns = ['wiki'], inplace=True)
        except:
            # album['summary'] = np.nan
            # album['content'] = np.nan
            album = pd.DataFrame([album])

        # display(pd.DataFrame(album['tracks'].item()['track']))
        # album['track'] = list(album['tracks']['track'].apply(lambda x: (x['name'], x['artist']['name'])))
        # print(pd.DataFrame(album['tracks'].item()['track']))
        # print(album['tags'][0])

        # try:
        #     if isinstance(album['tracks'].item()['track'], list):
        #         album['track'] = [list(pd.DataFrame(album['tracks'].item()['track']).apply(lambda x: (x['name'], x['artist']['name']), axis=1))]
        #     else:
        #         album['track'] = [list(pd.DataFrame([album['tracks'].item()['track']]).apply(lambda x: (x['name'], x['artist']['name']), axis=1))]
        # except:
        #     album['track'] = np.nan # album 을 조회했는데 tracks 가 없는 경우..?

        if 'tracks' in list(album.keys()):
            album.drop(columns=['tracks'], inplace=True)

        if 'tags' in list(album.keys()):
            album.drop(columns=['tags'], inplace=True)

        if 'mbid' in list(album.keys()):
            album.drop(columns=['mbid'], inplace=True)

        function_dataframe_list_tmp.append(album)
        if i % 4 == 0:
            sleep(1)
    return {'dataframe_list':function_dataframe_list_tmp}

def userinfo(user2id):
    function_dataframe_list_tmp = []
    gender_dict = {'n' : 0}
    # print(user2id)
    for i, (user, id) in enumerate(tqdm(user2id)):
        params_user['user'] = user
        user = requests.get(url, params_user).text

        try:
            user = json.loads(user)['user']
        except:
            print('break!!')
            print(user)
            return {'dataframe_list':function_dataframe_list_tmp}
            
        user['image'] = user['image'][-1]['#text']
        user['registered'] = user['registered']['unixtime']
        # print(user['gender'])
        user['gender'] = gender_dict[user['gender']]
        user = pd.DataFrame([user])
        user['follower'] = np.nan
        user['following'] = np.nan

        user.drop(columns=['playlists', 'type', 'artist_count', 'track_count', 'album_count'], inplace=True)
        function_dataframe_list_tmp.append(user)
        if i % 10 == 0:
            sleep(1)
    return {'dataframe_list':function_dataframe_list_tmp}

def taginfo(tag2id):
    function_dataframe_list_tmp = []
    for i, (tag, id) in enumerate(tqdm(tag2id)):
        params_tag['tag'] = tag
        tag = requests.get(url, params_tag).text
        
        try:
            tag = json.loads(tag)['tag']
        except:
            try:
                tag = json.loads(tag)
                try:
                    if tag == {}:
                        print(tag, '-1')
                        continue
                    elif tag['error'] == 29: # {'message': 'Album not found', 'error': 6}
                        # print(album, '2')
                        sleep(10)
                        continue
                except:
                    print('break!!')
                    print(tag)
                    return {'dataframe_list':function_dataframe_list_tmp}
            except:
                print(tag, '4')
                continue

        # print(tag.keys())
        # tag['summary'] = tag['wiki']['summary']
        # tag['content'] = tag['wiki']['content']
        tag = pd.DataFrame([tag])
        tag.drop(columns=['wiki'], inplace=True)
        
        function_dataframe_list_tmp.append(tag)
        if i % 10 == 0:
            sleep(1)
    return {'dataframe_list':function_dataframe_list_tmp}

def artistinfo(artist2id):
    function_dataframe_list_tmp = []
    for i, (artist, id) in enumerate(tqdm(artist2id)):
        params_artist['artist'] = artist
        result = requests.get(url, params_artist).json()

        try:
            image = result['artist']['image']
        except:
            try:
                try:
                    if result['error'] == 6: # {'error': 6, 'message': 'The artist you supplied could not be found', 'links': []}
                        # print(result, '2')
                        continue
                except:
                    print('break!!')
                    print(result, '3')
                    return {'dataframe_list':function_dataframe_list_tmp}
            except:
                print(result, '4')
                continue
        
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
        
        function_dataframe_list_tmp.append(tmp)
        if i % 10 == 0:
            sleep(1)
    return {'dataframe_list':function_dataframe_list_tmp}

def make_path(string):
    return dirname + '/' + string

def multiprocessing_interaction():
    global track2id, track2artist, album2id, artist2id, artist2album
    cpu = 8
    pool = Pool(processes=cpu)
    print(len(user2id))
    dataframe_list_tmp = pool.map(interaction, list_split(list(user2id.items()), cpu))
    pool.close()
    pool.join()
    dataframe_list = list(itertools.chain.from_iterable([tmp['dataframe_list'] for tmp in dataframe_list_tmp]))
    artist2album_list = [tmp['artist2album'] for tmp in dataframe_list_tmp]
    track2artist_list = [tmp['track2artist'] for tmp in dataframe_list_tmp]
    track2id_list = [tmp['track2id'] for tmp in dataframe_list_tmp]
    album2id_list = [tmp['album2id'] for tmp in dataframe_list_tmp]
    artist2id_list = [tmp['artist2id'] for tmp in dataframe_list_tmp]
    artist2album_tmp = set()
    track2artist_tmp = set()
    track2id_tmp = set()
    album2id_tmp = set()
    artist2id_tmp = set()
    for artist2album_tmpp in artist2album_list:
        artist2album_tmp = artist2album_tmp | artist2album_tmpp
    for track2artist_tmpp in track2artist_list:
        track2artist_tmp = track2artist_tmp | track2artist_tmpp
    for track_tmp in track2id_list:
        track2id_tmp = track2id_tmp | track_tmp
    for album_tmp in album2id_list:
        album2id_tmp = album2id_tmp | album_tmp
    for artist_tmp in artist2id_list:
        artist2id_tmp = artist2id_tmp | artist_tmp
    # print(len(artist2album), len(track2artist), len(track2id_tmp), len(album2id_tmp), len(artist2id_tmp))
    for id, track in enumerate(list(track2id_tmp)):
        track2id[track] = id
    for track, artist in list(track2artist_tmp):
        track2artist[track] = artist
    for id, album in enumerate(list(album2id_tmp)):
        album2id[album] = id
    for id, artist in enumerate(list(artist2id_tmp)):
        artist2id[artist] = id
    for artist, album in list(artist2album_tmp):
        artist2album[artist] = album

    data_csv = pd.concat(dataframe_list, ignore_index=True)
    data_csv.rename(columns={'name':'track_name'}, inplace=True)
    data_csv.replace('', np.NaN, inplace=True)
    data_csv = data_csv.astype({
        'track_name':'string',
        'loved':'int8',
        'username':'string',
        'album_name':'string',
        'date_uts':'int64',
        'artist_name':'string',
    })
    print(data_csv.dtypes)
    data_csv.to_csv(make_path(f"interaction_{args.user}_{args.ver}.csv"), index=False)

    with open(make_path(f'track2id_{args.user}.pickle'), 'wb') as f:
        pickle.dump(track2id, f, pickle.HIGHEST_PROTOCOL)
    with open(make_path(f'track2artist_{args.user}.pickle'), 'wb') as f:
        pickle.dump(track2artist, f, pickle.HIGHEST_PROTOCOL)
    with open(make_path(f'album2id_{args.user}.pickle'), 'wb') as f:
        pickle.dump(album2id, f, pickle.HIGHEST_PROTOCOL)
    with open(make_path(f'artist2id_{args.user}.pickle'), 'wb') as f:
        pickle.dump(artist2id, f, pickle.HIGHEST_PROTOCOL)
    with open(make_path(f'artist2album_{args.user}.pickle'), 'wb') as f:
        pickle.dump(artist2album, f, pickle.HIGHEST_PROTOCOL)

def multiprocessing_trackinfo():
    global tag2id
    filename = f'./track2artist_{args.user}.pickle' # 위쪽 주석처리하고 여기부터 수집할 수 있도록
    if os.path.isfile(make_path(filename)):
        with open(make_path(filename), 'rb') as f:
            track2artist = pickle.load(f)
        print('track2artist loaded!')
    cpu = 8
    pool = Pool(processes=cpu)
    print(len(track2artist))
    dataframe_list_tmp = pool.map(trackinfo, list_split(list(track2artist.items()), cpu))
    # print(dataframe_list_tmp)
    pool.close()
    pool.join()
    dataframe_list = list(itertools.chain.from_iterable([tmp['dataframe_list'] for tmp in dataframe_list_tmp]))
    tag2id_list = [tmp['tag2id'] for tmp in dataframe_list_tmp]
    tag2id_tmp = set()
    for tag2id_tmpp in tag2id_list:
        tag2id_tmp = tag2id_tmp | tag2id_tmpp
    for id, tag in enumerate(list(tag2id_tmp)):
        tag2id[tag] = id
    trackInfo_csv = pd.concat(dataframe_list, ignore_index=True)
    trackInfo_csv.rename(columns={'name':'track_name', 'tags':'track_tag_list'}, inplace=True)
    trackInfo_csv = trackInfo_csv.astype({
        'track_name':'string',
        # 'url':'string',
        'duration':'int32',
        'listeners':'int32',
        'playcount':'int32',
        'artist_name':'string',
        'artist_url':'string',
        # 'track_tag_list':'object',
        'artist_url':'string',
        'streamable_text':'int8',
        'streamable_fulltrack':'int8'
    })
    trackInfo_csv.to_csv(make_path(f"trackinfo_{args.user}_{args.ver}.csv"), index=False)
    print(trackInfo_csv.dtypes)
    with open(make_path(f'tag2id_{args.user}.pickle'), 'wb') as f:
        pickle.dump(tag2id, f, pickle.HIGHEST_PROTOCOL)

def multiprocessing_albuminfo():
    filename = f'./artist2album_{args.user}.pickle' # 위쪽 주석처리하고 여기부터 수집할 수 있도록
    if os.path.isfile(make_path(filename)):
        with open(make_path(filename), 'rb') as f:
            artist2album = pickle.load(f)
        print('artist2album loaded!')
    cpu = 8
    pool = Pool(processes=cpu)
    print(len(artist2album))
    dataframe_list_tmp = pool.map(albuminfo, list_split(list(artist2album.items()), cpu))
    # print(dataframe_list_tmp)
    pool.close()
    pool.join()
    dataframe_list = list(itertools.chain.from_iterable([tmp['dataframe_list'] for tmp in dataframe_list_tmp]))
    albumInfo_csv = pd.concat(dataframe_list, ignore_index=True)
    albumInfo_csv.rename(columns={'artist':'artist_name', 'name':'album_name'}, inplace=True)
    albumInfo_csv.replace('', np.NaN, inplace=True)
    albumInfo_csv = albumInfo_csv.astype({
        'artist_name':'string',
        'album_name':'string',
        'image':'string',
        'listeners':'int32',
        'playcount':'int32',
        'url':'string',
        'published':'string',
    })
    albumInfo_csv.to_csv(make_path(f"albumInfo_{args.user}_{args.ver}.csv"), index=False)
    print(albumInfo_csv.dtypes)

def multiprocessing_artistinfo():
    filename = f'./artist2id_{args.user}.pickle' # 위쪽 주석처리하고 여기부터 수집할 수 있도록
    if os.path.isfile(make_path(filename)):
        with open(make_path(filename), 'rb') as f:
            artist2id = pickle.load(f)
        print('artist2id loaded!')
    cpu = 8
    pool = Pool(processes=cpu)
    print(len(artist2id))
    dataframe_list_tmp = pool.map(artistinfo, list_split(list(artist2id.items()), cpu))
    # print(dataframe_list_tmp)
    pool.close()
    pool.join()
    dataframe_list = list(itertools.chain.from_iterable([tmp['dataframe_list'] for tmp in dataframe_list_tmp]))
    artistInfo_csv = pd.concat(dataframe_list, ignore_index=True)
    artistInfo_csv = artistInfo_csv[['mbid','name','small','medium','large','extralarge','mega','']]
    artistInfo_csv.to_csv(make_path(f"artist_{args.user}_{args.ver}.csv"), index = False)
    print(artistInfo_csv.dtypes)

def multiprocessing_userinfo():
    cpu = 8
    pool = Pool(processes=cpu)
    print(len(user2id))
    dataframe_list_tmp = pool.map(userinfo, list_split(list(user2id.items()), cpu))
    # print(dataframe_list_tmp)
    pool.close()
    pool.join()
    dataframe_list = list(itertools.chain.from_iterable([tmp['dataframe_list'] for tmp in dataframe_list_tmp]))
    userInfo_csv = pd.concat(dataframe_list, ignore_index=True)
    userInfo_csv.replace('None', np.NaN, inplace=True)
    userInfo_csv.replace('', np.NaN, inplace=True)
    userInfo_csv.rename(columns={'name':'user_name'}, inplace=True)
    userInfo_csv = userInfo_csv.astype({
        'user_name':'string',
        'age':'int',
        'subscriber':'int',
        'realname':'string',
        'bootstrap':'int',
        'playcount':'int',
        'image':'string',
        'realname':'string',
        'registered':'string', # ?
        'country':'string',
        'gender':'int8',
        'url':'string',
    })
    userInfo_csv.to_csv(make_path(f"userInfo_{args.user}_{args.ver}.csv"), index=False)
    print(userInfo_csv.dtypes)

def multiprocessing_taginfo():
    filename = f'./tag2id_{args.user}.pickle' # 위쪽 주석처리하고 여기부터 수집할 수 있도록
    if os.path.isfile(make_path(filename)):
        with open(make_path(filename), 'rb') as f:
            tag2id = pickle.load(f)
        print('tag2id loaded!')
    cpu = 8
    pool = Pool(processes=cpu)
    print(len(tag2id))
    dataframe_list_tmp = pool.map(taginfo, list_split(list(tag2id.items()), cpu))
    # print(dataframe_list_tmp)
    pool.close()
    pool.join()
    dataframe_list = list(itertools.chain.from_iterable([tmp['dataframe_list'] for tmp in dataframe_list_tmp]))
    tagInfo_csv = pd.concat(dataframe_list, ignore_index=True)
    tagInfo_csv.replace('', np.NaN, inplace=True)
    tagInfo_csv = tagInfo_csv.astype({
        'name':'string',
        'total':'int',
        'reach':'int',
    })
    tagInfo_csv.to_csv(make_path(f"tagInfo_{args.user}_{args.ver}.csv"), index=False)
    print(tagInfo_csv.dtypes)

if args.phase == 1:
    multiprocessing_interaction()
else:
    multiprocessing_trackinfo()
    multiprocessing_albuminfo()
    multiprocessing_artistinfo()
    multiprocessing_userinfo()
    multiprocessing_taginfo()