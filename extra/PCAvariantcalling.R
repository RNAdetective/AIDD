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
pathway_file_name <- read.csv("/media/sf_AIDD/level_list/pathway/file_name.csv")
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
pcaData <- plotPCA(rld, intgroup = c( "condition"), returnData = TRUE)
print("new pcaData matrix for creating PCAplots")
pcaData
percentVar <- round(100 * attr(pcaData, "percentVar"))
tiff("/media/sf_AIDD/Results/pathway/heatmaps/file_name_PCAplot2.tiff", units="in", width=10, height=10, res=900)
ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, group = condition, label=rownames(pcaData))) + geom_point(size = 0) + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() +geom_text(aes(label=rownames(pcaData)))
dev.off()
