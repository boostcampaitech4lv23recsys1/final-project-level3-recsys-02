from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
import psycopg2
import pandas as pd
from datetime import timezone, datetime

class User(BaseModel):
    id: str
    pwd: str

class userInfo(BaseModel):
    name : str # id
    password: str
    realname : str
    image : str
    country : str
    age : int
    gender : int
    playcount : int
    following : list[str]
    follower : list[str]


app = FastAPI()

@app.post('/login')
def login_user(user:  User) -> userInfo:
    query = f"SELECT password FROM user_info WHERE user_name ='{user.id}';"
    user_df = pd.read_sql(query, db_connect)

    if user.pwd == user_df['password']: 
        return userInfo()
    else:
        return '아이디 비밀번호 불일치'


# insert user_info & inter
@app.post('/signin')
def signin_user(userInfo: userInfo, tags: list[str], artists: list[str]):
    # insert user personal information
    user_query = f"INSERT INTO user_info (user_name, realname, password, age, gender, country, playcount, follower, following) \
            VALUES ('{userInfo.name}', '{userInfo.realname}', '{userInfo.password}', \
                {userInfo.age}, {userInfo.gender}, '{userInfo.country}', \
                {userInfo.playcount}, {userInfo.follower},{ userInfo.following}) \
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

if __name__ == "__main__":
    db_connect = psycopg2.connect(
        user="myuser",
        password="0000",
        host="localhost",
        port=5432,
        database="mydatabase",
    )

    uvicorn.run(app, host="0.0.0.0", port=8001)