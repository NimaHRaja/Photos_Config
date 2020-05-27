### Extracts File (serial) number from Metadata files

get_file_number <- function(file_name) {
    # function(base_file, bucket_number) {
    
    print(file_name)
    
    load(file = file_name)
    
    output %>% select(DateTimeOriginal, Directory, FileNumber)
} 
