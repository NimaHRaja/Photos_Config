# INIT
# loads packages, sources functions, and create directories


# Libraries

library(exifr)
library(Rcpp)
library(reshape2)
library(ggplot2)


# Source functions

source("Get_list_of_Files.R")
source("Get_Meta_for_a_Bucket.R")


# Create directories

if(!dir.exists("data")) {dir.create("data")}
if(!dir.exists("data/list")) {dir.create("data/list")}
if(!dir.exists("data/photo_meta")) {dir.create("data/photo_meta")}
