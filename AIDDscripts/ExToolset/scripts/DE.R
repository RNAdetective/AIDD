#!/usr/bin/env Rscript
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
suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("data.table"))
args = commandArgs(trailingOnly=TRUE)
file_in <- paste0(args[1]) #gene or transcript_count_matrix.csv
pheno <- paste0(args[2]) #PHENO_DATA.csv
cond <- paste0(args[3]) #cond used in DESeq2
level_name <- paste0(args[4]) #level_name
rlogandvariance <- paste0(args[5]) #/media/sf_AIDD/Results/DESeq2/level/calibration/rlogandvariance.tiff
logtranscounts <- paste0(args[6]) #"/media/sf_AIDD/Results/DESeq2/level/calibration/logtranscounts.tiff"
transcounts2sam <- paste0(args[7]) #"/media/sf_AIDD/Results/DESeq2/level/calibration/transcounts2sam.tiff"
PoisHeatmap <- paste0(args[8]) #"/media/sf_AIDD/Results/DESeq2/level/calibration/PoisHeatmap.tiff"
PCAplot <- paste0(args[9]) #"/media/sf_AIDD/Results/DESeq2/level/PCA/PCAplot.tiff"
PCAplot2 <- paste0(args[10]) #"/media/sf_AIDD/Results/DESeq2/level/PCA/PCAplot2.tiff"
MDSplot <- paste0(args[11]) #"/media/sf_AIDD/Results/DESeq2/level/PCA/MDSplot.tiff"
MDSpois <- paste0(args[12]) #"/media/sf_AIDD/Results/DESeq2/level/PCA/MDSpois.tiff"
resultsall <- paste0(args[13]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/resultsall.csv"
upreg <- paste0(args[14]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/upreg.csv"
upreg100 <- paste0(args[15]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/upregGListtop100.csv"
upregGlist <- paste0(args[16]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/upregGList.csv"
downreg <- paste0(args[17]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/downreg.csv"
downreg100 <- paste0(args[18]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/downregGListtop100.csv"
downregGlist <- paste0(args[19]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/downregGList.csv"
heatmap <- paste0(args[20]) #"/media/sf_AIDD/Results/DESeq2/level/counts/top60heatmap.tiff"
volcano <- paste0(args[21]) #"/media/sf_AIDD/Results/DESeq2/level/differential_expression/VolcanoPlot.tiff"
countData <- as.matrix(read.csv(file_in, row.names=1))
colData <- read.csv(pheno, row.names=1)
#print("do all your row names and colnames match with the PHENO_DATA file")
#all(rownames(colData) %in% colnames(countData))
#countData <- countData[, rownames(colData)]
#print("after renaming columns with PHENO_DATA file do they still match")
#all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ set_design)
dds <- dds[ rowSums(counts(dds)) > 1, ]
tiff(rlogandvariance, units="in", width=10, height=10, res=600)
lambda <- 10^seq(from = -1, to = 2, length = 1000)
cts <- matrix(rpois(1000*100, lambda), ncol = 100)
meanSdPlot(cts, ranks = FALSE)
invisible(dev.off()) #save tiff
tiff(logtranscounts, units="in", width=10, height=10, res=600)
log.cts.one <- log2(cts + 1)
meanSdPlot(log.cts.one, ranks = FALSE)
invisible(dev.off()) #save tiff
print("RUNNING NORMALIZATION MAY TAKE AWHILE")
rld <- rlog(dds, blind = FALSE)
vsd <- vst(dds, blind = FALSE)
dds <- estimateSizeFactors(dds)
df <- bind_rows(as_tibble(log2(counts(dds)[, 1:2]+1)) %>% mutate(transformation = "log2(x + 1)"), as_tibble(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"), as_tibble(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))
colnames(df)[1:2] <- c("x", "y")
tiff(transcounts2sam, units="in", width=10, height=10, res=600)
p <- ggplot(df, aes(x = x, y = y)) + geom_hex(bins = 80) + coord_fixed() + facet_grid( . ~ transformation)
print(p)
invisible(dev.off()) #save tiff
sampleDists <- dist(t(assay(rld)))
sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$set_design)
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
poisd <- PoissonDistance(t(counts(dds)))
samplePoisDistMatrix <- as.matrix( poisd$dd )
rownames(samplePoisDistMatrix) <- paste(rld$set_design)
colnames(samplePoisDistMatrix) <- NULL
tiff(PoisHeatmap, units="in", width=10, height=10, res=600)
pheatmap(samplePoisDistMatrix, clustering_distance_rows = poisd$dd, clustering_distance_cols = poisd$dd, col = colors)
invisible(dev.off()) #save tiff
tiff(PCAplot, units="in", width=10, height=10, res=600)
plotPCA(rld, intgroup = c("set_design"))
invisible(dev.off()) #save tiff
pcaData <- plotPCA(rld, intgroup = c("set_design"), returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
tiff(PCAplot2, units="in", width=10, height=10, res=600)
ggplot(pcaData, aes(x = PC1, y = PC2, color = set_design, group = set_design, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_text(aes(label=rownames(pcaData))) + scale_color_manual(values=c("red", "blue")) + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
invisible(dev.off()) #save tiff
mds <- as.data.frame(colData(rld))  %>% cbind(cmdscale(sampleDistMatrix))
tiff(MDSplot, units="in", width=10, height=10, res=600)
ggplot(mds, aes(x = `1`, y = `2`, color = set_design)) + geom_point(size = 3) + coord_fixed()
invisible(dev.off()) #save tiff
mdsPois <- as.data.frame(colData(dds)) %>% cbind(cmdscale(samplePoisDistMatrix))
tiff(MDSpois, units="in", width=10, height=10, res=600)
ggplot(mdsPois, aes(x = `1`, y = `2`, color = set_design)) + geom_point(size = 3) + coord_fixed()
invisible(dev.off()) #save tiff
print("RUNNING DESEQ2 COMMAND MAY TAKE AWHILE")
dds <- DESeq(dds)
res <- results(dds)
mcols(res, use.names = TRUE)
colnames(res)[1] <- level_name 
write.csv(res, resultsall)
table1 <- read.csv(resultsall)
table2 <- table1[ which(table1$pvalue < 0.05 & table1$log2FoldChange > 1), ]
colnames(table2)[colnames(table2)=="X"] <- level_name
myvars <- c(level_name, "log2FoldChange")
table3 <- table2[myvars]
attach(table3)
newdata <- table3[order(-log2FoldChange),]
detach(table3)
write.csv(newdata, upreg, row.names=FALSE)
datatop <- newdata[1:100,]
myvars <- c("level_name")
finaltable <- datatop[myvars]
write.csv(finaltable, upreg100, row.names=FALSE)
table4 <- table2[myvars]
write.csv(table4, upregGlist, row.names=FALSE)
table2 <- table1[ which(table1$pvalue < 0.05 & table1$log2FoldChange < -1), ]
colnames(table2)[colnames(table2)=="X"] <- "level_name"
myvars <- c("level_name", "log2FoldChange")
table3 <- table2[myvars]
attach(table3)
newdata <- table3[order(log2FoldChange),]
detach(table3)
write.csv(newdata, downreg, row.names=FALSE)
datatop <- newdata[1:100,]
myvars <- c("level_name")
finaltable <- datatop[myvars]
write.csv(finaltable, downreg100, row.names=FALSE)
table4 <- table2[myvars]
write.csv(table4, downregGlist, row.names=FALSE)
topVarlevels <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarlevels, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("set_design")])
rownames(anno) <- colData[,3]
colnames(anno) <- level_name
tiff(heatmap, units="in", width=10, height=10, res=600)
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=6)
invisible(dev.off()) #save tiff
level_list <- read.csv(resultsall, row.names=1)
threshold_OE <- level_list$pvalue < 0.05 
level_list$threshold <- threshold_OE
res_tableOE_ordered <- level_list[order(level_list$pvalue), ] 
res_tableOE_ordered$levellabels <- ""
res_tableOE_ordered$levellabels[1:20] <- rownames(res_tableOE_ordered)[1:20]
tiff(volcano, units="in", width=10, height=10, res=600)
volc = ggplot(res_tableOE_ordered, aes(log2FoldChange, -log10(pvalue))) + geom_point(aes(x = log2FoldChange, y = -log10(pvalue), colour = threshold)) + ggtitle("Differential Expression Volcano Plot") + xlab("log2 fold change") + ylab("-log10 adjusted p-value") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) 
volc + geom_text_repel(data=head(res_tableOE_ordered, 10), aes(label = levellabels)) 
invisible(dev.off())

