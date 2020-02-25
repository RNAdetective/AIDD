#Part1
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(sirt))
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
# Barcharts with Percentages for labels
file_in <- paste0(args[1]);
file_out1 <- paste0(args[2]);
file_out2 <- paste0(args[3]);
file_out3 <- paste0(args[4]);
data <- read.csv(file_in)
numcol <- ncol(data)
gutt <- prob.guttman(data[,c(7:numcol)], guess.equal=TRUE, slip.equal=TRUE)
guttscores <- gutt$person
guttitems <- gutt$item
gutttrait <- gutt$trait
write.csv(guttscores, file_out1, row.names=FALSE, quote=FALSE)
write.csv(guttitems, file_out2, row.names=FALSE, quote=FALSE)
write.csv(gutttrait, file_out3, row.names=FALSE, quote=FALSE)



