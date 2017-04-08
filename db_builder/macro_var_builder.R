#install.packages("readr")

library(WDI)
library(dplyr)
library(stringr)
library(readr)
library(stringdist)

setwd("yourpath") #WD

WB_countries <- unique(WDI(indicator = "NY.GDP.PCAP.KD", country = "all", start = 2012, end = 2015)[ , c("iso2c", "country")])
WB_countries <- WB_countries[which(WB_countries$iso2c == "AF"):nrow(WB_countries),]
colnames(WB_countries) <- c("Code", "Country_name")
WB_countries[which(WB_countries$Code == "KR"), "Country_name"] <- "Korea"


PISA_countries <- readr::read_csv("countries.csv")
colnames(PISA_countries) <- c("Code", "Country_name")
PISA_countries_to_rm <- readr::read_csv("countries_to_remove.csv")
colnames(PISA_countries_to_rm) <- c("Code", "Country_name")
PISA_countries <- PISA_countries %>% filter(!(Code %in% PISA_countries_to_rm$Code))

matchcountries <- NULL
for( i in 1:nrow(PISA_countries) ) {
  matchcountries <- c(matchcountries, amatch(as.character(PISA_countries$Country_name[i]),
                                      as.character(WB_countries$Country_name),maxDist=Inf))
}

countries_baseline <- NULL
for (i in 1:length(matchcountries)) {
  if ( !is.na(matchcountries[i]) ) {
    countries_baseline <- rbind(countries_baseline, 
                                           c(as.character(PISA_countries[i, ]), 
                                             as.character(WB_countries[matchcountries[i],])
                                             )
                                           )
  }
}

countries_baseline <- as.data.frame(countries_baseline, stringsAsFactors = FALSE)
colnames(countries_baseline) <- c("id_country_pisa", "name_country_pisa", "id_country_wb", "name_country_wb")

#WDIsearch('urban')

varnames <- c("NY.GDP.PCAP.KD", "SP.URB.TOTL.IN.ZS", "SP.RUR.TOTL.ZS", "SP.DYN.LE00.IN", "SI.POV.GINI", 
              "SE.XPD.TOTL.GD.ZS", "UIS.ROFSPPT.1", "SE.SEC.NENR", "EN.ATM.CO2E.PC", "SL.UEM.1524.ZS",
              "SE.TER.TCHR", "BAR.TER.CMPT.15UP.ZS", "SE.PRM.ENRL.TC.ZS", "UIS.GER.2.GPI", "EN.POP.DNST")

macro_indicators   <- WDI(indicator = varnames, country = as.character(countries_baseline$id_country_wb), start = 2002, end = 2015)
colnames(macro_indicators)[c(1,2)] <- c("id_country_wb", "name_country_wb")

macro_indicators <- macro_indicators %>% inner_join(countries_baseline, "id_country_wb") %>% 
                    select(-one_of(c("id_country_wb", "name_country_wb.x", "name_country_wb.y")))

CNT_NAME <- unique(macro_indicators[, c("id_country_pisa", "name_country_pisa")])

macro_indicators <- macro_indicators %>% select(-one_of("name_country_pisa")) %>% rename(CNT = id_country_pisa)

macro_indicators$year <- as.integer(macro_indicators$year)

write_csv(macro_indicators, "macro_indicators.csv", na = "\\N")
