#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(ggpubr))
suppressPackageStartupMessages(library(dplyr))
args = commandArgs(trailingOnly=TRUE)
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
# Barcharts with Percentages for labels
file_in <- paste0(args[1]);
file_out <- paste0(args[2]);
image_out1 <- paste0(args[3]);
image_out2 <- paste0(args[4]);
image_out3 <- paste0(args[5]);
image_out4 <- paste0(args[6]);
image_out5 <- paste0(args[7]);
image_out6 <- paste0(args[8]);
image_out7 <- paste0(args[9]);
image_out8 <- paste0(args[10]);
data <- read.csv(file_in)

data_summary1 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (ACcount)) %>%
mutate(nucleotide = "ACcount")
#write.csv(data_summary, file_out, row.names=FALSE, quote=FALSE)
data_summary2 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (AGcount)) %>%
mutate(nucleotide = "AGcount")
data_summary3 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean(ATcount)) %>%
mutate(nucleotide = "ATcount") 
data_summary4 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean(CAcount)) %>%
mutate(nucleotide = "CAcount")
data_summary5 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean(CGcount)) %>%
mutate(nucleotide = "CGcount")
data_summary6 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean(CTcount)) %>%
mutate(nucleotide = "CTcount")
data_summary7 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (GAcount)) %>%
mutate(nucleotide = "GAcount")
data_summary8 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (GCcount)) %>%
mutate(nucleotide = "GCcount")
data_summary9 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (GTcount)) %>%
mutate(nucleotide = "GTcount")
data_summary10 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (TAcount)) %>%
mutate(nucleotide = "TAcount")
data_summary11 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (TCcount)) %>%
mutate(nucleotide = "TCcount")
data_summary12 <- data %>% 
group_by(condition, condition2, name, type) %>%
summarize(average = mean (TGcount)) %>%
mutate(nucleotide = "TGcount")
final_data <- rbind(data_summary1, data_summary2, data_summary3, data_summary4, data_summary5, data_summary6, data_summary7, data_summary8, data_summary9, data_summary10, data_summary11, data_summary12)
write.csv(final_data, file_out, row.names=FALSE, quote=FALSE)

tiff(image_out1, units="in", width=10, height=5, res=300)
data_plot1 <- final_data %>%
filter(name == "filtered_snps_finalAll") %>%
filter(type == "total") %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_wrap(~condition2, scales = "free") +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot1
dev.off()
tiff(image_out2, units="in", width=10, height=5, res=300)
data_plot2 <- final_data %>%
filter(name == "filtered_snps_finalAll") %>%
filter(type == "nonsnps") %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_wrap(~condition2, scales = "free") +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot2
dev.off()
tiff(image_out3, units="in", width=10, height=5, res=300)
data_plot3 <- final_data %>%
filter(type == "nonsnps") %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(condition2 ~ name) +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot3
dev.off()
tiff(image_out4, units="in", width=10, height=5, res=300)
data_plot4 <- final_data %>%
filter(type == "total") %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(condition2 ~ name) +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot4
dev.off()
tiff(image_out5, units="in", width=20, height=10, res=300)
data_plot5 <- final_data %>%
filter(name == "filtered_snps_finalAll") %>%
filter(type %in% c("total","nonsnps")) %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(condition2 ~ type, scales= "free") +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot5
dev.off()
tiff(image_out6, units="in", width=20, height=10, res=300)
data_plot6 <- final_data %>%
filter(name == "raw_snps") %>%
filter(type %in% c("total","nonsnps")) %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(condition2 ~ type, scales= "free") +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot6
dev.off()
tiff(image_out7, units="in", width=20, height=10, res=300)
data_plot7 <- final_data %>%
filter(name %in% c("filtered_snps_finalAll","raw_snps")) %>%
filter(type %in% c("total","nonsnps")) %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(condition2 ~ type ~ name, scales= "free") +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot7
dev.off()
tiff(image_out8, units="in", width=20, height=10, res=300)
data_plot8 <- final_data %>%
filter(type %in% c("total","nonsnps")) %>%
ggplot(aes(x=nucleotide, y=average, fill=condition)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(condition2 ~ type ~ name, scales= "free") +  scale_fill_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
data_plot8
dev.off()
