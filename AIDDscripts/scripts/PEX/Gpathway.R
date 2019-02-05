suppressPackageStartupMessages(library("DESeq2"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("pheatmap"))
suppressPackageStartupMessages(library("ggrepel"))

results <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/resultsall.csv")
colnames(results)[2] <- "base_mean"
colnames(results)[1] <- "level_name"
colData <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
GCMedit <- read.csv("/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixedited.csv")
colnames(GCMedit)[1] <- "level_name"
pathway_file_name <- read.csv("/media/sf_AIDD/indexes/level_list/pathway/file_name.csv")
table1 <- merge(GCMedit, pathway_file_name, by="level_name")
table2 <- merge(table1, results, by="level_name")
write.csv(table2, "/media/sf_AIDD/Results/pathway/tables/file_nameresults.csv", row.names=FALSE)
countData <- as.matrix(read.csv("/media/sf_AIDD/Results/pathway/tables/file_nameresults.csv", row.names=1))
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = set_design)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
pcaData <- plotPCA(rld, intgroup = c( "
dition"), returnData = TRUE)
print("new pcaData matrix for creating PCAplots")
pcaData
percentVar <- round(100 * attr(pcaData, "percentVar"))
tiff("/media/sf_AIDD/Results/pathway/heatmaps/file_name_PCAplot2.tiff")
ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, group = condition, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_text(aes(label=rownames(pcaData)))  + scale_color_manual(values=c("red", "blue")) + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,3]
colnames(anno) <- "_name"
tiff("/media/sf_AIDD/Results/pathway/heatmaps/file_name_heatmap.tiff")
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
dds <- DESeq(dds)
res <- results(dds)
res <- lfcShrink(dds, contrast=c("condition","con1","con2"), res=res)
summary(res)
res <- res[order(res$padj),]
results = as.data.frame(dplyr::mutate(as.data.frame(res), sig=ifelse(res$padj<0.05, "FDR<0.05", "Not Sig")), row.names=rownames(res))
head(results)
DEs_DESeq <- results[which(abs(results$log2FoldChange) > log2(1.5) & results$padj < 0.05),]
tiff("/media/sf_AIDD/Results/pathway/volcano/file_name_VolcanoPlot.tiff")
p = ggplot(results, aes(log2FoldChange, -log10(pvalue))) + geom_point(aes(col =sig)) + scale_color_manual(values = c("red", "black")) + ggtitle("Volcano Plot of DESeq2 analysis")
p + geom_text_repel(data=results[1:10, ], aes(label=rownames(results[1:10, ])))+ theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()

