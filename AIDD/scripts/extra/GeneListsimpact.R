table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/condition_name/condition_name_1condition_nameprotein_effect.csv")
table1[2] <- NULL
write.csv(table1, "/media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/condition_name/condition_name_1condition_namelevelList.csv", row.names=FALSE)
