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
