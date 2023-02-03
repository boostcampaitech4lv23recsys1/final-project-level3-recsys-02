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
    # username: str
    track_id: int
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
    user_id: int
    user_name: str
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
    user_query = f"SELECT user_id, password FROM user_info WHERE user_name='{user.id}';"
    user_df = pd.read_sql(user_query, db_connect).to_dict()
    print(user_df)
    if (len(user_df) == 0):
        return 'Empty'

    elif user.pwd == user_df['password'][0]: 
        return user_df['user_id'][0]
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

@app.get("/topTracks", description='get top tracks')
def get_top_tracks(tags, artists):
    # 각 태그마다 top 10개 트랙 추출 inter에 넣기
    inters = pd.DataFrame(columns=['track_id', 'track_name', 'url', 'duration','listeners', 'playcount', 'artist_name', 'artist_url', \
                                    'track_tag_list', 'album_name', 'streamable_text', 'streamable_fulltrack'])

    for t in tags:
        tag_query = f"SELECT * FROM track_info WHERE '{t}' = ANY (track_tag_list) ORDER BY playcount LIMIT 10;"
        tag_tracks = pd.read_sql(tag_query, db_connect)
        inters = pd.concat([inters, tag_tracks])

    for a in artists:
        artist = f"'{a}'"
        artist_query = f"SELECT * FROM track_info WHERE artist_name={artist} ORDER BY playcount LIMIT 10;"
        artist_tracks = pd.read_sql(artist_query, db_connect)
        inters = pd.concat([inters, artist_tracks])

    return inters


@app.post('/signin', description='회원가입')
def signin_user(userInfo: userInfo, tags: list, artists: list):

    # 이미 가입한 회원인지 확인
    user_query = f"SELECT user_name FROM user_info WHERE user_name='{userInfo.user_name}';"
    #user_df = pd.read_sql(user_query, db_connect)
    with db_connect.cursor() as cur:
        cur.execute(user_query)
        values = cur.fetchall()
    
    if (len(values)== 0):
        query = 'SELECT max(user_id) AS max_id FROM user_info;'
        with db_connect.cursor() as cur:
            cur.execute(query)
            values = cur.fetchall()[0][0]

        userInfo.user_id = values + 1
        user_query = f"INSERT INTO user_info (user_id, user_name, realname, password, age) \
         VALUES ({int(userInfo.user_id)}, '{userInfo.user_name}', '{userInfo.realname}', '{userInfo.password}', \
             {int(userInfo.age)});"

        with db_connect.cursor() as cur:
            cur.execute(user_query)
        print('get query')
        # tag, artist 별 N개 트랙 inter에 넣기
        user_tracks = get_top_tracks(tags, artists)

        for _, row in user_tracks.iterrows():
            print(row)
            add_interaction(user_id=userInfo.user_id, track_id=row['track_id'])

            db_connect.commit()
            return "True"
        else:
            return "False"
    # 해당 이름이 이미 존재하는 경우
    else:
        return "False"


@app.get("/users/{user_id}/profiles", description="사용자 정보")
def get_profiles(user_id: int) -> userInfo:
    user_query = f"SELECT user_id FROM user_info WHERE user_id={user_id};"
    user_df = pd.read_sql(user_query, db_connect)
    if (user_df.shape[0] == 0):
        return 'None'
    else:
        info = userInfo(
                user_id=user_df['user_id'],                
                user_name=user_df['user_name'],
                password=user_df['password'],
                realname =user_df['realname'],
                image =user_df['image'],
                age =user_df['age'],
                playcount =user_df['playcount'],
                following = user_df['following'],
                follower = user_df['follower'])

    return info



@app.get("/users/{user_id}/likes", description="좋아요 리스트")
def get_likes(user_id: int):  # -> track name
    query = f"""select distinct track_info.track_name,
    track_info.album_name, track_info.artist_name, track_info.duration, 
    album_info.image from track_info left outer join inter on 
    track_info.track_id = inter.track_id left outer 
    join album_info on inter.album_name = album_info.album_name 
    where (inter.user_id = {user_id} and inter.loved = 1);
    """
    with db_connect.cursor() as cur:
        cur.execute(query)
        values = cur.fetchall()

    return values



@app.get("/interaction/{user_id}/{track_id}/0", description='click interaction')
def add_interaction(user_id: int, track_id: int):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())

    query = f"INSERT INTO inter (track_id, loved, user_id, date_uts)\
             VALUES ({track_id}, 0, {user_id}, {timestamp});"
    query2 = f"update track_info set playcount = playcount+1 where track_id = {track_id};"
    with db_connect.cursor() as cur:
        cur.execute(query)
        cur.execute(query2)
        db_connect.commit()

    return "Success"


@app.get("/interaction/{user_id}/{track_id}/1", description='like interaction')
def add_like(user_id: int, track_id: int):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())

    query = f"INSERT INTO inter (track_id, loved, user_id, date_uts)\
             VALUES ({track_id}, 1, {user_id}, {timestamp});"
    with db_connect.cursor() as cur:
        cur.execute(query)
        db_connect.commit()

    return "Success"

@app.get("/interaction/{user_id}/{track_id}/2", description='delete interaction')
def add_delete(user_id: int, track_id: int):
    timestamp = int(datetime.now().replace(tzinfo=timezone.utc).timestamp())

    query = f"update inter set loved = 0 where user_id = {user_id} and track_id = {track_id};"
    with db_connect.cursor() as cur:
        cur.execute(query)
        db_connect.commit()

    return "Success"


@app.get("/follow/{user_A}/{user_B}", description='user_A follows user_B')
def add_follow(user_A: int, user_B: int):
    query = f"update user_info set follower = array_append(follower, {user_A}) where user_id = {user_B};"
    query2= f"update user_info set following = array_append(following, {user_B}) where user_id = {user_A};"
    with db_connect.cursor() as cur:
        cur.execute(query2)
        cur.execute(query)
        db_connect.commit()

    return "Success"

@app.get("/unfollow/{user_A}/{user_B}", description='user_A unfollows user_B')
def add_unfollow(user_A: int, user_B: int):
    query = f"update user_info set following = array_remove(following, {user_B}) where user_id = {user_A};"
    query2 = f"update user_info set following = array_remove(follower, {user_A}) where user_id = {user_B};"
    with db_connect.cursor() as cur:
        cur.execute(query2)
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
