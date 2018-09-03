multmerge = function(mypath){
filenames=list.files(path=mypath, full.names=TRUE)
datalist = lapply(filenames, function(x){read.csv(file=x,header=T)})
Reduce(function(x,y) {merge(x,y)}, datalist)}
mymergeddata = multmerge("/media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/merged/")
write.csv(mymergeddata, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/ntsubsallconfinal.csv", row.names=FALSE)

