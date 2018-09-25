import pymongo
import requests
import numpy as np
import pandas as pd
from splinter import Browser
from bs4 import BeautifulSoup

def init_browser():
    executable_path = {'executable_path': 'chromedriver.exe'}
    return Browser('chrome', **executable_path, headless=False)

def scarpe():
    browser = init_browser()
    mars_dict = {}
    news_url = "https://mars.nasa.gov/news/"
    response = requests.get(news_url)
    # Create BeautifulSoup object; parse with 'html.parser'
    news_soup = BeautifulSoup(response.text, 'html.parser')
    # Examine the results, then determine element that contains sought info
    news_title = news_soup.title.text
    news_p = news_soup.p.text
    mars_dict["news_title"] = news_title
    mars_dict["news_p"] = news_p

    image_url = "https://www.jpl.nasa.gov/spaceimages/?search=&category=Mars"
    response_img = requests.get(image_url)
    #response_img
    # Create BeautifulSoup object; parse with 'html.parser'
    # soup_image = BeautifulSoup(response_img.text, 'html.parser')
    # # Examine the results, then determine element that contains sought info
    # featured_img_url_nosplinter = soup_image.article["style"]
    # # Parse string, e.g. '47 comments' for possible numeric manipulation
    # comments_num = featured_img_url_nosplinter.split()[1]
    # # Access the href attribute with bracket notation

    browser.visit(image_url)
    xpath = '//*[@id="page"]/section[1]/div/div/article'
    xpath_search = browser.find_by_xpath(xpath)
    featured_img_url = xpath_search["style"].split()[1]
    featured_img_url = featured_img_url.strip("url")
    featured_img_url = featured_img_url.strip('("')
    featured_img_url = featured_img_url.strip('");')
    featured_img_url = featured_img_url.strip('/')

    mars_dict["featured_img_url"] = featured_img_url

    weather_url = "https://twitter.com/marswxreport?lang=en"
    weather_response = requests.get(weather_url)
    browser.visit(weather_url)
    mars_xpath = '//*[@id="stream-item-tweet-1041843517113475075"]/div[1]/div[2]/div[2]/p'
    mars_weather = browser.find_by_xpath(mars_xpath).text

    # for p in mars_weather:
    #     p = mars_weather.text
    # p
    weather_soup = BeautifulSoup(weather_response.text, "html.parser")
    weather_soup = weather_soup.find_all(
        "p", class_="TweetTextSize TweetTextSize--normal js-tweet-text tweet-text")[0]
    mars_weather_soup = weather_soup.text
    mars_dict["mars_weather"] = mars_weather_soup

    mars_facts_url = 'http://space-facts.com/mars/'
    mars_facts_tables = pd.read_html(mars_facts_url)[0]

    mars_facts_tables_html = mars_facts_tables.to_html()

    mars_facts_tables_html_clean = mars_facts_tables_html.replace('\n', '')

    mars_dict["mars_facts"] = mars_facts_tables_html_clean

    hemisphere_url = 'https://astrogeology.usgs.gov/search/results?q=hemisphere+enhanced&k1=target&v1=Mars'
    browser.visit(hemisphere_url)
    #browser.click_link_by_text("Cerberus Hemisphere Enhanced")
    hemisphere_image_urls = []
    hemisphere_html = browser.html

    hemisphere_html_soup = BeautifulSoup(hemisphere_html, "html.parser")
    for i in range(len(hemisphere_html_soup.find_all("h3"))):
        titles = browser.find_by_tag("h3").text
        browser.find_by_tag("h3")[i].click()
        xpath_hem = '//*[@id="wide-image"]/div/ul/li[2]/a'
        link = browser.find_by_xpath(xpath_hem)["href"]
        browser.back()
        hem_dict = {"title": titles, "img_url": link}
        hemisphere_image_urls.append(hem_dict)

    mars_dict["Mars_Hemisphere"] = hemisphere_image_urls
    print(mars_dict)
    return mars_dict
scarpe()