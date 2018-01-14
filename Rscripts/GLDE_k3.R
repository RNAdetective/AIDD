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
table1 <- read.csv("gene_count_matrix.csv")
table2 <- read.csv("g_names.csv")
Data <- read.csv("PHENO_DATAZika.csv", row.names=1)
table3 <- merge(table2, table1, by="gene_id")
table4 <- table3$gene_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table3, "gene_count_matrixedited.csv", row.names=FALSE)
countData <- as.matrix(read.csv("gene_count_matrixedited.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition + cell + condition:cell)
print("total rows in new matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("total number of rows with counts greater then 1")
nrow(dds)
jpeg("rlogandvariance.jpeg")
lambda <- 10^seq(from = -1, to = 2, length = 1000)
cts <- matrix(rpois(1000*100, lambda), ncol = 100)
meanSdPlot(cts, ranks = FALSE)
dev.off()
jpeg("logtranscounts.jpeg")
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
df <- bind_rows(as_data_frame(log2(counts(dds, normalized=TRUE)[, 1:2]+1)) %>% mutate(transformation = "log2(x + 1)"), as_data_frame(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"), as_data_frame(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))
colnames(df)[1:2] <- c("x", "y")
jpeg("transcounts2sam.jpeg")
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
jpeg("PoisHeatmap.jpeg")
pheatmap(samplePoisDistMatrix, clustering_distance_rows = poisd$dd, clustering_distance_cols = poisd$dd, col = colors)
dev.off()
jpeg("PCAplot.jpeg")
plotPCA(rld, intgroup = c("condition", "cell"))
dev.off()
pcaData <- plotPCA(rld, intgroup = c( "condition", "cell"), returnData = TRUE)
print("new pcaData matrix for creating PCAplots")
pcaData
percentVar <- round(100 * attr(pcaData, "percentVar"))
jpeg("PCAplot2.jpeg")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, shape=condition, group = condition, label=rownames(pcaData))) + geom_point(size = 4) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() ##+geom_text(aes(label=rownames(pcaData)))
dev.off()
mds <- as.data.frame(colData(rld))  %>% cbind(cmdscale(sampleDistMatrix))
jpeg("MDSplot.jpeg")
ggplot(mds, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
mdsPois <- as.data.frame(colData(dds)) %>% cbind(cmdscale(samplePoisDistMatrix))
jpeg("MDSpois.jpeg")
ggplot(mdsPois, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()
dev.off()
print("Running DESeq2 command")
dds <- DESeq(dds)
jpeg("ADAR1counts.jpeg")
plotCounts(dds, gene = "ADAR", intgroup=c("condition", "cell"))
dev.off()
geneCounts <- plotCounts(dds, gene = "ADAR", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("ADAR1counts2.jpeg")
ggplot(geneCounts, aes(x = cell, y = count, color = condition, shape=cell)) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3)
dev.off()
geneCounts <- plotCounts(dds, gene = "ADAR", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("ADAR1counts3.jpeg")
ggplot(geneCounts, aes(x = cell, y = count, color = condition, shape=cell, group = condition, label=rownames(pcaData))) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3) + geom_line()
dev.off()
jpeg("ADARB1counts.jpeg")
plotCounts(dds, gene = "ADARB1", intgroup=c("condition", "cell"))
dev.off()
geneCounts <- plotCounts(dds, gene = "ADARB1", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("ADARB1counts2.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell)) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3)
dev.off()
geneCounts <- plotCounts(dds, gene = "ADARB1", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("ADARB1counts3.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell, group = cell, label=rownames(pcaData))) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3) + geom_line()
dev.off()
jpeg("ADARB2counts.jpeg")
plotCounts(dds, gene = "ADARB2", intgroup=c("condition", "cell"))
dev.off()
geneCounts <- plotCounts(dds, gene = "ADARB2", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("ADARB2counts2.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell)) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3)
dev.off()
geneCounts <- plotCounts(dds, gene = "ADARB2", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("ADARB2counts3.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell, group = cell, label=rownames(pcaData))) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3) + geom_line()
dev.off()
jpeg("VEGFAcounts.jpeg")
plotCounts(dds, gene = "VEGFA", intgroup=c("condition", "cell"))
dev.off()
geneCounts <- plotCounts(dds, gene = "VEGFA", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("VEGFAcounts2.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell)) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3)
dev.off()
geneCounts <- plotCounts(dds, gene = "VEGFA", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("VEGFAcounts3.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell, group = cell, label=rownames(pcaData))) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3) + geom_line()
dev.off()
jpeg("VEGFBcounts.jpeg")
plotCounts(dds, gene = "VEGFB", intgroup=c("condition", "cell"))
dev.off()
geneCounts <- plotCounts(dds, gene = "VEGFB", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("VEGFBcounts2.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell)) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3)
dev.off()
geneCounts <- plotCounts(dds, gene = "VEGFB", intgroup = c("condition", "cell"), returnData = TRUE)
jpeg("VEGFBcounts3.jpeg")
ggplot(geneCounts, aes(x = condition, y = count, color = cell, group = cell, label=rownames(pcaData))) + scale_y_log10() +  geom_beeswarm(cex = 3) + geom_point(size = 3) + geom_line()
dev.off()
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("top60heatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
## this does all cells
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of new results file")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("table of padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("table of log fold change greater then 1 with a padj of less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "resultsall.csv")
print("number of genes that are below pvalue 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of genes that are below 0.05")
sum(!is.na(res$pvalue))
print("number of genes that have padj below 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top genes based on the highest log2foldchange")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "Downreg.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "Upreg.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
jpeg("MAplot.jpeg")
plotMA(res, ylim = c(-5, 5))
dev.off()
jpeg("Histopvalue")
hist(res$pvalue[res$baseMean > 1], breaks = 0:20/20, col = "grey50", border = "white")
dev.off()
##this does K048
tableA <- read.csv("gene_count_matrixedited.csv")
table4 <- tableA$K054Mock1 <- NULL
table5 <- tableA$K054Mock2 <- NULL
table6 <- tableA$K054Mock3 <- NULL
table7 <- tableA$K054Zika1 <- NULL
table8 <- tableA$K054Zika2 <- NULL
table9 <- tableA$K054Zika3 <- NULL
tablea <- tableA$G010Mock1 <- NULL
tableb <- tableA$G010Mock2 <- NULL
tablec <- tableA$G010Mock3 <- NULL
tabled <- tableA$G010Zika1 <- NULL
tablee <- tableA$G010Zika2 <- NULL
tablef <- tableA$G010Zika3 <- NULL
write.csv(tableA, "K048gene_count_matrix.csv", row.names=FALSE)
countData <- as.matrix(read.csv("K048gene_count_matrix.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAK048.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("total rows in new matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("total number of rows with counts greater then 1")
nrow(dds)
print("Taking rlog of counts for downstream analysis")
rld <- rlog(dds, blind = FALSE)
print("Top three rows from new log matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("Further processing vst of new log matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
print("Running DESeq2 command")
dds <- DESeq(dds)
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of new results file")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("table of padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("table of log fold change greater then 1 with a padj of less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "K048results.csv")
print("number of genes that are below pvalue 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of genes that are below 0.05")
sum(!is.na(res$pvalue))
print("number of genes that have padj below 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top genes based on the highest log2foldchange")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "K048Downreg.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "K048Upreg.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("top60heatmapK048.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
##this does K054
countData <- read.csv("gene_count_matrixedited.csv")
table4 <- countData$K048Mock1 <- NULL
table5 <- countData$K048Mock2 <- NULL
table6 <- countData$K048Mock3 <- NULL
table7 <- countData$K048Zika1 <- NULL
table8 <- countData$K048Zika2 <- NULL
table9 <- countData$K048Zika3 <- NULL
tablea <- countData$G010Mock1 <- NULL
tableb <- countData$G010Mock2 <- NULL
tablec <- countData$G010Mock3 <- NULL
tabled <- countData$G010Zika1 <- NULL
tablee <- countData$G010Zika2 <- NULL
tablef <- countData$G010Zika3 <- NULL
write.csv(countData, "K054gene_count_matrix.csv", row.names=FALSE)
countData <- as.matrix(read.csv("K054gene_count_matrix.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAK054.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("total rows in new matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("total number of rows with counts greater then 1")
nrow(dds)
print("Taking rlog of counts for downstream analysis")
rld <- rlog(dds, blind = FALSE)
print("Top three rows from new log matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("Further processing vst of new log matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
print("Running DESeq2 command")
dds <- DESeq(dds)
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of new results file")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("table of padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("table of log fold change greater then 1 with a padj of less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "K054results.csv")
print("number of genes that are below pvalue 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of genes that are below 0.05")
sum(!is.na(res$pvalue))
print("number of genes that have padj below 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top genes based on the highest log2foldchange")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "K054Downreg.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "K054Upreg.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("K054top60heatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
##this does G010
table3 <- read.csv("gene_count_matrixedited.csv")
table4 <- table3$K048Mock1 <- NULL
table5 <- table3$K048Mock2 <- NULL
table6 <- table3$K048Mock3 <- NULL
table7 <- table3$K048Zika1 <- NULL
table8 <- table3$K048Zika2 <- NULL
table9 <- table3$K048Zika3 <- NULL
tablea <- table3$K054Mock1 <- NULL
tableb <- table3$K054Mock2 <- NULL
tablec <- table3$K054Mock3 <- NULL
tabled <- table3$K054Zika1 <- NULL
tablee <- table3$K054Zika2 <- NULL
tablef <- table3$K054Zika3 <- NULL
write.csv(table3, "G010gene_count_matrix.csv", row.names=FALSE)
countData <- as.matrix(read.csv("G010gene_count_matrix.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAG010.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
print("total rows in new matrix")
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
print("total number of rows with counts greater then 1")
nrow(dds)
print("Taking rlog of counts for downstream analysis")
rld <- rlog(dds, blind = FALSE)
print("Top three rows from new log matrix")
head(assay(rld), 3)
vsd <- vst(dds, blind = FALSE)
print("Further processing vst of new log matrix")
head(assay(vsd), 3)
dds <- estimateSizeFactors(dds)
print("Running DESeq2 command")
dds <- DESeq(dds)
res <- results(dds)
res <- results(dds, contrast=c("condition","A","B"))
mcols(res, use.names = TRUE)
print("summary of new results file")
summary(res)
res.05 <- results(dds, alpha = 0.05)
print("table of padj less then 0.05")
table(res.05$padj < 0.05)
resLFC1 <- results(dds, lfcThreshold=1)
print("table of log fold change greater then 1 with a padj of less then 0.1")
table(resLFC1$padj < 0.1) 
results <- results(dds, contrast = c("condition", "A", "B"))
write.csv(results, "G010results.csv")
print("number of genes that are below pvalue 0.05")
sum(res$pvalue < 0.05, na.rm=TRUE)
print("number of genes that are below 0.05")
sum(!is.na(res$pvalue))
print("number of genes that have padj below 0.1")
sum(res$padj < 0.1, na.rm=TRUE)
resSig <- subset(res, padj < 0.1)
print("top genes based on the highest log2foldchange")
head(resSig[ order(resSig$log2FoldChange), ])
resSigdown <- resSig[ order(resSig$log2FoldChange), ]
write.csv(resSigdown, "G010Downreg.csv")
resSigup <- resSig[ order(resSig$log2FoldChange, decreasing = TRUE), ]
write.csv(resSigup, "G010Upreg.csv")
res <- lfcShrink(dds, contrast=c("condition","A","B"), res=res)
topVarGenes <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarGenes, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("G010top60heatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
dev.off()
dat  <- counts(dds, normalized = TRUE)
idx  <- rowMeans(dat) > 1
dat  <- dat[idx, ]
mod  <- model.matrix(~ condition, colData(dds))
mod0 <- model.matrix(~   1, colData(dds))
svseq <- svaseq(dat, mod, mod0, n.sv = 2)
svseq$sv
##make VEGFpathway way final table and heat map
table1 <- read.csv("gene_count_matrixedited.csv")
table2 <- read.csv("VEGFpathway_genes.csv")
table3 <- merge(table2, table1, by="gene_name")
table4 <- table3$t_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table3, "VEGFpathwayedited_counts.csv", row.names=FALSE)
tableB1 <- read.csv("resultsall.csv")
table5 <- colnames(tableB1)[c(1)] <- c("gene_name")
head(tableB1)
tableC3 <- merge(table3, tableB1, by="gene_name")
write.csv(tableC3, "resultsall_VEGFpathwayediting_counts.csv", row.names=FALSE)
countData <- as.matrix(read.csv("VEGFpathwayedited_counts.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition + cell + condition:cell)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
jpeg("VEGFpathwayPCAplot2.jpeg")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, group = cell, label=rownames(pcaData))) + geom_point(size = 3) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) +geom_line() + coord_fixed()
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("VEGFpathwayheatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
##make PNS developmental genes final table and heat map
table12 <- read.csv("gene_count_matrixedited.csv")
table22 <- read.csv("pns_deve_genes.csv")
table32 <- merge(table22, table12, by="gene_name")
table42 <- table32$t_id <- NULL
table52 <- colnames(table32)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table32, "pns_deve_genesedited_counts.csv", row.names=FALSE)
tableC32 <- merge(table32, tableB1, by="gene_name")
write.csv(tableC32, "resultsall_pns_deveediting_counts.csv", row.names=FALSE)
countData <- as.matrix(read.csv("pns_deve_genesedited_counts.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition + cell + condition:cell)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
jpeg("pns_deve_genesPCAplot2.jpeg")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, group = cell, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_line()
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("pns_deve_genesheatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
##make neurological genes final table and heat map
table13 <- read.csv("gene_count_matrixedited.csv")
table23 <- read.csv("neuro_genes.csv")
table33 <- merge(table23, table13, by="gene_name")
table43 <- table33$t_id <- NULL
table53 <- colnames(table33)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table33, "neuro_genesedited_counts.csv", row.names=FALSE)
tableC33 <- merge(table33, tableB1, by="gene_name")
write.csv(tableC33, "resultsall_neuro_editing_counts.csv", row.names=FALSE)
countData <- as.matrix(read.csv("neuro_genesedited_counts.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition + cell + condition:cell)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
jpeg("neuro_genesPCAplot2.jpeg")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, group = cell, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_line()
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("neuro_genesheatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
##make neurological developmental genes final table and heat map
table14 <- read.csv("gene_count_matrixedited.csv")
table24 <- read.csv("neuro_deve_genes.csv")
table34 <- merge(table24, table14, by="gene_name")
table44 <- table34$t_id <- NULL
table54 <- colnames(table34)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table34, "neuro_deve_genesedited_counts.csv", row.names=FALSE)
tableC34 <- merge(table34, tableB1, by="gene_name")
write.csv(tableC34, "resultsall_neuro_deveediting_counts.csv", row.names=FALSE)
countData <- as.matrix(read.csv("neuro_deve_genesedited_counts.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition + cell + condition:cell)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
jpeg("neuro_deve_genesPCAplot2.jpeg")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, group = cell, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_line()
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("neuro_deve_genesheatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
##make CNS developmental genes final table and heat map
table15 <- read.csv("gene_count_matrixedited.csv")
table25 <- read.csv("cns_deve_genes.csv")
table35 <- merge(table25, table15, by="gene_name")
table45 <- table35$t_id <- NULL
table55 <- colnames(table35)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table35, "cns_deve_genesedited_counts.csv", row.names=FALSE)
tableC35 <- merge(table35, tableB1, by="gene_name")
write.csv(tableC35, "resultsall_cns_deve_genesediting_counts.csv", row.names=FALSE)
countData <- as.matrix(read.csv("cns_deve_genesedited_counts.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition + cell + condition:cell)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
jpeg("cns_deve_genesPCAplot2.jpeg")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, group = cell, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_line()
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("cns_deve_genesheatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
##make brain developmental genes final table and heat map
table16 <- read.csv("gene_count_matrixedited.csv")
table26 <- read.csv("brain_deve_genes.csv")
table36 <- merge(table26, table16, by="gene_name")
table46 <- table36$t_id <- NULL
table56 <- colnames(table36)[c(2:19)] <- rownames(Data)[c(1:18)]
write.csv(table36, "brain_deve_genesedited_counts.csv", row.names=FALSE)
tableC36 <- merge(table36, tableB1, by="gene_name")
write.csv(tableC36, "resultsall_brain_deveediting_counts.csv", row.names=FALSE)
countData <- as.matrix(read.csv("brain_deve_genesedited_counts.csv", row.names="gene_name"))
colData <- read.csv("PHENO_DATAZika.csv", row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition + cell + condition:cell)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
jpeg("brain_deve_genesPCAplot2.jpeg")
ggplot(pcaData, aes(x = PC1, y = PC2, color = cell, group = cell, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_line()
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,5]
colnames(anno) <- "gene_name"
tiff("brain_deve_genesheatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
##VEGF final count tables
table1 <- read.csv("gene_count_matrixedited.csv")
table2 <- read.csv("VEGFgene.csv")
table3 <- merge(table2, table1, by="gene_name")
table4 <- table3$gene_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
tableB12 <- read.csv("resultsall.csv")
table5 <- colnames(tableB12)[c(1)] <- c("gene_name")
head(tableB12)
tableC6 <- merge(table3, tableB12, by="gene_name")
write.csv(tableC6, "resultsVEGF_gene_counts.csv", row.names=FALSE)
Data <- read.csv("bargraphindexZika.csv")
tablebargraph <- t(tableC6)
colnames(tablebargraph) <- tableC6[,1]
tablebargraph2 <- tablebargraph[-c(1,18, 19, 20, 21, 22, 23), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "gene_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="gene_name")
tablebargraph4 <- aggregate(tablebargraph3[, 3:5], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
write.csv(tablebargraph5, "7.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "gene_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraphG1 <- tablebargraph5$V3 <- NULL
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "gene_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphH1 <- tablebargraph6$V3 <- NULL
tablebargraph7 <- read.csv("7.csv")
tablebargraphZ <- colnames(tablebargraph7)[1] <- "gene_name"
tablebargraphX <- tablebargraph7$V1 <- NULL
tablebargraphX1 <- tablebargraph7$V2 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraphZZ <- colnames(tablebargraph7)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("VEGFbargraph.tiff")
ggplot(final, aes(x=g_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()

##ADAR final count table K048
table1 <- read.csv("K048gene_count_matrix.csv")
table2 <- read.csv("ADARgene.csv")
table3 <- merge(table2, table1, by="gene_name")
table4 <- table3$gene_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
tableC3 <- merge(table3, tableB12, by="gene_name")
write.csv(tableC3, "K048resultsADAR_gene_counts.csv", row.names=FALSE)
Data <- read.csv("bargraphindexK048.csv")
tablebargraph <- t(tableC3)
colnames(tablebargraph) <- tableC3[,1]
tablebargraph2 <- tablebargraph[-c(1,18, 19, 20, 21, 22, 23), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "gene_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="gene_name")
tablebargraph4 <- aggregate(tablebargraph3[, 3:5], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "gene_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraphM <- colnames(tablebargraph5)[2] <- "V1"
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "gene_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("K048ADARbargraph.tiff")
ggplot(final, aes(x=gene_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##ADAR final count table K054
table1 <- read.csv("K054gene_count_matrix.csv")
table2 <- read.csv("ADARgene.csv")
table3 <- merge(table2, table1, by="gene_name")
table4 <- table3$gene_id <- NULL
table5 <- colnames(table3)[c(2:19)] <- rownames(Data)[c(1:18)]
tableC3 <- merge(table3, tableB12, by="gene_name")
write.csv(tableC3, "K054resultsADAR_gene_counts.csv", row.names=FALSE)
Data <- read.csv("bargraphindexK054.csv")
tablebargraph <- t(tableC3)
colnames(tablebargraph) <- tableC3[,1]
tablebargraph2 <- tablebargraph[-c(1,18, 19, 20, 21, 22, 23), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "gene_name"
tablebargraph2
tablebargraph3 <- merge(Data, tablebargraph2, by="gene_name")
tablebargraph4 <- aggregate(tablebargraph3[, 3:5], list(tablebargraph3$sample), mean)
tablebargraph5 <- t(tablebargraph4)
tablebargraph5 <- tablebargraph5[-c(1),]
write.csv(tablebargraph5, "5.csv")
write.csv(tablebargraph5, "6.csv")
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "gene_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraphM <- colnames(tablebargraph5)[2] <- "V1"
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "gene_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("K054ADARbargraph.tiff")
ggplot(final, aes(x=gene_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
##ADAR final count table G010
table1 <- read.csv("G010gene_count_matrix.csv")
table2 <- read.csv("ADARgene.csv")
Data <- read.csv("bargraphindexG010.csv", row.names=1)
table3 <- merge(table2, table1, by="gene_name")
table4 <- table3$gene_id <- NULL
table5 <- colnames(table3)[c(2:7)] <- rownames(Data)[c(1:6)]
tableC3 <- merge(table3, tableB12, by="gene_name")
write.csv(tableC3, "G010resultsADAR_gene_counts.csv", row.names=FALSE)
tablebargraph <- t(tableC3)
colnames(tablebargraph) <- tableC3[,1]
tablebargraph2 <- tablebargraph[-c(1, 8, 9, 10, 11, 12, 13), ]
write.csv(tablebargraph2, "tablebargraph2.csv")
tablebargraph2 <- read.csv("tablebargraph2.csv")
tablebargraphY <- colnames(tablebargraph2)[1] <- "gene_name"
tablebargraph2
tablebargraph4 <- aggregate(tablebargraph2[, 2:4], list(tablebargraph2$gene_name), mean)
tablebargraph5 <- t(tablebargraph4)
write.csv(tablebargraph5, "5.csv", row.names=FALSE)
write.csv(tablebargraph5, "6.csv", row.names=FALSE)
tablebargraph5 <- read.csv("5.csv")
tablebargraphF <- colnames(tablebargraph5)[1] <- "gene_name"
tablebargraphG <- tablebargraph5$V2 <- NULL
tablebargraphM <- colnames(tablebargraph5)[2] <- "V1"
tablebargraph6 <- read.csv("6.csv")
tablebargraphE <- colnames(tablebargraph6)[1] <- "gene_name"
tablebargraphH <- tablebargraph6$V1 <- NULL
tablebargraphI <- colnames(tablebargraph6)[2] <- "V1"
tablebargraph5["condition"] <- "A"
tablebargraph6["condition"] <- "B"
final <- rbind(tablebargraph5, tablebargraph6)
tiff("G010ADARbargraph.tiff")
ggplot(final, aes(x=gene_name, y=V1, fill=condition)) +
    geom_bar(stat="identity", position=position_dodge(), colour="black")
dev.off()
