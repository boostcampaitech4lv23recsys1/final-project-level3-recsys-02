from tqdm import tqdm
from selenium import webdriver
from selenium.webdriver.common.by import By
import multiprocessing
import argparse

from bs4 import BeautifulSoup as bs
import numpy as np
import requests
import time
import datetime
import pickle
import random
import os

############################## tags ##############################

print("making tag list file...")

if os.path.isfile("./artifacts/tag_list.pkl") : 
    with open(f"./artifacts/tag_list.pkl", "rb") as f: 
        tags = pickle.load(f)
else : 
    page = requests.get('https://www.last.fm/music')
    soup = bs(page.text, "html.parser")

    featured_tags_elem = soup.select_one('div.music-tags').select('h3.music-featured-item-heading')
    featured_tags = list(map(lambda x:x.text.strip(), featured_tags_elem))

    tags_elem = soup.select_one('div.music-tags').select_one('ul.music-more-tags').select('span.music-more-tags-tag-link')
    tags = list(map(lambda x:x.text.strip(), tags_elem))

    tags.extend(featured_tags)
    tags = list(set(tags))
    with open(f"./artifacts/tag_list.pkl", "wb") as f: 
        pickle.dump(tags, f)

# mm = datetime.datetime.now().month
# dd = datetime.datetime.now().day
# hh = datetime.datetime.now().hour

# with open(f"./tag_list_{mm}-{dd}:{hh}.pkl", "wb") as f: 
#     pickle.dump(tags, f)

############################## artists ##############################

print("making tag-artist dictionary file...")

if os.path.isfile("./artifacts/tag_artist_dict.pkl") : 
    with open(f"./artifacts/tag_artist_dict.pkl", "rb") as f: 
        tag_artist_dict = pickle.load(f)
else : 
    tag_artist_dict = {}
    for tag in tqdm(tags) : 
        page = requests.get(f"https://www.last.fm/tag/{tag.lower()}/artists")
        # page = requests.get(f"https://www.last.fm/tag/Electronic/artists")
        soup = bs(page.text, "html.parser")
        len_pages = soup.find_all('li', {"class":"pagination-page"})[-1].text.strip()
        artist_lst = []

        # for page in range(int(len_pages)) : 
        for page in range(1, 101) : 
            page = requests.get(f"https://www.last.fm/tag/{tag.lower()}/artists?page={page}")
            soup = bs(page.text, "html.parser")
            artists_elems = soup.find_all('a', {"class":'link-block-target', 'itemprop':'url'})
            artists = list(map(lambda x:x.text.strip(), artists_elems))
            artist_lst.extend(artists)
            
        tag_artist_dict[tag] = artist_lst
    
    with open(f"./artifacts/tag_artist_dict.pkl", "wb") as f: 
        pickle.dump(tag_artist_dict, f)


# ############################## listeners ##############################

# # login 정보를 넣어주지 않으면 "None"으로 출력됨 -> Selenium
# # # listeners -> 

# # artist_param = artists[0].replace(' ', '+')
# # headers = {'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36'}
# # page = requests.get(f"https://www.last.fm/music/{artists[0]}/+listeners")
# # soup = bs(page.text, "html.parser")
# # soup.find_all('h3', {"itemprop":"name", "class":"top-listeners-item-name"})

# # # artists_elems = soup.find_all('a', {"class":'link-block-target', 'itemprop':'url'})
# # # artists = list(map(lambda x:x.text.strip(), artists_elems))

# print("making user list file...")
# driver = webdriver.Chrome('./chromedriver')
# time.sleep(2)
# print("chromedriver running...")

# # url
# driver.get("https://www.last.fm")

# login_page = driver.find_elements(By.CLASS_NAME, "site-auth-control")[0]
# login_page.click()
# time.sleep(2)

# id_box = driver.find_element(By.CSS_SELECTOR, "#id_username_or_email")
# pw_box = driver.find_element(By.CSS_SELECTOR, "#id_password")

# # login
# id_box.send_keys("sdsf1225@gmail.com")
# # id_box.send_keys("your id")
# time.sleep(0.5)
# pw_box.send_keys("qhrrl9651!")
# # pw_box.send_keys("your password")
# submit = driver.find_element(By.CSS_SELECTOR, "#login > div:nth-child(5) > div > button")
# submit.click()
# time.sleep(3)

# def next_page() : 
#     try : 
#         driver.find_element(By.CLASS_NAME, "pagination-next").find_element(By.TAG_NAME, 'a').click()
#         time.sleep(5)
#         return True
#     except  : 
#         return False


# tags = list(tag_artist_dict.keys())
# artists_listeners_dict = {}
# listener_lst = []
# for tag in tags : 
#     artists = tag_artist_dict[tag]
#     for artist in tqdm(artists) : 
#         # go to artist page

