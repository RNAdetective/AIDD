data <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/level/protein_effect_impact/protein_effectmerged.csv", row.names=1)
names <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
colnames(data) <- rownames(names)
write.csv(data, "/media/sf_AIDD/Results/variant_calling/haplotype/level/protein_effect_impact/protein_effectmerged.csv")
