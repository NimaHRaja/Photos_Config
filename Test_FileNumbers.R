######### INIT 

source("Functions/General/INIT.R")

######### File Numbers

source("Functions/Analysis/get_file_number.R")

data_file <- paste(clean_metadata_folder, "/camera_filenumber.csv", sep = "")

if(!file.exists(data_file)){
    DF_FileNumber <- 
        do.call("bind_rows", 
                lapply(
                    list.files(
                        config %>% filter(type == "meta_folder_analysis") %>% select(value) %>% as.character(), 
                        full.names = TRUE), 
                    get_file_number))  %>% 
        mutate(year = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y")) %>%
        mutate(series = floor(FileNumber/1000), FN = FileNumber - series * 1000);
    
    write.csv(DF_FileNumber, data_file, row.names = FALSE)
} else {DF_FileNumber <- read.csv(data_file)}

DF_FileNumber %>% 
    arrange(DateTimeOriginal) %>%
    group_by(series) %>%
    summarise(started = min(DateTimeOriginal), ended = max(DateTimeOriginal), 
              min_FN = min(FN), max_FN = max(FN), count = n(), delta = max_FN - min_FN - count + 1) %>%
    mutate(delta2 = ((( max_FN %>% lag(1)) - min_FN + 1) %% 1000)) %>% View()


DF_FileNumber %>% mutate(FN = FN + series %%10 * 1000, series = floor(series/10))  %>% 
    arrange(DateTimeOriginal) %>%
    group_by(series) %>%
    summarise(started = min(DateTimeOriginal), ended = max(DateTimeOriginal), 
              min_FN = min(FN), max_FN = max(FN), count = n(), delta = max_FN - min_FN - count + 1) %>%
    mutate(delta2 = ((( max_FN %>% lag(1)) - min_FN + 1) %% 1000)) %>% View()


organised_folders <-            
    config %>% filter(type == "camera5_organised_series") %>% select(value) %>% as.character() %>% read.csv() %>%
    mutate(organised = "YES")


DF_FileNumber %>% mutate(FN = FN + series %%10 * 1000, series = floor(series/10))  %>% 
    # left_join(organised_folders, "series") %>%
    # filter(is.na(organised)) %>%
    mutate(Directory_short = substr(Directory,0,48)) %>%
    arrange(DateTimeOriginal) %>%
    group_by(series, Directory_short) %>%
    # group_by(series, Directory) %>%
    summarise(started = min(DateTimeOriginal), ended = max(DateTimeOriginal), 
              min_FN = min(FN), max_FN = max(FN), count = n(), delta = max_FN - min_FN - count + 1) %>%
    mutate(delta2 = ((( max_FN %>% lag(1)) - min_FN + 1) %% 1000)) %>%
    arrange(started) %>% View()

