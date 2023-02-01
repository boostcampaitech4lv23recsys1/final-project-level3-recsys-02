# How to run

1. 본인 api 키를 api_key 파일에 넣는다.
2. sh lastfm_api_crawl.sh [USER] [VER] [USER_SAMPLING] [SKIP]  
e.g., sh lastfm_api_crawl.sh kdy kdy_200 200 0

---

- USER: csv, pickle 의 파일명에 들어가는 username
- VER: csv, pickle 이 저장되는 폴더명 - API/[VER]/ 폴더 안에 저장됨
- USER_SAMPLING: 몇 명의 user 를 중심으로 수집할 것인지
- SKIP: 0이면 phase 1 을 실행하고, 1이면 실행하지 않음.  
interaction 을 전부 수집해서 pickle 파일들이 저장되어있는 경우, interaction 을 한 번 더 수집할 필요가 없음  
이런 경우 SKIP 값을 1으로 설정하면 phase 2 만 실행됨.