source("config.R")
input_file <- dir_path/Results/DESeq2/level_count_matrix.csv"
output_file <- dir_path/Results/DESeq2/level_count_matrixedited.csv"
index_file <- dir_path/indexes/index/level_names.csv
pheno_file <- dir_path/PHENO_DATA.csv
for (level in gene transcript ) {
  matrix <- read.csv(input_file) # LOAD MARTRIX
colnames(matrix)[1] <- "level_id" # ADD COLUMN NAME
index <- read.csv(index_file) # LOAD INDEX WITH GENE NAMES
  if (level=transcript) {
    set_column_order <- 1,3,2
    index2 <- index[c(set_column_order)] # SET COLUMN ORDER
    index2[3] <- NULL # REMOVES EXTRA COLUMN IN TRANSCRIPT 
  }
rename <- merge(index2, matrix, by="level_id") # COMBINES INDEX WITH MARTIX
rename$level_id <- NULL # GETS RID OF OLD ID NUMBER
final <- rename[!duplicated(rename$level_name), ] # REMOVES ANY DUPLICATE ROWS
row.names(final) <- final$level_name # RENAMES INDEX COLUMN
final[1] <- NULL 
Data <- read.csv(pheno_file, row.names=1) # READS PHENO_DATA
colnames(final) <- rownames(Data) # ADDS SAMPLE NAMES DEFINED BY USER TO MATRIX
write.csv(final, output_file) # WRITES THE NEWLY NAMED MATRIX FILE
}


