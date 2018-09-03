table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/globalrun_namesubs.csv", row.names=1)
table2 <- t(table1)
write.csv(table2, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/globalrun_namesubsfinal.csv")
