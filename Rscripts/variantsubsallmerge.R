table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/globalcell_line/Basechanges.csv")
table2 <- as.matrix(table1)
table3 <- as.vector(table2)
write.csv(table3, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/Basechangesvectorcell_line.csv")
data <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/Basechangesvectorcell_line.csv")
colnames(data)[1] <- "merge"
colnames(data)[2] <- "cell_line"
index <- read.csv("/media/sf_AIDD/index/ntsubsrownames.csv")
colnames(index)[1] <- "merge"
colnames(index)[2] <- "index"
final <- merge(index, data, by="merge")
final$merge <- NULL
write.csv(final, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/Basechangesallcell_line.csv", row.names=FALSE)
tableA <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/globalcell_line/Aminoacidchangetable.csv")
tableB <- as.matrix(tableA)
tableC <- as.vector(tableB)
write.csv(tableC, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/Aminoacidchangesvectorcell_line.csv")
data <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/Aminoacidchangesvectorcell_line.csv")
colnames(data)[1] <- "merge"
colnames(data)[2] <- "cell_line"
index <- read.csv("/media/sf_AIDD/index/aasubsrownames.csv")
colnames(index)[1] <- "merge"
colnames(index)[2] <- "index"
final <- merge(index, data, by="merge")
final$merge <- NULL
write.csv(final, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/allfinal/Aminoacidchangesallcell_line.csv", row.names=FALSE)
