# 💁 🎶  사용자 취향 분석 기반 음악 추천 및 친구 추천

<a align = "center"><img width="100" src="img/img/musicoops.png"></a>

 <img src="https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=Python&logoColor=white"> <img src="https://img.shields.io/badge/Pytorch-EE4C2C?style=flat-square&logo=Pytorch&logoColor=white"> <img src="https://img.shields.io/badge/PostgreSQL-316192?style=flat-square&logo=postgresql&logoColor=white"> <img src="https://img.shields.io/badge/Google_Cloud-4285F4?style=flat-square&logo=google-cloud&logoColor=white"> <img src="https://img.shields.io/badge/Airflow-017CEE?style=flat-square&logo=Apache%20Airflow&logoColor=white"> <img src="https://img.shields.io/badge/FastAPI-005571?style=flat-square&logo=fastapi"> <img src="https://img.shields.io/badge/docker-%230db7ed.svg?style=flat-square&logo=docker&logoColor=white"> <img src="https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white">

&nbsp;
&nbsp;

### 2️⃣ RecSys_2조 2️⃣

### 🙋🏻‍♂️🙋🏻‍♀️  Member
<table align="center">
  <tr height="155px">
    <td align="center" width="150px">
      <a href="https://github.com/ktasha45"><img src="https://avatars.githubusercontent.com/ktasha45"/></a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/NIckmin96"><img src="https://avatars.githubusercontent.com/NIckmin96"/></a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/parkkyungjun"><img src="https://avatars.githubusercontent.com/parkkyungjun"/></a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/HeeJeongOh"><img src="https://avatars.githubusercontent.com/HeeJeongOh"/></a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/yhw991228"><img src="https://avatars.githubusercontent.com/heecircle"/></a>
    </td>
  </tr>
  <tr height="80px">
    <td align="center" width="150px">
      <a href="https://github.com/ktasha45">김동영_4028</a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/NIckmin96">민복기_T4074</a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/parkkyungjun">박경준_T4076</a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/HeeJeongOh">오희정_T4129</a>
    </td>
    <td align="center" width="150px">
      <a href="https://github.com/heecircle">용희원_T4130</a>
    </td>
  </tr>
</table>

### 🗂️ Project Structure
```python
.
├── API
│   ├── Dockerfile
│   ├── backend-api.py
│   └── requirements.txt
├── Airflow
│   ├── airflow-webserver.pid
│   ├── airflow.cfg
│   ├── airflow.db
│   ├── dags
│   └── webserver_config.py
├── DB
│   └── README.md
├── EDA
│   ├── EDA_bk.ipynb
│   ├── EDA_final.ipynb
│   ├── README.md
│   └── columns.JPG
├── README.md
├── UI
│   ├── README.md
│   ├── assets
│   ├── lib
│   │   ├── constants.dart
│   │   ├── main.dart
│   │   ├── models
│   │   ├── pages
│   │   ├── utils
│   │   └── widgets
│   ├── pubspec.lock
│   ├── pubspec.yaml
│   └── web
├── bentoml
│   ├── bento
│   └── env
├── crawling
│   ├── README.md
│   ├── artifacts
│   ├── crawling.py
│   ├── multiproceessing_test.py
│   └── requirements.txt
├── model
│   ├── README.md
│   ├── data
│   ├── datasets.py
│   ├── label2string.py
│   ├── models.py
│   ├── modules.py
│   ├── output
│   ├── predictor.py
│   ├── preprocessing_csv.py
│   ├── preprocessing_db.py
│   ├── requirements.txt
│   ├── run_finetune_full.py
│   ├── run_inference.py
│   ├── run_pretrain.py
│   ├── trainers.py
│   └── utils.py
├── lastfm_api_crawl
│   ├── README.md
│   ├── api_key
│   ├── etc
│   ├── lastfm_api_crawl.py
│   └── lastfm_api_crawl.sh
└── img



```

### 🎶  Project Overview
이 서비스는 사용자에게 새로운 친구와 새로운 음악에 대한 추천을 제공함으로써 두 장점을 결합한다. 사용자의 음악 선호도와 패턴을 분석해 음악 취향이 비슷한 사람들을 매칭해주는 서비스이다.

또한, 사용자가 좋아하는 아티스트, 노래, 장르를 기반으로 개인화된 음악 추천 제공한다. 더불어 사용자가 항상 원하는 스타일의 최신 음악에 접근할 수 있도록 정기적으로 업데이트를 진행한다.

이 서비스를 통해, 사용자들은 새로운 음악을 발견하고, 새로운 친구를 사귀고, 음악에 대한 열정을 공유하는 다른 사람들을 만날 수 있다.

### 📆 Project Plan
![img.png](img%2Fimg%2Fimg.png)
### 🎧 MusicOops
<img width="1200" alt="image" src="https://user-images.githubusercontent.com/74080194/217674648-f4589392-3894-467f-8e3c-b389bc3b5f80.png">

### ✅ Recommand List
<img width = "500" src = "img/img/reclist.png">

### 🚨 System Architecture
![image](https://user-images.githubusercontent.com/62127798/217698684-6dc6a9ae-fcce-41d5-a23f-922b868ca373.png)

### 📀 Dataset : LFM-1b dataset
![lastfmsite.png](img/img/lastfmsite.png)

[//]: # ()
[//]: # (![lastfmapi2.png]&#40;img/img/lastfmapi2.png&#41;)

[//]: # ()
[//]: # (![lastfmapi1.png]&#40;img/img/lastfmapi1.png&#41;)

### 🧶Model : S3Rec
![s3rec.png](img/img/s3rec.png)
출처 : https://arxiv.org/abs/2008.07873

### 🧳 DB : Postgresql
![image](https://user-images.githubusercontent.com/62127798/217698587-18de8ffb-b4c0-4d97-9766-2154d0bfd986.png)
