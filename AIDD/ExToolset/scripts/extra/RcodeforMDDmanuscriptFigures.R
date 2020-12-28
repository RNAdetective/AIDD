##To make read depth graph S. Figure 3
data <- read.csv("/media/sf_AIDD/all_read_depth.csv")
file_out <- "/media/sf_AIDD/all_read_depthphenotype.tiff"
tiff(file_out, units="in", width=5, height=10, res=300)
data_plot <- data %>%
filter (COD != "Accident") %>%
group_by(phenotype,gender,tissue) %>%
summarize(average = mean (freq), sd=sd(freq))
data_plot$phenotype <- factor(data_plot$phenotype)
my_plot <- ggplot(data_plot, aes(x=tissue, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender)) + scale_fill_manual(values=c('blue','yellow'))  + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=20))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=16)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
my_plot2
dev.off()
##To graph results of variant filtering S. Figure 4
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
##To graph stackdepth S. Figure 5
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
##Figure 1

##stats for figure 1

##run all_globalEditing.sh
##figure 2 ADAR editing by location
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
data <- read.csv("/media/sf_AIDD/impactcountsgather.csv")
file_out <- "/media/sf_AIDD/impactcountsgatherADARphenotype.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data %>%
filter (gene_name == "ADAR") %>%
filter (COD != "Accident") %>%
group_by(tissue,phenotype,gender,gene_name) %>%
summarize(average = mean (count), sd=sd(count))
my_plot <- ggplot(data_plot, aes(x=tissue, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9)) + scale_fill_manual(values=c('blue','yellow')) 
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(axis.text.x = element_text(angle = 90)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12)))
my_plot2
dev.off()
##stats for figure 2 ADAR editing by location
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
##figure 3 ADAR editing by chromosome
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
##Stats for figure 3 ADAR editing by chromosome
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
##Figure 4 High and Moderate impact differences
##to make matrices used script IVEX.sh this makes raw counts then used excel to normalized by freq
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2impact.csv")
data2 <- data %>%
gather (impact, counts, -COD, -gender, -phenotype, -tissue)
write.csv(data2, "/media/sf_AIDD/all_excitomefreq/MDDfreqall2impactgather.csv", row.names=FALSE)

file_out <- "/media/sf_AIDD/all_excitomefreq/MDDfreqall2impactPheno.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data2 %>%
group_by(phenotype,gender,tissue,impact) %>%
summarize(average = mean (counts), sd=sd(counts))
data_plot$phenotype <- factor(data_plot$phenotype)
my_plot <- ggplot(data_plot, aes(x=impact, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender),vars(tissue)) + scale_fill_manual(values=c('blue','yellow'))  + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=20))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=16)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
my_plot2
dev.off()
##run guttmansplit to run guttman analysis
##Figure 5 -6 Guttman Rank Order
data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanAllphenotypeitemlevelCAT.csv")
data2 <- data %>%
gather (feature, rank, -guttman_order, -gene_name)
write.csv(data2, "/media/sf_AIDD/all_guttman/GuttmanAllMDDitemlevelonly3gather.csv", row.names=FALSE)

data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanAllMDDitemlevelonly3gather.csv")
file_out <- "/media/sf_AIDD/all_guttman/GuttmanAllMDDitemlevelonly3gather.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
my_plot <- ggplot(data2, aes(x=rank, y=site, color=COD)) + geom_point() + facet_grid(vars(Sex), vars(Brain_Region)) + theme_bw() + scale_color_manual(values=c('red','blue'))
my_plot2 <- my_plot + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12)))  + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) + theme(text = element_text(size=20)) + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())
my_plot2
dev.off()
##Figure 6 Category totals for pairwise t-test

data <- read.csv("/media/sf_AIDD/all_guttman/TotalCategorySums.csv")
file_out <- "/media/sf_AIDD/all_guttman/TotalCategorySums4.tiff"

tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data %>%
group_by(Category,Condition,gender,tissue) %>%
summarize(average = mean (totalitemscore), sd=sd(totalitemscore))
data_plot$Condition <- factor(data$Condition)
my_plot <- ggplot(data_plot, aes(x=Category, y=average, fill=Category)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender),vars(tissue)) + scale_fill_manual(values=c('blue','yellow','blue','red'))  + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=20))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=16))
my_plot2
dev.off()

