# Get_list_of_files
# Finds all files in a directory (folder_name)
# Assigns them to buckets of size num_files_in_each_bucket (to be analysed in bunches later)
# Adds a status column to the list to identify the photos that have already been analysed
# Writes the list into output_file

Get_list_of_files <- function(folder_name, num_files_in_each_bucket, output_file){
    
    #############  
    
    print(paste(Sys.time(), ": Generating list of all files in ", folder_name, sep = ""))
    
    files <- 
        data.frame(
            file_path =  
                unlist(list.files(
                    folder_name, 
                    all.files = TRUE,
                    full.names = TRUE,
                    recursive = TRUE)),
            status = FALSE)
    
    print(paste(Sys.time(), ": Completed", sep = ""))
    
    #############
    
    print(paste(Sys.time(), ": Assigning files to buckets", sep = ""))
    
    num_files <- dim(files)[1]
    
    files$bucket <- rep(1:round(num_files/num_files_in_each_bucket), 
                        each = num_files_in_each_bucket, 
                        length.out = num_files)
    
    print(paste(Sys.time(), ": Completed", sep = ""))
    
    #############
    
    print(paste(Sys.time(), ": Writing results to ", output_file, sep = ""))
    
    write.table(files, output_file, row.names = FALSE)
    
    print(paste(Sys.time(), ": Completed", sep = ""))
}