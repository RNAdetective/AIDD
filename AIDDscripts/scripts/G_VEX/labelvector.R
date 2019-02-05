table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/sub_level/file_name.csv")
index <- read.csv("/media/sf_AIDD/indexes/index/sub_level.csv")
final <- merge(index, table1, by="x")
colnames(final)[2] <- "sub_names"
colnames(final)[3] <- "file_name"
final$x <- NULL
write.csv(final, "/media/sf_AIDD/Results/variant_calling/sub_level/file_name.csv", row.names=FALSE)

