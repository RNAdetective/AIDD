##these load all the programs used
suppressPackageStartupMessages(library("DESeq2"))
suppressPackageStartupMessages(library("vsn"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("pheatmap"))
suppressPackageStartupMessages(library("RColorBrewer"))
suppressPackageStartupMessages(library("PoiClaClu"))
suppressPackageStartupMessages(library("ggbeeswarm"))
suppressPackageStartupMessages(library("genefilter"))
suppressPackageStartupMessages(library("sva"))
suppressPackageStartupMessages(library("ggrepel"))
suppressPackageStartupMessages(library("plotly"))
countData <- as.matrix(read.csv("/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixedited.csv", row.names=1))
colData <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ set_design)
print("total rows in new matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("total number of rows with counts greater then 1")
nrow(dds)
tiff("/media/sf_AIDD/Results/DESeq2/level/calibration/rlogandvariance.tiff", units="in", width=10, height=10, res=900)
lambda <- 10^seq(from = -1, to = 2, length = 1000)
cts <- matrix(rpois(1000*100, lambda), ncol = 100)
meanSdPlot(cts, ranks = FALSE)
dev.off()
tiff("/media/sf_AIDD/Results/DESeq2/level/calibration/logtranscounts.tiff", units="in", width=10, height=10, res=900)
log.cts.one <- log2(cts + 1)
meanSdPlot(log.cts.one, ranks = FALSE)
dev.off()
print("Taking rlog of counts for downstream analysis")
rld <- rlog(dds, blind = FALSE)
print("Top three rows from new log matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("Further processing vst of new log matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
df <- bind_rows(as_data_frame(log2(counts(dds)[, 1:2]+1)) %>% mutate(transformation = "log2(x + 1)"), as_data_frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"), as_data_frame(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))
colnames(df)[1:2] <- c("x", "y")
tiff("/media/sf_AIDD/Results/DESeq2/level/calibration/transcounts2sam.tiff", units="in", width=10, height=10, res=900)
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
tiff("/media/sf_AIDD/Results/DESeq2/level/calibration/PoisHeatmap.tiff", units="in", width=10, height=10, res=900)
pheatmap(samplePoisDistMatrix, clustering_distance_rows = poisd$dd, clustering_distance_cols = poisd$dd, col = colors)
dev.off()
tiff("/media/sf_AIDD/Results/DESeq2/level/PCA/PCAplot.tiff", units="in", width=10, height=10, res=900)
plotPCA(rld, intgroup = c("condition"))
dev.off()
pcaData <- plotPCA(rld, intgroup = c( "condition"), returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
tiff("/media/sf_AIDD/Results/DESeq2/level/PCA/PCAplot2.tiff", units="in", width=10, height=10, res=900)
ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, group = condition, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_text(aes(label=rownames(pcaData)))
dev.off()
mds <- as.data.frame(colData(rld))  %>% cbind(cmdscale(sampleDistMatrix))
tiff("/media/sf_AIDD/Results/DESeq2/level/PCA/MDSplot.tiff", units="in", width=10, height=10, res=900)
ggplot(mds, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
mdsPois <- as.data.frame(colData(dds)) %>% cbind(cmdscale(samplePoisDistMatrix))
tiff("/media/sf_AIDD/Results/DESeq2/level/PCA/MDSpois.tiff", units="in", width=10, height=10, res=900)
ggplot(mdsPois, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
print("Running DESeq2 command")
dds <- DESeq(dds)
res <- results(dds)
mcols(res, use.names = TRUE)
colnames(res)[1] <- "level_name" 
write.csv(res, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/resultsall.csv")
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/resultsall.csv")
table2 <- table1[ which(table1$pvalue < 0.05 & table1$log2FoldChange > 1), ]
colnames(table2)[colnames(table2)=="X"] <- "level_name"
myvars <- c("level_name", "log2FoldChange")
table3 <- table2[myvars]
attach(table3)
newdata <- table3[order(-log2FoldChange),]
detach(table3)
write.csv(newdata, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/upreg.csv", row.names=FALSE)
datatop <- newdata[1:100,]
myvars <- c("level_name")
finaltable <- datatop[myvars]
write.csv(finaltable, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/upregGListtop100.csv", row.names=FALSE)
table4 <- table2[myvars]
write.csv(table4, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/upregGList.csv", row.names=FALSE)

##this will create down regulated results and lists for venn diagram analysis
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/resultsall.csv")
table2 <- table1[ which(table1$pvalue < 0.05 & table1$log2FoldChange < -1), ]
colnames(table2)[colnames(table2)=="X"] <- "level_name"
myvars <- c("level_name", "log2FoldChange")
table3 <- table2[myvars]
attach(table3)
newdata <- table3[order(log2FoldChange),]
detach(table3)
write.csv(newdata, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/downreg.csv", row.names=FALSE)
datatop <- newdata[1:100,]
myvars <- c("level_name")
finaltable <- datatop[myvars]
write.csv(finaltable, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/downregGListtop100.csv", row.names=FALSE)
table4 <- table2[myvars]
write.csv(table4, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/downregGList.csv", row.names=FALSE)
##this makes a heatmap of the top 60
topVarlevels <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarlevels, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,3]
colnames(anno) <- "level_name"
tiff("/media/sf_AIDD/Results/DESeq2/level/counts/top60heatmap.tiff", units="in", width=10, height=10, res=900)
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
res <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/resultsall.csv")
colnames(res)[1] <- "level_name"
colnames(res)[2] <- "base mean"
countData <- read.csv("/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixedited.csv")
colnames(countData)[1] <- "level_name"
final <- merge(res, countData, by="level_name")
write.csv(final, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/finalResults.csv", row.names=FALSE)
levelofinterest <- read.csv("/media/sf_AIDD/level_list/DESeq2/levelofinterest.csv")
levelofinterestfinal <- merge(levelofinterest, final, by="level_name")
write.csv(levelofinterestfinal, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/levelofinterestfinalresults.csv", row.names=FALSE)
excitome <- read.csv("/media/sf_AIDD/level_list/DESeq2/excitome.csv")
colnames(final)[1] <- "excitome_name"
excitomefinal <- merge(excitome, final, by="excitome_name")
write.csv(excitomefinal, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/excitomefinalresults.csv", row.names=FALSE)
level_list <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/resultsall.csv", row.names=1)
threshold_OE <- level_list$pvalue < 0.05 
length(which(threshold_OE))
level_list$threshold <- threshold_OE
res_tableOE_ordered <- level_list[order(level_list$pvalue), ] 
res_tableOE_ordered$levellabels <- ""
res_tableOE_ordered$levellabels[1:10] <- rownames(res_tableOE_ordered)[1:10]
tiff("/media/sf_AIDD/Results/DESeq2/level/differential_expression/VolcanoPlotZika.tiff", units="in", width=10, height=10, res=900)
volc = ggplot(res_tableOE_ordered, aes(log2FoldChange, -log10(pvalue))) + geom_point(aes(x = log2FoldChange, y = -log10(pvalue), colour = threshold)) + ggtitle("Differential Expression Volcano Plot") + xlab("log2 fold change") + ylab("-log10 adjusted p-value") 
volc + geom_text_repel(data=head(res_tableOE_ordered, 10), aes(label = levellabels)) 
dev.off()
sessionInfo()

