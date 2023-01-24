import pandas as pd
import psycopg2
from fastapi import FastAPI, HTTPException
from sqlalchemy import Column, Integer, String, Text, DateTime
from pydantic import BaseModel

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

# PK class


class Album_info(BaseModel):
    album_name: str
    artist_name: str

class Track_info(BaseModel):
    track_name: str
    album_name: str
    artist_name: str

class User_name_auth(BaseModel):
    User_name: str
    authentication: bool


# 내 정보, 프로필, 공개여부,..
@app.post("/users/{user_id}/profiles")
def get_User_info(input: User_name_auth):
    user_name = input.User_name
    authentication = input.authentication  # True = my info, False, others
    query = f"SELECT * FROM user_info WHERE name=\'{user_name}\'"
    df = pd.read_sql(query, db_connect)
    if authentication == False:
        return df
    else:
        return df


@app.put("/users/{user_id}/likes/{track_name}")
def remove_likes(input_1: User_name_auth, input_2: Track_info, ops: bool):
    if input_1.authentication == False:
        AuthError()
    else:
        query = f"select * from inter where user_id=\'{input_1.User_name}\'"
        query_append = f"and where artist_name={input_2.artist_name} and where track_name={input_2.track_name} and where album_name={input_2.album_name}"
        # query += query_append
        with db_connect.cursor() as cur:
            cur.execute(query)
            if ops:
                return "Add success"
            else:
                return "Delete success"



# 앨범 정보 및 트랙 정보 가져오기
@app.post("/users/{albumid}")
def get_album(input: Album_info):
    df_album = pd.read_sql(
        f"(select * from album_info where album_name=\'{input.album_name}\')\
        union(select *\
        from album_info where\
        artist_name = \'{input.artist_name}\');",
        db_connect)

    if df_album.shape[0] == 0:
        return_albums = {}
    else:
        return_albums = {
            'album_name': df_album['album_name'][0],
            'artist_name': df_album['artist_name'][0],
            'published': df_album['published'][0],
            'url': df_album['url'][0],
            'tags': df_album['tags'][0],
        }

    artist_name = df_album['artist_name']
    query = f"SELECT * FROM track_info WHERE album_name=\'{input.album_name}\' and artist_name=\'{input.artist_name}\';"
    df_tracks = pd.read_sql(query, db_connect)

    if df_tracks.shape[0] == 0:
        return_tracks = {}
    else:
        return_tracks = {str(i): {
            "track_name": df_tracks['track_name'][i],
            "album_name": df_tracks['album_name'][i],
            "artist_name": df_tracks['artist_name'][i],
            "track_tag_list": df_tracks['track_tag_list'][i],
            "url": df_tracks['url'][i],
            "playcount": df_tracks['playcount'][i].astype(str),
            "listeners": df_tracks['listeners'][i].astype(str),
            "streamable_text": df_tracks['streamable_text'][i].astype(str),
            "duration": df_tracks['duration'][i].astype(str)

        } for i in range(df_tracks.shape[0])}

    return_val = {"album_info": return_albums, "track_info": return_tracks}
    return return_val
