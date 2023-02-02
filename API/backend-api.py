from fastapi import FastAPI
import uvicorn
import pandas as pd
import psycopg2
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime, timezone
import json

app = FastAPI()

# Fail response
NAME_NOT_FOUND = HTTPException(status_code=400, detail="Name not found.")
TRACK_NOT_FOUND = HTTPException(status_code=400, detail="Track not found.")
AuthError = HTTPException(status_code=400, detail="not auth user")

def change_str(a):
    return a.replace('\'', '')

class trackInfo(BaseModel):
    username: str
    track_name: str
    album_name: str
    artist_name: str
    duration: int
    date_uts: int
    loved: int


class ops(BaseModel):
    option: int


class User(BaseModel):
    id: str
    pwd: str


class userInfo(BaseModel):
    user_name: str  # id
    password: str
    realname: str
    image: str
    age: int
    playcount: int
    following: object
    follower: object

@app.get('/user')
def get_user_table():
    query = f"SELECT * FROM user_info;"
    test = pd.read_sql(query, db_connect)
    print(test)
    return test.to_string()


@app.get('/track')
def get_track_table():
    query = f"SELECT * FROM track_info;"
    return pd.read_sql(query, db_connect)


@app.post('/login', description='로그인')
def login_user(user: User) -> str:
    user_query = f"SELECT user_name, password FROM user_info WHERE user_name='{user.id}';"
    user_df = pd.read_sql(user_query, db_connect)
    print (user_df)
    if (len(user_df) == 0):
        return 'Empty'
    elif user.pwd == user_df['password'][0]: 
        return user_df['user_name'][0]
    else:
        return 'Empty'

@app.get('/signin/artists')
def get_artists():
    artist_query = f"SELECT DISTINCT artist_name, artist_url FROM track_info ORDER BY artist_name;"
    artist_df = pd.read_sql(artist_query, db_connect)
    return artist_df.to_dict('records')

def list2array(list_data):
    tmp = ''
    for d in list_data:
        tmp += f'"{d}",'
    return tmp[:-1]

@app.get("/topTracks", description='get top trakcs')
def getTopTracks(tags, artists):
    # 각 태그마다 top 10개 트랙 추출 inter에 넣기
    # tags = ['indie', 'pop', 'jazz']
    # artists = ['Coldplay']
    inters = pd.DataFrame(columns=['track_name', 'url', 'duration','listeners', 'playcount', 'artist_name', 'artist_url', \
                                    'track_tag_list', 'album_name', 'streamable_text', 'streamable_fulltrack'])
    for t in tags:
        tag = f'"{t}"'
        tag_query = f"SELECT * FROM track_info WHERE track_tag_list && '{{{tag}}}' ORDER BY playcount LIMIT 10;"
        print(tag_query)
        tag_tracks = pd.read_sql(tag_query, db_connect)
        pd.concat([inters,tag_tracks], ignore_index=True)
  
    # 각 태그마다 top 10개 트랙 추출 inter에 넣기
    for a in artists:
        artist = f"'{a}'"
        artist_query = f"SELECT * FROM track_info WHERE artist_name={artist} ORDER BY playcount LIMIT 10;"
        print(artist_query)
        artist_tracks = pd.read_sql(artist_query, db_connect)
        print(artist_tracks)
        pd.concat([inters,artist_tracks], ignore_index=True)

    print(inters.shape)

    # # 중복제거 -> shuffle
    inters.drop_duplicates(inplace=True)
    inters = inters.sample(frac=1)

    print(inters)

    return inters

@app.post('/signin', description='회원가입')
def signin_user(userInfo: userInfo, tags: list, artists: list):
    # print(userInfo)
    # print(tags)
    # print(artists)

    # 이미 가입한 회원인지 확인
    user_query = f"SELECT user_name FROM user_info WHERE user_name='{userInfo.user_name}';"
    user_df = pd.read_sql(user_query, db_connect)

    if (user_df.shape[0] == 0):
        following = list2array(userInfo.following)
        follower = list2array(userInfo.follower)
        #user information : user_name, realname, password, age, playcount, follower, following
        user_query = f"INSERT INTO user_info (user_name, realname, password, age, playcount, follower, following) \
                VALUES ('{userInfo.user_name}', '{userInfo.realname}', '{userInfo.password}', \
                    {userInfo.age}, 0, '{{{follower}}}','{{{following}}}') \
                RETURNING user_name;"

        response1 = pd.read_sql(user_query, db_connect).all()

        # interaction : user_name, track_name, album_name, artist_name, timestamp(uts), loved(int)
        # tag, artist 별 N개 트랙 inter에 넣기
        timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())
        user_tracks = getTopTracks(tags, artists)
        print("usertrack\n", user_tracks)
        
        for _, row in user_tracks.iterrows():
            inter_query = f"INSERT INTO inter (user_name, track_name, album_name, artist_name, date_uts, loved) \
                    VALUES ('{userInfo.user_name}', '{row['track_name']}', '{row['album_name']}', '{row['artist_name']}', {timestamp}, 0)\
                    RETURNING user_name;"
            response2 = pd.read_sql(inter_query, db_connect)
            print(response2['user_name'])

        if response1['user_name']:
            db_connect.commit()
            return "True"
        else:
            return "False"
    # 해당 이름이 이미 존재하는 경우
    else:   
        return "False"

