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
in_dir <- paste0(args[1]) #directory
work_dir <- paste(in_dir,"Results",sep="/")
set_design <- paste0(args[2]) #set model design for DESeq2
set_designdeq <- noquote(set_design)
print(set_designdeq)
level_name <- paste0(args[3]) #set level name between transript or gene
file_in <- paste(work_dir,"gene_count_matrixeditedDESeq2.csv",sep="/")
pheno <- paste(in_dir,"PHENO_DATA.csv",sep="/")
countData <- data.matrix(read.csv(file_in, row.names=1), rownames.force = TRUE)
countData[is.na(countData)] <- 0
colData <- read.csv(pheno, row.names=1)
print("do all your row names and colnames match with the PHENO_DATA file")
all(rownames(colData) %in% colnames(countData))
countData <- countData[, rownames(colData)]
print("after renaming columns with PHENO_DATA file do they still match")
all(rownames(colData) == colnames(countData))
dds <- DESeqDataSetFromMatrix(countData = countData, colData = colData, design = ~ condition1:condition2:condition3) #add model to this line set to interactions between 3 conditions if you have less then change the model everything after the ~. If you want to test each condition independently then do condition + condition2 and so on.
dds <- dds[ rowSums(counts(dds)) > 1, ]
rlogv <- paste(work_dir,"rlogvar.tiff",sep="/")
tiff(rlogv, units="in", width=10, height=10, res=600)
lambda <- 10^seq(from = -1, to = 2, length = 1000)
cts <- matrix(rpois(1000*100, lambda), ncol = 100)
meanSdPlot(cts, ranks = FALSE)
invisible(dev.off()) #save tiff
logtran <- paste(work_dir,"logtrans.tiff",sep="/")
tiff(logtran, units="in", width=10, height=10, res=600)
log.cts.one <- log2(cts + 1)
meanSdPlot(log.cts.one, ranks = FALSE)
invisible(dev.off()) #save tiff
print("RUNNING NORMALIZATION MAY TAKE AWHILE")
rld <- rlog(dds, blind = FALSE)
print(slotNames(rld))
print(rld@colData)
vsd <- vst(dds, blind =FALSE)
dds <- estimateSizeFactors(dds)
df <- bind_rows(as_tibble(log2(counts(dds)[, 1:2]+1)) %>% mutate(transformation = "log2(x + 1)"), as_tibble(assay(rld)[, 1:2]) %>% mutate(transformation = "rlog"), as_tibble(assay(vsd)[, 1:2]) %>% mutate(transformation = "vst"))
colnames(df)[1:2] <- c("x", "y")
trans2sam <- paste(work_dir,"trans2sam.tiff",sep="/")
tiff(trans2sam, units="in", width=10, height=10, res=600)
p <- ggplot(df, aes(x = x, y = y)) + geom_hex(bins = 80) + coord_fixed() + facet_grid( . ~ transformation)
print(p)
invisible(dev.off()) #save tiff
sampleDists <- dist(t(assay(rld)))
sampleDistMatrix <- as.matrix( sampleDists )
rownames(sampleDistMatrix) <- paste( rld$condition,rld$condition2,rld$condition3) #add all columns of your phenodata file
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
poisd <- PoissonDistance(t(counts(dds)))
samplePoisDistMatrix <- as.matrix( poisd$dd )
rownames(samplePoisDistMatrix) <- paste(rld$condition,rld$condition2,rld$condition3) #add all columns of your phenodata file
colnames(samplePoisDistMatrix) <- NULL
PoisHeatmap <- paste(work_dir,"PoisHeatmap.tiff", sep="/")
tiff(PoisHeatmap, units="in", width=10, height=10, res=600)
pheatmap(samplePoisDistMatrix, clustering_distance_rows = poisd$dd, clustering_distance_cols = poisd$dd, col = colors)
invisible(dev.off()) #save tiff
PCAplot <- paste(work_dir, "PCAplot.tiff", sep="/")
tiff(PCAplot, units="in", width=10, height=10, res=600)
plotPCA(rld, intgroup = c("condition","condition2","condition3")) #this is set for three conditions change to yours
invisible(dev.off()) #save tiff
pcaData <- plotPCA(rld, intgroup = c("condition","condtion2","condition3"), returnData = TRUE) #this is set for three conditions change to yours
percentVar <- round(100 * attr(pcaData, "percentVar"))
PCAplot2 <- paste(work_dir, "PCAplot2.tiff", sep="/")
tiff(PCAplot2, units="in", width=10, height=10, res=600)
ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, group = condition, label=rownames(pcaData))) + geom_point() + xlab(paste0("PC1: ", percentVar[1], "% variance")) + ylab(paste0("PC2: ", percentVar[2], "% variance")) + coord_fixed() + geom_text_repel(aes(label=rownames(pcaData)),position = position_dodge(width=0.9)) + theme(legend.position="bottom") # this is set to color by condition if you would like to change it to condition2 or condition3. If you want multiple then change your pheno_Data file to combine which ever conditions you want to label by. for example KO_Veh KO_treatment WT_Veh and WT_treatment in stead of just coloring by WT and KO just don't put "." or "-" in your names R does not like them.
invisible(dev.off()) #save tiff
mds <- as.data.frame(colData(rld))  %>% cbind(cmdscale(sampleDistMatrix))
MDSplot <- paste(work_dir, "MDSplot.tiff", sep="/")
tiff(MDSplot, units="in", width=10, height=10, res=600)
ggplot(mds, aes(x = `1`, y = `2`, color = condition, label=rownames(pcaData))) + geom_point(size = 3) + coord_fixed() # again it is set to color by condition but you can change this just as before
invisible(dev.off()) #save tiff
mdsPois <- as.data.frame(colData(dds)) %>% cbind(cmdscale(samplePoisDistMatrix))
MDSpois <- paste(work_dir,"MDSpois.tiff",sep="/")
tiff(MDSpois, units="in", width=10, height=10, res=600)
ggplot(mdsPois, aes(x = `1`, y = `2`, color = condition)) + geom_point(size = 3) + coord_fixed()# again it is set to color by condition but you can change this just as before
invisible(dev.off()) #save tiff
print("RUNNING DESEQ2 COMMAND MAY TAKE AWHILE")
dds <- DESeq(dds)
print(resultsNames(dds))
res <- as.data.frame(DESeq2::results(dds,format="DataFrame",name="Intercept"))
#mcols(res, use.names = TRUE)
colnames(res)[1] <- level_name 
resultsall <- paste(work_dir,"resultsall.csv",sep="/")
write.csv(res, resultsall)
table1 <- read.csv(resultsall)
table2 <- table1[ which(table1$padj < 0.05 & table1$log2FoldChange > 1), ]
colnames(table2)[colnames(table2)=="X"] <- level_name
myvars <- c(level_name, "log2FoldChange")
table3 <- table2[myvars]
attach(table3)
newdata <- table3[order(-log2FoldChange),]
detach(table3)
upreg <- paste(work_dir,"upreg.csv",sep="/")
write.csv(newdata, upreg, row.names=FALSE, quote=FALSE)
datatop <- newdata[1:100,]
myvars <- c(level_name)
finaltable <- datatop[myvars]
upreg100 <- paste(work_dir,"upreg100.csv",sep="/")
write.csv(finaltable, upreg100, row.names=FALSE, quote=FALSE)
table4 <- table2[myvars]
upregGlist <- paste(work_dir,"upregGlist.csv",sep="/")
write.csv(table4, upregGlist, row.names=FALSE, quote=FALSE)
table2 <- table1[ which(table1$padj < 0.05 & table1$log2FoldChange < -1), ]
colnames(table2)[colnames(table2)=="X"] <- level_name
myvars <- c(level_name, "log2FoldChange")
table3 <- table2[myvars]
attach(table3)
newdata <- table3[order(log2FoldChange),]
detach(table3)
downreg <- paste(work_dir,"downreg.csv",sep="/")
write.csv(newdata, downreg, row.names=FALSE, quote=FALSE)
datatop <- newdata[1:100,]
myvars <- c(level_name)
finaltable <- datatop[myvars]
downreg100 <- paste(work_dir,"downreg100.csv",sep="/")
write.csv(finaltable, downreg100, row.names=FALSE, quote=FALSE)
table4 <- table2[myvars]
downregGlist <- paste(work_dir,"downregGlist.csv",sep="/")
write.csv(table4, downregGlist, row.names=FALSE, quote=FALSE)
topVarlevels <- head(order(rowVars(assay(rld)), decreasing = TRUE), 60)
mat  <- assay(rld)[ topVarlevels, ]
mat  <- mat - rowMeans(mat)
anno <- as.data.frame(colData(rld)[, c("condition")]) # again it is set to color by condition but you can change this just as before
rownames(anno) <- colData[,3]
colnames(anno) <- level_name
heatmap <- paste(work_dir,"heatmap.tiff",sep="/")
tiff(heatmap, units="in", width=10, height=10, res=600)
pheatmap(mat, annotation_col = anno, annotation_legend=FALSE, fontsize_row=14)
invisible(dev.off()) #save tiff
level_list <- read.csv(resultsall, row.names=1)
threshold_OE <- level_list$padj < 0.05 
level_list$threshold <- threshold_OE
res_tableOE_ordered <- level_list[order(level_list$padj), ] 
res_tableOE_ordered$levellabels <- ""
res_tableOE_ordered$levellabels[1:20] <- rownames(res_tableOE_ordered)[1:20]
res_tableOE_ordered$pval[res_tableOE_ordered$pvalue<=0.05] <- "significant"
res_tableOE_ordered$pval[res_tableOE_ordered$pvalue>0.05] <- "notsignificant"
res_tableOE_ordered$pval <- factor(res_tableOE_ordered$pval)
print(head(res_tableOE_ordered))
volcano <- paste(work_dir,"volcano.tiff",sep="/")
tiff(volcano, units="in", width=10, height=10, res=600)
volc = ggplot(res_tableOE_ordered, aes(log2FoldChange, -log10(pvalue))) + geom_point(aes(x = log2FoldChange, y = -log10(pvalue), colour = threshold)) + ggtitle("Differential Expression Volcano Plot") + xlab("log2 fold change") + ylab("-log10 adjusted p-value") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) 
volc + geom_text_repel(data=head(res_tableOE_ordered, 20), aes(label = levellabels))
invisible(dev.off())
