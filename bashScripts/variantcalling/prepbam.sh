#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    java -jar /home/user/AIDD/AIDD_tools/picard.jar AddOrReplaceReadGroups I=/media/sf_AIDD/raw_data/bam_files/"$run".bam O=/media/sf_AIDD/working_directory/"$run"_2.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
    java -jar /home/user/AIDD/AIDD_tools/picard.jar ReorderSam I=/media/sf_AIDD/working_directory/"$run"_2.bam O=/media/sf_AIDD/working_directory/"$run"_3.bam R=/media/sf_AIDD/references/ref2.fa CREATE_INDEX=TRUE
    java -jar /home/user/AIDD/AIDD_tools/picard.jar CollectAlignmentSummaryMetrics R=/media/sf_AIDD/references/ref2.fa I=/media/sf_AIDD/working_directory/"$run"_3.bam O=/media/sf_AIDD/working_directory/"$run"_alignment_metrics.txt
    cp /media/sf_AIDD/working_directory/"$run"_alignment_metrics.txt /media/sf_AIDD/quality_control/alignment_metrics/
    java -jar /home/user/AIDD/AIDD_tools/picard.jar CollectInsertSizeMetrics INPUT=/media/sf_AIDD/working_directory/"$run"_3.bam OUTPUT=/media/sf_AIDD/working_directory/"$run"_insert_metrics.txt HISTOGRAM_FILE=/media/sf_AIDD/working_directory/"$run"_insert_size_histogram.pdf
    cp /media/sf_AIDD/working_directory/"$run"_insert_metrics.txt /media/sf_AIDD/quality_control/insert_metrics/
    cp /media/sf_AIDD/working_directory/"$run"_insert_size_histogram.pdf /media/sf_AIDD/quality_control/insert_metrics/
    samtools depth /media/sf_AIDD/working_directory/"$run"_3.bam > /media/sf_AIDD/working_directory/"$run"depth_out.txt
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/prepbam.log