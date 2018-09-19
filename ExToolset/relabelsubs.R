suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("data.table"))
suppressPackageStartupMessages(library("ggpubr"))
table1 <- read.csv("/media/sf_AIDD/Results/variant_calling/sub_level/largegraph/file_namemeansd.csv")
table1A <- add_column(table1, subs_names = "file_name", .after = 1)
colnames(table1A)[1] <- "condition"
colnames(table1A)[3] <- "avg"
colnames(table1A)[4] <- "sd"
write.csv(table1A, "/media/sf_AIDD/Results/variant_calling/sub_level/largegraph/file_namemeansd.csv", row.names=FALSE)

