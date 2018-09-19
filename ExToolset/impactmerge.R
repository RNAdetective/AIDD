dataset1 <- read.csv("/media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/condition_name1levelprotein_effectfinal.csv")
dataset2 <- read.csv("/media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/condition_name2levelprotein_effectfinal.csv")
final <- merge(dataset1, dataset2, by="level_id")
write.csv(final, "/media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/levelprotein_effectfinal.csv", row.names=FALSE)
