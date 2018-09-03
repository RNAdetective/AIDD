##need to set variables: level and  (sample number in experiment)
##load matrix
matrix <- read.csv("/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrix.csv")
##change column 1 name to id
colnames(matrix)[1] <- "level_id"
##load index file
index <- read.csv("/media/sf_AIDD/index/level_names.csv")
index[3] <- NULL
##merge index file so have id, name, samples,
rename <- merge(index, matrix, by="level_id")
##gets rid of id column so left with name, samples
rename$level_id <- NULL
final <- rename[!duplicated(rename$level_name), ]
row.names(final) <- final$level_name
final[1] <- NULL
Data <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
colnames(final)[c(set_samp_num)] <- rownames(Data)[c(set_samp_num)]
write.csv(final, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixedited.csv")


