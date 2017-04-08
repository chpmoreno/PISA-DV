library(sp)
library(maps)
library(maptools)
library(rgdal)
library(leaflet)
library(shiny)
library(shinydashboard)
library(lubridate)
library(Cairo)
library(dplyr)
library(ggplot2)
library(readr)
library(scales)
library(wordcloud)
library(stringi)
library(stringr)
library(plotly)
library(markdown)
library(mclust)

#install.packages(c(sp, maps, maptools, rgdal, leaflet, shiny, shinydashboard, 
#                   lubridate, Cairo, dplyr, ggplot2, readr, scales, wordcloud,
#                   stringi, stringr, plotly, markdown, mclust))

options(shiny.reactlog=TRUE)

# set the working directory
setwd("~/Dropbox/Documents/BGSE/Second_Term/DV/Project/PISA/github/PISA-DV/dashboard/app/Dashboard")

load("data/countries.RData")
load("data/macro.RData")
load("data/dictionary.RData")

# if you are using shiny-server use this
df_basic <- macro %>% filter(idyear == 2012) %>% left_join(countries) %>% 
  select(one_of("IDcountry", "country", "gdp_pc", "life_exp", "youth_unemp",
                "p_urb", "p_rur", "gini"))

macro_2012 <- macro %>% filter(idyear == 2012) %>% select(-one_of("idyear"))

macro_2012_dep <- macro_2012
for(i in 1:ncol(macro_2012)) {
  if(sum(is.na(macro_2012[, i])) > 1) {
    macro_2012_dep <- macro_2012_dep %>% select(-one_of(colnames(macro_2012)[i]))
  }
}

scores <- read.csv("data/scores.csv") 

clustering_data <- macro_2012_dep %>% left_join(scores) %>% select(-one_of("IDcountry", "p_rur", "pop_dens"))
rownames(clustering_data) <- macro_2012$IDcountry

clus <- Mclust(clustering_data)$classification
df_basic <- df_basic %>% left_join(scores) %>% bind_cols(data.frame(clus = clus))

countries_map <- readOGR("data/countries.geojson", "OGRGeoJSON")

joined_basic <- merge(countries_map, df_basic, by.x = "wb_a3", by.y = "IDcountry", all=FALSE, sort = FALSE) 

math_pal <- colorQuantile("RdYlBu", joined_basic$M, n = 5)

math_popup <- paste0("<strong>Country: </strong>", 
                      joined_basic$sovereignt, 
                      "<br><strong>score: </strong>", 
                      joined_basic$M)

sci_pal <- colorQuantile("RdYlBu", joined_basic$S, n = 5)

sci_popup <- paste0("<strong>Country: </strong>", 
                     joined_basic$sovereignt, 
                     "<br><strong>score: </strong>", 
                     joined_basic$S)

math_pal <- colorQuantile("RdYlBu", joined_basic$M, n = 5)

math_popup <- paste0("<strong>Country: </strong>", 
                     joined_basic$sovereignt, 
                     "<br><strong>score: </strong>", 
                     joined_basic$M)

clustering_pal <- colorNumeric("RdYlBu", joined_basic$clus)

clustering_popup <- paste0("<strong>Country: </strong>", 
                     joined_basic$sovereignt, 
                     "<br><strong>Cluster: </strong>", 
                     joined_basic$clus)

read_pal <- colorQuantile("RdYlBu", joined_basic$R, n = 5)

read_popup <- paste0("<strong>Country: </strong>", 
                     joined_basic$sovereignt, 
                     "<br><strong>score: </strong>", 
                     joined_basic$R)

load(file = "data/news.RData")

pal_wc <- brewer.pal(9,"YlGnBu")[-(1:4)]

PISA_data_dashboard <- read.csv("data/PISA_var_descriptive.csv") %>% left_join(dictionary)

parameters_cnt <- as.data.frame(read.csv("data/parameters_cnt.csv"))

parameters_cnt_names <- as.data.frame(t(read.csv("data/names_parameters.csv", header = FALSE)))
colnames(parameters_cnt_names) <- c("code", "name")

