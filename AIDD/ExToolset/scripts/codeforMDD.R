
data <- read.csv("/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinal.csv")
file_out <- "/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinaltypename3.tiff"
tiff(file_out, units="in", width=20, height=15, res=300)
data_plot <- data %>%
filter (type != "percent" & type != "total") %>%
filter (sub != "ADAR") %>%
filter (COD != "Accident") %>%
group_by(name, type, sub, COD, gender) %>%
summarize(average = mean (variants), sd=sd(variants))
my_plot <- ggplot(data_plot, aes(x=sub, y=average, fill=COD)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(type), vars(name), vars(gender)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + scale_fill_manual(values=c('blue','red'))
my_plot2
dev.off()


data <- read.csv("/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinal.csv")
file_out <- "/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinaltypename4.tiff"
tiff(file_out, units="in", width=20, height=15, res=300)
data_plot <- data %>%
filter (type != "percent" & type != "total") %>%
filter (sub != "ADAR") %>%
filter (COD != "Accident") %>%
group_by(name, type, sub) %>%
summarize(average = mean (variants), sd=sd(variants))
my_plot <- ggplot(data_plot, aes(x=sub, y=average, fill=name)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(type)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + scale_fill_brewer(palette="Spectral")
my_plot2
dev.off()


data <- read.csv("/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinal2.csv")
file_out <- "/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinalADARCOD.tiff"
tiff(file_out, units="in", width=20, height=15, res=300)
data_plot <- data %>%
filter (type == "nonsnps") %>%
filter (sub == "ADAR") %>%
filter (COD != "Accident") %>%
filter (name == "filtered_snps_finalAll") %>%
group_by(gender, COD, tissue) %>%
summarize(average = mean (variants), sd=sd(variants))
my_plot <- ggplot(data_plot, aes(x=tissue, y=average, fill=COD)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + scale_fill_manual(values=c('blue','red'))
my_plot2
dev.off()

data <- read.csv("/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinal2.csv")
file_out <- "/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinalADARMDD.tiff"
tiff(file_out, units="in", width=20, height=15, res=300)
data_plot <- data %>%
filter (type == "nonsnps") %>%
filter (sub == "ADAR") %>%
filter (COD != "Accident") %>%
filter (name == "filtered_snps_finalAll") %>%
group_by(gender, MDD, tissue) %>%
summarize(average = mean (variants), sd=sd(variants))
my_plot <- ggplot(data_plot, aes(x=tissue, y=average, fill=MDD)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=16))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + scale_fill_manual(values=c('blue','yellow'))
my_plot2
dev.off()

data <- read.csv("/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinal2.csv")
file_out <- "/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinalADARCOD.tiff"
tiff(file_out, units="in", width=20, height=15, res=300)
data_plot <- data %>%
filter (type == "nonsnps") %>%
filter (sub == "ADAR") %>%
filter (COD != "Accident") %>%
filter (name == "filtered_snps_finalAll") %>%
group_by(gender, COD, tissue) %>%
summarize(average = mean (variants), sd=sd(variants))
my_plot <- ggboxplot(data_plot, x= "tissue", y = "average", color = "COD")
my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=16))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + scale_color_manual(values=c('blue','red'))
dev.off()

data <- read.csv("/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinal2.csv")
file_out <- "/media/sf_AIDD/all_variantfiltering/VariantFilteringVisualFinalADARMDD.tiff"
tiff(file_out, units="in", width=20, height=15, res=300)
data_plot <- data %>%
filter (type == "nonsnps") %>%
filter (sub == "ADAR") %>%
filter (COD != "Accident") %>%
filter (name == "filtered_snps_finalAll") %>%
group_by(gender, MDD, tissue) %>%
summarize(average = mean (variants), sd=sd(variants))
my_plot <- ggboxplot(data_plot, x= "tissue", y = "average", color = "MDD")
my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + scale_color_manual(values=c('blue','yellow'))
dev.off()

data_plot <- data %>%
filter (type == "nonsnps") %>%
filter (sub == "ADAR") %>%
filter (COD != "Accident") %>%
filter (name == "filtered_snps_finalAll")
res.aov <- aov(variants~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)

data <- read.csv("/media/sf_AIDD/stackdepthfinal2.csv")
file_out <- "/media/sf_AIDD/stackdepthfinal2gather.csv"
data2 <- data %>%
gather(gene_name, depth, -COD, -gender, -phenotype, -tissue)
write.csv(data2, file_out, row.names=FALSE)



