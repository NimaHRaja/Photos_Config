######### INIT 

source("Functions_new/INIT.R")

######### Camera models

### Number of photos per Camera per year

source("Analysis/get_Camera_model.R")

DF_camera <- 
    do.call("bind_rows", 
            lapply(
                list.files(
                    config %>% filter(type == "meta_folder_analysis") %>% select(value) %>% as.character(), 
                    full.names = TRUE), 
                get_camera_model)) 


DF_camera %>% 
        mutate(year = as.POSIXct(DateTimeOriginal ,format="%Y:%m:%d %H:%M:%S") %>% format("%Y")) %>%
    group_by(year, Model, CanonModelID) %>% summarise(n())
