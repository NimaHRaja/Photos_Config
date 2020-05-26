source("Functions_new/INIT.R")
source("Functions_new/Get_list_of_Files.R")
Get_list_of_files(folder_name = FN, num_files_in_each_bucket = 100, output_file = OP)
list_of_files <- read.table(OP, header = TRUE, stringsAsFactors = FALSE)
lapply(1:50,
       function(i){print(i);
           output <- read_exif((list_of_files %>% filter(bucket == i))$file_path);
           save(output,
                file = paste(
                    config %>% filter(type == "meta_file_common_name") %>% select(value) %>% as.character(),
                    i, ".Rdata", sep = ""))})
