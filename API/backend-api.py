from fastapi import FastAPI
import uvicorn
import pandas as pd
import psycopg2
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from datetime import datetime, timezone
from typing import Optional
import datetime
from random import randint

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
    track_name: Optional[str]
    album_name: Optional[str]
    artist_name: Optional[str]
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
    user_name: Optional[str]
    password: Optional[str]
    realname: Optional[str]
    image: Optional[str]
    age: Optional[int]
    playcount: Optional[int]
    following: object
    follower: object

@app.get('/user')
def get_user_table():
    query = f"SELECT * FROM user_info;"
    test = pd.read_sql(query, db_connect)
    #print(test)
    return test.to_string()

@app.get('/get_search_track/{track}', description='트랙 검색 리스트 생성')
def get_search_track(track: str):
    query = ''
    if track == '-1':
        query = f"SELECT track_id, track_name, artist_name FROM track_info LIMIT 10;"
    else:
        query = f"SELECT track_id, track_name, artist_name FROM track_info WHERE track_name LIKE'%{track}%';"
    track_df = pd.read_sql(query, db_connect)
    return track_df.to_dict('records')  

# 특정 트랙 정보 가져오기
@app.get('/get_track_detail/{track_id}', description='트랙 정보 가져오기')
def get_track_detail(track_id: int):
    query = f"SELECT * FROM track_info WHERE track_id={track_id};"
    track_df = pd.read_sql(query, db_connect)
    return track_df.to_dict('records')  


@app.post('/login', description='로그인')
def login_user(user: User) -> str:
    user_query = f"SELECT user_id, password FROM user_info WHERE user_name='{user.id}';"
    user_df = pd.read_sql(user_query, db_connect).to_dict()
    #print(user_df)
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

@app.get("/signin/inters", description='get new interaction tracks')
def get_new_inters(tags, artists):
    # 각 태그마다 top 10개 트랙 추출 inter에 넣기
    inters = pd.DataFrame(columns=['track_id', 'track_name', 'url', 'duration','listeners', 'playcount', 'artist_name', 'artist_url', \
                                    'track_tag_list', 'album_name', 'streamable_text', 'streamable_fulltrack'])

    for t in tags:
        tag_query = f"SELECT * FROM track_info WHERE '{t}' = ANY (track_tag_list) ORDER BY playcount desc LIMIT 10;"
        tag_tracks = pd.read_sql(tag_query, db_connect)
        inters = pd.concat([inters, tag_tracks])

    for a in artists:
        artist = f"'{a}'"
        artist_query = f"SELECT * FROM track_info WHERE artist_name={artist} ORDER BY playcount desc LIMIT 10;"
        artist_tracks = pd.read_sql(artist_query, db_connect)
        inters = pd.concat([inters, artist_tracks])

    return inters


@app.post('/signin', description='회원가입')
def signin_user(userInfo: userInfo, tags: list, artists: list):

    # 이미 가입한 회원인지 확인
    user_query = f"SELECT user_name FROM user_info WHERE user_name='{userInfo.user_name}';"
    #user_df = pd.read_sql(user_query, db_connect)
    #print(userInfo)
    with db_connect.cursor() as cur:
        cur.execute(user_query)
        values = cur.fetchall()
    
    if (len(values)== 0):
        query = 'SELECT max(user_id) AS max_id FROM user_info;'
        with db_connect.cursor() as cur:
            cur.execute(query)
            values = cur.fetchall()[0][0]

        userInfo.user_id = values + 1

        user_query = f"INSERT INTO user_info (user_id, user_name, realname, password, age, following, follower, playcount, image) \
         VALUES ({userInfo.user_id}, '{userInfo.user_name}', '{userInfo.realname}', '{userInfo.password}', \
             {userInfo.age}, '{{}}', '{{}}', 0, '{userInfo.image}');"

        with db_connect.cursor() as cur:
            cur.execute(user_query)
        
        # tag, artist 별 N개 트랙 inter에 넣기
        user_tracks = get_new_inters(tags, artists)

        for _, row in user_tracks.iterrows():
            #print(row)
            add_interaction(user_id=userInfo.user_id, track_id=row['track_id'], album_name=row['album_name'])

        db_connect.commit()
        return "True"
    # 해당 이름이 이미 존재하는 경우
    else:
        return "False"


@app.get("/users/{user_id}/profiles", description="사용자 정보")
def get_profiles(user_id: int) -> userInfo:
    user_query = f"SELECT * FROM user_info WHERE user_id={user_id};"
    user_df = pd.read_sql(user_query, db_connect).to_dict()
    #print(user_df)
    if (len(user_df) == 0):
        return 'None'
    else:
        if(user_df['playcount'][0] == None):
            user_df['playcount'][0] = 0
        if(user_df['image'][0] == None):
            user_df['image'][0] = 'assets/profile2.png'
        if(user_df['following'][0] == None):
            user_df['following'][0] = []
        if(user_df['follower'][0] == None):
            user_df['follower'][0] = []
        info = userInfo(
                user_id=user_df['user_id'][0],                
                user_name=user_df['user_name'][0],  
                password=user_df['password'][0], 
                realname =user_df['realname'][0],  
                image =user_df['image'][0],  
                age =user_df['age'][0],
                playcount =user_df['playcount'][0],  
                following = user_df['following'][0],  
                follower = user_df['follower'][0])

    return info


@app.get("/users/{user_id}/likes", description="좋아요 리스트")
def get_likes(user_id: int):  # -> track name
    query = f"""select distinct track_info.track_id, track_info.track_name,
    track_info.album_name, track_info.artist_name, track_info.duration, 
    album_info.image, track_info.url  from track_info left outer join inter on 
    track_info.track_id = inter.track_id left outer 
    join album_info on inter.album_name = album_info.album_name 
    where (inter.user_id = {user_id} and inter.loved = 1);
    """
    with db_connect.cursor() as cur:
        cur.execute(query)
        values = cur.fetchall()

    return values



