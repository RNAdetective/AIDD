#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
# Pie Chart with Percentages for labels
###################NEED TO COLLAPSE labels in country and journal and yearA
file_in <- print(paste0(args[1]));
file_out <- print(paste0(args[2]));
name <- print(paste0(args[3]));
data_in <- read.csv(file_in);
if (name=="topic") {
total <- data_in[5, 2]
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
