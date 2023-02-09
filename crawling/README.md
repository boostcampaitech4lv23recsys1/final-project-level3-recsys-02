# 1. Download Webdriver

# 2. pip install
  ```
  pip install -r requirements.txt
  ```
# 3. Run
change dir where "crawling.py" locating
### 기존 수집된 tag 기반으로 listener 수집 : n개 가능
` python crawling.py --tags genre1,genre2 `

### 새로운 Tag 수집 후, listener 수집 : 1개 가능
`python crawling.py --new_tag new_genre`

# output
outputs will be saved at __'artifacts'__ in __'.pkl'__ format