library(gdata)
library(topGO)
library(VennDiagram)
library(ggplot2)

## this will do all 4 tables from genes.txt
genes <- read.table("insert_run.genes.txt")
colnames <- read.csv("/media/sf_AIDD/index/VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/insert_run.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/insert_runHIGH.csv", row.names=FALSE)

genes <- read.table("insert_run.genes.txt")
colnames <- read.csv("/media/sf_AIDD/index/VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/insert_run.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/insert_runModerate.csv", row.names=FALSE)

genes <- read.table("insert_run.genes.txt")
colnames <- read.csv("/media/sf_AIDD/index/VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "/media/sf_AIDD/Results/variant_calling/haplotype/transcript/insert_run.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "/media/sf_AIDD/Results/variant_calling/haplotype/transcript/insert_runHIGHtranscripts.csv", row.names=FALSE)

genes <- read.table("insert_run.genes.txt")
colnames <- read.csv("/media/sf_AIDD/index/VCnames.csv")
genes2 <- colnames(genes)[c(1:28)] <- colnames(colnames)[c(1:28)]
write.csv(genes, "/media/sf_AIDD/Results/variant_calling/haplotype/transcript/insert_run.genes.csv", row.names=FALSE)
genes[,2:4]<- list(NULL)
genes[,3:25]<- list(NULL)
genes2 <- aggregate(genes[, 2], list(genes$gene_name), sum)
colnames(genes2)[1] <- "gene_name"
colnames(genes2)[2] <- "HIGH"
genes2[genes2 == 0] <- NA
genes3 <- na.omit(genes2)
head(genes3)
write.csv(genes3, "/media/sf_AIDD/Results/variant_calling/haplotype/transcript/insert_runModerateTranscripts.csv", row.names=FALSE)
