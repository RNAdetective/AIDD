table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/counts/gene_count_matrix.csv")
table2 <- read.csv("/media/sf_AIDD/index/g_names.csv")
Data <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
table3 <- merge(table2, table1, by="gene_id")
table3$gene_id <- NULL
table5 <- colnames(table3)[c(2:5)] <- rownames(Data)[c(1:4)]
write.csv(table3, "/media/sf_AIDD/Results/DESeq2/gene/counts/gene_count_matrixedited.csv", row.names=FALSE)

table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/counts/transcript_count_matrix.csv")
colnames(table1)[1] <- "transcript_id"
table2 <- read.csv("/media/sf_AIDD/index/t_names.csv")
Data <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
table3 <- merge(table2, table1, by="transcript_id")
table3$transcript_id <- NULL
table5 <- colnames(table3)[c(2:5)] <- rownames(Data)[c(1:4)]
write.csv(table3, "/media/sf_AIDD/Results/DESeq2/transcript/counts/transcript_count_matrixedited.csv", row.names=FALSE)
