#!/usr/bin/env Rscript
library(ggplot2)
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
tool <- print(paste0(args[1]))
print(paste0(tool))
if (tool=="piechart") {
# Pie Chart with Percentages for labels
file_in <- print(paste0(args[2]));
file_out <- print(paste0(args[3]));
name <- print(paste0(args[4]));
data_in <- read.csv(file_in);
if (name=="total") {
total <- data_in$freq[nrow(data_in)] 
data <- data_in[-nrow(data_in),]
} else {
total <- sum(data_in$freq)
data <- data_in
}
cols <- rainbow(nrow(data));
slices <- data$freq
lb_per <- paste0(round(data$freq/total*100,2),'%')
lb_name <- paste0(data$name)
lb_all <- paste0(lb_name," , ",lb_per)
title <- print(paste0("out of ",total," pubmed articles"))
tiff(file_out, units="in", width=10, height=10, res=600)
pie(slices,labels=lb_all,col=cols,main=title);
dev.off()
} 
if (tool=="barchart") {
# Barcharts with Percentages for labels
file_in <- print(paste0(args[2]));
file_out <- print(paste0(args[3]));
data_in <- read.csv(file_in);
total <- data_in$freq[nrow(data_in)] #find the correct total to calculate percents
data <- data_in[-nrow(data_in),]
total <- sum(data_in$freq)
data <- data_in
#data$pct <- data$name/total #adds percent column
tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
ggplot(data, aes(x=name, y=freq, fill=name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
dev.off()
}
