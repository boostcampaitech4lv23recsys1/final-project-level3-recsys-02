from tqdm import tqdm
from selenium import webdriver
from selenium.webdriver.common.by import By
import multiprocessing
import argparse

from bs4 import BeautifulSoup as bs
import requests
import time
import pickle
import os

def run_bs(tag, mode) : 

    ############################## tags ##############################

    def get_tags(tag, mode) : 
        if os.path.isfile("./artifacts/tag_list.pkl") & (mode == 'tags'): 
            print("loading tag list file ...")
            with open(f"./artifacts/tag_list.pkl", "rb") as f: 
                tags = pickle.load(f)
                
        elif mode == "new_tag" : 
            print("append new tag list file ...")
            print("loading tag list file ...")
            with open(f"./artifacts/tag_list.pkl", "rb") as f: 
                tags = pickle.load(f)
            tags.append(tag)
        
            with open(f"./artifacts/tag_list.pkl", "wb") as f: 
                pickle.dump(tags, f)

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
                
        return tags

    ############################## artists ##############################

    def get_artists(tag, mode) : 
        tags = get_tags(tag, mode)
        if os.path.isfile("./artifacts/tag_artist_dict.pkl") & (mode == 'tags') : 
            print("loading tag-artist dictionary file ...")
            with open(f"./artifacts/tag_artist_dict.pkl", "rb") as f: 
                tag_artist_dict = pickle.load(f)
                
        elif mode == "new_tag" : 
            print("append new tag-artist dictionary ...")
            print("loading tag-artist dictionary file ...")
            with open(f"./artifacts/tag_artist_dict.pkl", "rb") as f: 
                tag_artist_dict = pickle.load(f)
                
            print("adding tag-artist dictionary ...")
            page = requests.get(f"https://www.last.fm/tag/{tag.lower()}/artists")
            soup = bs(page.text, "html.parser")
            artist_lst = []

            for page in tqdm(range(1, 101)) : 
                page = requests.get(f"https://www.last.fm/tag/{tag.lower()}/artists?page={page}")
                soup = bs(page.text, "html.parser")
                artists_elems = soup.find_all('a', {"class":'link-block-target', 'itemprop':'url'})
                artists = list(map(lambda x:x.text.strip(), artists_elems))
                artist_lst.extend(artists)
                
            tag_artist_dict[tag] = artist_lst
            with open(f"./artifacts/tag_artist_dict.pkl", "wb") as f: 
                pickle.dump(tag_artist_dict, f)
            
        else : 
            print("making tag-artist dictionary file...")
            tag_artist_dict = {}
            for tag in tqdm(tags) : 
                page = requests.get(f"https://www.last.fm/tag/{tag.lower()}/artists")
                soup = bs(page.text, "html.parser")
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
    
    if mode == "new_tag" :
        return get_artists(tag, mode)
    elif mode == "tags" : 
        return get_artists(tag, mode)


# ############################## listeners #############################

def next_page(driver) : 
    try : 
        driver.find_element(By.CLASS_NAME, "pagination-next").find_element(By.TAG_NAME, 'a').click()
        time.sleep(5)
        return True
    except  : 
        return False

def crawl(tag, mode) : 
    try:
        tag_artist_dict = run_bs(tag, mode)
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
            time.sleep(5)

            is_page = True

            # get listeners' name
            while is_page : 
                driver.execute_script("window.scrollTo(0, 10)")
                listeners_elem = driver.find_elements(By.CLASS_NAME, 'top-listeners-item-name')
                listeners = list(map(lambda x: x.find_element(By.CLASS_NAME, 'link-block-target').text, listeners_elem))
                listener_lst.extend(listeners)
                is_page = next_page(driver)
                
            
        driver.close()
        driver.quit()
        
        # save listener list
        with open(f"./artifacts/listeners/lastfm_listeners_{tag}.pkl", "wb") as f : 
            pickle.dump(listener_lst, f)
    except: 
        print("Error Occured. Partial data saved")
        with open(f"./artifacts/listeners/lastfm_listeners_{tag}_interrupted.pkl", "wb") as f : 
            pickle.dump(listener_lst, f)

# tag list : [jazz, pop, dance, rock, electronic, rap, hip-hop, country, blues, classical, k-pop, metal,
# rnb, reggae, acoustic, indie, alternative, punk, hardcore, soul]
def get_listeners(arguments) : 
    print(arguments)
    mode = arguments[0]
    tag = arguments[1]
    
    if tag == "jazz" : 
        crawl("jazz", mode)
    elif tag == "pop" : 
        crawl("pop", mode)
    elif tag == "dance" : 
        crawl("dance", mode)
    elif tag == "rock" : 
        crawl("rock", mode)
    elif tag == "Electronic" : 
        crawl("Electronic", mode)
    elif tag == "rap" : 
        crawl("rap", mode)
    elif tag == "hip-hop":
        crawl("hip-hop", mode)
    elif tag == "country" : 
        crawl("country", mode)
    elif tag == "blues" : 
        crawl("blues", mode)
    elif tag == "classical" : 
        crawl("classical", mode)
    elif tag == "k-pop" : 
        crawl("k-pop", mode)
    elif tag == "metal" : 
        crawl("metal", mode)
    elif tag == "rnb" : 
        crawl("rnb", mode)
    elif tag == "reggae" : 
        crawl("reggae", mode)
    elif tag == "acoustic" : 
        crawl("acoustic", mode)
    elif tag == "indie" : 
        crawl("indie", mode)
    elif tag == "alternative" : 
        crawl("alternative", mode)
    elif tag == "punk" : 
        crawl("punk", mode)
    elif tag == "hardcore" : 
        crawl("hardcore", mode)
    elif tag == "soul" : 
        crawl("soul", mode)
    ##############################
    elif tag == "korean" : 
        crawl("korean", mode)
    elif tag == "kpop" : 
        crawl("kpop", mode)
    
def main(tags) : 
    mode = ["tags"]*2
    if type(tags) == str : # new_tag인 경우
        tags = [tags]
        mode = ["new_tag"]
    arguments = list(zip(mode, tags))
    cpu_count = multiprocessing.cpu_count()
    pool = multiprocessing.Pool(cpu_count)
    pool.map(get_listeners,arguments)
    pool.close()
    pool.join()
    
    
if __name__ == '__main__' : 
    
    parser = argparse.ArgumentParser()
    tp = lambda x:x.split(',')
    parser.add_argument("-t", "--tags", type=tp, help='add tags to crawl: up to 2 tags')
    parser.add_argument("--new_tag", help='append new tags and crawl: only 1 tag')
    args = parser.parse_args()
    if args.tags == None : 
        del args.tags
        print(f"start new tag crawling...")
        print("new tags to crawl: ",args.new_tag)
        main(args.new_tag)
    elif args.new_tag == None : 
        del args.new_tag
        print(f"start crawling...")
        print("tags to crawl: ",args.tags)
        main(args.tags)