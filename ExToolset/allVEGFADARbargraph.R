suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("data.table"))
suppressPackageStartupMessages(library("ggpubr"))
##all VEGF gene level
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/VEGFAmeansd.csv")
table1A <- add_column(table1, gene = "VEGFA", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
table2 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/VEGFBmeansd.csv")
table2A <- add_column(table2, gene = "VEGFB", .after = 1)
colnames(table2A)[1] <- "condition"
colnames(table2A)[3] <- "avg"
colnames(table2A)[4] <- "sd"
tablemerge <- rbind(table1A, table2A)
write.csv(tablemerge, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/allVEGFs.csv",row.names=FALSE)
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/allVEGFs.csv")
tiff("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/allVEGFs.tiff", units="in", width=10, height=10, res=600)
q <- ggplot(table1, aes(x=gene, y=avg, fill=condition)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="VEGF genes", y="mRNA expression counts normalized for coverage at each nucleotide", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
q
dev.off()
##VEGFA 4 isoforms
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/VEGFA165meansd.csv")
table1A <- add_column(table1, gene = "VEGFA165", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
table2 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/VEGFA121meansd.csv")
table2A <- add_column(table2, gene = "VEGFA121", .after = 1)
colnames(table2A)[1] <- "condition"
colnames(table2A)[3] <- "avg"
colnames(table2A)[4] <- "sd"
table3 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/VEGFA189meansd.csv")
table3A <- add_column(table3, gene = "VEGFA189", .after = 1)
colnames(table3A)[1] <- "condition"
colnames(table3A)[3] <- "avg"
colnames(table3A)[4] <- "sd"
table4 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/VEGFA165Bmeansd.csv")
table4A <- add_column(table4, gene = "VEGFA165B", .after = 1)
colnames(table4A)[1] <- "condition"
colnames(table4A)[3] <- "avg"
colnames(table4A)[4] <- "sd"
tablemerge <- rbind(table1A, table2A, table3A, table4A)
write.csv(tablemerge, "/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allVEGFAs.csv",row.names=FALSE)
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allVEGFAs.csv")
tiff("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allVEGFAs.tiff", units="in", width=10, height=10, res=600)
r <- ggplot(table1, aes(x=gene, y=avg, group=condition, color=condition)) + geom_line() + geom_point() + geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.4) + scale_color_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") + labs(x="VEGFA isoforms", y="mRNA expression counts normalized for coverage at each nucleotide", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
r
dev.off()
##VEGFB 2 isoforms
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/VEGFB186meansd.csv")
table1A <- add_column(table1, gene = "VEGFB186", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
table2 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/VEGFB167meansd.csv")
table2A <- add_column(table2, gene = "VEGFB167", .after = 1)
colnames(table2A)[1] <- "condition"
colnames(table2A)[3] <- "avg"
colnames(table2A)[4] <- "sd"
tablemerge <- rbind(table1A, table2A)
write.csv(tablemerge, "/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allVEGFBs.csv",row.names=FALSE)
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allVEGFBs.csv")
tiff("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allVEGFBs.tiff", units="in", width=10, height=10, res=600)
s <- ggplot(table1, aes(x=gene, y=avg, fill=condition)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="VEGFB isoforms", y="mRNA expression counts normalized for coverage at each nucleotide", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
s
dev.off()
##ADAR1 three isoforms
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARp150meansd.csv")
table1A <- add_column(table1, gene = "ADARp150", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
table2 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARp110meansd.csv")
table2A <- add_column(table2, gene = "ADARp110", .after = 1)
colnames(table2A)[1] <- "condition"
colnames(table2A)[3] <- "avg"
colnames(table2A)[4] <- "sd"
table3 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARp80meansd.csv")
table3A <- add_column(table3, gene = "ADARp80", .after = 1)
colnames(table3A)[1] <- "condition"
colnames(table3A)[3] <- "avg"
colnames(table3A)[4] <- "sd"
tablemerge <- rbind(table1A, table2A, table3A)
write.csv(tablemerge, "/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADAR1.csv",row.names=FALSE)
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADAR1.csv")
tiff("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADAR1.tiff", units="in", width=10, height=10, res=600)
t <- ggplot(table1, aes(x=gene, y=avg, fill=condition)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="ADAR1 isoforms", y="mRNA expression counts normalized for coverage at each nucleotide", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
t
dev.off()
##ADARB1 line graph
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_003meansd.csv")
table1A <- add_column(table1, gene = "ADARB1_003", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
table2 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_004meansd.csv")
table2A <- add_column(table2, gene = "ADARB1_004", .after = 1)
colnames(table2A)[1] <- "condition"
colnames(table2A)[3] <- "avg"
colnames(table2A)[4] <- "sd"
table3 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_005meansd.csv")
table3A <- add_column(table3, gene = "ADARB1_005", .after = 1)
colnames(table3A)[1] <- "condition"
colnames(table3A)[3] <- "avg"
colnames(table3A)[4] <- "sd"
table4 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_006meansd.csv")
table4A <- add_column(table4, gene = "ADARB1_006", .after = 1)
colnames(table4A)[1] <- "condition"
colnames(table4A)[3] <- "avg"
colnames(table4A)[4] <- "sd"
table5 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_007meansd.csv")
table5A <- add_column(table5, gene = "ADARB1_007", .after = 1)
colnames(table5A)[1] <- "condition"
colnames(table5A)[3] <- "avg"
colnames(table5A)[4] <- "sd"
table6 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_011meansd.csv")
table6A <- add_column(table6, gene = "ADARB1_011", .after = 1)
colnames(table6A)[1] <- "condition"
colnames(table6A)[3] <- "avg"
colnames(table6A)[4] <- "sd"
table7 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_201meansd.csv")
table7A <- add_column(table7, gene = "ADARB1_201", .after = 1)
colnames(table7A)[1] <- "condition"
colnames(table7A)[3] <- "avg"
colnames(table7A)[4] <- "sd"
table8 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB1_202meansd.csv")
table8A <- add_column(table8, gene = "ADARB1_202", .after = 1)
colnames(table8A)[1] <- "condition"
colnames(table8A)[3] <- "avg"
colnames(table8A)[4] <- "sd"
tablemerge <- rbind(table1A, table2A, table3A, table4A, table5A, table6A, table7A, table8A)
write.csv(tablemerge, "/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADARB1.csv",row.names=FALSE)
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADARB1.csv")
tiff("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADARB1.tiff", units="in", width=10, height=10, res=600)
u <- ggplot(table1, aes(x=gene, y=avg, group=condition, color=condition)) + geom_line() + geom_point() + geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.4) + scale_color_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") + labs(x="ADARB1 isoforms", y="mRNA expression counts normalized for coverage at each nucleotide", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
u
dev.off()
##ADARB2 two isoforms
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB2_01meansd.csv")
table1A <- add_column(table1, gene = "ADARB2_01", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
table2 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/ADARB2_04meansd.csv")
table2A <- add_column(table2, gene = "ADARB2_04", .after = 1)
colnames(table2A)[1] <- "condition"
colnames(table2A)[3] <- "avg"
colnames(table2A)[4] <- "sd"
tablemerge <- rbind(table1A, table2A)
write.csv(tablemerge, "/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADARB2.csv",row.names=FALSE)
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADARB2.csv")
tiff("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allADARB2.tiff", units="in", width=10, height=10, res=600)
v <- ggplot(table1, aes(x=gene, y=avg, fill=condition)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="ADARB2 isoforms", y="mRNA expression counts normalized for coverage at each nucleotide", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
v
dev.off()
##combine all graphs into one figure
tiff("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterest/allVEGFADAR.tiff", units="in", width=20, height=30, res=600)
final <- ggarrange(q, r, s, t, u, v, labels = c("A", "B", "C", "D", "E", "F"),ncol = 2, nrow = 3)
annotate_figure(final,
                top = text_grob("VEGF and ADAR genes and isoforms expression in AML compared to healthy bone marrow.", color = "black", face = "bold", size = 14),
                fig.lab = "Figure 8", fig.lab.face = "bold"
                )
##all ADAR gene level
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/ADARmeansd.csv")
table1A <- add_column(table1, gene = "ADAR", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
table2 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/ADARB1meansd.csv")
table2A <- add_column(table2, gene = "ADARB1", .after = 1)
colnames(table2A)[1] <- "condition"
colnames(table2A)[3] <- "avg"
colnames(table2A)[4] <- "sd"
table3 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/ADARB2meansd.csv")
table3A <- add_column(table2, gene = "ADARB2", .after = 1)
colnames(table3A)[1] <- "condition"
colnames(table3A)[3] <- "avg"
colnames(table3A)[4] <- "sd"
tablemerge <- rbind(table1A, table2A, table3A)
write.csv(tablemerge, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/allADARs.csv",row.names=FALSE)
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/allADARs.csv")
tiff("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterest/allADARs.tiff", units="in", width=10, height=10, res=600)
p <- ggplot(table1, aes(x=gene, y=avg, fill=condition)) + geom_bar(stat="identity", color="black", position=position_dodge()) + geom_errorbar(aes(ymin=avg-sd, ymax=avg+sd), width=.4, position=position_dodge(.9)) + scale_fill_manual(values=c("red","blue")) + theme_minimal() + theme(legend.position="bottom") +
  labs(x="ADAR genes", y="mRNA expression counts normalized for coverage at each nucleotide", color="condition") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p
dev.off()
