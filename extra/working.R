library("tibble")
library("dplyr")
library("plotly")
library("ggplot2")
table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/geneofinterestfinalresults.csv", row.names=1)
table1[, c(1:7)] <- NULL
table2 <- t(table1)
pheno <- read.csv("/media/sf_AIDD/PHENO_DATA.csv", row.names=1)
pheno[, c(1,3)] <- NULL
table3 <- merge(pheno, table2, by="row.names")
head(table3)
table4 <- table3 %>% group_by(condition,cell) %>% summarise (ADARavg = mean(ADAR), ADARsd = sd(ADAR))
write.csv(table4, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/ADARmeansd.csv", row.names=FALSE)
jpeg("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/ADARmean.jpeg")
p <- ggplot(table4, aes(x=cell, y=ADARavg, fill=condition)) + 
   geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=ADARavg-ADARsd, ymax=ADARavg+ADARsd), width=.4,
                 position=position_dodge(.9))
  
p + scale_fill_brewer(palette="Reds") + theme_minimal()
p
dev.off()


write.csv(table4, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/ADARmeansd.csv", row.names=FALSE)
jpeg("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/ADARmean.jpeg")
p <- ggplot(table4, aes(x=cell, y=ADARavg, fill=condition)) + 
   geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=ADARavg-ADARsd, ymax=ADARavg+ADARsd), width=.4,
                 position=position_dodge(.9))
  
p + scale_fill_brewer(palette="Paired") + theme_minimal()
p
dev.off()



table3 %>% group_by(condition,cell) %>% summarise (x = mean(ADAR))


table3 <- as_data_frame(table1)
table4 <- mutate(table3, avg_ZIKV = (K048ZIKV1 + K048ZIKV2 + K048ZIKV3)/3, avg_Mock = (K048Mock1 + K048Mock2 + K048Mock3)/3)
table4[, c(1:6)] <- NULL
table5 <- mutate(table4, diff_ZIKV_Mock = (avg_ZIKV - avg_Mock))
head(table5)
write.csv(table5, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/geneofinterestcountsK048.csv")
p <- plot_ly(table6, x = ~X, y = ~diff_ZIKV_Mock, type = 'bar', name = 'IFN gene count differendes K048')

table1 <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/geneofinterestfinalresultsK048.csv", row.names=1)
table1[, c(1:7)] <- NULL
table2 <- t(table1)









table1[, -c(1:3)] <- NULL
table2 <- t(table1)
colMeans(table2[,1:39])
head(table2)
meansvec <- colMeans(table2[ , c(1:3)] ) 
write.csv(table2, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/geneofinterestMockcountsK048.csv")
ZIKV <- read.csv("/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/geneofinterestcountsK048.csv")
ZIKV[, -(4:6)] <- NULL
write.csv(table2, "/media/sf_AIDD/Results/DESeq2/gene/differential_expression/geneofinterestfinalresults/geneofinterestZIKVcountsK048.csv")


##this will move files into the right folder
for i in gene transcript ; do
mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$i"ofinterestfinalresults/
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$i"ofinterestfinalresults* /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$i"ofinterestfinalresults*/
mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/excitomefinalresults/
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/excitomefinalresults* /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/excitomefinalresults*/
done
##