@app.get("/interaction/{user_id}/{track_id}/{album_name}/0", description='click interaction')
def add_interaction(user_id: int, track_id: int, album_name: str):
    timestamp = int(datetime.datetime.now().replace(tzinfo=timezone.utc).timestamp())
    try:
        album_name = album_name.replace('\'', '')
    except:
        pass
    query = f"INSERT INTO inter (track_id, loved, user_id, date_uts, album_name)\
             VALUES ({track_id}, 0, {user_id}, {timestamp}, '{album_name}');"
    query2 = f"update track_info set playcount = playcount+1 where track_id = {track_id};"

    with db_connect.cursor() as cur:
        cur.execute(query)
        cur.execute(query2)
        db_connect.commit()

    return "Success"


@app.get("/interaction/{user_id}/{track_id}/{album_name}/1", description='like interaction')
def add_like(user_id: int, track_id: int, album_name: str):
    timestamp = int(datetime.datetime.now().replace(tzinfo=timezone.utc).timestamp())
    try:
        album_name = album_name.replace('\'', '')
    except:
        pass
    query = f"INSERT INTO inter (track_id, loved, user_id, date_uts, album_name)\
             VALUES ({track_id}, 1, {user_id}, {timestamp}, '{album_name}');"
    with db_connect.cursor() as cur:
        cur.execute(query)
        db_connect.commit()

    return "Success"

@app.get("/interaction/{user_id}/{track_id}/2", description='delete interaction')
def add_delete(user_id: int, track_id: int):
    # timestamp = int(datetime.datetime.now().replace(tzinfo=timezone.utc).timestamp())

    query = f"update inter set loved = 0 where user_id = {user_id} and track_id = {track_id};"
    with db_connect.cursor() as cur:
        cur.execute(query)
        db_connect.commit()

    return "Success"


@app.get("/follow/{user_A}/{user_B}", description='user_A follows user_B')
def add_follow(user_A: int, user_B: int):
    query = f"""
    UPDATE user_info 
    SET following = CASE WHEN CAST({user_B} AS BIGINT) = ANY(following) THEN following ELSE ARRAY_APPEND(following, CAST({user_B} AS BIGINT)) END
    WHERE user_id = {user_A};"""

    query2 = f"""UPDATE user_info 
    SET follower = CASE WHEN CAST({user_A} AS BIGINT) = ANY(follower) THEN follower ELSE ARRAY_APPEND(follower, CAST({user_A} AS BIGINT)) END
    WHERE user_id = {user_B}"""

    query3 = f"update user_info set following = array_remove(following, {user_A}) where user_id = {user_A};"
    query4 = f"update user_info set follower = array_remove(follower, {user_B}) where user_id = {user_B};"

    with db_connect.cursor() as cur:
        cur.execute(query2)
        cur.execute(query)
        cur.execute(query3)
        cur.execute(query4)
        db_connect.commit()

    return "Success"

@app.get("/unfollow/{user_A}/{user_B}", description='user_A unfollows user_B')
def add_unfollow(user_A: int, user_B: int):
    query = f"update user_info set following = array_remove(following, {user_B}) where user_id = {user_A};"
    query2 = f"update user_info set follower = array_remove(follower, {user_A}) where user_id = {user_B};"
    with db_connect.cursor() as cur:
        cur.execute(query2)
        cur.execute(query)
        db_connect.commit()

    return "Success"

@app.get("/toptrack", description="daily Top tracks")
def get_top_tracks():
    now = datetime.datetime.now().timestamp()
    now = 1674831129
    dailysec = 86400
    query = f"select * from inter where date_uts >= {now - 2 * dailysec} and date_uts <= {now - dailysec};"
    df = pd.read_sql(query, db_connect)

    if df.shape[0] == 0:
        return {}
    else:
        df = (
            df.groupby(by=["track_id"], as_index=False)["loved"]
            .count()
            .sort_values(by=["loved"], ascending=False)
        )
        list_ = df["track_id"][:20].to_list()
        list_to_str = "(" + ",".join([str(i) for i in list_]) + ")"
        # print(list_to_str)
        query = f"""select distinct track_info.track_id, track_info.track_name,
                    track_info.album_name, track_info.artist_name, track_info.duration, 
                    track_info.url ,album_info.image from track_info left outer join inter on 
                    track_info.track_id = inter.track_id left outer 
                    join album_info on inter.album_name = album_info.album_name 
                    where (inter.track_id in  {list_to_str});
                    """

        with db_connect.cursor() as cur:
            cur.execute(query)
            values = cur.fetchall()
        a = []
        name = []
        for i in values:
            i = list(i)
            if i[1] not in name:
                name.append(i[1])
                if i[-1] == None:
                    ran = randint(0,4)
                    i[-1] = f"assets/album{ran}.png"
                for j in range(1,4):
                    if i[j] == None:
                        i[j] = '-'
                a.append(tuple(i))

        return a

@app.get("/{user_id}/tasts", description='get tag, artist')
def get_usertasts(user_id: int):
    query = f"select track_tag_list, artist_name from track_info where track_id = (select track_id from inter where user_id = {user_id} order by date_uts desc limit 1);"
    
    with db_connect.cursor() as cur:
        cur.execute(query)
        values = cur.fetchall()[0]
    
    return values



if __name__ == "__main__":
    db_connect = psycopg2.connect(
        user="myuser",
        password="mypassword",
        host="34.64.54.251",
        port=5432,
        database="mydatabase",
    )

    uvicorn.run(app, host="0.0.0.0", port=8001)






