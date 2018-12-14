suppressPackageStartupMessages(library("tibble"))
##this will load regulation or regulation regulated levels list created from GLDE.R for each cell line in level or level level analysis both for all levels or levels above 1 log2foldchange with a p<0.05.
tablecell_line <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationGList.csv")
##changes name of column to make venn diagrams 
colnames(tablecell_line)[1] <- "cell_line"
##this saves the level list with level id's for all regulation or regulation regulated level or levels.
write.csv(tablecell_line, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationGListclass.csv", row.names=FALSE)
##this will do the same as above but with only the top 100 level or levels found to regulation or regulation regulated in cells.
datacell_line <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationGListclass.csv")
##changes name of column to make venn diagrams 
colnames(datacell_line)[1] <- "regulationGListclasscell_line"
##this saves the level list with level id's for the top 100 regulation or regulation regulated level or levels.
write.csv(datacell_line, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationGListclass.csv", row.names=FALSE)
##loads indexes
level_names <- read.csv("/media/sf_AIDD/indexes/index/level_names.csv")
##reads in data tables
data <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationGListclass.csv")
##renames columns
colnames(data)[1] <- "level_name"
##merge together added a column of level names to use later
names <- merge(level_names, data, by="level_name")
##removes duplicates
data <- names[!duplicated(names$level_id), ]
##writes files to create level lists
write.csv(data, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationidGListclass.csv", row.names=FALSE)
##reads in data
data <- read.csv("/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationidGListclass.csv")
##deletes unneeded columns
data$level_name <- NULL
##rename columns for venn diagrams
colnames(data)[1] <- "regulationclasslevel"
##gets rid of unneeded columns
data$level_id <- NULL
##writes final level list for venn diagrams
write.csv(data, "/media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/regulationidGlistclass.csv", row.names=FALSE)
