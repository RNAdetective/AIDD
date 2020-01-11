#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file_in <- paste0(args[1]) #"$dirres"/RF_count_matrix.csv
x_axis <- paste0(args[2]) 
y_axis <- paste0(args[3]) 
color_by <- paste0(args[4]) 
fill_by <- paste0(args[5]) 
image5 <- paste0(args[6]) 
image6 <- paste0(args[7]) 
image7 <- paste0(args[8]) 
image8 <- paste0(args[9]) 
image9 <- paste0(args[10])
file_out <- paste0(args[11])
data <- read.csv("/media/sf_AIDD/all_count_matrixALLMDD.csv")
file_out <- "/media/sf_AIDD/ADARp110AtoG.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=x_axis, y=y_axis, color=color_by)) + geom_point() + geom_smooth(method="lm") + facet_wrap(~samp_name) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + scale_color_manual(values = c("green", "blue", "red", "green", "blue", "red"))
my_plot
dev.off()

file_out <- "/media/sf_AIDD/ADARp110AtoG_2.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=ADAR_002, y=AtoGnorm, color=samp_name)) + geom_point() + geom_smooth(method="lm") + facet_wrap(~Sex) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + scale_color_manual(values = c("green", "blue", "red", "green", "blue", "red"))
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/guttediting_count_matrixMDDscores.csv")
file_out <- "/media/sf_AIDD/guttman_scores.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=sex, y=Average, fill=fill_by)) + geom_bar(stat="identity", position=position_dodge()) + scale_fill_manual(values = c("green", "blue", "red", "green", "blue", "red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) 
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/guttediting_count_matrixMDDranks.csv")
file_out <- "/media/sf_AIDD/guttman_ranks.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=ranks, color=condition)) + geom_point() + geom_smooth(method="lm") + facet_wrap(~sex) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()
file_out <- "/media/sf_AIDD/guttman_ranksNoLines.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=ranks, color=condition)) + geom_point() + facet_wrap(~sex) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/guttediting_count_matrixMDDprob.csv")
file_out <- "/media/sf_AIDD/guttman_prob.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=prob, color=condition)) + geom_point() + facet_wrap(~sex) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/guttediting_count_matrixMDDbootstrap.csv")
file_out <- "/media/sf_AIDD/guttman_bootstrap.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=bootstrap, y=prob, color=condition)) + geom_boxplot() + facet_wrap(~sex) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/excitomefreq_count_matrixMDD.csv")
file_out <- "/media/sf_AIDD/excitomefreqAverage.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=gene_name, y=frequency, fill=condition)) + geom_bar(stat="identity", position=position_dodge()) + scale_fill_manual(values = c("green", "blue", "red", "green", "blue", "red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + facet_wrap(~sex)
my_plot


