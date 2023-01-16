## 1. psql 서버 생성 
  - docker run -d --name postgres-server -p 5432:5432 -e POSTGRES_USER=myuser \
  -e POSTGRES_PASSWORD=mypassword \
  -e POSTGRES_DB=mydatabase \
  postgres:14.0
  
## 2. [psql](https://www.postgresql.org/download/) 설치
  - 환경변수 설정
    - mac : export PATH=/Library/PostgreSQL/14/bin:$PATH
    
## 3. 데이터 다운로드
  - [lfm_temp.dump](https://www.notion.so/DB-263211aa2e1a483e8539114e81fff8ef#a4c2a0e9ea9e445995a2a07a7766404f)
## 4. table 만들기
  - PGPASSWORD=mypassword pg_restore -h localhost -p 5432 -U myuser -d mydatabase -Fc lfm_temp.dump 
