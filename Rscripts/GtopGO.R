##These next steps were the ones used to generate the index file that is stored in the Pipelines folder included in the vm
##wget http://geneontology.org/gene-associations/goa_human.gaf.gz
##unzip /home/user/Downloads/goa_human.gaf.gz
##library(plyr)
##X2 <- ddply(data, .(gene_name), summarize, Xc=paste(GOTerms,collapse=","))
##GO <- read.csv("annotations2.csv")
library("topGO")
library("grid")
library("Rgraphviz")
setwd("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/directory/")
geneID2GO <- readMappings(file = "/home/user/AIDD/index/annotations2.csv", sep = ",")
geneUniverse <- names(geneID2GO)
genesOfInterest <- read.table("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/directory/file_name.csv", header=FALSE)
genesOfInterest <- as.character(genesOfInterest$V1)
geneList <- factor(as.integer(geneUniverse %in% genesOfInterest))
names(geneList) <- geneUniverse
geneUniverse <- gsub("\\\"", "", geneUniverse)
myGOdata <- new("topGOdata", description="file_name", ontology="BP", allGenes=geneList, annot = annFUN.gene2GO, gene2GO = geneID2GO, ID = "ensembl")
myGOdata
sg <- sigGenes(myGOdata)
str(sg)
numSigGenes(myGOdata)
resultFisher <- runTest(myGOdata, algorithm="classic",statistic="fisher")
resultKS <- runTest(myGOdata, algorithm = "classic", statistic = "ks")
resultFisher2 <- runTest(myGOdata, algorithm = "weight01", statistic="fisher")
allRes <- GenTable(myGOdata,classicFisher=resultFisher,orderBy=resultFisher,ranksOf="classicFisher",topNodes=10)
write.csv(allRes, "file_name.csv", row.names=FALSE)
showSigOfNodes(myGOdata, score(resultFisher),firstSigNodes=10,useInfo='all')
printGraph(myGOdata, resultFisher, firstSigNodes=10,fn.prefix="file_name",useInfo="all",pdfSW=TRUE)
dev.off()
sessionInfo()