#         driver.get(f"https://www.last.fm/music/{artist}/+listeners")
#         time.sleep(1)

#         is_page = True

#         # get listeners' name
#         while is_page : 
#             driver.execute_script("window.scrollTo(0, 10)")
#             listeners_elem = driver.find_elements(By.CLASS_NAME, 'top-listeners-item-name')
#             listeners = list(map(lambda x: x.find_element(By.CLASS_NAME, 'link-block-target').text.strip(), listeners_elem))
#             listener_lst.extend(listeners)
#             artists_listeners_dict[artist] = listeners
#             is_page = next_page()
            
#         # save listener list
#         with open("./artifacts/lastfm_listeners.pkl", "wb") as f : 
#             pickle.dump(listener_lst, f)
#         with open("./artifacts/artists_listeners_dict.pkl", "wb") as f : 
#             pickle.dump(artists_listeners_dict, f)

#     driver.close()
#     driver.quit()

##################################################################################################################

def next_page(driver) : 
    try : 
        driver.find_element(By.CLASS_NAME, "pagination-next").find_element(By.TAG_NAME, 'a').click()
        time.sleep(5)
        return True
    except  : 
        return False

def crawl(tag) : 
    print("making user list file...")
    driver = webdriver.Chrome('./chromedriver')
    time.sleep(2)
    print("chromedriver running...")

    # url
    driver.get("https://www.last.fm")

    login_page = driver.find_elements(By.CLASS_NAME, "site-auth-control")[0]
    login_page.click()
    time.sleep(2)

    id_box = driver.find_element(By.CSS_SELECTOR, "#id_username_or_email")
    pw_box = driver.find_element(By.CSS_SELECTOR, "#id_password")

    # login
    id_box.send_keys("sdsf1225@gmail.com")
    # id_box.send_keys("your id")
    time.sleep(0.5)
    pw_box.send_keys("qhrrl9651!")
    # pw_box.send_keys("your password")
    submit = driver.find_element(By.CSS_SELECTOR, "#login > div:nth-child(5) > div > button")
    submit.click()
    time.sleep(3)
    
    
    artists = tag_artist_dict[tag]
    listener_lst = []
    for artist in tqdm(artists) : 
        # go to artist page

        driver.get(f"https://www.last.fm/music/{artist}/+listeners")
        time.sleep(1)

        is_page = True

        # get listeners' name
        while is_page : 
            driver.execute_script("window.scrollTo(0, 10)")
            listeners_elem = driver.find_elements(By.CLASS_NAME, 'top-listeners-item-name')
            listeners = list(map(lambda x: x.find_element(By.CLASS_NAME, 'link-block-target').text, listeners_elem))
            listener_lst.extend(listeners)
            is_page = next_page(driver)
            
        print(len(set(listener_lst)))
            
        # save listener list
    driver.close()
    driver.quit()
    
    with open(f"./artifacts/lastfm_listeners_{tag}.pkl", "wb") as f : 
        pickle.dump(listener_lst, f)

    return print(len(listener_lst))

def get_listeners(tag) : 
    print(tag)
    tags = list(tag_artist_dict.keys())
    
    if tag == "jazz" : 
        crawl("jazz")
    elif tag == "rnb" : 
        crawl("rnb")
    elif tag == "reggae":
        crawl("raggae")
    elif tag == "rock" : 
        crawl("rock")
    elif tag == "Electronic" : 
        crawl("Electronic")
    elif tag == "acoustic" : 
        crawl("acoustic")
    elif tag == "dance" : 
        crawl("dance")
    elif tag == "Metal" : 
        crawl("Metal")
    elif tag == "rap" : 
        crawl("rap")
    elif tag == "metal" : 
        crawl("metal")
    elif tag == "country" : 
        crawl("country")
    elif tag == "hip-hop" : 
        crawl("hip-hop" )
    elif tag == "alternative" : 
        crawl("alternative")
    elif tag == "indie" : 
        crawl("indie")
    elif tag == "hardcore" : 
        crawl("hardcore")
    elif tag == "blues" : 
        crawl("blues")
    elif tag == "classical" : 
        crawl("classical")
    elif tag == "punk" : 
        crawl("punk")
    
def main(tags) : 
    cpu_count = multiprocessing.cpu_count()
    pool = multiprocessing.Pool(cpu_count)

    pool.map(get_listeners, tags)
    pool.close()
    pool.join()
    
    
if __name__ == '__main__' : 
    
    parser = argparse.ArgumentParser()
    tp = lambda x:list(x.split())
    parser.add_argument("-t", "--tags", type=tp, help='add tags to crawl')          # extra value
    # parser.add_argument("-f", "--fast", dest="fast", action="store_true")           # existence/nonexistence
    args = parser.parse_args()
    
    tags = list(tag_artist_dict.keys())
    print(f"start crawling...")
    print("tags to crawl : ", args.tags)
    main(tags)
 


