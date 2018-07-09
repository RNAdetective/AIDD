#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp -jar /home/user/AIDD/AIDD_tools/picard.jar MarkDuplicates INPUT=/media/sf_AIDD/working_directory/"$run"_3.bam OUTPUT=/media/sf_AIDD/working_directory/"$run"_dedup_reads.bam METRICS_FILE=/media/sf_AIDD/working_directory/"$run"metrics.txt
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/markduplicates.log
