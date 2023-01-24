## 1. psql 서버 생성 
~~~bash
docker run -d --name postgres-server -p 5432:5432 -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_DB=mydatabase \
  postgres:14.0
~~~
## 2. [psql](https://www.postgresql.org/download/) 설치
  - 환경변수 설정
    - mac 
    ~~~bash
    export PATH=/Library/PostgreSQL/14/bin:$PATH 
    ~~~
    
## 3. 데이터 다운로드
  - [lfm_temp.dump](https://www.notion.so/DB-263211aa2e1a483e8539114e81fff8ef#a4c2a0e9ea9e445995a2a07a7766404f)
## 4. table 만들기
  - ~~~bash
    PGPASSWORD=mypassword pg_restore -h localhost -p 5432 -U myuser -d mydatabase -Fc lfm_temp.dump
    ~~~ 

## 5. Insert Info
    
- interaction_2000
- user_info
- album_table
수정 예정 : track 추가, track에 album_name 추가

album_table

|album_name|artist_name|published| url |tag|
|---|---|---|---|---|


user_info

|name|age|realname|bootstrap|playcount|artist_count|track_count|album_count|playlists|following|follower|country|gender|subscriber|url|image|registered|open|
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|


interaction_2000

|user_id|track_name|artist_name|album_name|timestamp|interaction|
|---|---|---|---|---|---|

track_info

|track_name|album_name|artist_name|track_tag_list|url|playcount|listeners|streamable_text|duration|
|---|---|---|---|---|---|---|---|---|