##these load all the programs used
library("DESeq2")
library("vsn")
library("dplyr")
library("ggplot2")
library("pheatmap")
library("RColorBrewer")
library("PoiClaClu")
library("ggbeeswarm")
library("genefilter")
library("sva")
table1 <- read.csv("transcript_count_matrix.csv")
tableF <- colnames(table1)[1] <- "t_id"
table2 <- read.csv("t_names.csv")
table3 <- merge(table2, table1, by="t_id")
table4 <- table3$t_id <- NULL
Data <- read.csv("PHENO_DATA.csv", row.names=1)
table5 <- colnames(table3)[c(2:5)] <- rownames(Data)[c(1:4)]
write.csv(table3, "transcript_count_matrixedited.csv", row.names=FALSE)
countData <- as.matrix(read.csv("transcript_count_matrixedited.csv", row.names="t_name"))
colData <- read.csv("PHENO_DATA.csv", row.names=1)
print("Do the row and columns names match in your files?")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("After renaming do the row and columns names still match?")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("Number of rows in new Matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("Number of rows in new Matrix that are greater then 1 count")
nrow(dds)
tiff("rlogandvariance_trans.tiff")
lambda <- 10^seq(from = -1, to = 2, length = 1000)
cts <- matrix(rpois(1000*100, lambda), ncol = 100)
meanSdPlot(cts, ranks = FALSE)
dev.off()
tiff("logtranscounts_trans.tiff")
log.cts.one <- log2(cts + 1)
meanSdPlot(log.cts.one, ranks = FALSE)
dev.off()
print("Taking rlog of new matrix counts")
rld <- rlog(dds, blind = FALSE)
print("top three rows in new rlog matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("top three rows in new vst rlog matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
df <- bind_rows(as_data_frame(log2(counts(dds, normalized=TRUE)[, 1:2]+1)) %>% mutate(transformation = "log2(x + 1)"), as_data_frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"), as_data_frame(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))
colnames(df)[1:2] <- c("x", "y")
tiff("transcounts2sam_trans.tiff")
ggplot(df, aes(x = x, y = y)) + geom_hex(bins = 80) + coord_fixed() + facet_grid( . ~ transformation)
dev.off()
sampleDists <- dist(t(assay(rld)))
sampleDists
sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$condition)
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
poisd <- PoissonDistance(t(counts(dds)))
samplePoisDistMatrix <- as.matrix( poisd$dd )
rownames(samplePoisDistMatrix) <- paste( rld$condition)
colnames(samplePoisDistMatrix) <- NULL
tiff("PoisHeatmap_trans.tiff")
pheatmap(samplePoisDistMatrix, clustering_distance_rows = poisd$dd, clustering_distance_cols = poisd$dd, col = colors)
dev.off()
tiff("PCAplot_trans.tiff")
plotPCA(rld, intgroup = c("condition"))
dev.off()
pcaData <- plotPCA(rld, intgroup = c( "condition"), returnData = TRUE)
pcaData
percentVar <- round(100 * attr(pcaData, "percentVar"))
tiff("PCAplot2_trans.tiff")
ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, group = condition, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_text(aes(label=rownames(pcaData)))
dev.off()
mds <- as.data.frame(colData(rld))  %>% cbind(cmdscale(sampleDistMatrix))
tiff("MDSplot_trans.tiff")
ggplot(mds, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
mdsPois <- as.data.frame(colData(dds)) %>% cbind(cmdscale(samplePoisDistMatrix))
tiff("MDSpois_trans.tiff")
ggplot(mdsPois, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
dds <- DESeq(dds)
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of newly calculated results")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("Table of new results with padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("Table of new results with log fold change greater then 1 and padj less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "resultsall_trans.csv")
print("Number of transcripts with pvalue less then 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of transcripts with pvalue sorted")
sum(!is.na(res$pvalue))
print("number of transcripts with padj less then 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top transcripts based on log2 fold changes")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "Downreg_trans.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "Upreg_trans.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
tiff("MAplot_trans.tiff")
plotMA(res, ylim = c(-5, 5))
dev.off()
tiff("Histopvalue_trans")
hist(res$pvalue[res$baseMean > 1], breaks = 0:20/20, col = "grey50", border = "white")
dev.off()
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,3]
colnames(anno) <- "t_name"
tiff("top60heatmap_trans.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
##these make final tables for VEGF and ADAR transcripts
##ADAR1
table1 <- read.csv("transcript_count_matrixedited.csv")
table2 <- read.csv("ADAR1transcript.csv")
table3 <- merge(table2, table1, by="t_name")
table4 <- table3$t_id <- NULL
tableB1 <- read.csv("resultsall_trans.csv")
table5 <- colnames(tableB1)[c(1)] <- c("t_name")
head(tableB1)
tableC3 <- merge(table3, tableB1, by="t_name")
write.csv(tableC3, "resultsADAR1_trans_counts.csv", row.names=FALSE)
Data <- read.csv("bargraphindextrans.csv")
tablebargraph <- t(tableC3)
colnames(tablebargraph) <- tableC3[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
Data <- read.csv("bargraphindextrans.csv")
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:13], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("ADAR1isoformbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##ADAR1 transcripts that are biologically relevant
table13 <- read.csv("transcript_count_matrixedited.csv")
table23 <- read.csv("ADAR1transcriptimp.csv")
table33 <- merge(table23, table13, by="t_name")
table43 <- table33$t_id <- NULL
tableC33 <- merge(table33, tableB1, by="t_name")
tablebargraph <- t(tableC33)
colnames(tablebargraph) <- tableC33[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:4], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
names1 <- read.csv("ADAR1transcriptimp_names.csv")
tablebargraph5 <- merge(tablebargraph5, names1, by="isoform_name")
tablebargraph6 <- merge(tablebargraph6, names1, by="isoform_name")
final <- rbind(tablebargraph5, tablebargraph6)
tiff("ADAR1isoformimpbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##ADARB1
table11 <- read.csv("transcript_count_matrixedited.csv")
table21 <- read.csv("ADARB1transcript.csv")
table31 <- merge(table21, table11, by="t_name")
table41 <- table31$t_id <- NULL
tableC31 <- merge(table31, tableB1, by="t_name")
write.csv(tableC31, "resultsADARB1_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC31)
colnames(tablebargraph) <- tableC31[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:11], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("ADARB1isoformbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##ADARB2 
table12 <- read.csv("transcript_count_matrixedited.csv")
table22 <- read.csv("ADARB2transcript.csv")
table32 <- merge(table22, table12, by="t_name")
table42 <- table32$t_id <- NULL
tableC32 <- merge(table32, tableB1, by="t_name")
write.csv(tableC32, "resultsADARB2_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC32)
colnames(tablebargraph) <- tableC32[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:4], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("ADARB2isoformbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##VEGFA
table13 <- read.csv("transcript_count_matrixedited.csv")
table23 <- read.csv("VEGFAtranscript.csv")
table33 <- merge(table23, table13, by="t_name")
table43 <- table33$t_id <- NULL
tableC33 <- merge(table33, tableB1, by="t_name")
write.csv(tableC33, "resultsVEGFA_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC33)
colnames(tablebargraph) <- tableC33[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:23], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("VEGFAisoformbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##VEGFA biologically relevant
table13 <- read.csv("transcript_count_matrixedited.csv")
table23 <- read.csv("VEGFAtranscriptimp.csv")
table33 <- merge(table23, table13, by="t_name")
table43 <- table33$t_id <- NULL
tableC33 <- merge(table33, tableB1, by="t_name")
tablebargraph <- t(tableC33)
colnames(tablebargraph) <- tableC33[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:6], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
names1 <- read.csv("VEGFAtranscriptimp_names.csv")
tablebargraph5 <- merge(tablebargraph5, names1, by="isoform_name")
tablebargraph6 <- merge(tablebargraph6, names1, by="isoform_name")
final <- rbind(tablebargraph5, tablebargraph6)
tiff("VEGFAisoformimpbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##VEGFB
table14 <- read.csv("transcript_count_matrixedited.csv")
table24 <- read.csv("VEGFBtranscript.csv")
table34 <- merge(table24, table1, by="t_name")
table44 <- table34$t_id <- NULL
tableC34 <- merge(table34, tableB1, by="t_name")
write.csv(tableC34, "resultsVEGFB_trans_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC34)
colnames(tablebargraph) <- tableC34[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:6], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("VEGFBisoformbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##VEGFB biologically relevant
table13 <- read.csv("transcript_count_matrixedited.csv")
table23 <- read.csv("VEGFBtranscriptimp.csv")
table33 <- merge(table23, table13, by="t_name")
table43 <- table33$t_id <- NULL
tableC33 <- merge(table33, tableB1, by="t_name")
tablebargraph <- t(tableC33)
colnames(tablebargraph) <- tableC33[,1]
tablebargraph2 <- tablebargraph[-c(1, 6, 7, 8, 9, 10, 11), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "sample"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="sample")
tablebargraph4 <- aggregate(tablebargraph3[, 3:4], list(tablebargraph3$isoform_name), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
colnames(tablebargraph5)[1] <- "isoform_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
colnames(tablebargraph5)[2] <- "counts"
tablebargraph6 <- read.csv("6.csv")
colnames(tablebargraph6)[1] <- "isoform_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
colnames(tablebargraph6)[2] <- "counts"
tablebargraph5["condition"] <- "AML"
tablebargraph6["condition"] <- "Normal"
names1 <- read.csv("VEGFBtranscriptimp_names.csv")
tablebargraph5 <- merge(tablebargraph5, names1, by="isoform_name")
tablebargraph6 <- merge(tablebargraph6, names1, by="isoform_name")
final <- rbind(tablebargraph5, tablebargraph6)
tiff("VEGFBisoformimpbar1.tiff")
ggplot(final, aes(x=isoform_name, y=counts, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
sessionInfo()
