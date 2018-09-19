#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ##this will set up filtering guidelines in bam files
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp -jar /home/user/AIDD/AIDD_tools/picard.jar AddOrReplaceReadGroups I=/media/sf_AIDD/raw_data/bam_files/"$run".bam O=/media/sf_AIDD/working_directory/"$run"_2.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
    ##this will reorder alignment files 
    java -jar /home/user/AIDD/AIDD_tools/picard.jar ReorderSam I=/media/sf_AIDD/working_directory/"$run"_2.bam O=/media/sf_AIDD/working_directory/"$run"_3.bam R=/media/sf_AIDD/references/ref2.fa CREATE_INDEX=TRUE
    ##this removes unused intermediate files
    rm /media/sf_AIDD/working_directory/"$run"_2.bam
    ##this collect alignment metrics and piut them in quality control for user to look at for accuracy
    java -jar /home/user/AIDD/AIDD_tools/picard.jar CollectAlignmentSummaryMetrics R=/media/sf_AIDD/references/ref2.fa I=/media/sf_AIDD/working_directory/"$run"_3.bam O=/media/sf_AIDD/working_directory/"$run"_alignment_metrics.txt
    cp /media/sf_AIDD/working_directory/"$run"_alignment_metrics.txt /media/sf_AIDD/quality_control/alignment_metrics/
    ##collect more metrics for quality summary
    java -jar /home/user/AIDD/AIDD_tools/picard.jar CollectInsertSizeMetrics INPUT=/media/sf_AIDD/working_directory/"$run"_3.bam OUTPUT=/media/sf_AIDD/working_directory/"$run"_insert_metrics.txt HISTOGRAM_FILE=/media/sf_AIDD/working_directory/"$run"_insert_size_histogram.pdf
    cp /media/sf_AIDD/working_directory/"$run"_insert_metrics.txt /media/sf_AIDD/quality_control/insert_metrics/
    cp /media/sf_AIDD/working_directory/"$run"_insert_size_histogram.pdf /media/sf_AIDD/quality_control/insert_metrics/
    ##creates depth file for quality control on variant calling.
    samtools depth /media/sf_AIDD/working_directory/"$run"_3.bam > /media/sf_AIDD/working_directory/"$run"depth_out.txt
    rm /media/sf_AIDD/working_directory/"$run"_alignment_metrics.txt
    rm /media/sf_AIDD/working_directory/"$run"_insert_metrics.txt
    rm /media/sf_AIDD/working_directory/"$run"_insert_size_histogram.pdf
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/prepbam.log
