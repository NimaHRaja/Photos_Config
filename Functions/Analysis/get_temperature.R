### Extracts Camera Temperature from Metadata files

get_temperature <- function(file_name) {
    # function(base_file, bucket_number) {
    
    print(file_name)
    
    load(file = file_name)
    
    output %>% select(DateTimeOriginal, CameraTemperature)
} 