data <- read.csv("/media/sf_AIDD/all_guttman/GuttmanCategoryChanges.csv")
file_out <- "/media/sf_AIDD/all_guttman/GuttmanCategoryChanges_final4.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data %>%
group_by(Condition,gender,tissue,Category) %>%
summarize(average = mean (Count), sd=sd(Count))
my_plot <- ggplot(data_plot, aes(x=tissue, y=average, fill=Category)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender),vars(as.factor(Condition))) + scale_fill_manual(values=c('red','green','purple'))  + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=20))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=16))
my_plot2
dev.off()



##Figure 7
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

##Random Forest Analysis and Visualization
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("RColorBrewer")) 
suppressPackageStartupMessages(library("plot3D")) 
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("parallel"))
suppressPackageStartupMessages(library("randomForestSRC"))
suppressPackageStartupMessages(library("ggRandomForests"))
suppressPackageStartupMessages(library("GenomicAlignments"))
suppressPackageStartupMessages(library("randomForest"))
library("caret")
library("caTools")
library(randomForest)
library(mlbench)
library(caret)
library(randomForest)
library(mlbench)
library(caret)
##1
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2DE.csv")
data$COD = factor(data$COD)
seed <- 7
metric <- "Accuracy"
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("nodesize","mtry"), class = rep("numeric", 2), label = c("nodesize","mtry"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, nodesize = param$nodesize, mtry=param$mtry, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
tunegrid <- expand.grid(.nodesize=c(1:15),.mtry=c(5,10,20,30,40,50,60,70,80,90,100,120,140))
set.seed(seed)
custom <- train(COD~., data=data, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control,na.action=na.roughfix)
summary(custom)
custom
file_name <- "/media/sf_AIDD/rfparamNodeMtry.tiff"
tiff(file_name, units="in", width=10, height=10, res=600)
plot(custom)
dev.off()
##3
data <- read.csv("/media/sf_AIDD/all_excitomefreq/final/MDDfreqall2.csv")
data$COD = factor(data$COD)
seed <- 7
metric <- "Accuracy"
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("nodesize","ntree"), class = rep("numeric", 2), label = c("nodesize","ntree"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, nodesize = param$nodesize, ntree=param$ntree, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
tunegrid <- expand.grid(.nodesize=c(1:15),.ntree=c(50,100,300,500,1000,1500,3000,5000,10000))
set.seed(seed)
custom <- train(COD~., data=data, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control,na.action=na.roughfix)
summary(custom)
custom
file_name <- "/media/sf_AIDD/rfparamNodeNtree.tiff"
tiff(file_name, units="in", width=10, height=10, res=600)
plot(custom)
dev.off()
##4
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2.csv")
data$COD = factor(data$COD)
seed <- 7
metric <- "Accuracy"
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("ntree","mtry"), class = rep("numeric", 2), label = c("ntree","mtry"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, ntree = param$ntree, mtry=param$mtry, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
tunegrid <- expand.grid(.ntree=c(50,100,300,500,1000,1500,3000,5000,10000),.mtry=c(5,10,20,30,40,50,60,70,80,90,100,120,140))
set.seed(seed)
custom <- train(COD~., data=data, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control,na.action=na.roughfix)
summary(custom)
custom
file_name <- "/media/sf_AIDD/rfparamNtreeMtry.tiff"
tiff(file_name, units="in", width=10, height=10, res=600)
plot(custom)
dev.off()

folds <- sample(1:10, size = nrow(data), replace = T)
table(folds)
folds <- sample(rep(1:10, length.out = nrow(data)), size = nrow(data), replace = F)
table(folds)
CV_rf <- lapply(1:10, function(x){ #5 corresponds to the number of folds defined earlier
  model <- randomForest(COD ~ ., data = data[folds != x,],na.action=na.roughfix,forest=TRUE,ntree=10000,importance=TRUE,prOximity=TRUE,nodesize=10,mtry=140)
  file_name <- paste0("/media/sf_AIDD/myfileTree3COD", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)
  reprtree:::plot.getTree(model)
  dev.off()
  print(model)
  file_name <- paste0("/media/sf_AIDD/myfileError3COD", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)
  plot(model)
  dev.off()
  file_name <- paste0("/media/sf_AIDD/myfileImp3COD", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)  
  varImpPlot(model)
  #print(varImp(model))
  dev.off()
  file_name <- paste0("/media/sf_AIDD/myfileTreesizemod3COD", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)
  hist(treesize(model))
  dev.off()
  #print(varUsed(model))
  #print(importance(model))
  preds <- predict(model, data[folds == x,], type="response")
  #print(preds)
  return(data.frame(preds, real = data$COD[folds == x]))
  })
CV_rf <- do.call(rbind, CV_rf)
caret::confusionMatrix(CV_rf$preds, CV_rf$real)
model$err.rate[1000,1] 

data <- read.csv("/media/sf_AIDD/final/all_excitomefreq/MDDfreqall2DE.csv")
data$COD = factor(data$COD)
seed <- 7
split= sample.split(data$COD, SplitRatio = 0.8)
training_set = subset(data, split == TRUE)
test_set = subset(data, split == FALSE)
rfsrc_regions <- rfsrc(COD~.,data=training_set,na.action="na.impute",ntree=10000,importance=TRUE,mtry=80,nodesize=5)
predict_regions <- predict(rfsrc_regions, test_set)
rfsrc_regions
predict_regions
image1 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLRFAtoG1mtry140node10.tiff"
image2 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG2mtry140node10.tiff"
image3 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG3mtry140node10.tiff"
image4 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG4mtry140node10.tiff"
image5 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG5mtry140node10.tiff"
image6 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG6mtry140node10.tiff"
image7 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG7mtry140node10.tiff"
image8 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG8mtry140node10.tiff"
image9 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG9mtry140node10.tiff"
image10 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFAtoG10mtry140node10.tiff"
image11 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFMLEAtoG11mtry140node10.tiff"
image12 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFMLEAtoG12mtry140node10.tiff"
image13 <- "/media/sf_AIDD/MDDDESeq2/guttmanscoresMLERFMLEAtoG13mtry140node10.tiff"

tiff(image1, units="in", width=10, height=10, res=600)
plot(gg_rfsrc(rfsrc_regions), alpha=.33)
dev.off()
tiff(image2, units="in", width=10, height=10, res=600)
plot(gg_vimp(rfsrc_regions)) + labs(fill = "VIMP > 0")
dev.off()
varsel_regions <- var.select(rfsrc_regions)
#varsel_regions
gg_md <- gg_minimal_depth(varsel_regions)
tiff(image3, units="in", width=10, height=10, res=600)
plot(gg_md)
dev.off()
tiff(image4, units="in", width=10, height=10, res=600)
plot(gg_minimal_vimp(varsel_regions)) + scale_color_manual(values=c('blue','red'))
dev.off()
gg_v <- gg_variable(rfsrc_regions)
xvar <- gg_md$topvars
tiff(image5, units="in", width=10, height=10, res=600)
plot(gg_v, xvar=xvar[-1], panel=TRUE, se=.95, span=1.2, alpha=.4) + geom_smooth() + coord_cartesian(ylim = c(-0.05, 1.05)) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + scale_color_manual(values=c('blue','red'))
dev.off()
tiff(image6, units="in", width=10, height=10, res=600)
plot(gg_v, xvar="MLE", points=FALSE, se=FALSE, notch=TRUE, alpha=.4)
dev.off()
tiff(image7, units="in", width=10, height=10, res=600)
partial_regions <- plot.variable(rfsrc_regions,xvar=gg_md$topvars,partial=TRUE, sorted=FALSE,show.plots = TRUE)
dev.off()
interaction_regions <- find.interaction(rfsrc_regions)
interaction_regions
tiff(image8, units="in", width=10, height=10, res=600)
plot(gg_interaction(interaction_regions), xvar=gg_md$topvars, panel=TRUE)
dev.off()
tiff(image9, units="in", width=30, height=10, res=600)
model <- randomForest(COD~.,data=data,na.action=na.roughfix,forest=TRUE,importance=TRUE,ntree=10000,do.trace=100,mtry=60,nodesize=12,prOximity=TRUE)
reprtree:::plot.getTree(model)
dev.off()
tiff(image10, units="in", width=10, height=10, res=600)
plot(rfsrc_regions)
dev.off()
tiff(image11, units="in", width=10, height=10, res=600)
gg_dta <- gg_roc(rfsrc_regions, which.outcome=1)
plot(gg_dta)  + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom")
dev.off()
tiff(image12, units="in", width=10, height=10, res=600)
gg_dta <- gg_roc(rfsrc_regions, which.outcome=2) 
plot(gg_dta) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom")
dev.off()
tiff(image13, units="in", width=10, height=10, res=600)
roc.list <- roc(rfsrc_regions ~ Suicide + Natural + All, data = data)
gg_dta <- gg_roc(rfsrc_regions) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom")
plot(gg_dta)
dev.off()


##1
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2.csv")
data$phenotype = factor(data$phenotype)
seed <- 7
metric <- "Accuracy"
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("nodesize","mtry"), class = rep("numeric", 2), label = c("nodesize","mtry"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, nodesize = param$nodesize, mtry=param$mtry, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
tunegrid <- expand.grid(.nodesize=c(1:15),.mtry=c(5,10,20,30,40,50,60,70,80,90,100,120,140))
set.seed(seed)
custom <- train(phenotype~., data=data, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control,na.action=na.roughfix)
summary(custom)
custom
file_name <- "/media/sf_AIDD/rfparamNodeMtryphenotype.tiff"
tiff(file_name, units="in", width=10, height=10, res=600)
plot(custom)
dev.off()
##3
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2.csv")
data$phenotype = factor(data$phenotype)
seed <- 7
metric <- "Accuracy"
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("nodesize","ntree"), class = rep("numeric", 2), label = c("nodesize","ntree"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, nodesize = param$nodesize, ntree=param$ntree, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
tunegrid <- expand.grid(.nodesize=c(1:15),.ntree=c(50,100,300,500,1000,1500,3000,5000,10000))
set.seed(seed)
custom <- train(phenotype~., data=data, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control,na.action=na.roughfix)
summary(custom)
custom
file_name <- "/media/sf_AIDD/rfparamNodeNtreephenotype.tiff"
tiff(file_name, units="in", width=10, height=10, res=600)
plot(custom)
dev.off()
##4
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2.csv")
data$phenotype = factor(data$phenotype)
seed <- 7
metric <- "Accuracy"
customRF <- list(type = "Classification", library = "randomForest", loop = NULL)
customRF$parameters <- data.frame(parameter = c("ntree","mtry"), class = rep("numeric", 2), label = c("ntree","mtry"))
customRF$grid <- function(x, y, len = NULL, search = "grid") {}
customRF$fit <- function(x, y, wts, param, lev, last, weights, classProbs, ...) {
  randomForest(x, y, ntree = param$ntree, mtry=param$mtry, ...)
}
customRF$predict <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata)
customRF$prob <- function(modelFit, newdata, preProc = NULL, submodels = NULL)
   predict(modelFit, newdata, type = "prob")
customRF$sort <- function(x) x[order(x[,1]),]
customRF$levels <- function(x) x$classes

control <- trainControl(method="repeatedcv", number=10, repeats=3)
tunegrid <- expand.grid(.ntree=c(50,100,300,500,1000,1500,3000,5000,10000),.mtry=c(5,10,20,30,40,50,60,70,80,90,100,120,140))
set.seed(seed)
custom <- train(phenotype~., data=data, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control,na.action=na.roughfix)
summary(custom)
custom
file_name <- "/media/sf_AIDD/rfparamNtreeMtryphenotype.tiff"
tiff(file_name, units="in", width=10, height=10, res=600)
plot(custom)
dev.off()

folds <- sample(1:10, size = nrow(data), replace = T)
table(folds)
folds <- sample(rep(1:10, length.out = nrow(data)), size = nrow(data), replace = F)
table(folds)
CV_rf <- lapply(1:10, function(x){ #5 corresponds to the number of folds defined earlier
  model <- randomForest(phenotype ~ ., data = data[folds != x,],na.action=na.roughfix,forest=TRUE,ntree=50,importance=TRUE,prOximity=TRUE,nodesize=7,mtry=120)
  file_name <- paste0("/media/sf_AIDD/myfileTree3pheno", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)
  reprtree:::plot.getTree(model)
  dev.off()
  print(model)
  file_name <- paste0("/media/sf_AIDD/myfileError3pheno", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)
  plot(model)
  dev.off()
  file_name <- paste0("/media/sf_AIDD/myfileImp3pheno", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)  
  varImpPlot(model)
  #print(varImp(model))
  dev.off()
  file_name <- paste0("/media/sf_AIDD/myfileTreesizemod3pheno", x, ".tiff")
  tiff(file_name, units="in", width=10, height=10, res=600)
  hist(treesize(model))
  dev.off()
  #print(varUsed(model))
  #print(importance(model))
  preds <- predict(model, data[folds == x,], type="response")
  #print(preds)
  return(data.frame(preds, real = data$phenotype[folds == x]))
  })
CV_rf <- do.call(rbind, CV_rf)
caret::confusionMatrix(CV_rf$preds, CV_rf$real)
model$err.rate[10000,1] 

split= sample.split(data$phenotype, SplitRatio = 0.8)
training_set = subset(data, split == TRUE)
test_set = subset(data, split == FALSE)
rfsrc_regions <- rfsrc(phenotype~.,data=training_set,na.action="na.impute",ntree=50,importance=TRUE,mtry=120,nodesize=7)
predict_regions <- predict(rfsrc_regions, test_set)
rfsrc_regions
predict_regions
image1 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLRFAtoG1mtry140node10pheno.tiff"
image2 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG2mtry140node10pheno.tiff"
image3 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG3mtry140node10pheno.tiff"
image4 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG4mtry140node10pheno.tiff"
image5 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG5mtry140node10pheno.tiff"
image6 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG6mtry140node10pheno.tiff"
image7 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG7mtry140node10pheno.tiff"
image8 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG8mtry140node10pheno.tiff"
image9 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG9mtry140node10pheno.tiff"
image10 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG10mtry140node10pheno.tiff"
image11 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG11mtry140node10pheno.tiff"
image12 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG12mtry140node10pheno.tiff"
image13 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG13mtry140node10pheno.tiff"

tiff(image1, units="in", width=10, height=10, res=600)
plot(gg_rfsrc(rfsrc_regions), alpha=.33)
dev.off()
tiff(image2, units="in", width=10, height=10, res=600)
plot(gg_vimp(rfsrc_regions)) + labs(fill = "VIMP > 0")
dev.off()
varsel_regions <- var.select(rfsrc_regions)
#varsel_regions
gg_md <- gg_minimal_depth(varsel_regions)
tiff(image3, units="in", width=10, height=10, res=600)
plot(gg_md)
dev.off()
tiff(image4, units="in", width=10, height=10, res=600)
plot(gg_minimal_vimp(varsel_regions)) + scale_color_manual(values=c('blue','red'))
dev.off()
gg_v <- gg_variable(rfsrc_regions)
xvar <- gg_md$topvars
tiff(image5, units="in", width=10, height=10, res=600)
plot(gg_v, xvar=xvar[-1], panel=TRUE, se=.95, span=1.2, alpha=.4) + geom_smooth() + coord_cartesian(ylim = c(-0.05, 1.05)) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + scale_color_manual(values=c('blue','yellow'))
dev.off()
tiff(image6, units="in", width=10, height=10, res=600)
plot(gg_v, xvar="MLE", points=FALSE, se=FALSE, notch=TRUE, alpha=.4)
dev.off()
tiff(image7, units="in", width=10, height=10, res=600)
partial_regions <- plot.variable(rfsrc_regions,xvar=gg_md$topvars,partial=TRUE, sorted=FALSE,show.plots = TRUE)
dev.off()
interaction_regions <- find.interaction(rfsrc_regions)
interaction_regions
tiff(image8, units="in", width=10, height=10, res=600)
plot(gg_interaction(interaction_regions), xvar=gg_md$topvars, panel=TRUE)
dev.off()
tiff(image9, units="in", width=30, height=10, res=600)
model <- randomForest(phenotype~.,data=data,na.action=na.roughfix,forest=TRUE,importance=TRUE,ntree=10000,do.trace=100,mtry=80,nodesize=3,prOximity=TRUE)
reprtree:::plot.getTree(model)
dev.off()
tiff(image10, units="in", width=10, height=10, res=600)
plot(rfsrc_regions)
dev.off()
tiff(image11, units="in", width=10, height=10, res=600)
gg_dta <- gg_roc(rfsrc_regions, which.outcome=1)
plot(gg_dta)  + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom")
dev.off()
tiff(image12, units="in", width=10, height=10, res=600)
gg_dta <- gg_roc(rfsrc_regions, which.outcome=2) 
plot(gg_dta) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom")
dev.off()
tiff(image13, units="in", width=10, height=10, res=600)
roc.list <- roc(rfsrc_regions ~ Suicide + Natural + All, data = data)
gg_dta <- gg_roc(rfsrc_regions) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom")
plot(gg_dta)
dev.off()
data <- read.csv("/media/sf_AIDD/RFparamCOD.csv")
data$mtry = factor(data$mtry)
file_out <- "/media/sf_AIDD/RFparamCODNodeMtry.tiff"
tiff(file_out, units="in", width=15, height=15, res=300)
colourCount <- length(unique(data$mtry)) # number of levels
getPalette <- colorRampPalette(brewer.pal(13, "Set1"))
my_plot <- ggplot(data, aes(x=nodesize, y=Accuracy, color=mtry)) + geom_line() + theme_bw()+  scale_color_manual(values = colorRampPalette(brewer.pal(12,"Accent"))(colourCount)) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=14))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + geom_point(size=3)
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/RFparamCOD2.csv")
data$ntree = factor(data$ntree)
file_out <- "/media/sf_AIDD/RFparamCODNodeNtree.tiff"
tiff(file_out, units="in", width=15, height=15, res=300)
colourCount <- length(unique(data$nodesize)) # number of levels
getPalette <- colorRampPalette(brewer.pal(15, "Set1"))
my_plot <- ggplot(data, aes(x=nodesize, y=Accuracy, color=ntree)) + geom_line() + theme_bw()+  scale_color_manual(values = colorRampPalette(brewer.pal(12,"Accent"))(colourCount)) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + geom_point(size=3)
my_plot
dev.off()


data <- read.csv("/media/sf_AIDD/RFparamCOD3.csv")
data$ntree = factor(data$ntree)
file_out <- "/media/sf_AIDD/RFparamCODmtryntree.tiff"
tiff(file_out, units="in", width=15, height=15, res=300)
colourCount <- length(unique(data$mtry)) # number of levels
getPalette <- colorRampPalette(brewer.pal(13, "Set1"))
my_plot <- ggplot(data, aes(x=mtry, y=Accuracy, color=as.factor(ntree))) + geom_line() + theme_bw()+  scale_color_manual(values = colorRampPalette(brewer.pal(12,"Accent"))(colourCount)) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + geom_point(size=3)
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/TreeparamMDD/RFparamPheno1.csv")
data$mtry = factor(data$mtry)
file_out <- "/media/sf_AIDD/RFparamPhenoNodeMtry.tiff"
tiff(file_out, units="in", width=15, height=15, res=300)
colourCount <- length(unique(data$mtry)) # number of levels
getPalette <- colorRampPalette(brewer.pal(13, "Set1"))
my_plot <- ggplot(data, aes(x=nodesize, y=Accuracy, color=mtry)) + geom_line() + theme_bw()+  scale_color_manual(values = colorRampPalette(brewer.pal(12,"Accent"))(colourCount)) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=14))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + geom_point(size=3)
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/TreeparamMDD/RFparamPheno2.csv")
data$ntree = factor(data$ntree)
file_out <- "/media/sf_AIDD/RFparamPhenoNodeNtree.tiff"
tiff(file_out, units="in", width=15, height=15, res=300)
colourCount <- length(unique(data$nodesize)) # number of levels
getPalette <- colorRampPalette(brewer.pal(15, "Set1"))
my_plot <- ggplot(data, aes(x=nodesize, y=Accuracy, color=ntree)) + geom_line() + theme_bw()+  scale_color_manual(values = colorRampPalette(brewer.pal(12,"Accent"))(colourCount)) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + geom_point(size=3)
my_plot
dev.off()