data <- read.csv("/media/sf_AIDD/stackdepthfinal2gather.csv")
file_out <- "/media/sf_AIDD/stackdepthfinal2gather.tiff"
tiff(file_out, units="in", width=25, height=15, res=300)
data_plot <- data %>%
group_by(gender, tissue, gene_name) %>%
summarize(average=mean(depth), sd=sd(depth))
my_plot <- ggplot(data_plot, aes(x=gene_name, y=average, fill=gene_name)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(tissue), vars(gender)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9)) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(legend.position="none")
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/all_globalEditing/CombinedCountsFinal.csv")
file_out <- "/media/sf_AIDD/all_globalEditing/CombinedCounts2COD.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
group_by(tissue,COD,gender,location) %>%
summarize(average = mean (percent), sd=sd(percent))
my_plot <- ggplot(data_plot, aes(x=location, y=average, fill=COD)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender), vars(tissue)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9)) + scale_fill_manual(values=c('blue','red')) 
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(axis.text.x = element_text(angle = 90)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12)))
my_plot2
dev.off()

data <- read.csv("/media/sf_AIDD/all_globalEditing/ADARChange.csv")
file_out <- "/media/sf_AIDD/all_globalEditing/ADARChangegather.csv"
data2 <- data %>%
gather(chromosome, count, -COD, -phenotype, -tissue, -gender)
write.csv(data2, file_out, row.names=FALSE)

data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "DOWNSTREAM")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "EXON")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "INTRON")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "INTERGENIC")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "MOTIF")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "SPLICE_SITE_ACCEPTOR")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "SPLICE_SITE_DONOR")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "SPLICE_SITE_REGION")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "TRANSCRIPT")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "UTR_3_PRIME")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "UPSTREAM")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (type == "ADAR") %>%
filter (COD != "Accident") %>%
filter (location == "UTR_5_PRIME")
res.aov <- aov(percent~COD*tissue*gender*MDD, data=data_plot)
summary(res.aov)



data <- read.csv("/media/sf_AIDD/all_globalEditing/ADARChangegather.csv")
file_out <- "/media/sf_AIDD/all_globalEditing/ADARChangegatherphenotype.tiff"
tiff(file_out, units="in", width=30, height=40, res=300)
data_plot <- data %>%
filter (COD != "Accident") %>%
group_by(tissue,phenotype,gender,chromosome) %>%
summarize(average = mean (count), sd=sd(count))
my_plot <- ggplot(data_plot, aes(x=chromosome, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(tissue), vars(gender)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9)) + scale_fill_manual(values=c('blue','yellow')) 
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=28)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=28))) + theme(strip.text.x = element_text(size = 28)) + theme(text = element_text(size=28)) + theme(axis.text.x = element_text(angle = 90))
my_plot2
dev.off()

data_plot <- data %>%
filter (COD != "Accident")
res.aov <- aov(count~COD*tissue*gender*phenotype*chromosome, data=data_plot)
summary(res.aov)

data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr01")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr02")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr03")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr04")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr05")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr06")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr07")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr08")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr09")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr10")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr11")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr12")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr13")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr14")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr15")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr16")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr17")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr18")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr19")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr20")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr21")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chr22")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chrX")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (COD != "Accident") %>%
filter (chromosome == "chrY")
res.aov <- aov(count~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)

file_in <- "/media/sf_AIDD/all_guttman/scores/allscoresfinal.csv"
image1 <- "/media/sf_AIDD/all_guttman/scores/MLE/phenotype/phenotypescore1.tiff"
data <- read.csv(file_in)
tiff(image1, units="in", width=15, height=15, res=300)
data_plot <- data %>%
group_by(COD, gender, tissue) %>%
summarize(average = mean (MLE), sd=sd(MLE))
my_plot <- ggplot(data_plot, aes(x=COD, y=average, fill=COD)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender), vars(tissue)) + scale_fill_manual(values=c('blue','yellow')) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
my_plot2
dev.off()

res.aov <- aov(score~COD*tissue*gender*phenotype, data=data)
summary(res.aov)


data <- read.csv("/media/sf_AIDD/all_guttman/1GuttmanAllphenotypeitemlevelCAT.csv")
data2 <- data %>%
gather (feature, rank, -guttman_order, -gene_name)
write.csv(data2, "/media/sf_AIDD/all_guttman/1GuttmanAllMDDitemlevelonly3gather.csv", row.names=FALSE)

data <- read.csv("/media/sf_AIDD/all_guttman/1GuttmanAllMDDitemlevelonly3gather.csv")
file_out <- "/media/sf_AIDD/all_guttman/1GuttmanAllMDDitemlevelonly3gather.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=phenotype)) + geom_line() + facet_grid(vars(tissue), vars(gender)) + theme_bw() + scale_color_manual(values=c('blue','yellow')) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanAllphenotypeitemlevelCAT.csv")
data2 <- data %>%
gather (feature, rank, -guttman_order, -gene_name)
write.csv(data2, "/media/sf_AIDD/all_guttman/GuttmanAllphenotypeitemlevelCATgather.csv", row.names=FALSE)

