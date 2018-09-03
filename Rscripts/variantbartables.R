library("tibble")
library("dplyr")
library("plotly")
library("ggplot2")
table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/ntsubsallfinal.csv", row.names=1)
table2 <- t(table1)
pheno <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
pheno[, c(1,3)] <- NULL
table3 <- merge(pheno, table2, by="row.names")
head(table3)
table4 <- table3 %>% group_by(condition) %>% summarise (file_nameavg = mean(file_name), file_namesd = sd(file_name))
write.csv(table4, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/ntsubsallfinalconfinalfile_name.csv", row.names=FALSE)


table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/allfinal/importantAAsubsfinal.csv")
tiff("/media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/allfinal/importantAAsubsfinal.tiff", units="in", width=10, height=10, res=500)
p <- ggplot(table1, aes(x=index, y=subs, fill=condition)) + geom_bar(stat="identity", colour="black", position=position_dodge()) + geom_errorbar(aes(ymin=0, ymax=subs+sd), width=.6, position=position_dodge(.9)) + scale_fill_manual(values = c("#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"), name=c("hESC", "Endo", "Meso", "NPC", "PNCC"), labels=c("hESC", "Endo", "Meso", "NPC", "PNCC"))
p + xlab("Type of substitution by cell type") + ylab("Number of amino acid substitutions") + theme(legend.position = "bottom") + coord_flip()
p
dev.off()
