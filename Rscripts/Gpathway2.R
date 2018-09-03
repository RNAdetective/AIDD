suppressPackageStartupMessages(library("DESeq2"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("pheatmap"))
suppressPackageStartupMessages(library("ggrepel"))

colData <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
countData <- as.matrix(read.csv("/media/sf_AIDD/Results/DESeq2/level/count/List_namesfinalresults.csv", row.names=1))
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition)
nrow(dds)
dds <- dds[ rowSums(counts(dds)) > 1, ]
nrow(dds)
rld <- rlog(dds, blind = FALSE)
pcaData <- plotPCA(rld, intgroup = c( "condition"), returnData = TRUE)
print("new pcaData matrix for creating PCAplots")
pcaData
percentVar <- round(100 * attr(pcaData, "percentVar"))
tiff("/media/sf_AIDD/Results/DESeq2/level/count/List_names_PCAplot2.tiff", units="in", width=10, height=10, res=900)
ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, group = condition, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_text(aes(label=rownames(pcaData)))
dev.off()
mat  <- assay(rld)
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")])
rownames(anno) <- colData[,3]
colnames(anno) <- "_name"
tiff("/media/sf_AIDD/Results/DESeq2/level/count/List_names_heatmap.tiff", units="in", width=10, height=10, res=900)
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, show_rownames = FALSE)
dev.off()