data <- read.csv("/media/sf_AIDD/TreeparamMDD/RFparamPheno3.csv")
data$ntree = factor(data$ntree)
file_out <- "/media/sf_AIDD/RFparamPhenomtryntree.tiff"
tiff(file_out, units="in", width=15, height=15, res=300)
colourCount <- length(unique(data$mtry)) # number of levels
getPalette <- colorRampPalette(brewer.pal(13, "Set1"))
my_plot <- ggplot(data, aes(x=mtry, y=Accuracy, color=as.factor(ntree))) + geom_line() + theme_bw()+  scale_color_manual(values = colorRampPalette(brewer.pal(12,"Accent"))(colourCount)) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + geom_point(size=3)
my_plot
dev.off()

data <- read.csv("/media/sf_AIDD/impactcounts.csv")
file_out <- "/media/sf_AIDD/impactcountsgather.csv"
data2 <- data %>%
gather(gene_name, count, -COD, -gender, -phenotype, -tissue)
write.csv(data2, file_out, row.names=FALSE)
data <- read.csv("/media/sf_AIDD/impactcountsgather.csv")
file_out <- "/media/sf_AIDD/impactcountsgather.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data %>%
filter (gene_name != "ADAR") %>%
group_by(gene_name,COD,gender,tissue) %>%
summarize(average = mean (count), sd=sd(count))
my_plot <- ggplot(data_plot, aes(x=gene_name, y=average, fill=COD)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender), vars(tissue)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9)) + scale_fill_manual(values=c('blue','red')) 
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=24)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=24))) + theme(strip.text.x = element_text(size = 24)) + theme(text = element_text(size=24)) + theme(axis.text.x = element_text(angle = 90))
my_plot2
dev.off()


