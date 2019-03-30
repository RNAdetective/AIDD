


####OLD BARGRAPHS.R
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



BARGRAPHSSUBS.R OLD FILE




suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("ggplot2"))
table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/sub_level/sub_levelproportions.csv", row.names=1)
table4 <- t(table1)
pheno <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
pheno[, c(1,3)] <- NULL
table5 <- merge(pheno, table4, by="row.names")
table6 <- table5 %>% group_by(set_group) %>% summarise (file_nameavg = mean(file_name), file_namesd = sd(file_name))
write.csv(table6, "/media/sf_AIDD/Results/variant_calling/sub_level/largegraph/file_namemeansd.csv", row.names=FALSE)
tiff("/media/sf_AIDD/Results/variant_calling/sub_level/file_namemean.tiff", units="in", width=10, height=10, res=600)
p <- ggplot(table6, aes(set_x, y=file_nameavg, set_fill)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=file_nameavg, ymaset_x+file_namesd)) + scale_fill_manual(values=c(set_barcolors)) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="level of interest", y="mRNA expression counts normalized for coverage at each sub_level", color="set_group") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p
dev.off()
##relabelsubs.R
suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("data.table"))
suppressPackageStartupMessages(library("ggpubr"))
table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/sub_level/largegraph/file_namemeansd.csv")
table1A <- add_column(table1, subs_names = "file_name", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
write.csv(table1A, "/media/sf_AIDD/Results/variant_calling/sub_level/largegraph/file_namemeansd.csv", row.names=FALSE)
##rbindsubs.R
setwd("/media/sf_AIDD/Results/variant_calling/sub_level/largegraph")
 
file_list <- list.files()
 
for (file in file_list){
       
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.csv(file)
  }
   
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.csv(file)
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
 write.csv(dataset, "/media/sf_AIDD/Results/variant_calling/sub_level/largegraph/sub_levelfinalmeansd.csv", row.names=FALSE)
}
##subsbargraphs.R
suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("data.table"))
suppressPackageStartupMessages(library("ggpubr"))
table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/nucleotide/largegraph/nucleotidefinalmeansd.csv")
tiff("/media/sf_AIDD/Results/variant_calling/nucleotide/largegraph/nucleotidefinalmeansd.tiff", units="in", width=10, height=10, res=600)
v <- ggplot(table1, aes(x=subs_names, y=avg, fill=condition)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=avg, ymax=avg+sd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="nucleotide substitutions", y="number of substitutions", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
v
dev.off()
table2 <- read.csv("/media/sf_AIDD/Results/variant_calling/amino_acid/largegraph/amino_acidfinalmeansd.csv")
tiff("/media/sf_AIDD/Results/variant_calling/amino_acid/largegraph/amino_acidfinalmeansd.tiff", units="in", width=10, height=10, res=600)
w <- ggplot(table2, aes(x=subs_names, y=avg, fill=condition)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=avg, ymax=avg+sd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="nucleotide substitutions", y="number of substitutions", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
w
dev.off()
##combine all graphs into one figure
tiff("/media/sf_AIDD/Results/variant_calling/substitutions/allsubs.tiff", units="in", width=20, height=30, res=600)
final <- ggarrange(v, w, labels = c("A", "B"),ncol = 1, nrow = 2)
annotate_figure(final,
                top = text_grob("substitutions caused by RNA editing in AML compared to healthy bone marrow.", color = "black", face = "bold", size = 14),
                fig.lab = "Figure 8", fig.lab.face = "bold"
                )

