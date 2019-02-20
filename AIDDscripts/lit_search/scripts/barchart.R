#!/usr/bin/env Rscript
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
# Barcharts with Percentages for labels
file_in <- print(paste0(args[1]));
file_out <- print(paste0(args[2]));
data_in <- read.csv(file_in);
total <- data_in$freq[nrow(data_in)] #find the correct total to calculate percents
data <- data_in[-nrow(data_in),]
total <- sum(data_in$freq)
data <- data_in
#data$pct <- data$name/total #adds percent column
tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
ggplot(data, aes(x=name, y=freq, fill=name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()
