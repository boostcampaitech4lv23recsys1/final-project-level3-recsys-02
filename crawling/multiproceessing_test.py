import multiprocessing
import pickle
from selenium import webdriver
from selenium.webdriver.common.by import By
import time
import datetime
import os
import random
from tqdm import tqdm

with open("./artifacts/tag_artist_dict.pkl","rb") as f:
    tag_artist_dict = pickle.load(f)

def next_page() : 
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
            is_page = next_page()
            
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
    tags = list(tag_artist_dict.keys())
    print("yes")
    main(tags)
    
    