data <- read.csv("/media/sf_AIDD/final/TreeParamMDD/MDDfreqall2_top15phenotype.csv")
file_out <- "/media/sf_AIDD/final/TreeParamMDD/MDDfreqall_top15gather.csv"
data2 <- data %>%
gather(gene_name, count, -COD, -gender, -phenotype, -tissue)
write.csv(data2, file_out, row.names=FALSE)
file_out <- "/media/sf_AIDD/final/TreeParamMDD/MDDfreqall_top15gatherphenotype.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
data_plot <- data2 %>%
group_by(gene_name,phenotype,gender,tissue) %>%
summarize(average = mean (count), sd=sd(count))
my_plot <- ggplot(data_plot, aes(x=gene_name, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(gender), vars(tissue)) + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9)) + scale_fill_manual(values=c('blue','yellow')) 
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=16)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=20))) + theme(strip.text.x = element_text(size = 16)) + theme(text = element_text(size=16)) + theme(axis.text.x = element_text(angle = 90))
my_plot2
dev.off()



file_out <- "/media/sf_AIDD/final/RFsampling.tiff"
tiff(file_out, units="in", width=15, height=10, res=300)
my_plot <- ggplot(data, aes(x=model, y=Accuracy, color=condition, group=condition)) + geom_line() + geom_errorbar(aes(ymin=CIlow, ymax=Cihigh), width=.2, position=position_dodge(.05)) + scale_color_manual(values=c('green','purple'))
my_plot2 <- my_plot + scale_color_manual(values=c('green','purple'))  + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=16)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=20))) + theme(strip.text.x = element_text(size = 16)) + theme(text = element_text(size=16)) + theme(axis.text.x = element_text(angle = 90))
my_plot2
dev.off()

