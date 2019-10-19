library("ggplot2")
library("RColorBrewer") 
library("plot3D") 
library("dplyr")
library("parallel")
library("randomForestSRC")
library("ggRandomForests")
theme_set(theme_bw())
event.marks <- c(1, 4)
event.labels <- c(FALSE, TRUE)
data1=read.csv("/media/sf_AIDD/MDD/Results/random_forestsomeCM.csv")

dta <- melt(data1, id.vars=c("region","GRIA2_1edited"))
ggplot(dta, aes(x=region, y=value, color=GRIA2_1edited)) + geom_point(alpha=.4) + geom_rug(data=dta %>% filter(is.na(value))) + scale_color_brewer(palette="Set2") + facet_wrap(~variable, scales="free_y", ncol=3)

rfsrc_regions <- rfsrc(sampname~.,data=data1,nodesize=6,na.action = "na.impute",importance=TRUE)
heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM1.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
plot(gg_rfsrc(rfsrc_regions), alpha=.33)
dev.off()

heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM2.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
plot(gg_vimp(rfsrc_regions))
dev.off()

varsel_regions <- var.select(rfsrc_regions)
data(varsel_regions)
gg_md <- gg_minimal_depth(varsel_regions)
heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM3.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
plot(gg_md)
dev.off()

heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM4.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
plot(gg_minimal_vimp(varsel_regions))
dev.off()

gg_v <- gg_variable(rfsrc_regions)
xvar <- gg_md$topvars
heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM5.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
plot(gg_v, xvar=xvar, panel=TRUE, se=.95, span=1.2, alpha=.4)
dev.off()

heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM6.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
plot(gg_v, xvar="GRIA2_1edited", points=FALSE, se=FALSE, notch=TRUE, alpha=.4)
dev.off()

heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM7.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
partial_regions <- plot.variable(rfsrc_regions,xvar=gg_md$topvars,partial=TRUE, sorted=FALSE,show.plots = FALSE)
dev.off()

interaction_regions <- find.interaction(rfsrc_regions)
interaction_regions
heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM8.tiff"
tiff(heatmap, units="in", width=10, height=10, res=600)
plot(gg_interaction(interaction_regions), xvar=gg_md$topvars, panel=TRUE)
dev.off()

heatmap <- "/media/sf_AIDD/MDD/Results/randomforestsomeCM.tiff"
tiff(heatmap, units="in", width=30, height=10, res=600)
model <- randomForest(region~.,data=data1,importance=TRUE,ntree=1000,mtry=6,do.trace=100)
reprtree:::plot.getTree(model)
dev.off()

