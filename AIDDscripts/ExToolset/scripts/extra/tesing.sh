library(ggpubr)
library(dplyr)
suppressPackageStartupMessages(library(ggplot2))
suppressPackageStartupMessages(library(plyr))
file_in <- paste0(args[1])
file_out <- paste0(args[2])
bartype <- paste0(args[3])
pheno <- paste0(args[4])
count_of_interest <- paste0(args[5])
sum_file <- paste0(args[6])
condition_name <- paste0(args[7])
file_out2 <- paste0(args[8])
sum_file2 <- paste0(args[9])
data <- read.csv(file_in)
#data$suicide <- factor(data$suicide, levels = c("no","yes"), labels = c("no", "yes")) # suicide
#data$Sex <- factor(data$Sex, levels = c("male","female"), labels = c("male","female")) # sex
#data$MDD <- factor(data$MDD, levels = c("no","yes"), labels = c("no", "yes")) # MDD
cdata <- ddply(data, c("condition_name"), summarise, N = length(freq_name), mean=round(mean(freq_name),5), sd=round(sd(freq_name), 5))
cdata$substitution <- rep("freq_name",nrow(cdata)) # make new column 
print(head(cdata))
write.csv(cdata, sum_file, row.names=FALSE, quote=FALSE)
tiff(file_out, units="in", width=10, height=10, res=600) #names the chart file
q <- ggplot(cdata, aes(x=condition_name, y=mean, fill=condition_name)) + geom_bar(stat="identity", color="black", position=position_dodge()) + theme_minimal() + theme(legend.position="bottom") + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
p <- q + theme(axis.text.x = element_text(angle = 90, hjust = 1))
r <- p + geom_errorbar(aes(ymin=mean-sd, ymax=mean+sd), width=.2, position=position_dodge(.9)) 
z <- r + labs(title="freq_name expression for condition_name", x="freq_name", y = "Expression(TPM)")
print(z)
garbage <- dev.off()
tiff(file_out2, units="in", width=10, height=10, res=600)
ggboxplot(data, x= "condition_name", y = "freq_name normalized for read depth", color = "condition_name")
dev.off()
res.aov <- anova(lm(AtoGnorm~suicide*Sex*MDD, data=data, type ="3"))
out <- capture.output(summary(res.aov))
cat("freq_nameANOVA", out, file=sum_file2, sep="n", append=TRUE)

#genehigh_impactADAReditingnormalized
#genehigh_impactAGnormalized
#genehigh_impactAllnormalized

#genemoderate_impactADAReditingnormalized
#genemoderate_impactAGnormalized
#genemoderate_impactAllnormalized

#transcripthigh_impactADAReditingnormalized
#transcripthigh_impactAGnormalized
#transcripthigh_impactAllnormalized

#transcriptmoderate_impactADAReditingnormalized
#transcriptmoderate_impactAGnormalized
#transcriptmoderate_impactAllnormalized
