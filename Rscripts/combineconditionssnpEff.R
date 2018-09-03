multmerge = function(mypath){
filenames=list.files(path=mypath, full.names=TRUE)
datalist = lapply(filenames, function(x){read.csv(file=x,header=T)})
Reduce(function(x,y) {merge(x,y)}, datalist)}
mymergeddata = multmerge("/media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/Meso")
write.csv(mymergeddata, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/Mesomoderatemerged.csv", row.names=FALSE)

table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/Meso/SRR5850755Mesomoderate.csv")
table2 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/Meso/SRR5850756Mesomoderate.csv")
table3 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/Meso/SRR5850757Mesomoderate.csv")
table4 <- read.csv("/media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/Meso/SRR5850758Mesomoderate.csv")
table5 <- merge(table1, table2, by="gene_id")
table6 <- merge(table5, table3, by="gene_id")
table7 <- merge(table6, table4, by="gene_id")
write.csv(table4, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/Meso/Mesomoderatemerged.csv", row.names=FALSE)