@app.get("/users/{user_id}/profiles", description="사용자 정보")
def get_profiles(user_id: str):

    query = f"""
        select * from user_info where user_name = '{user_id}'
    ;"""

    with db_connect.cursor() as cur:
        cur.execute(query)
        values = list(cur.fetchall()[0])
    print(values)
    for index, i in enumerate(values):
        if values[index] == None:
            if index == 0 or index == 3 or index == 6 or index == 8 or index == 10 or index == 13:
                values[index] = 'None'
            elif index == 11 or index == 12:
                values[index] = []
            else:
                values[index] = -1

    info = userInfo(user_name=values[0],
            password=values[13],
            realname =values[3],
            image =values[6],
            age =values[1],
            playcount =values[5],
            following = values[11],
            follower = values[12],
            result='success')

    return info


@app.get("/users/{user_name}/likes", description="좋아요 리스트")
def get_likes(user_name: str):
    query = f"""select distinct inter.track_name,
    inter.album_name, track_info.artist_name, track_info.duration, 
    album_info.image from track_info left outer join inter on 
    track_info.track_name = inter.track_name left outer 
    join album_info on inter.album_name = album_info.album_name 
    where (inter.user_name = '{user_name}' and inter.loved = 1)
    ;"""
    with db_connect.cursor() as cur:
        cur.execute(query)
        values = cur.fetchall()

    return values


@app.get("/interaction/{user_id}/{albumInfo}/{artistInfo}/{trackName}/0", description='click interaction')
def add_interaction(user_id: str, albumInfo: str, artistInfo: str, trackName: str):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())
    print(albumInfo, artistInfo, trackName)
    query = f"INSERT INTO inter (track_name, loved, user_name, album_name, date_uts, artist_name)\
             VALUES ('{change_str(trackName)}', 0, '{user_id}', '{albumInfo}', {timestamp}, '{artistInfo}');"
    query2 = f"update track_info set playcount = playcount+1 where album_name = '{albumInfo}' and track_name = '{trackName}' and artist_name = '{artistInfo}'"
    with db_connect.cursor() as cur:
        cur.execute(query)
        cur.execute(query2)
        db_connect.commit()

    return "Success"


@app.get("/interaction/{user_id}/{albumInfo}/{artistInfo}/{trackName}/1", description='like interaction')
def add_like(user_id: str, albumInfo: str, artistInfo: str, trackName: str):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())
    print(albumInfo, artistInfo, trackName)
    query = f"INSERT INTO inter (track_name, loved, user_name, album_name, date_uts, artist_name)\
             VALUES ('{change_str(trackName)}', 1, '{user_id}', '{albumInfo}', {timestamp}, '{artistInfo}');"
    with db_connect.cursor() as cur:
        cur.execute(query)
        db_connect.commit()

    return "Success"


@app.get("/interaction/{user_id}/{albumInfo}/{artistInfo}/{trackName}/2", description='delete interaction')
def add_delete(user_id: str, albumInfo: str, artistInfo: str, trackName: str):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())
    print(albumInfo, artistInfo, trackName)
    query = f"update inter set loved = 0 where user_name = '{user_id}' and album_name = '{albumInfo}' and track_name = '{trackName}' and artist_name = '{artistInfo}' and loved = 1"
    with db_connect.cursor() as cur:
        cur.execute(query)
        db_connect.commit()

    return "Success"

if __name__ == "__main__":
    db_connect = psycopg2.connect(
        user="myuser",
        password="mypassword",
        host="34.64.50.61",
        port=5432,
        database="mydatabase",
    )

    uvicorn.run(app, host="0.0.0.0", port=8001)