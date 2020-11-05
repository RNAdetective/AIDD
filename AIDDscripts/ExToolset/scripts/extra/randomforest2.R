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
library("caret")
library("caTools")
library(randomForest)
library(mlbench)
library(caret)
library(randomForest)
library(mlbench)
library(caret)
##1
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2.csv")
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
tunegrid <- expand.grid(.nodesize=c(1:15),.mtry=c(5,10,20,30,40,50,60,70,80,90,100))
set.seed(seed)
custom <- train(COD~., data=data, method=customRF, metric=metric, tuneGrid=tunegrid, trControl=control,na.action=na.roughfix)
summary(custom)
custom
file_name <- "/media/sf_AIDD/rfparamNodeMtry.tiff"
tiff(file_name, units="in", width=10, height=10, res=600)
plot(custom)
dev.off()
##3
data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2.csv")
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
tunegrid <- expand.grid(.ntree=c(50,100,300,500,1000,1500,3000,5000,10000),.mtry=c(5,10,20,30,40,50,60,70,80))
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
  model <- randomForest(COD ~ ., data = data[folds != x,],na.action=na.roughfix,forest=TRUE,ntree=100,importance=TRUE,prOximity=TRUE,nodesize=15,mtry=120)
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
model$err.rate[100,1] 

split= sample.split(data$COD, SplitRatio = 0.8)
training_set = subset(data, split == TRUE)
test_set = subset(data, split == FALSE)
rfsrc_regions <- rfsrc(COD~.,data=training_set,na.action="na.impute",ntree=3000,importance=TRUE,mtry=140,nodesize=5)
predict_regions <- predict(rfsrc_regions, test_set)
rfsrc_regions
predict_regions
image1 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLRFAtoG1mry60node12.tiff"
image2 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG2mry60node12.tiff"
image3 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG3mry60node12.tiff"
image4 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG4mry60node12.tiff"
image5 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG5mry60node12.tiff"
image6 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG6mry60node12.tiff"
image7 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG7mry60node12.tiff"
image8 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG8mry60node12.tiff"
image9 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG9mry60node12.tiff"
image10 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG10mry60node12.tiff"
image11 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG11mry60node12.tiff"
image12 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG12mry60node12.tiff"
image13 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG13mry60node12.tiff"

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
  model <- randomForest(phenotype ~ ., data = data[folds != x,],na.action=na.roughfix,forest=TRUE,ntree=3000,importance=TRUE,prOximity=TRUE,nodesize=9,mtry=60)
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
rfsrc_regions <- rfsrc(phenotype~.,data=training_set,na.action="na.impute",ntree=5000,importance=TRUE,mtry=70,nodesize=2)
predict_regions <- predict(rfsrc_regions, test_set)
rfsrc_regions
predict_regions
image1 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLRFAtoG1mry60node12pheno.tiff"
image2 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG2mry60node12pheno.tiff"
image3 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG3mry60node12pheno.tiff"
image4 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG4mry60node12pheno.tiff"
image5 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG5mry60node12pheno.tiff"
image6 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG6mry60node12pheno.tiff"
image7 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG7mry60node12pheno.tiff"
image8 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG8mry60node12pheno.tiff"
image9 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG9mry60node12pheno.tiff"
image10 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFAtoG10mry60node12pheno.tiff"
image11 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG11mry60node12pheno.tiff"
image12 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG12mry60node12pheno.tiff"
image13 <- "/media/sf_AIDD/all_guttman/guttmanscoresMLERFMLEAtoG13mry60node12pheno.tiff"

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


## See available palettes
display.brewer.all()

## You need to expand palette size
colourCount <- length(unique(data$)) # number of levels
getPalette <- colorRampPalette(brewer.pal(13, "Set1"))

## Now you can draw your 15 different factors
g <- ggplot(data) 
g <- g +  geom_ba(aes(factor(hp), fill=factor(hp))) 
g <- g +  scale_color_manual(values = colorRampPalette(brewer.pal(12, 
                                                                 "Accent"))(colourCount)) 
g <- g + theme(legend.position="top")
g <- g + xlab("X axis name") + ylab("Frequency (%)")
g




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




data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2_1.csv")
data2 <- data %>%
gather (gene_name, freq, -COD, -gender, -phenotype, -tissue)
write.csv(data2, "/media/sf_AIDD/all_excitomefreq/MDDfreqall2_1gather.csv", row.names=FALSE)


data <- read.csv("/media/sf_AIDD/all_excitomefreq/MDDfreqall2_1gather.csv")
file_out <- "/media/sf_AIDD/all_excitomefreq/MDDfreqall2_1gatherPheno.tiff"
tiff(file_out, units="in", width=10, height=15, res=300)
data_plot <- data %>%
group_by(phenotype,gender,tissue,gene_name) %>%
summarize(average = mean (freq), sd=sd(freq))
my_plot <- ggplot(data_plot, aes(x=gene_name, y=average, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(tissue), vars(gender)) + scale_fill_manual(values=c('blue','yellow'))  + geom_errorbar(aes(ymin=average, ymax=average+sd), width=.2, position=position_dodge(.9))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=28)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=12))) + theme(strip.text.x = element_text(size = 28)) + theme(text = element_text(size=16)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
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

data <- read.csv("/media/sf_AIDD/all_read_depth.csv")
file_out <- "/media/sf_AIDD/all_read_depthallphenotype.tiff"
tiff(file_out, units="in", width=20, height=10, res=300)
data_plot <- data %>%
filter (COD != "Accident")
my_plot <- ggplot(data_plot, aes(x=sample, y=freq, fill=phenotype)) + geom_bar(colour="black", stat="identity", position=position_dodge()) + facet_grid(vars(COD), vars(tissue)) + scale_fill_manual(values=c('blue','yellow'))
my_plot2 <- my_plot + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) + theme(legend.text=element_text(size=20)) + theme(legend.position="bottom") + guides(colour = guide_legend(override.aes = list(size=20))) + theme(strip.text.x = element_text(size = 20)) + theme(text = element_text(size=16)) + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
my_plot2
dev.off()




