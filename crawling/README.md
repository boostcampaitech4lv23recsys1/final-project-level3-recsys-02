0. Download Webdriver
1. pip install
  - selenium
  - bs4
  - tqdm
  - requests
  - numpy

2. run
- "crawling.py" 위치로 이동 후,
  1. 기존 수집된 tag 기반으로 listener 수집 : n개 가능

`python crawling.py --tags genre1,genre2`
  2. 새로운 Tag 수집 후, listener 수집 : 1개 가능
`python crawling.py --new_tag new_genre`
