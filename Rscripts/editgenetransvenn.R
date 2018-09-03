table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/regulationidGlistclasscell_lineadded.csv")
colnames(table1)[3] <- "regulationcell_lineclassranscript"
colnames(table1)[2] <- "XX"
table1$XX <- NULL
write.csv(table1, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/regulationidGlistclasscell_lineadded.csv", row.names=FALSE)

