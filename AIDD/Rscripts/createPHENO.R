##need to set 7:18-3 and 7:18-3P(for pheno_data file)
##this will split level_count_matrix by 3 conditions with however many replicates you have
countData <- read.csv("/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixedited.csv", row.names=1)
countDataF6 <- countData[ ,-c(7:18)]
write.csv(countDataF6, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedK048.csv")
countDataM6 <- countData[ ,-c(1:6, 13:18)]
write.csv(countDataM6, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedK054.csv")
countDataL6 <- countData[ ,-c(1:12)]
write.csv(countDataL6, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedG010.csv")
##this does the same for the pheno_data file.
colData <- read.csv("/media/sf_AIDD/PHENO_DATA.csv")
colDataF6 <- colData[-c(7:18), ]
write.csv(colDataF6, "/media/sf_AIDD/PHENO_DATAK048.csv", row.names=FALSE)
colDataM6 <- colData[-c(1:6, 13:18), ]
write.csv(colDataM6, "/media/sf_AIDD/PHENO_DATAK054.csv", row.names=FALSE)
colDataL6 <- colData[-c(1:12), ]
write.csv(colDataL6, "/media/sf_AIDD/PHENO_DATAG010.csv", row.names=FALSE)

