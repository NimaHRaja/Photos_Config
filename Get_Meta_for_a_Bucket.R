Get_meta_for_a_bucket <- function(i, list_of_files){
    print(paste(Sys.time(), ": Subsetting the list", sep = ""))
    
    bucket_of_files <- subset(list_of_files, bucket == i & !status)
    bucket_of_files <- bucket_of_files[1:10,]
    
    print(paste(Sys.time(), ": Completed", sep = ""))
    
    ############# 
    
    print(paste(Sys.time(), ": Getting metadata for bucket ", i, sep = ""))
    
    output<- melt(exifr(bucket_of_files$file_path), id.vars = "SourceFile")
    
    print(paste(Sys.time(), ": Completed", sep = ""))
    
    print(paste(Sys.time(), ": Returning the result for bucket ", i, sep = ""))
    
    list(meta_for_a_bucket = output, 
         list_of_files = data.frame(file_path = unique(output$SourceFile), bucket_id = i))
}