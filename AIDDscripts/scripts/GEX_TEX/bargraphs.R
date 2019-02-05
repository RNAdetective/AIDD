suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("ggplot2"))
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/List_names/List_namesfinalresults.csv")
table2 <- table1[c(set_column_order)]
table2[, c(2:8)] <- NULL
table3 <- table2[,-1]
rownames(table3) <- table2[,1]
table4 <- t(table3)
pheno <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
pheno[, c(1,3)] <- NULL
table5 <- merge(pheno, table4, by="row.names")
table6 <- table5 %>% group_by(set_group) %>% summarise (file_nameavg = mean(file_name), file_namesd = sd(file_name))
write.csv(table6, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/List_names/file_namemeansd.csv", row.names=FALSE)
tiff("/media/sf_AIDD/Results/DESeq2/level/differential_expression/List_names/file_namemean.tiff", units="in", width=10, height=10, res=600)
p <- ggplot(table6, aes(x=set_group, y=file_nameavg, fill=set_group)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=file_nameavg-file_namesd, ymax=file_nameavg+file_namesd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c(set_barcolors)) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="level of interest", y="mRNA expression counts normalized for coverage at each nucleotide", color="set_group") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p
dev.off()
