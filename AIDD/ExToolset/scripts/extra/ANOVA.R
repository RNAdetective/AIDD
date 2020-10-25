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
bartype <- paste0(args[3]);
if ( bartype == "ANOVA" ) {
  pheno <- paste0(args[4])
  count_of_interest <- paste0(args[5])
  sum_file <- paste0(args[6])
  #condition_name <- paste0(args[7])
  file_out2 <- paste0(args[8])
  sum_file2 <- paste0(args[9])
  data <- read.csv(file_in)
  print(head(data))
  #data$suicide <- factor(data$suicide, levels = c("no","yes"), labels = c("no", "yes")) # suicide
  #data$Sex <- factor(data$Sex, levels = c("male","female"), labels = c("male","female")) # sex
  #data$MDD <- factor(data$MDD, levels = c("no","yes"), labels = c("no", "yes")) # MDD
  cdata <- ddply(data, c("condition_name"), summarise, N = length("freq_name"), mean=round(mean("freq_name"),5), sd=round(sd("freq_name"), 5))
  cdata$substitution <- rep("freq_name",nrow(cdata)) # make new column 
  write.csv(cdata, sum_file, row.names=FALSE, quote=FALSE)
  tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
  q <- ggplot(cdata, aes(x=substitution, y=mean, fill=condition_name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  p <- q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  r <- p + geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2, position=position_dodge(.9)) 
  z <- r + labs(title="condition_name expression for freq_name", x="freq_name", y = "Expression(TPM)")
  print(z)
  garbage <- dev.off()
  tiff(file_out2, units="in", width=10, height=10, res=600)
  p <- ggboxplot(data, x= "condition_name", y = "freq_name", color = "condition_name")
  print(p)
  garbage <- dev.off()
res.aov <- anova(lm(freq_name~condition_name, data=data))
out <- capture.output(summary(res.aov))
write.csv(out, sum_file2, row.names=FALSE, quote=FALSE)
cat("freq_nameANOVA", out, file=sum_file2, sep="n", append=TRUE)
}
