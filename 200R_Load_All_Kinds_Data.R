##%######################################################%##
#                                                          #
####                   csv data file                    ####
#                                                          #
##%######################################################%##

R200_01_latent_growth <- read.csv("https://raw.githubusercontent.com/aronlindberg/latent_growth_classes/master/LGC_data.csv", header = TRUE)
R200_02_kids <- read.delim("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test_delim.txt", sep="$") 
R200_03_police_death_raw <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/police-deaths/clean_data.csv", header = TRUE)
R200_04_police_death_cleaned <- read.csv("https://raw.githubusercontent.com/fivethirtyeight/data/master/police-deaths/all_data.csv", header = TRUE)

##%######################################################%##
#                                                          #
####                   Txt data file                    ####
#                                                          #
##%######################################################%##

# Txt data with sep="" (space)
R200_05_metoffice_anomaly <- read.table("http://www.metoffice.gov.uk/hadobs/hadcrut4/data/current/time_series/HadCRUT.4.6.0.0.annual_ns_avg.txt",
                        sep="", header = FALSE)

# Txt data with sep="/"
R200_06_kids <- read.table("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/scores_timed.txt", 
                        header = FALSE, 
                        sep="/", 
                        strip.white = TRUE, # indicate whether you want the white spaces from unquoted character fields stripped
                        na.strings = "EMPTY") # The na.strings indicates which strings should be interpreted as NA values.)

# Txt data with sep="$"
R200_07_kids <- read.delim("https://s3.amazonaws.com/assets.datacamp.com/blog_assets/test_delim.txt", sep="$") 


##%######################################################%##
#                                                          #
####               SPSS/STATA data file                 ####
#                                                          #
##%######################################################%##

library(haven)

R200_08_iris <- read_dta("iris_stata.dta")
R200_09_survey  <- read_spss("survey.sav")


##%######################################################%##
#                                                          #
####                  Excel data file                   ####
#                                                          #
##%######################################################%##

library(plyr)
library(readxl)

readxl_example()
R200_10_excel <- readxl_example("datasets.xls")
read_excel(R200_10_excel)
excel_sheets(R200_10_excel)

R200_11_excel <- read_excel("Labour.xls")
excel_sheets("Labour.xls")
R200_12_excel <- read_excel("Labour.xls", sheet = "Civil rights")
R200_13_excel <-read_excel("Labour.xls", sheet = "Civil rights", skip = 5)

# Mulitple sheets but same columns
sheet_list <- lapply(excel_sheets("Mortality_3years.xlsx"), read_excel, path="Mortality_3years.xlsx")
R200_14_excel1 <- dplyr::rbind_all(sheet_list)
R200_14_excel2 <- plyr::ldply(sheet_list, data.frame)

# Mulitple sheets but different columns
sheet_list <- lapply(excel_sheets("Mortality_diff_columns.xlsx"), read_excel, path="Mortality_diff_columns.xlsx")
R200_15_excel1 <- dplyr::rbind_all(sheet_list)
R200_15_excel2 <- plyr::ldply(sheet_list, data.frame)

# Mulitple sheets but unequal columns and rows
sheet_list <- lapply(excel_sheets("Mortality_unequal.xlsx"), read_excel, path="Mortality_unequal.xlsx")
R200_16_excel1 <- dplyr::rbind_all(sheet_list)
R200_16_excel2 <- plyr::ldply(sheet_list, data.frame)


##%######################################################%##
#                                                          #
####                  Json data file                    ####
#                                                          #
##%######################################################%##

library("httr")
library( "jsonlite")

R200_17_providers <- fromJSON( "http://fm.formularynavigator.com/jsonFiles/publish/11/47/providers.json" , simplifyDataFrame=TRUE, flatten = TRUE) 
R200_18_hadly <- fromJSON("https://api.github.com/users/hadley/repos", flatten = TRUE)
R200_19_worldbank <- stream_in(url("http://api.worldbank.org/country?per_page=10&region=OED&lendingtype=LNX&format=json"))
R200_20_diamond <- stream_in(url("http://jeroen.github.io/data/diamonds.json"))

NameWhatYouWant <- url("http://gtfs.irail.be/nmbs/feedback/occupancy-until-20161029.newlinedelimitedjsonobjects")
R200_21_irail <- flatten(jsonlite::stream_in(NameWhatYouWant), recursive=TRUE)

NameWhatYouWant2 <- fromJSON("http://citibikenyc.com/stations/json")
R200_23_stations <- NameWhatYouWant2$stationBeanList
colnames(R200_23_stations)

NameWhatYouWant3 <- fromJSON('http://ergast.com/api/f1/2004/1/results.json')
R200_24_drivers <- NameWhatYouWant3[["MRData"]][["RaceTable"]][["Races"]][["Results"]][[1]][["Driver"]]
colnames(R200_24_drivers)

books_key <- "&api-key=76363c9e70bc401bac1e6ad88b13bd1d"
url <- "http://api.nytimes.com/svc/books/v2/lists/overview.json?published_date=2013-01-01"
req <- fromJSON(paste0(url, books_key))
bestsellers <- req$results$list
R200_25_category <- bestsellers[[1, "books"]]
subset(R200_25_category, select = c("author", "title", "publisher"))

##%######################################################%##
#                                                          #
####                 Twitter data file                  ####
#                                                          #
##%######################################################%##

#Create your own appication key at https://dev.twitter.com/apps
consumer_key = "EZRy5JzOH2QQmVAe9B4j2w";
consumer_secret = "OIDC4MdfZJ82nbwpZfoUO4WOLTYjoRhpHRAWj6JMec";

#Use basic auth
secret <- jsonlite::base64_enc(paste(consumer_key, consumer_secret, sep = ":"))
req <- httr::POST("https://api.twitter.com/oauth2/token",
                  httr::add_headers(
                    "Authorization" = paste("Basic", gsub("\n", "", secret)),
                    "Content-Type" = "application/x-www-form-urlencoded;charset=UTF-8"
                  ),
                  body = "grant_type=client_credentials"
);

#Extract the access token
httr::stop_for_status(req, "authenticate with twitter")
token <- paste("Bearer", httr::content(req)$access_token)

#Actual API call
url <- "https://api.twitter.com/1.1/statuses/user_timeline.json?count=10&screen_name=Rbloggers"
req <- httr::GET(url, httr::add_headers(Authorization = token))
json <- httr::content(req, as = "text")
R200_26_tweets <- fromJSON(json)
substring(tweets$text, 1, 100)
