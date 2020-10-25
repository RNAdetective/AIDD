data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanAllCODitemlevelonly3levels2.csv")
file_out <- "/media/sf_AIDD/all_guttman/GuttmanAllCODitemlevelonly3levels2.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=COD)) + geom_line() + facet_grid(vars(tissue), vars(gender)) + theme_bw() + scale_color_manual(values=c('blue','red')) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanAllCODitemlevelonly3levels.csv")
data2 <- data %>%
gather (feature, rank, -guttman_order, -gene_name)
write.csv(data2, "/media/sf_AIDD/all_guttman/GuttmanAllCODitemlevelonly3levels2.csv", row.names=FALSE)

data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2.csv")
data2 <- data %>%
gather (gene_name, freq, -samp_name, -Run, -Cause_of_death, -gender, -phenotype, -tissue)
write.csv(data2, "/media/sf_AIDD/all_excitomefreq/MDDfreqall2gather.csv", row.names=FALSE, quote=FALSE)





