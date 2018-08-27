# get_folders_for_a_meta_file
# Reads metadata files and finds all photos of a camera.
# (temporary)

get_folders_for_a_meta_file <- function(meta_file, camera_name){
    DF <- read.table(meta_file, header = TRUE, stringsAsFactors = FALSE)
    
    photos <- 
        subset(DF, variable == "Model" & value == camera_name)$SourceFile
    
    print(meta_file)
    # unique(subset(DF, SourceFile %in% photos & variable == "Directory")$value)
    subset(DF, SourceFile %in% photos)
}

all_meta_files <- 
    unlist(list.files(
        "data/photo_meta", 
        all.files = TRUE,
        full.names = TRUE,
        recursive = TRUE))

BB <- do.call(rbind,lapply(all_meta_files, get_folders_for_a_meta_file, "Canon PowerShot SX220 HS"))

CC <- unique(data.frame(folder = subset(BB, variable == "Directory")$value, stringsAsFactors = FALSE))

table(apply(CC, 1, function(x){strsplit(x, "/")[[1]][3]}))


ff <- table(subset(BB, variable == "FileNumber")$value)
min(as.numeric(names(ff[ff > 1])))
min(as.numeric(names(ff[ff > 1]))[as.numeric(names(ff[ff > 1]))!= 1346170])

min(subset(BB, variable == "FileNumber")$value)

library(reshape2)
ghj <- 
    dcast(subset(BB, variable %in% c("FileNumber", "Directory")), 
          SourceFile ~ variable, value.var = "value")

ghj <- ghj[order(ghj$FileNumber),]
row.names(ghj) <- NULL


# 12450 فلیکر مریم
# تا ۱۵۶۵۷ انجام شده