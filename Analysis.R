######### INIT 

source("Functions/General/INIT.R")

######### Camera models

### Number of photos per Camera per year

source("Functions/Analysis/get_Camera_model.R")

DF_camera <- 
    do.call("bind_rows", 
            lapply(
                list.files(
                    config %>% filter(type == "meta_folder_analysis") %>% select(value) %>% as.character(), 
                    full.names = TRUE)[1:2], 
                get_camera_model)) 


DF_camera %>% 
    mutate(year = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y")) %>%
    group_by(year, Model, CanonModelID) %>% summarise(n())

######### File Numbers

source("Analysis/get_file_number.R")

DF_FileNumber <- 
    do.call("bind_rows", 
            lapply(
                list.files(
                    config %>% filter(type == "meta_folder_analysis") %>% select(value) %>% as.character(), 
                    full.names = TRUE), 
                get_file_number))  %>% 
    mutate(year = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y")) %>%
    mutate(series = floor(FileNumber/1000), FN = FileNumber - series * 1000)

DF_FileNumber %>% 
    arrange(DateTimeOriginal) %>%
    group_by(series) %>%
    summarise(started = min(DateTimeOriginal), ended = max(DateTimeOriginal), 
              min_FN = min(FN), max_FN = max(FN), count = n(), delta = max_FN - min_FN - count + 1) %>%
    mutate(delta2 = ((( max_FN %>% lag(1)) - min_FN + 1) %% 1000)) %>%
    View()


DF_FileNumber %>% mutate(FN = FN + series %%10 * 1000, series = floor(series/10))  %>% 
    arrange(DateTimeOriginal) %>%
    group_by(series) %>%
    summarise(started = min(DateTimeOriginal), ended = max(DateTimeOriginal), 
              min_FN = min(FN), max_FN = max(FN), count = n(), delta = max_FN - min_FN - count + 1) %>%
    mutate(delta2 = ((( max_FN %>% lag(1)) - min_FN + 1) %% 1000)) %>%
    View()


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
    arrange(started) %>%
    View()


########## CameraTemperature

source("Analysis/get_temperature.R")

DF_temperature <- 
    do.call("bind_rows", 
            lapply(
                list.files(
                    config %>% filter(type == "meta_folder_analysis") %>% select(value) %>% as.character(), 
                    full.names = TRUE), 
                get_temperature))  %>% 
    mutate(year_month_number = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y-%m")) %>% 
    mutate(year_month = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y-%b")) %>% 
    mutate(year = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y")) %>% 
    mutate(month_number = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%m")) %>% 
    mutate(month = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%b")) %>% 
    mutate(yearmon = as.yearmon(as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S")))

# jpeg("camera5_temperature.jpg", width = 800, height = 600)
DF_temperature %>% filter(!is.na(CameraTemperature)) %>%
    ggplot(aes(x = yearmon, y = CameraTemperature, group = yearmon)) + 
    geom_boxplot(fill = "lightblue")
# dev.off()
