#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file_in <- paste0(args[1])
file_out2 <- paste0(args[2])
file_out3 <- paste0(args[3])
file_out4 <- paste0(args[4])
file_out5 <- paste0(args[5])
file_out6 <- paste0(args[6])
file_out7 <- paste0(args[7])
file_out8 <- paste0(args[8])
image1 <- paste0(args[9])
image2 <- paste0(args[10])
image3 <- paste0(args[11])
image4 <- paste0(args[12])
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("tidyr"))
suppressPackageStartupMessages(library("ggplot2"))

data <- read.csv(file_in)
tiff(image1, units="in", width=15, height=15, res=300)
data_plot <- data %>%
group_by(Var_infection, Timepoint, CellLine) %>%
summarize(average = mean (s_type), sd=sd(s_type))
my_plot <- ggplot(data_plot, aes(x=Var_infection, y=average, fill=Var_infection)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(Timepoint), vars(CellLine)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
my_plot2
dev.off()

data <- read.csv(file_in)
tiff(image2, units="in", width=15, height=15, res=300)
data_plot <- data %>%
group_by(Var_infection, Timepoint) %>%
summarize(average = mean (s_type), sd=sd(s_type))
my_plot <- ggplot(data_plot, aes(x=Var_infection, y=average, fill=Var_infection)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(Timepoint)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
my_plot2
dev.off()

data <- read.csv(file_in)
tiff(image3, units="in", width=15, height=15, res=300)
data_plot <- data %>%
group_by(Var_infection, CellLine) %>%
summarize(average = mean (s_type), sd=sd(s_type))
my_plot <- ggplot(data_plot, aes(x=Var_infection, y=average, fill=Var_infection)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(CellLine)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
my_plot
dev.off()

data <- read.csv(file_in)
tiff(image4, units="in", width=15, height=15, res=300)
data_plot <- data %>%
group_by(Var_infection) %>%
summarize(average = mean (s_type), sd=sd(s_type))
my_plot <- ggplot(data_plot, aes(x=Var_infection, y=average, fill=Var_infection)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
my_plot2
dev.off()

data <- read.csv(file_in)
data_plot <- data %>%
filter ( Var_infection != "Accident" )
fit <- aov(s_type ~ Var_infection*Timepoint*CellLine, data=data_plot)
res.aov <- summary(fit)
res.Tukey <- TukeyHSD(fit)
# Title
cat("freq_nameANOVA", file = file_out2)
# add 2 newlines
cat("\n\n", file = file_out2, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out2, append = TRUE)
capture.output(res.aov, file = file_out2, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out2, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out2, append = TRUE)
capture.output(res.Tukey, file = file_out2, append = TRUE)


data <- read.csv(file_in)
data_plot <- data %>%
filter ( Var_infection != "Accident" )
fit <- aov(s_type ~ Var_infection*CellLine, data=data_plot)
res.aov <- summary(fit)
res.Tukey <- TukeyHSD(fit)
# Title
cat("freq_nameANOVA", file = file_out3)
# add 2 newlines
cat("\n\n", file = file_out3, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out3, append = TRUE)
capture.output(res.aov, file = file_out3, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out3, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out3, append = TRUE)
capture.output(res.Tukey, file = file_out3, append = TRUE)


data <- read.csv(file_in)
data_plot <- data %>%
filter ( Var_infection != "Accident" )
fit <- aov(s_type ~ Timepoint*CellLine, data=data_plot)
res.aov <- summary(fit)
res.Tukey <- TukeyHSD(fit)
# Title
cat("freq_nameANOVA", file = file_out4)
# add 2 newlines
cat("\n\n", file = file_out4, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out4, append = TRUE)
capture.output(res.aov, file = file_out4, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out4, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out4, append = TRUE)
capture.output(res.Tukey, file = file_out4, append = TRUE)


data <- read.csv(file_in)
data_plot <- data %>%
filter ( Var_infection != "Accident" )
fit <- aov(s_type ~ Var_infection*Timepoint, data=data_plot)
res.aov <- summary(fit)
res.Tukey <- TukeyHSD(fit)
# Title
cat("freq_nameANOVA", file = file_out5)
# add 2 newlines
cat("\n\n", file = file_out5, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out5, append = TRUE)
capture.output(res.aov, file = file_out5, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out5, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out5, append = TRUE)
capture.output(res.Tukey, file = file_out5, append = TRUE)


data <- read.csv(file_in)
data_plot <- data %>%
filter ( Var_infection != "Accident" )
fit <- aov(s_type ~ Var_infection, data=data_plot)
res.aov <- summary(fit)
res.Tukey <- TukeyHSD(fit)
# Title
cat("freq_nameANOVA", file = file_out6)
# add 2 newlines
cat("\n\n", file = file_out6, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out6, append = TRUE)
capture.output(res.aov, file = file_out6, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out6, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out6, append = TRUE)
capture.output(res.Tukey, file = file_out6, append = TRUE)


data <- read.csv(file_in)
data_plot <- data %>%
filter ( Var_infection != "Accident" )
fit <- aov(s_type ~ Timepoint, data=data_plot)
res.aov <- summary(fit)
res.Tukey <- TukeyHSD(fit)
# Title
cat("freq_nameANOVA", file = file_out2)
# add 2 newlines
cat("\n\n", file = file_out7, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out7, append = TRUE)
capture.output(res.aov, file = file_out7, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out7, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out7, append = TRUE)
capture.output(res.Tukey, file = file_out7, append = TRUE)


data <- read.csv(file_in)
data_plot <- data %>%
filter ( Var_infection != "Accident" )
fit <- aov(s_type ~ CellLine, data=data_plot)
res.aov <- summary(fit)
res.Tukey <- TukeyHSD(fit)
# Title
cat("freq_nameANOVA", file = file_out8)
# add 2 newlines
cat("\n\n", file = file_out8, append = TRUE)
# export anova test output
cat("Anova Test\n", file = file_out8, append = TRUE)
capture.output(res.aov, file = file_out8, append = TRUE)
# add 2 newlines
cat("\n\n", file = file_out8, append = TRUE)
# export t-test output
cat("Tukey-HSD\n", file = file_out8, append = TRUE)
capture.output(res.Tukey, file = file_out8, append = TRUE)

