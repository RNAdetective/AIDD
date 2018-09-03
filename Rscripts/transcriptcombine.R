multmerge = function(mypath){
filenames=list.files(path=mypath, full.names=TRUE)
datalist = lapply(filenames, function(x){read.csv(file=x,header=T)})
Reduce(function(x,y) {merge(x,y)}, datalist)}
mymergeddata = multmerge("/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/Listnamesfinalresults/final/gene/merged/")
write.csv(mymergeddata, "/media/sf_AIDD/Results/DESeq2/transcript/differential_expression/Listnamesfinalresults/final/genefinal.csv", row.names=FALSE)
