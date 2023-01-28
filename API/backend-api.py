from fastapi import FastAPI
import uvicorn
import pandas as pd
import psycopg2
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime, timezone

app = FastAPI()

# Fail response
NAME_NOT_FOUND = HTTPException(status_code=400, detail="Name not found.")
TRACK_NOT_FOUND = HTTPException(status_code=400, detail="Track not found.")
AuthError = HTTPException(status_code=400, detail="not auth user")

def change_str(a):
    return a.replace('\'', '')

class trackInfo(BaseModel):
    track_name: str
    loved: int
    username: str
    album_name: str
    date_uts: int
    artist_name: str


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
    country: str
    age: int
    gender: int
    playcount: int
    following: list
    follower: list
    result: str


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
def login_user(user: User) -> userInfo:
    query = f"SELECT password FROM user_info WHERE user_name ='{user.id}';"
    user_df = pd.read_sql(query, db_connect)

    if user.pwd == user_df['password']: 
        return userInfo(
            user_name=user_df['user_name'],
            password=user_df['password'],
            realname =user_df['realname'],
            image =user_df['image'],
            country =user_df['country'],
            age =user_df['age'],
            gender =user_df['gender'],
            playcount =user_df['playcount'],
            following =user_df['following'],
            follower =user_df['follower'],
            result='success')
    else:
        return userInfo(result='fail')


@app.post('/signin', description='회원가입')
def signin_user(userInfo: userInfo, tags: list, artists: list):
    # insert user personal information
    user_query = f"INSERT INTO user_info (user_name, realname, password, age, gender, country, playcount, follower, following) \
            VALUES ('{userInfo.user_name}', '{userInfo.realname}', '{userInfo.password}', \
                {userInfo.age}, {userInfo.gender}, '{userInfo.country}', \
                {userInfo.playcount}, {userInfo.follower},{userInfo.following}) \
            RETURNING success;"
    response1 = pd.read_sql(user_query, db_connect)

    # interaction : user_name, track_name, album_name, artist_name, timestamp(uts), loved(int)
    # tag 별 N개 트랙 inter에 넣기
    N = 10
    # 선택한 태그를 포함하는 경우의 track들을 줄 세우고, playcount을 기준으로 높은 거 N개
    # tag_string = ", ".join(tags)
    # tag_query = f"SELECT * FROM track_info \
    #             WHERE tags IN ({tag_string})\
    #             ORDER BY playcount \
    #             LIMIT {N};"
    # tag_tracks = pd.read_sql(tag_query, db_connect)
    # print(tag_tracks)

    # 아티스트별 N개 트랙 inter에 넣기
    artist_string = ", ".join(artists)
    artist_query = f"SELECT * FROM track_info \
                WHERE artist_name IN ({artist_string})\
                ORDER BY playcount\
                LIMIT {N};"
    artist_tracks = pd.read_sql(artist_query, db_connect)
    print(artist_tracks)

    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())

    # user_tracks = pd.concat(tag_tracks, artist_tracks)
    user_tracks = artist_tracks
    for ut in user_tracks:
        inter_query = f"INSERT INTO user_info (user_name, track_name, album_name, artist_name, timestamp_uts, loved) \
                VALUES ('{userInfo.user_name}', '{ut['track_name']}', '{ut['album_name']}', '{ut['artist_name']}', {timestamp}, 0)\
                RETURNING success;"
    response2 = pd.read_sql(inter_query, db_connect)
    
    return response1 and response2


@app.get("/users/{user_id}/profiles", description="사용자 정보")
def get_profiles(user_id: str):

    query = f"""
        select * from user_info where user_name = '{user_id}'
    ;"""

    with db_connect.cursor() as cur:
        cur.execute(query)
        values = list(cur.fetchall()[0])
    
    for index, i in enumerate(values):
        if values[index] == None:
            if index == 0 or index == 3 or index == 10 or index == 12 or index == 14 or index == 17:
                values[index] = 'None'
            elif index == 15 or index == 16:
                values[index] = []
            else:
                values[index] = -1

    info = userInfo(user_name=values[0],
            password=values[17],
            realname =values[3],
            image =values[10],
            country =values[12],
            age =values[1],
            gender =values[13],
            playcount =values[5],
            following =values[15],
            follower =values[16],
            result='success')

    return info


@app.get("/users/{user_name}/likes", description="좋아요 리스트")
def get_likes(user_name: str):
    query = f"""select distinct inter.track_name, 
    inter.album_name, track_info.artist_name, track_info.duration, 
    album_info.image from track_info left outer join inter on 
    track_info.track_name = inter.track_name left outer 
    join album_info on inter.album_name = album_info.album_name 
    where (inter.user_name = '{user_name}' and inter.loved = 0)
    ;"""
    with db_connect.cursor() as cur:
        cur.execute(query)
        values = cur.fetchall()

    return values

@app.put("/users/{user_name}/likes/{track_name}", description='인터렉션 추가, 좋아요 추가, 삭제')
def add_interaction(input_1: userInfo, input_2: trackInfo, option: ops):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())
    if input_1.authentication == -1:
        return AuthError()
    else:
        query = f"INSERT INTO inter (track_name, loved, username, album_name, date_uts, artist_name)\
                 VALUES ('{change_str(input_2.track_name)}', {option.option}, '{input_1.user_name}', '{change_str(input_2.album_name)}', {timestamp}, '{input_2.artist_name}');"
        with db_connect.cursor() as cur:
            cur.execute(query)
            return "Success"

if __name__ == "__main__":
    db_connect = psycopg2.connect(
        user="myuser",
        password="mypassword",
        host="localhost",
        port=5432,
        database="mydatabase",
    )

    uvicorn.run(app, host="0.0.0.0", port=8001)