#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file_in <- paste0(args[1])
file_out <- paste0(args[2])
file_out2 <- paste0(args[3])
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyr"))
suppressPackageStartupMessages(library("ggplot2"))
data <- read.csv(file_in)
data_plot <- data %>%
filter(excitome_gene == "e2_gene") %>%
group_by(COD, gender, tissue) %>%
summarize(average = mean (freq)) 
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data_plot, aes(x=COD, y=average, fill=COD))  + geom_bar(stat="identity", position=position_dodge()) + facet_grid(vars(gender), vars(tissue)) + scale_fill_manual(values=c('blue','red'))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=28)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 28)) + theme(text = element_text(size=28)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
my_plot2
dev.off()
res.aov <- aov(freq~COD*gender*tissue, data=data)
sum.res.aov <- summary(res.aov)
res.aov
res.Tukey <- TukeyHSD(res.aov)
#out <- capture.output(summary(res.aov))
#write.csv(out, file_out2, row.names=FALSE, quote=FALSE)
#cat("freq_nameANOVA", out, file=file_out2, sep="n", append=TRUE)

# Title
cat("freq_nameANOVA", file = file_out2)
# add 2 newlines
cat("\n\n", file = file_out2, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out2, append = TRUE)
capture.output(sum.res.aov, file = file_out2, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out2, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out2, append = TRUE)
capture.output(res.aov, file = file_out2, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out2, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out2, append = TRUE)
capture.output(res.Tukey, file = file_out2, append = TRUE)

