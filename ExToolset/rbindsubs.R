setwd("/media/sf_AIDD/Results/variant_calling/sub_level/largegraph")
 
file_list <- list.files()
 
for (file in file_list){
       
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.csv(file)
  }
   
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.csv(file)
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
 write.csv(dataset, "/media/sf_AIDD/Results/variant_calling/sub_level/largegraph/sub_levelfinalmeansd.csv", row.names=FALSE)
}

