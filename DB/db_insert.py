import psycopg2
import time
import pandas as pd
import numpy as np
import json

db_connect = psycopg2.connect(
    user="mloops",
    password="password!",
    host="localhost",
    port=5431,
    database="music",
)


# inter
interaction = pd.read_csv('interaction_2000.csv')
interaction['timestamp'] = interaction['timestamp'].fillna(0)
interaction = interaction.fillna(" ")
#user
user = pd.read_csv('userInfo_10.csv')
for i in ['name', 'realname', 'country', 'gender', 'url', 'image']:
    user[i] = user[i].fillna('')
user = user.fillna(int(-1))
#album
album = pd.read_csv('album_table.csv')

#track
track = pd.read_csv('trackinfo_50_v1.1.csv')
for i in track.columns:
    if (track[i].dtypes) == 'object':
        track[i] = track[i].fillna('')
    else:
        track[i] = track[i].fillna(-1)

create_table_query_interaction = "create table inter (user_id varchar(50), track_name varchar(200), artist_name varchar(200), album_name varchar(200), timestamp int, interaction bool);"
create_table_query_user = "create table user_info (name varchar(50) primary key, age int, realname varchar(50), bootstrap int, playcount int, artist_count int, track_count int, album_count int, playlists int, following json, follower json, country varchar(50), gender varchar(5), subscriber int, url varchar(500), image varchar(500), registered int, open int);"
create_table_query_album = "create table album_info (album_name varchar(200) primary key, artist_name varchar(200), published varchar(100),url varchar(200), tag varchar(300));"
create_table_query_track = "create table track_info (track_name varchar(200), album_name varchar(200), artist_name varchar(200), track_tag_list varchar(200), url varchar(200), playcount int, listeners int, streamable_text int, duration int);"


def create_table(db_connect, create_table_query):
    print(create_table_query)
    with db_connect.cursor() as cur:
        cur.execute(create_table_query)
        db_connect.commit()
# create_table(db_connect, create_table_query_interaction)
# create_table(db_connect, create_table_query_user)
# create_table(db_connect, create_table_query_album)
# create_table(db_connect, create_table_query_track)

def change_str(a):
    if type(a) == type(0.1): # nan 처리
        return "\'\'"
    return "\'"+a.replace('\'', '\"') + "\'"


def insert_data_interaction(db_connect, data):
    insert_row_query = f"INSERT INTO inter (user_id, track_name, artist_name, album_name, timestamp, interaction) \
                         VALUES ({change_str(data.user_id)}, {change_str(data.track_name)}, {change_str(data.artist_name)}, {change_str(data.album_name)}, {data.timestamp}, {False});"
    print(insert_row_query)
    with db_connect.cursor() as cur:
        cur.execute(insert_row_query)
        db_connect.commit()

def insert_data_album(db_connect, data):
    insert_row_query = f"INSERT INTO album_info (album_name, artist_name, published, url, tag) \
                         VALUES ({change_str(data.album_name)}, {change_str(data.artist_name)}, {change_str(data.published)}, {change_str(data.url)}, {change_str(data.tag)});"
    print(insert_row_query)
    with db_connect.cursor() as cur:
        cur.execute(insert_row_query)
        db_connect.commit()

def insert_data_user(db_connect, data):
    empty_json = '\'{}\''
    insert_row_query = f"INSERT INTO user_info (name, age, realname, bootstrap, playcount, artist_count, track_count, album_count, playlists, following, follower, country, gender, subscriber, url, image, registered, open)\
                         VALUES ({change_str(data['name'])}, {data['age']}, {change_str(data.realname)}, {data.bootstrap}, {data.playcount}, {data.artist_count}, {data.track_count}, {data.album_count}, {data.playlists}, {empty_json}, {empty_json}, {change_str(data.country)}, {change_str(data.gender)}, {data.subscriber}, {change_str(data.url)}, {change_str(data.image)}, {data.registered}, {data.open});"
    print(insert_row_query)
    with db_connect.cursor() as cur:
        cur.execute(insert_row_query)
        db_connect.commit()

def insert_data_track(db_connect, data):
    empty_json = '\'{}\''
    insert_row_query = f"INSERT INTO track_info (track_name, album_name, artist_name, track_tag_list, url, playcount, listeners, streamable_text, duration)\
                         VALUES ({change_str(data['track_name'])}, {change_str(data['album_name'])}, {change_str(data['artist_name'])}, {change_str(data['track_tag_list'])}, {change_str(data['url'])}, {data['playcount']}, {data['listeners']}, {data['streamable_text']}, {data['duration']});"
    print(insert_row_query)
    with db_connect.cursor() as cur:
        cur.execute(insert_row_query)
        db_connect.commit()
def generate_data(db_connect, df):
    for i in range(1, df.shape[0]):
        insert_data_track(db_connect, df.loc[i].squeeze())

if __name__ == "__main__":
    db_connect = db_connect
    print(user.loc[0])
    generate_data(db_connect, track)