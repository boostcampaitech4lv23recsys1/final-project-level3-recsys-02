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

def run_bs() : 

    ############################## tags ##############################

    if os.path.isfile("./artifacts/tag_list.pkl") : 
        with open(f"./artifacts/tag_list.pkl", "rb") as f: 
            tags = pickle.load(f)

    else : 
        print("making tag list file...")
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

    ############################## artists ##############################

    if os.path.isfile("./artifacts/tag_artist_dict.pkl") : 
        with open(f"./artifacts/tag_artist_dict.pkl", "rb") as f: 
            tag_artist_dict = pickle.load(f)
    else : 
        print("making tag-artist dictionary file...")
        tag_artist_dict = {}
        for tag in tqdm(tags) : 
            page = requests.get(f"https://www.last.fm/tag/{tag.lower()}/artists")
            soup = bs(page.text, "html.parser")
            len_pages = soup.find_all('li', {"class":"pagination-page"})[-1].text.strip()
            artist_lst = []

            for page in range(1, 101) : 
                page = requests.get(f"https://www.last.fm/tag/{tag.lower()}/artists?page={page}")
                soup = bs(page.text, "html.parser")
                artists_elems = soup.find_all('a', {"class":'link-block-target', 'itemprop':'url'})
                artists = list(map(lambda x:x.text.strip(), artists_elems))
                artist_lst.extend(artists)
                
            tag_artist_dict[tag] = artist_lst
        
        with open(f"./artifacts/tag_artist_dict.pkl", "wb") as f: 
            pickle.dump(tag_artist_dict, f)
            
    return tag_artist_dict


# ############################## listeners #############################

def next_page(driver) : 
    try : 
        driver.find_element(By.CLASS_NAME, "pagination-next").find_element(By.TAG_NAME, 'a').click()
        time.sleep(1)
        return True
    except  : 
        return False

def crawl(tag) : 
    try : 
        tag_artist_dict = run_bs()
        print("making user list file...")
        driver = webdriver.Chrome('./chromedriver')
        time.sleep(0.5)
        print("chromedriver running...")

        # url
        driver.get("https://www.last.fm")

        login_page = driver.find_elements(By.CLASS_NAME, "site-auth-control")[0]
        login_page.click()
        time.sleep(0.5)

        id_box = driver.find_element(By.CSS_SELECTOR, "#id_username_or_email")
        pw_box = driver.find_element(By.CSS_SELECTOR, "#id_password")

        # login
        id_box.send_keys("your id")
        time.sleep(0.5)
        pw_box.send_keys("your password")
        submit = driver.find_element(By.CSS_SELECTOR, "#login > div:nth-child(5) > div > button")
        submit.click()
        time.sleep(1)
        
        
        artists = tag_artist_dict[tag]
        listener_lst = []
        for artist in tqdm(artists) : 
            # go to artist page

            driver.get(f"https://www.last.fm/music/{artist}/+listeners")
            time.sleep(1)

            is_page = True

            # get listeners' name
            while is_page : 
                time.sleep(1)
                driver.execute_script("window.scrollTo(0, 10)")
                listeners_elem = driver.find_elements(By.CLASS_NAME, 'top-listeners-item-name')
                listeners = list(map(lambda x: x.find_element(By.CLASS_NAME, 'link-block-target').text, listeners_elem))
                listener_lst.extend(listeners)
                is_page = next_page(driver)
                
            # save listener list
        driver.close()
        driver.quit()
        
        with open(f"./artifacts/lastfm_listeners_{tag}.pkl", "wb") as f : 
            pickle.dump(listener_lst, f)
    except : 
        with open(f"./artifacts/lastfm_listeners_{tag}_interrupted.pkl", "wb") as f : 
            pickle.dump(listener_lst, f)


def get_listeners(tag) : 
    
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
    tp = lambda x:x.split(',')
    # print("tags : [jazz, rnb, reggae, rock, Electronic, acoustic, dance, Metal, rap, metal, country, hip-hop, alternative, indie, hardcore, blues, classical, punk]")
    parser.add_argument("-t", "--tags", type=tp, help='add tags to crawl') 
    args = parser.parse_args()
    print(f"start crawling...")
    print("tags to crawl : ", args.tags)
    main(args.tags)
 


