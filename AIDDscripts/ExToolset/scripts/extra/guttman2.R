#Part2
data <- read.csv("/media/sf_AIDD/Results/excitome.csv")
data$pathway <- factor(data$pathway, levels = data$pathway)
file_out <- "/media/sf_AIDD/Results/excitome.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
ggplot(data, aes(x="", y=count, fill=pathway)) +
  geom_bar(stat="identity", width=1, color="black") +
  coord_polar("y", start=0) +
  theme_void() + 
  theme(legend.position="bottom") + 
  guides(colour = guide_legend(override.aes = list(size=20)))
dev.off()

data <- read.csv("/media/sf_AIDD/Results/guttman/scores/guttediting_count_matrixANOVAscores.csv")
file_out <- "/media/sf_AIDD/Results/guttman/scores/guttediting_count_matrixANOVAscores.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data %>%
group_by(region, timepoint) %>%
summarize(average = mean (score))
my_plot <- ggplot(data_plot, aes(x=timepoint, y=average, fill=timepoint)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_wrap(~region) + scale_fill_brewer(palette="Spectral") 
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=28)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 28)) + theme(text = element_text(size=28)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
my_plot2
dev.off()

data <- read.csv("/media/sf_AIDD/Results/guttman/regions/timepoint/RegionTimepointitems.csv")
file_out <- "/media/sf_AIDD/Results/guttman/regions/timepoint/RegionTimepointitems.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=timepoint)) + geom_line() + facet_wrap(~region) + theme_bw() + scale_color_brewer(palette="Spectral") + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()
file_out <- "/media/sf_AIDD/Results/guttman/regions/timepoint/RegionTimepointitemsNoLines.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=timepoint)) + facet_wrap(~region) + geom_point() + scale_color_brewer(palette="Spectral") + theme_bw() + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/MDD/Results/guttman/sex/condition/Allitems.csv")
file_out <- "/media/sf_AIDD/MDD/Results/guttman/sex/condition/Allitems.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=condition)) + geom_line() + facet_wrap(~sex) + scale_color_manual(values=c("green","blue","red")) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()
file_out <- "/media/sf_AIDD/MDD/Results/guttman/sex/condition/AllitemsNoLines.tiff"
tiff(file_out, units="in", width=10, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=condition)) + geom_point() + facet_wrap(~sex) + scale_color_manual(values=c("green","blue","red")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()


