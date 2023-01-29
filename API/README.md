# How to run

1. 본인 api 키를 api_key 파일에 넣는다.
2. sh lastfm_api_crawl.sh [USER] [VER] [USER_SAMPLING]  
e.g., sh lastfm_api_crawl.sh kdy kdy_test 200

---

- USER: csv, pickle 의 파일명에 들어가는 username
- VER: csv, pickle 이 저장되는 폴더명 - API/[VER]/ 폴더 안에 저장됨
- USER_SAMPLING: 몇 명의 user 를 중심으로 수집할 것인지