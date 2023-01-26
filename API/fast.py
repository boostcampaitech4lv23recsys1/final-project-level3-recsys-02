import pandas as pd
import psycopg2
from fastapi import FastAPI, HTTPException
from sqlalchemy import Column, Integer, String, Text, DateTime
from pydantic import BaseModel
from datetime import datetime, timezone
app = FastAPI()

# Fail response
NAME_NOT_FOUND = HTTPException(status_code=400, detail="Name not found.")
TRACK_NOT_FOUND = HTTPException(status_code=400, detail="Track not found.")
AuthError = HTTPException(status_code=400, detail="not auth user")


db_connect = psycopg2.connect(
    user="mloops",
    password="password!",
    host="localhost",
    port=5431,
    database="music",
)

def change_str(a):
    return a.replace('\'', '')


# PK class


class Track_info(BaseModel):
    track_name: str
    loved: int
    username: str
    album_name: str
    date_uts: int
    artist_name: str


class ops(BaseModel):
    option: str


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

# 내 정보, 프로필, 공개 여부,..
@app.post("/users/{user_id}/profiles")
def get_User_info(input: userInfo):
    user_name = input.name
    query = f"SELECT * FROM user_info WHERE name=\'{user_name}\'"
    df = pd.read_sql(query, db_connect)
    if df.shape[0] == 0:
        return NAME_NOT_FOUND
    else:
        return df


# 좋아요 목록
@app.put("/users/{user_id}/likes/{track_name}")
def add_interaction(input_1: userInfo, input_2: Track_info, option: ops):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())
    if input_1.authentication == -1:
        AuthError
    else:
        query = f"INSERT INTO inter (track_name, loved, username, album_name, date_uts, artist_name)\
                 VALUES ('{change_str(input_2.track_name)}', {option.option}, '{input_1.name}', '{change_str(input_2.album_name)}', {timestamp}, '{input_2.artist_name}');"

        with db_connect.cursor() as cur:
            cur.execute(query)
            return "Success"


# 앨범 정보 및 트랙 정보 가져 오기
# @app.post("/users/{albumid}")
# def get_album(input: Album_info):
#     df_album = pd.read_sql(
#         f"(select * from album_info where album_name='{input.album_name}')\
#         union(select *\
#         from album_info where\
#         artist_name = '{input.artist_name}');",
#         db_connect,
#     )
#
#     if df_album.shape[0] == 0:
#         return_albums = {}
#     else:
#         return_albums = {
#             "album_name": df_album["album_name"][0],
#             "artist_name": df_album["artist_name"][0],
#             "published": df_album["published"][0],
#             "url": df_album["url"][0],
#             "tags": df_album["tags"][0],
#         }
#
#     artist_name = df_album["artist_name"]
#     query = f"SELECT * FROM track_info WHERE album_name='{input.album_name}' and artist_name='{input.artist_name}';"
#     df_tracks = pd.read_sql(query, db_connect)
#
#     if df_tracks.shape[0] == 0:
#         return_tracks = {}
#     else:
#         return_tracks = {
#             str(i): {
#                 "track_name": df_tracks["track_name"][i],
#                 "album_name": df_tracks["album_name"][i],
#                 "artist_name": df_tracks["artist_name"][i],
#                 "track_tag_list": df_tracks["track_tag_list"][i],
#                 "url": df_tracks["url"][i],
#                 "playcount": df_tracks["playcount"][i].astype(str),
#                 "listeners": df_tracks["listeners"][i].astype(str),
#                 "streamable_text": df_tracks["streamable_text"][i].astype(str),
#                 "duration": df_tracks["duration"][i].astype(str),
#             }
#             for i in range(df_tracks.shape[0])
#         }
#
#     return_val = {"album_info": return_albums, "track_info": return_tracks}
#     return return_val
