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
    name: str  # id
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


@app.post('/login', description='로그인')
def login_user(user: User) -> userInfo:
    query = f"SELECT password FROM user_info WHERE user_name ='{user.id}';"
    user_df = pd.read_sql(query, db_connect)

    if user.pwd == user_df['password']: 
        return userInfo(
            name=user_df['name'],
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
            VALUES ('{userInfo.name}', '{userInfo.realname}', '{userInfo.password}', \
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
                VALUES ('{userInfo.name}', '{ut['track_name']}', '{ut['album_name']}', '{ut['artist_name']}', {timestamp}, 0)\
                RETURNING success;"
    response2 = pd.read_sql(inter_query, db_connect)

    return response1 and response2


@app.get("/users/{user_id}/profiles", description="사용자 정보")
async def get_profiles(user_id: str):
    get_sample = f"""
        select * from user_info where name = '{user_id}'
    ;"""

    with db_connect.cursor() as cur:
        cur.execute(get_sample)
        values = cur.fetchall()[0]

    info = userInfo()
    info.name = values[0]
    info.realname = values[2]
    info.following = values[10]
    info.follower = values[11]
    info.open = values[-1]

    return info


@app.get("/users/{user_id}/likes", description="좋아요 리스트")
async def get_likes(user_id: str):
    get_sample = f"""
        select track_name from inter where (user_id = '{user_id}' and loved = 1)
    ;"""

    with db_connect.cursor() as cur:
        cur.execute(get_sample)
        likes = cur.fetchall()

    get_sample = f"""
        select track_name from inter where (user_id = '{user_id}' and loved = 2)
    ;"""

    with db_connect.cursor() as cur:
        cur.execute(get_sample)
        unlikes = cur.fetchall()

    return list(set(likes) - set(unlikes))


@app.post("/users/{user_id}/profiles", description='내 정보, 프로필, 공개 여부,..')
def get_user_info(input: userInfo):
    user_name = input.name
    query = f"SELECT * FROM user_info WHERE name=\'{user_name}\'"
    df = pd.read_sql(query, db_connect)
    if df.shape[0] == 0:
        return NAME_NOT_FOUND
    else:
        return df


@app.put("/users/{user_id}/likes/{track_name}", description='좋아요 목록')
def add_interaction(input_1: userInfo, input_2: trackInfo, option: ops):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())
    if input_1.authentication == -1:
        return AuthError()
    else:
        query = f"INSERT INTO inter (track_name, loved, username, album_name, date_uts, artist_name)\
                 VALUES ('{change_str(input_2.track_name)}', {option.option}, '{input_1.name}', '{change_str(input_2.album_name)}', {timestamp}, '{input_2.artist_name}');"
        with db_connect.cursor() as cur:
            cur.execute(query)
            return "Success"
        return "False"

if __name__ == "__main__":
    db_connect = psycopg2.connect(
        user="myuser",
        password="mypassword",
        host="localhost",
        port=5432,
        database="mydatabase",
    )

    uvicorn.run(app, host="0.0.0.0", port=8001)
