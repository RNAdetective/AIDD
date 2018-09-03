## run the flux simulator
export PATH=$PATH:/home/user/AIDD/AIDD_tools/flux-simulator-1.2.1/bin
flux-simulator -p /media/sf_sim/300M75length.par
##split the fastq reads into two files one with _1 and the other with _2
python /media/sf_sim/extra/splitfq.py /media/sf_sim/300M75length.fastq
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
##quality check the reads
fastqc /media/sf_sim/300M75length_1.fastq /media/sf_sim/300M75length_2.fastq --outdir /media/sf_sim/
##align with hisat2
hisat2 -q -x /media/sf_sim/references/genome -p3 --dta-cufflinks -1 /media/sf_sim/300M75length_1.fastq -2 /media/sf_sim/300M75length_2.fastq -t --summary-file /media/sf_sim/300M75length.txt -S /media/sf_sim/300M75length.sam
##sam to bam
java -Djava.io.tmpdir=/media/sf_AIDD/tmp -jar /home/user/AIDD/AIDD_tools/picard.jar SortSam INPUT=/media/sf_sim/300M75length.sam OUTPUT=/media/sf_sim/300M75length.bam SORT_ORDER=coordinate
##assemble transcriptome
stringtie /media/sf_sim/300M75length.bam -p3 -G /media/sf_sim/references/ref.gtf -A /media/sf_sim/300M75length.tab -l -B -b /media/sf_sim/ -e -o /media/sf_sim/300M75length.gtf
##prepare tables for R analysis
##pro file add header
sed -i '1i x gene_id x x x x x x x x x TPM' /media/sf_sim/300M75length.pro
## convert pro file to csv
sed 's/\t/,/g' /media/sf_sim/300M75length.pro > /media/sf_sim/300M75length.csv
##select only colomn 2 and column9 from the final file
awk -F "," '{ print $2, $12 }' /media/sf_sim/300M75length.csv > /media/sf_sim/300M75length_2.csv
## add headers
sed -i '1i gene_id x x x x x x x TPM' /media/sf_sim/300M75length.tab
## convert tab to csv
sed 's/\t/,/g' /media/sf_sim/300M75length.tab > /media/sf_sim/300M75lengthHISAT.csv
## pick columns of AIDD table
awk -F "," '{ print $1, $9 }' /media/sf_sim/300M75lengthHISAT.csv > /media/sf_sim/300M75lengthAIDD.csv
## remove column names
sed -i '1d' /media/sf_sim/300M75lengthAIDD.csv

R
library(ggplot2)
table1 <- read.csv("/media/sf_sim/300M75length_2.csv")
table2 <- read.csv("/media/sf_sim/refseq.csv")
table3 <- merge(table1, table2, by="refseq")
write.csv(table3, "/media/sf_sim/300M75lengthsimulated.csv", row.names=FALSE)
table1 <- read.csv("/media/sf_sim/300M75lengthsimulated.csv")
table2 <- read.csv("/media/sf_sim/300M75lengthAIDD.csv")
table3 <- merge(table1, table2, by="gene_id")
write.csv(table3, "/media/sf_sim/300M75lengthscatter.csv", row.names=FALSE)
jpeg("/media/sf_sim/300M75length.jpeg")
ggplot(table3, aes(x=TPM, y=counts)) + geom_point() + geom_smooth(method=lm) + labs(title="300M75length", x="AIDD", y = "counts") + theme_classic()
dev.off()
cor.test( ~ TPM + counts, data=table3, method = "pearson", continuity = FALSE, conf.level = 0.95)

##run at transcript level download all parameters_2.csv and tab files from alignment.
library(ggplot2)
table1 <- read.csv("/media/sf_sim/300M75length_2.csv")
table2 <- read.csv("/media/sf_sim/refseq.csv")
table3 <- merge(table1, table2, by="refseqtrans")
write.csv(table3, "/media/sf_sim/300M75lengthsimulatedtrans.csv", row.names=FALSE)
table1 <- read.csv("/media/sf_sim/300M75lengthsimulatedtrans.csv")
table2 <- read.csv("/media/sf_sim/300M75lengthAIDDtrans.csv")
table3 <- merge(table1, table2, by="transcript_id")
write.csv(table3, "/media/sf_sim/300M75lengthscattertrans.csv", row.names=FALSE)
jpeg("/media/sf_sim/300M75lengthtrans.jpeg")
ggplot(table3, aes(x=TPM, y=counts, shape=condition, color=cell)) + geom_point() + geom_smooth(method=lm) + labs(title="300M75length", x="AIDD", y = "counts") + theme_classic()
dev.off()
cor.test( ~ TPM + counts, data=table3, method = "pearson", continuity = FALSE, conf.level = 0.95)

