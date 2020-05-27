# INIT
# loads packages, sources functions, and create directories


### options

options(stringsAsFactors = FALSE)

### Libraries

library(exifr)
# library(Rcpp)
library(reshape2)
library(ggplot2)
library(dplyr)
library(fs)
library(zoo)


### Read config

config <- read.csv("config.csv", stringsAsFactors = FALSE) 
local_folder <- config %>% filter(type == "local_folder") %>% select(value) %>% as.character()
clean_metadata_folder <- config %>% filter(type == "clean_metadata_folder") %>% select(value) %>% as.character()



### Create directories

root_folder <- getwd()
setwd(local_folder)
if(!dir.exists("data")) {dir.create("data")}
if(!dir.exists("data/list")) {dir.create("data/list")}
if(!dir.exists("data/photo_meta")) {dir.create("data/photo_meta")}
setwd(root_folder)


# Remove variables

rm(root_folder)
