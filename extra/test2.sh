R
library(ggplot2)
table1 <- read.csv("/media/sf_AIDD/Results/ADAR150RG.csv")
jpeg("/media/sf_AIDD/Results/ADAR150RG.jpeg")
ggplot(table1, aes(x=QR, y=B1_004)) + geom_point() + geom_smooth(method=lm) + labs(x="QR", y = "B1_004") + theme_classic()
dev.off()
cor.test( ~ B1_004 + QR, data=table1, method = "pearson", continuity = FALSE, conf.level = 0.95)

