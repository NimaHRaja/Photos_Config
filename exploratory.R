# INIT

library(exifr)
# library(tools) file_ext()
library(Rcpp)
library(reshape2)
library(ggplot2)

source("Get_list_of_Files.R")
source("Get_Meta_for_a_Bucket.R")
# Prepare and save list of files 

if(!dir.exists("data")) {dir.create("data")}
if(!dir.exists("data/list")) {dir.create("data/list")}
if(!dir.exists("data/photo_meta")) {dir.create("data/photo_meta")}

Get_list_of_files(folder_name = "C:/Photos_All", 
                  num_files_in_each_bucket = 1000, 
                  output_file = "data/list/list_of_photos.csv")


# Read and Subset list_of_files

list_of_files <- 
    read.table("data/list/list_of_photos.csv", 
               header = TRUE, 
               stringsAsFactors = FALSE)

meta_for_a_bucket <- 
    Get_meta_for_a_bucket(i = 2, 
                          list_of_files = list_of_files)

list_of_files_temp <- merge(list_of_files, 
                            meta_for_a_bucket[[2]], 
                            by = "file_path", 
                            all.x = TRUE)

list_of_files_temp[!(is.na(list_of_files_temp$bucket_id)),]$status <- TRUE
write.table(list_of_files_temp[, 1:3], "data/list/list_of_photos.csv", row.names = FALSE)

write.table(meta_for_a_bucket[[1]],
            paste("data/photo_meta/photo_meta_", i, ".csv", sep = ""),
            row.names = FALSE)










### Exploratory Approach

# add_a_file_meta_to_csv <- function(a_file){
#     
#     # print(a_file)
#     if(!files[files$file_path == a_file, ]$status){
#         output <- melt(exifr(a_file), id.vars = c("SourceFile"))
#         
#         write.table(output, 
#                     "data/photos_metadata.csv", 
#                     row.names = FALSE, 
#                     append = TRUE, 
#                     col.names = FALSE)
#         
#         # print("message to log")
#         
#         # files[files$file_path == a_file, ]$status <- TRUE
#     }
#     # head(files)
# }

num_files_in_one_go <- 100
num_repeat <- 1

for(i in 1:num_repeat){
    
    print(Sys.time())
    files <- read.csv("data/list_of_photos.csv", stringsAsFactors = FALSE)
    set_of_files <- subset(files, !status)$file_path
    if(length(set_of_files)[1] > num_files_in_one_go){set_of_files <- 
        set_of_files[1:num_files_in_one_go]}
    
    
    lapply(set_of_files, add_a_file_meta_to_csv)
    files[files$file_path %in% set_of_files, ]$status <- TRUE
    write.csv(files, "data/list_of_photos.csv", row.names = FALSE)
    
    print(table(files$status))
    print(Sys.time())
}


A <- read.table("data/photos_metadata.csv", stringsAsFactors = FALSE, header = TRUE)
length(unique(A$SourceFile))

###########################

GG <- subset(A, variable %in% c("CreateDate", "Model"))
GG <- dcast(GG, SourceFile ~ variable, value.var = "value")
GG$CreateDate <- strptime(GG$CreateDate, format = "%Y:%m:%d %H:%M:%S")
ggplot(GG, aes(x = CreateDate, fill = Model)) + geom_histogram()
ggplot(GG, aes(x = CreateDate, fill = Model)) + geom_histogram() + facet_grid(Model ~ .)

###########################

table(subset(A, variable == "FileTypeExtension")$value)
table(subset(A, variable == "FileType")$value)
table(subset(A, variable == "Model")$value)
table(subset(A, variable == "ExposureTime")$value)
table(subset(A, variable == "ExifVersion")$value)
table(subset(A, variable == "CameraTemperature")$value)
table(subset(A, variable == "ImageSize")$value)
table(subset(A, variable == "FilePermissions")$value)
table(subset(A, variable == "Orientation")$value)
table(subset(A, variable == "ISO")$value)
table(subset(A, variable == "CameraISO")$value)
table(subset(A, variable == "CanonFlashMode")$value)
table(subset(A, variable == "SelfTimer")$value)
table(subset(A, variable == "SelfTimer2")$value)
table(subset(A, variable == "DigitalZoom")$value)
table(subset(A, variable == "Contrast")$value)
table(subset(A, variable == "ManualFlashOutput")$value)
table(subset(A, variable == "FacesDetected")$value)

# ExposureTime

##################################
GG[1,]$CreateDate$mon
JJ <- subset(A, variable %in% c("CreateDate", "CameraTemperature", "Model"))
JJ <- dcast(JJ, SourceFile ~ variable, value.var = "value")
JJ$CreateDate <- strptime(JJ$CreateDate, format = "%Y:%m:%d %H:%M:%S")
JJ$month <- JJ$CreateDate$mon
table(JJ$month)
ggplot(JJ, aes(x = as.factor(CreateDate$mon), y = as.integer(CameraTemperature))) + 
    geom_boxplot() + facet_grid(. ~ Model)

###########################


WW <- dcast(subset(A, variable %in% c("FacesDetected", "FileType")), SourceFile ~ variable)
table(WW$FacesDetected, WW$FileType)

WW <- dcast(subset(A, variable %in% c("ISO", "CameraISO")), SourceFile ~ variable)
table(WW$ISO, WW$CameraISO)

WW <- dcast(subset(A, variable %in% c("Model", "ExifVersion")), SourceFile ~ variable)
table(WW$Model, WW$ExifVersion)

WW <- dcast(subset(A, variable %in% c("Model", "ImageSize")), SourceFile ~ variable)
table(WW$Model, WW$ImageSize)


table(table(subset(A, variable == "FileNumber")$value))
table(subset(A, variable == "FileNumber")$value) [table(subset(A, variable == "FileNumber")$value)== 3]

table(table(A$SourceFile))
# table(A$SourceFile)[table(A$SourceFile) == 173]

ggplot(subset(A, variable == "FileSize"), aes (x = as.integer(value))) + 
    geom_histogram() +
    xlim(0,5000000)

length(unique(A$variable))

B <- dcast(A, SourceFile ~ variable, value.var = "value")


# dcast(subset(A, SourceFile %in% c("C:/Photos_All/DCIM/143___12/IMG_0358.JPG", 
#                             "C:/Photos_All/DCIM/143___12/IMG_0357.JPG")), 
#        variable ~ SourceFile)


# 
# 
# 
# 
# a_file <- exifr(set_of_files[[1]])
# 
# 
# 
# subset(a_file, select = AFPoint)
# 
# Sys.time()
# GG <- lapply(files, exifr)
# Sys.time()
# 
# table(unlist(lapply(GG, function(x) subset(x, select = AFPoint))))
# 
# View(GG[26])

