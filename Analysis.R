######### INIT 

source("Functions/General/INIT.R")


#########################################################################
######### Camera models

### Number of photos per Camera per year

source("Functions/Analysis/get_Camera_model.R")

data_file <- paste(clean_metadata_folder, "/camera_models.csv", sep = "")

if(!file.exists(data_file)){
    DF_camera <- 
        do.call("bind_rows", 
                lapply(
                    list.files(
                        config %>% filter(type == "meta_folder_analysis") %>% select(value) %>% as.character(), 
                        full.names = TRUE), 
                    get_camera_model));
    
    write.csv(DF_camera, data_file, row.names = FALSE)
} else {DF_camera <- read.csv(data_file)}

DF_camera %>% 
    mutate(year = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y")) %>%
    group_by(year, Model, CanonModelID) %>% summarise(tot_photos = n())


#########################################################################
########## CameraTemperature

source("Functions/Analysis/get_temperature.R")

data_file <- paste(clean_metadata_folder, "/camera_temperature.csv", sep = "")

if(!file.exists(data_file)){
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
        mutate(yearmon = as.yearmon(as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S")));
    
    write.csv(DF_temperature, data_file, row.names = FALSE)
} else {DF_temperature <- read.csv(data_file)}

DF_temperature %>% filter(!is.na(CameraTemperature)) %>%
    ggplot(aes(x = yearmon, y = CameraTemperature, group = yearmon)) + 
    geom_boxplot(fill = "lightblue") +
    ggtitle("Camera Temperature v. Month")

DF_temperature %>% filter(!is.na(CameraTemperature)) %>%
    ggplot(aes(x = CameraTemperature, colour = month)) +
    geom_density()