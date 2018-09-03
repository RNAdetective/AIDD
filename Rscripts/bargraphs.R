suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("ggplot2"))
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/Listnames/Listnames.csv", row.names=1)
table1[, c(1:7)] <- NULL
table2 <- t(table1)
pheno <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
pheno[, c(1,3)] <- NULL
table3 <- merge(pheno, table2, by="row.names")
table4 <- table3 %>% group_by(condition) %>% summarise (file_name7avg = mean(file_name7), file_name7sd = sd(file_name7))
write.csv(table4, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/Listnames/file_name7meanfile_name7sd.csv", row.names=FALSE)
tiff("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/Listnames/file_name7mean.tiff", units="in", width=10, height=10, res=900)
p <- ggplot(table4, aes(set_x, y=file_name7avg, set_fill)) + 
   geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=file_name7avg-file_name7sd, ymax=file_name7avg+file_name7sd), width=.4,
                 position=position_dodge(.9))
  
p + scale_fill_manual(values=c(set_barcolors)) + theme_minimal()
p
dev.off()

