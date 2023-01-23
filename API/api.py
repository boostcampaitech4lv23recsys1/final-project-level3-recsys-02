from fastapi import FastAPI

import uvicorn
import psycopg2

app = FastAPI()

class userInfo:
       def __init__(self):
              self.name : str
              self.age : int
              self.realname : str
              self.bootstrap :int 
              self.playcount : int
              self.artist_count : int
              self.track_count : int
              self.album_count : int
              self.playlists : int
              self.following : list # 10
              self.follower : list
              self.country : str
              self.gender : str
              self.subscriber : int
              self.url : str
              self.image : str
              self.registered : int
              self.open : bool

@app.get("/users/{user_id}/profiles", description="사용자 정보")
async def get_profiles(user_id : str):
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
    info.open = values[18]

    return info

@app.get("/users/{user_id}", description="공개 여부 전환")
async def update_open(user_id : str, ex = 0):
    get_sample = f"""
        update user_info set open = {not ex} where name = '{user_id}';
    ;"""

    with db_connect.cursor() as cur:
        cur.execute(get_sample)
        info = db_connect.commit()

@app.get("/users/{user_id}/likes", description="좋아요 리스트")
async def get_likes(user_id : str):
    get_sample = f"""
        select track_name from inter where (user_id = '{user_id}' and Interaction = true)
    ;"""

    with db_connect.cursor() as cur:
        cur.execute(get_sample)
        return cur.fetchall()

if __name__ == "__main__":
    db_connect = psycopg2.connect(
        user="myuser",
        password="mypassword",
        host="localhost",
        port=5432,
        database="mydatabase",
    )

    uvicorn.run(app, host="0.0.0.0", port=8001)