data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanAllphenotypeitemlevelCATgather.csv")
file_out <- "/media/sf_AIDD/all_guttman/GuttmanAllphenotypeitemlevelCATgather.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=phenotype)) + geom_line() + facet_grid(vars(tissue), vars(gender)) + theme_bw() + scale_color_manual(values=c('blue','yellow')) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanAllCODitemlevel4.csv")
file_out <- "/media/sf_AIDD/all_guttman/GuttmanAllCODitemlevelgather.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data, aes(x=guttman_order, y=rank, color=COD)) + geom_line() + facet_grid(vars(tissue), vars(gender)) + theme_bw() + scale_color_manual(values=c('blue','red')) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2COD_3scoresMLEphenotop15.csv")
data2 <- data %>%
gather (gene_name, freq, -MLE, -COD, -gender, -phenotype, -tissue)
write.csv(data2, "/media/sf_AIDD/all_excitomefreq/MDDfreqall2COD_3scoresMLEphenotop15gather.csv", row.names=FALSE, quote=FALSE)

data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2COD_3scoresMLEphenotop15gather.csv")
file_out <- "/media/sf_AIDD/all_excitomefreq/MDDfreqall2COD_3scoresMLEphenotop15gather.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
data_plot <- data %>%
group_by(phenotype, gender, tissue, gene_name) %>%
summarize(average = mean (freq), sd=sd(freq))

#Turn your 'treatment' column into a character vector
data_plot$gene_name <- as.character(data_plot$gene_name)
#Then turn it back into a factor with the levels in the correct order
data_plot$gene_name <- factor(data_plot$gene_name, levels=unique(data_plot$gene_name))

my_plot <- ggplot(data_plot, aes(x=gene_name, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender), vars(tissue)) + scale_fill_manual(values=c('blue','yellow')) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
my_plot2
dev.off()

data_plot <- data %>%
filter (gene_name == "ACP1_106")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "AZIN1_367")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "FLNA_2341")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "GRIK2_567")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "GRIA2_607")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "GRIA2_764")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "GRIK2_571")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "IGFBP7_95")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "MFN1_328")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "MFN1_345")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "NOVA1_387")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "UNC80_2")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "ZNF397_329")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%



data_plot <- data %>%
filter (gene_name == "ADAR1_427")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "PTK2_84")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "ACP1_106")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "PTPRN2_231")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "AZIN1_367")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "TTYH1_427")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "MRPL28_230")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "CCNI_75")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "COPA_164")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "GRIA2_607")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "GRIA2_764")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "CACNA1D_1597")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "CADPS_1250")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "CYFIP2_320")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)
data_plot <- data %>%
filter (gene_name == "MFN1_345")
res.aov <- aov(freq~COD*tissue*gender*phenotype, data=data_plot)
summary(res.aov)


data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2_3CODscoresMLEtop15.csv")
data2 <- data %>%
gather (feature, rank, -guttman_order, -gene_name)
write.csv(data2, "/media/sf_AIDD/all_guttman/GuttmanAllphenotypeitemlevelCATgather.csv", row.names=FALSE)

data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2COD_3scoresMLEphenotop15gather.csv")
file_out <- "/media/sf_AIDD/all_excitomefreq/MDDfreqall2COD_3scoresMLEphenotop15gather2.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
data_plot <- data %>%
group_by(phenotype, gender, tissue, gene_name) %>%
summarize(average = mean (freq), sd=sd(freq))
myplot <- ggplot(data_plot, aes(x=gene_name, y=average, fill=phenotype)) + geom_violin(trim=FALSE) + geom_boxplot(width=0.1, fill="white") + facet_grid(vars(gender), vars(tissue)) + scale_fill_manual(values=c('blue','yellow'))

myplot2 <-myplot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
myplot2
dev.off()



my_plot <- ggplot(data_plot, aes(x=gene_name, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender), vars(tissue)) + scale_fill_manual(values=c('blue','yellow')) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
my_plot2
dev.off()


data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2COD_3scoresMLE.csv")
#Turn your 'treatment' column into a character vector
data_plot$gene_name <- as.character(data$gender)
#Then turn it back into a factor with the levels in the correct order
data$gender <- as.factor(data$gender)

data <- as.matrix(data)
sample = sample.split(data["COD"], SplitRatio = .75)
train = subset(data, sample == TRUE)
test = subset(data, sample == FALSE)
dim(train)
dim(test)
rf <- randomForest(COD ~ ., data=train,na.action = na.omit, ntrees=1000)
prep = predict(rf, newdata=test[134])



