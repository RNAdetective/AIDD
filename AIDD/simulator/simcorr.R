#!/usr/bin/env Rscript
suppressPackageStartupMessages(library("ggplot2"))
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
experimentname <- paste0(args[1]);
file_in <- paste0(args[2]);
file_in2 <- paste0(args[3]);
file_out <- paste0(args[4]);
file_out2 <- paste0(args[5]);
file_outAll <- paste0(args[6]);
data1 <- read.csv(file_in)
data2 <- read.csv(file_in2)
data <- merge(data1, data2, by="transcript_id")
write.csv(data, file_outAll, quote=FALSE, row.names=FALSE)
colnames(data) <- c("transcript_id", "sim", "AIDD")
tiff(file_out, units="in", width=10, height=10, res=600)
ggplot(data, aes(x=sim, y=AIDD)) + geom_point() + geom_smooth(method=lm) + labs(title=experimentname, x="simulated read counts", y="AIDD calculated read counts") + theme_classic()
garbage <- dev.off()
corr_text <- cor.test( ~ sim + AIDD, data=data, method = "pearson", continuity = FALSE, conf.level = 0.95)
sink(file_out2)
corr_text
sink()


