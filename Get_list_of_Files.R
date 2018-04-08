# Prepare and save list of files 

Get_list_of_files <- function(folder_name, num_files_in_each_bucket, output_file){
    
    #############  
    
    print(paste(Sys.time(), ": Generating the list of all files in ", folder_name, sep = ""))
    
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
    
    if(!dir.exists("data")) {dir.create("data")}
    write.table(files, output_file, row.names = FALSE)
    
    print(paste(Sys.time(), ": Completed", sep = ""))
}