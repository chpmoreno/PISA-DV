library(RCurl)
library(XML)
library(syuzhet)
library(RYandexTranslate)
library(tm)
library(SnowballC)
library(dplyr)
library(stringr)
library(ggplot2)

setwd("~/Documents/OneDrive/Documents/BGSE/First_Term/FTP/PISA/db_builder/")
source("data_news_functions.R")

languages <- read.csv("language.csv")
iso       <- read.csv("iso_countries.csv")
colnames(iso)[2] <- "IDcountry"
  
iso_lang  <- left_join(languages, iso) 

data_news = NULL
plots_sentiment = NULL
for(i in 1:nrow(iso_lang)){
  data_news[[i]] <- google_result_freq(country.code = iso_lang[i, "ISO2"],
                                       country = iso_lang[i, "country"])
plots_sentiment[[i]] <- plot_sentiment(data_news[[i]]$sentence_sentiment)
}

names(data_news) <- iso_lang$IDcountry
names(plots_sentiment) <- iso_lang$IDcountry

save(list = c("data_news", "plots_sentiment"), file = "news.RData")
