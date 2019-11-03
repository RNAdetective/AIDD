#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
wkd <- paste0(args[1])
level <- paste0(args[2])
file_out <- paste0(args[3])
Rtool <- paste0(args[4])
Rtype <- paste0(args[5])
readdepth <- paste0(args[6])
tempfile <- paste0(args[10])
tempfile2 <- paste0(args[11])
tempfile3 <- paste0(args[12])
Rtooltrans <- paste0(args[13])
rename <- paste0(args[14])
if ( Rtype == "multi" ){
  file_list <- list.files()
    for (file in file_list){     
      # if the merged dataset doesn't exist, create it
      if (!exists("dataset")){
        dataset <- read.csv(file)
        dataset[!duplicated(dataset$level), ]
      } 
      # if the merged dataset does exist, append to it
      if (exists("dataset")){
        temp_dataset <- read.csv(file)
        dataset <- merge(dataset, temp_dataset, by=level, all=T)
        dataset[!duplicated(dataset$level), ]
        rm(temp_dataset)
      }
     write.csv(dataset, tempfile, row.names=FALSE, quote = FALSE)
    }
    if ( Rtool == "G_VEX" ) {
    datatable <- read.csv(tempfile, row.names=1)
    datatranspose <- t(datatable)
    write.csv(datatranspose, tempfile2, quote = FALSE)
    datatable <- read.csv(tempfile2)
    colnames(datatable)[1] <- "CATEGORY"
    readdepth <- read.csv(readdepth)
    colnames(readdepth)[1] <- "CATEGORY"
    normalized <- merge(datatable, readdepth, by="CATEGORY", all=T)
    write.csv(normalized, file_out, row.names=FALSE, quote = FALSE)
    } else if ( Rtool == "I_VEX" ) {
    datatable <- read.csv(tempfile, row.names=1)
    write.csv(datatable, file_out, quote = FALSE)  
    }
} else if ( Rtype == "single" ) {
filein <- paste0(args[7])
pheno <- paste0(args[8])
data1 <- read.csv(filein)
data2 <- read.csv(readdepth)
datafinal <- merge(data1, data2, by="CATEGORY")
write.csv(datafinal, file_out, row.names=FALSE, quote=FALSE)
#subs <- read.csv(tempfile3)
#phenodata <- read.csv(pheno)
#colnames(phenodata)[2] <- "CATEGORY"
#phenofinal <- merge(phenodata, subs, by="CATEGORY")
#write.csv(phenofinal, file_out, row.names=FALSE, quote=FALSE)
} else if ( Rtype == "onesingle" ) {
data <- paste0(args[6])
pheno <- paste0(args[8])
file_out <- paste0(args[3])
data_in <- read.csv(data)
pheno_in <- read.csv(pheno)
colnames(pheno_in)[2] <- "CATEGORY"
final <- merge(pheno_in, data_in, by="CATEGORY")
write.csv(final, file_out, quote=FALSE, row.names=FALSE)
} else if ( Rtype == "transpose" ) {
data <- read.csv(file_out, row.names=1)
data2 <- t(data)
write.csv(data2, tempfile, quote=FALSE)
}else if ( Rtype == "single2f" ) {
data <- paste0(args[7]) #gene
pheno <- paste0(args[8]) #transcript
level_name <- (paste0(args[9])) 
file_out <- paste0(args[3])
data_in <- read.csv(data)
pheno_in <- read.csv(pheno)
if ( Rtool == "finalmerge" ) {
colnames(data_in)[1] <- level_name
colnames(pheno_in)[1] <- level_name
}
final <- merge(pheno_in, data_in, by=level_name)
final[!duplicated(final$level_name), ]
write.csv(final, tempfile, quote=FALSE, row.names=FALSE)
if ( Rtool == "transpose" ) {
data <- read.csv(tempfile, row.names=1)
data2 <- t(data)
write.csv(data2, file_out, quote=FALSE)
}
if ( Rtooltrans == "transpose" ) {
data <- read.csv(file_out, row.names=1)
data2 <- t(data)
write.csv(data2, tempfile, quote=FALSE)
}
GOI_file <- paste0(args[10])
if ( GOI_file == "GOItrue" ) {
new_data <- read.csv(file_out)
pheno <- read.csv(readdepth)
colnames(new_data)[1] <- "CATEGORY"
colnames(pheno)[1] <- "CATEGORY"
new_datamerge <- merge(pheno, new_data, by="CATEGORY")
write.csv(new_datamerge, file_out, row.names=FALSE, quote=FALSE)
}
}
