### Extracts Camera Model from Metadata files

get_camera_model <- function(file_name) {
    # function(base_file, bucket_number) {
    
    print(file_name)
    
    load(file = file_name)
    
    output %>% select(DateTimeOriginal, Model, CanonModelID)
} 