mydata <- read.csv("/media/sf_AIDD/DEI/Results/all_count_matrixEdit.csv")
wss <- (nrow(mydata[5:8])-1)*sum(apply(mydata[5:8],2,var))
for (i in 2:15) wss[i] <- sum(kmeans(mydata[5:8], centers=i)$withinss)
tiff("/media/sf_AIDD/DEI/Results/clustering.tiff", units="in", width=10, height=10, res=600)
plot(1:15, wss, type="b", xlab="Number of Clusters", ylab="Within groups sum of squares")
dev.off() 
fit <- kmeans(mydata[5:8], 3)
aggregate(mydata[5:8],by=list(fit$cluster),FUN=mean)
mydata <- data.frame(mydata, fit$cluster)
d <- dist(mydata[5:8], method = "euclidean")
fit <- hclust(d, method="ward.D")
tiff("/media/sf_AIDD/DEI/Results/clusteringH.tiff", units="in", width=30, height=10, res=600)
plot(fit)
dev.off()
groups <- cutree(fit, k=5)
rect.hclust(fit, k=5, border="red")
fit <- pvclust(mydata[5:8], method.hclust="ward.D", method.dist="euclidean")
tiff("/media/sf_AIDD/DEI/Results/clusteringHbootstrap.tiff", units="in", width=10, height=10, res=600)
plot(fit)
pvrect(fit, alpha=.95)
dev.off()


mydata <- read.csv("/media/sf_AIDD/DEI/Results/excitome_count_matrix.csv")
df_f <- mydata[,apply(mydata, 2, var, na.rm=TRUE) != 0]
mydata.pca <- prcomp(df_f[7:92])
summary(mydata.pca)
str(mydata.pca)
library(devtools)
library(ggbiplot)
ggbiplot(mydata.pca)

mydata.pca <- prcomp(mydata[,c(7:92)])

scores = as.data.frame(pca1$x)

ggplot(data = scores, aes(x = PC1, y = PC2, label = mydata[,c(1)])) +
  geom_hline(yintercept = 0, colour = "gray65") +
  geom_vline(xintercept = 0, colour = "gray65") +
  geom_text(colour = "tomato", alpha = 0.8, size = 4) +
  ggtitle("PCA plot of USA States - Crime Rates")

# function to create a circle
circle <- function(center = c(0, 0), npoints = 100) {
    r = 1
    tt = seq(0, 2 * pi, length = npoints)
    xx = center[1] + r * cos(tt)
    yy = center[1] + r * sin(tt)
    return(data.frame(x = xx, y = yy))
}
corcir = circle(c(0, 0), npoints = 100)

# create data frame with correlations between variables and PCs
correlations = as.data.frame(cor(mydata[,c(7:92)], mydata.pca$x))

# data frame with arrows coordinates
arrows = data.frame(x1 = c(0, 0, 0, 0), y1 = c(0, 0, 0, 0), x2 = correlations$PC1, 
    y2 = correlations$PC2)

# geom_path will do open circles
ggplot() + geom_path(data = corcir, aes(x = x, y = y), colour = "gray65") + 
    geom_segment(data = arrows, aes(x = x1, y = y1, xend = x2, yend = y2), colour = "gray65") + 
    geom_text(data = correlations, aes(x = PC1, y = PC2, label = rownames(correlations))) + 
    geom_hline(yintercept = 0, colour = "gray65") + geom_vline(xintercept = 0, 
    colour = "gray65") + xlim(-1.1, 1.1) + ylim(-1.1, 1.1) + labs(x = "pc1 aixs", 
    y = "pc2 axis") + ggtitle("Circle of correlations")

