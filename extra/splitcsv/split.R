setwd("/media/sf_AIDD/") 
mydata = read.csv("PHENO_DATAwhole.csv")
chunk_column <- sample(mydata[rows_column,1:5]) 
write.csv(chunk_column,file="PHENO_DATAchunk_column.csv",quote=F,row.names=F)
