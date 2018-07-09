#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    java -jar /home/user/AIDD/AIDD_tools/picard.jar BuildBamIndex INPUT=/media/sf_AIDD/working_directory/"$run"_dedup_reads.bam
    java -jar /home/user/AIDD/AIDD_tools/gatk-4.0.2.0/gatk-package-4.0.2.0-local.jar -T RealignerTargetCreator -R /media/sf_AIDD/references/ref2.fa --filter_reads_with_N_cigar -I /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam -o /media/sf_AIDD/working_directory/"$run"realignment_targets.list
    java -jar /home/user/AIDD/AIDD_tools/gatk-4.0.2.0/gatk-package-4.0.2.0-local.jar -T IndelRealigner -R /media/sf_AIDD/references/ref2.fa --filter_reads_with_N_cigar -I /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam -targetIntervals /media/sf_AIDD/working_directory/$runrealignment_targets.list -o /media/sf_AIDD/working_directory/"$run"_realigned_reads.bam
    rm /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/realign.log
