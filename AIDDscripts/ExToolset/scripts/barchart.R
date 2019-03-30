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
if ( bartype == "readdepth" ) {
data_in <- read.csv(file_in);
colnames(data_in)[2] <- "name"
colnames(data_in)[5] <- "cell"
colnames(data_in)[7] <- "freq"
tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
q <- ggplot(data_in, aes(x=name, y=freq, fill=cell)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p <- q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
print(p)
garbage <- dev.off()
}
if ( bartype == "cond" ) {
data_in <- read.csv(file_in);
colnames(data_in)[2] <- "name"
colnames(data_in)[1] <- "freq"
tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
q <- ggplot(data_in, aes(x=name, y=freq, fill=name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p <- q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
print(p)
garbage <- dev.off()
}
if ( bartype == "excitome" ) {
pheno <- paste0(args[4])
freq <- (paste0(args[5]))
sum_file <- paste0(args[6])
sampname <- paste0(args[7])
pheno_in <- read.csv(pheno)
data_in <- read.csv(file_in);
  if ( sampname == "samp_name" ) {
  colnames(data_in)[1] <- "samp_name"
  datamerge <- merge(pheno_in, data_in, by="samp_name")
  }
  if ( sampname == "run" ) {
  colnames(data_in)[1] <- "run"
  datamerge <- merge(pheno_in, data_in, by="run")
  }
cdata <- ddply(datamerge, c("condition_name"), summarise, N = length(freq_name), mean=round(mean(freq_name),2), sd=round(sd(freq_name), 2))
cdata$substitution <- rep("freq_name",nrow(cdata)) # make new column 
write.csv(cdata, sum_file, row.names=FALSE, quote=FALSE)
#tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
#q <- ggplot(cdata, aes(x=condition_name, y=mean, fill=condition_name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
#p <- q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
#r <- p + geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2, position=position_dodge(.9)) 
#z <- r + labs(title="freq_name expression for condition_name", x="freq_name", y = "Expression(TPM)")
#print(z)
#garbage <- dev.off()
}
if ( bartype == "substitutions" ) {
cdata <- read.csv(file_in)
tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
q <- ggplot(cdata, aes(x=substitution, y=mean, fill=condition_name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p <- q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
r <- p + geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2, position=position_dodge(.9)) 
z <- r + labs(title="substitution", x="substitution", y = "Counts normalized by Read Depth")
print(z)
garbage <- dev.off()
}
if ( bartype == "ANOVA" ) {
  pheno <- paste0(args[4])
  count_of_interest <- paste0(args[5])
  sum_file <- paste0(args[6])
  #condition_name <- paste0(args[7])
  file_out2 <- paste0(args[8])
  sum_file2 <- paste0(args[9])
  data <- read.csv(file_in)
  #data$suicide <- factor(data$suicide, levels = c("no","yes"), labels = c("no", "yes")) # suicide
  #data$Sex <- factor(data$Sex, levels = c("male","female"), labels = c("male","female")) # sex
  #data$MDD <- factor(data$MDD, levels = c("no","yes"), labels = c("no", "yes")) # MDD
  cdata <- ddply(data, c("condition_name"), summarise, N = length(freq_name), mean=round(mean(freq_name),5), sd=round(sd(freq_name), 5))
  cdata$substitution <- rep("freq_name",nrow(cdata)) # make new column 
  write.csv(cdata, sum_file, row.names=FALSE, quote=FALSE)
  #tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
  #q <- ggplot(cdata, aes(x=condition_name, y=mean, fill=condition_name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
  #p <- q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
  #r <- p + geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2, position=position_dodge(.9)) 
  #z <- r + labs(title="freq_name expression for condition_name", x="freq_name", y = "Expression(TPM)")
  #print(z)
  #garbage <- dev.off()
  #tiff(file_out2, units="in", width=10, height=10, res=600)
#ggboxplot(data, x= "condition_name", y = "freq_name", color = "condition_name")
#  garbage <- dev.off()
res.aov <- anova(lm(freq_name~condition_name, data=data))
out <- capture.output(summary(res.aov))
write.csv(out, sum_file2, row.names=FALSE, quote=FALSE)
cat("freq_nameANOVA", out, file=sum_file2, sep="n", append=TRUE)
}
if ( bartype == "scatter" ) {
file_out2 <- paste0(args[8])
#tiff(file_out, units="in", width=10, height=10, res=600)
data <- read.csv(file_in)
#p <- ggplot(data, aes(x= scatter_x, y= scatter_y)) + geom_point(aes(color=cond_4, shape=cond_1, size=cond_3)) + geom_smooth(method=lm) + scale_shape_manual(values=c(16,17)) + scale_size_manual(values=c(2,4))
#print(p)
#garbage <- dev.off()
out <- capture.output(cor.test( ~ scatter_x + scatter_y, data=data, method = "pearson", continuity = FALSE, conf.level = 0.95))
write.csv(out, file_out2, row.names=FALSE, quote=FALSE)
}
#total <- data_in$freq[nrow(data_in)] #find the correct total to calculate percents
#data <- data_in[-nrow(data_in),]
#total <- sum(data_in$freq)
#data <- data_in
#data$pct <- data$name/total #adds percent column
