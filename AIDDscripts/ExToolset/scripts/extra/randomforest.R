#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)
file_in <- paste0(args[1]) #"$dirres"/RF_count_matrix.csv
image1 <- paste0(args[2]) 
image2 <- paste0(args[3]) 
image3 <- paste0(args[4]) 
image4 <- paste0(args[5]) 
image5 <- paste0(args[6]) 
image6 <- paste0(args[7]) 
image7 <- paste0(args[8]) 
image8 <- paste0(args[9]) 
image9 <- paste0(args[10])
file_out <- paste0(args[11])
image1 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD1.tiff"
image2 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD2.tiff"
image3 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD3.tiff"
image4 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD4.tiff"
image5 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD5.tiff"
image6 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD6.tiff"
image7 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD7.tiff"
image8 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD8.tiff"
image9 <- "/media/sf_AIDD/all_excitomefreq/MDDallfreqCOD9.tiff"
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("RColorBrewer")) 
suppressPackageStartupMessages(library("plot3D")) 
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("parallel"))
suppressPackageStartupMessages(library("randomForestSRC"))
suppressPackageStartupMessages(library("ggRandomForests"))
suppressPackageStartupMessages(library("GenomicAlignments"))
suppressPackageStartupMessages(library("randomForest"))
theme_set(theme_bw())
event.marks <- c(1, 4)
event.labels <- c(FALSE, TRUE)
data1=read.csv(file_in)
#dta <- melt(data1, id.vars=c("region","GRIA2_1edited"))
#ggplot(dta, aes(x=region, y=value, color=GRIA2_1edited)) + geom_point(alpha=.4) + geom_rug(data=dta %>% filter(is.na(value))) + scale_color_brewer(palette="Set2") + facet_wrap(~variable, scales="free_y", ncol=3)
rfsrc_regions <- rfsrc(type_1~.,data=data1,nodesize=6,na.action = "na.impute",importance=TRUE)
rfsrc_regions
#out <- capture.output(rfsrc_regions)
#write.csv(out, file_out, row.names=FALSE, quote=FALSE)
#cat("file_nameRF", out, file=file_out, sep="n", append=TRUE)

# Title
cat("type_1RF", file = file_out)
# add 2 newlines
cat("\n\n", file = file_out, append = TRUE)
# export anova test output
cat("Random Forest\n", file = file_out, append = TRUE)
capture.output(rfsrc_regions, file = file_out, append = TRUE)
# add 2 newlines
#cat("\n\n", file = file_out2, append = TRUE)
# export t-test output
#cat("Tukey-HSD\n", file = file_out2, append = TRUE)
#capture.output(res.Tukey, file = file_out2, append = TRUE)

regions.trial <- data %>% filter(!is.na(COD))
regions.test <- data %>% filter(is.na(COD))
gg_dta <- gg_survival(interval = "tissue", censor = "COD", data =regions.trial,conf.int = 0.95)
plot(gg_dta) + labs(x = "tissue", y = "COD", fill = "COD") + theme(legend.position = c(0.2, 0.2)) + coord_cartesian(y = c(0,1.01)) + scale_fill_manual(values=c('blue','red')) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=20)) + theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank())
rfsrc_regions <- rfsrc(COD~.,data=data,nodesize=6,na.action="na.impute",ntree=10000,importance=TRUE)
tiff("/media/sf_AIDD/all_excitomefreq/MDDfreqall2phenotype_3rferror.tiff", units="in", width=10, height=10, res=600)
plot(rfsrc_regions)
dev.off()

plot(gg_rfsrc(rfsrc_regions, by = "COD")) + theme(legend.position = c(0.2, 0.2)) + coord_cartesian(ylim = c(-0.01, 1.01))



plot(gg_dta, type = "cum_haz") + labs(y = "Cumulative Hazard", x = "Observation Time (years)",    color = "Treatment", fill = "Treatment") + theme(legend.position = c(0.2, 0.8)) +   coord_cartesian(ylim = c(-0.02, 1.22))


tiff(image1, units="in", width=10, height=10, res=600)
plot(gg_rfsrc(rfsrc_regions), alpha=.33)
dev.off()
tiff(image2, units="in", width=10, height=10, res=600)
plot(gg_vimp(rfsrc_regions)) + labs(fill = "VIMP > 0")
dev.off()
varsel_regions <- var.select(rfsrc_regions)
data(varsel_regions)
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
#tiff(image6, units="in", width=10, height=10, res=600)
#plot(gg_v, xvar="GRIA2_1edited", points=FALSE, se=FALSE, notch=TRUE, alpha=.4)
#dev.off()
tiff(image7, units="in", width=10, height=10, res=600)
partial_regions <- plot.variable(rfsrc_regions,xvar=gg_md$topvars,partial=TRUE, sorted=FALSE,show.plots = FALSE)
partial_regions
dev.off()
interaction_regions <- find.interaction(rfsrc_regions)
interaction_regions
tiff(image8, units="in", width=10, height=10, res=600)
plot(gg_interaction(interaction_regions), xvar=gg_md$topvars, panel=TRUE)
dev.off()
tiff(image9, units="in", width=30, height=10, res=600)
model <- randomForest(region~.,data=data1,importance=TRUE,ntree=1000,mtry=6,do.trace=100)
reprtree:::plot.getTree(model)
dev.off()

