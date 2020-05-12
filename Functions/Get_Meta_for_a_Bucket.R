# Get_meta_for_a_bucket
# Gets list_of_files and bucket number (i)
# Finds all the files in that buckets which hasn't been analysed 
# Extracts the metadata and melts (flatten) them
# Returns the metadata and a list of the analysed files

Get_meta_for_a_bucket <- function(i, list_of_files){
    print(paste(Sys.time(), ": Subsetting the list", sep = ""))
    
    bucket_of_files <- subset(list_of_files, bucket == i & !status)
    
    print(paste(Sys.time(), ": Completed", sep = ""))
    
    ############# 
    
    print(paste(Sys.time(), ": Getting metadata for bucket ", i, sep = ""))
    
    output<- melt(read_exif(bucket_of_files$file_path), id.vars = "SourceFile")
    
    print(paste(Sys.time(), ": Completed", sep = ""))
    
    print(paste(Sys.time(), ": Returning the result for bucket ", i, sep = ""))
    
    list(meta_for_a_bucket = output, 
         list_of_files = data.frame(file_path = unique(output$SourceFile), bucket_id = i))
}