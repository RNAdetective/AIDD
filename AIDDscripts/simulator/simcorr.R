library(ggplot2)
source /home/user/sim/simulator/config.R
jpeg(name.jpeg)
ggplot(data, aes(x=AIDD, y=sim)) + geom_point() + geom_smooth(method=lm) + labs(title="experimentlength", x="Simulator counts", y = "AIDD counts") + theme_classic()
dev.off()
corr_text <- cor.test( ~ AIDD + sim, data=data, method = "pearson", continuity = FALSE, conf.level = 0.95)
sink(namecorrelation.txt)
corr_text
sink()


