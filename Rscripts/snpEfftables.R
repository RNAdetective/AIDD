cell_line_1 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/level/protein_effect_impact/infection/cell_line_infection1infectionprotein_effect.csv")
cell_line_2 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/level/protein_effect_impact/infection/cell_line_infection2infectionprotein_effect.csv")
cell_line_3 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/level/protein_effect_impact/infection/cell_line_infection3infectionprotein_effect.csv")
cell_lineall <- merge(cell_line_1, cell_line_2, by="level_id")
cell_linefinal <- merge(cell_lineall, cell_line_3, by="level_id")
cell_linefinal2 <- cell_linefinal[!duplicated(cell_linefinal$level_id), ]
cell_linefinal3 <- cell_linefinal2[apply(cell_linefinal2[,-1], 1, function(x) !all(x==0)),] 
write.csv(cell_linefinal3, "/media/sf_AIDD/Results/variant_calling/haplotype/level/protein_effect_impact/cell_lineinfection.csv", row.names=FALSE)

