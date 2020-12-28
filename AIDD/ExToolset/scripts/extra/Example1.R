#!/usr/bin/env Rscript
suppressPackageStartupMessages(library(ggplot2)) #loads packages
suppressPackageStartupMessages(library(plyr))
suppressPackageStartupMessages(library(ggpubr))
suppressPackageStartupMessages(library(dplyr))
args = commandArgs(trailingOnly=TRUE) #loads data from command line when running the script
# test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} else if (length(args)==1) {
  args[2] = "out.txt"
}
file_in <- paste0(args[1]);  # this is your input file /media/sf_AIDD/allscoresfinal.csv
file_out <- paste0(args[2]); # this is your output graph /media/sf_AIDD/phenotypescore.tiff
color <- paste0(args[3]); #what fill color do you want
x_axis <- paste0(args[4]); #what goes on the x-axis
y_axis <- paste0(args[5]); #what goes on the y-axis
grid1 <- paste0(args[6]); #which facet do you want in columns
grid2 <- paste0(args[7]); #which facet do you want in rows
data <- read.csv(file_in) # reads input file into R
tiff(file_out, units="in", width=15, height=15, res=300) # this sets image size and resolution
data_plot <- data %>% # dply function to load data
group_by(COD, gender, tissue) %>% # this function groups data by three columns
summarize(average = mean (MLE), sd=sd(MLE)) # this calculates average and standard deviation
my_plot <- ggplot(data_plot, aes(x=x_axis, y=y_axis, fill=color)) + geom_bar(colour="black", stat="identity", position=position_dodge()) # makes basic bar plot
my_plot2 <- my_plot1 + facet_grid(vars(grid1), vars(grid2)) # adds facets which will divid graph into segemtns based on a variable
my_plot3 <- my_plot2 + scale_fill_manual(values=c('red','blue')) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9)) # this adds color choice to bars and error bars with standard deviation
my_plot4 <- my_plot3 + theme_bw() + theme(panel.grid.major = element_blank() + panel.grid.minor = element_blank()) #this moves grid lines
my_plot5 <- my_plot4 + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) # this edits the legend placement and size
my_plot6 <- my_plot5 + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) # this removes x axis since you have the same labels as colors in your legend
my_plot6 # prints the plot so you can save it.
dev.off() # this turns off the picture saving and will save graph to file specified.

