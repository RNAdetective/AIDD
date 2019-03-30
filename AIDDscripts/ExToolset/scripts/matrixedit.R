#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
output_file <- paste0(args[1])
input_file <- paste0(args[2])
index_file <- paste0(args[3])
pheno_file <- paste0(args[4])
Rtool <- paste0(args[5])
if ( Rtool == "GTEX" ) {
  level_id <- paste0(args[6])
  level_name <- paste0(args[7])
  filter_type <- paste0(args[8])
  level <- paste0(args[9])
  matrix <- read.csv(input_file) # LOAD MARTRIX
  colnames(matrix)[1] <- level_id # ADD COLUMN NAME
  index <- read.csv(index_file) # LOAD INDEX WITH GENE NAMES
  if ( level == "transcript" ) {
    index2 <- index[c(2,4,3,1)] # SET COLUMN ORDER
    index2[4] <- NULL # REMOVES EXTRA COLUMN IN TRANSCRIPT
    index <- index2[grep(filter_type, index2$type), ]
    index[3] <- NULL # REMOVES EXTRA COLUMN IN TRANSCRIPT
   }
  rename <- merge(index, matrix, by=level_id) # COMBINES INDEX WITH MARTIX
  rename[1] <- NULL # GETS RID OF OLD ID NUMBER
  colnames(rename)[1] <- level_name # RENAMES INDEX COLUMN
  newdata <- rename[order( rename[,1] ),] # sort them
  data <- newdata[!duplicated( newdata[,1] ), ]
  write.csv(newdata, output_file, quote=FALSE, row.names=FALSE)
  #rename <- read.csv(output_file, row.names=1)
  #Data <- read.csv(pheno_file, row.names=1) # READS PHENO_DATA
  #colnames(rename) <- rownames(Data) # ADDS SAMPLE NAMES DEFINED BY USER TO MATRIX
  #write.csv(rename, output_file, quote=FALSE) # WRITES THE NEWLY NAMED MATRIX FILE
} else if ( Rtool == "G_VEX" ) {
library("data.table")
input_file=paste0(args[2])
output_file=paste0(args[4])
data <- read.csv(input_file)
data2 <- as.matrix(data)
df <- as.vector(data2)
df2 <- cbind(df, "mergerow"=1:NROW(df))  
write.csv(df2, "/home/user/temp.csv", row.names=FALSE)
index <- read.csv(index_file)
final <- merge(index, df2, by="mergerow")
write.csv(final, output_file, row.names=FALSE)
} else if ( Rtool == "G_VEX2" ) { 
input_file=paste0(args[2])
data <- read.csv(input_file)
colnames(data)[1] <- "name"
data_summary <- read.csv(index_file) ## want to divid by read depth not by colSums
colnames(data_summary)[1] <- "name"
colnames(data_summary)[2] <- "totalcounts"
final <- merge(data, data_summary, by="name") # add column at the end
normalized <- sweep(final, 2, final$totalcounts, `/`)
write.csv(normalized, output_file)
}
