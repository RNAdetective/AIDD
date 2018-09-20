#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ##this runs alignment tool HISAT2 with paired end reads.  It creates a sam file containing alignment as well as count files that can be compared to strintie counts for ensured accuracy
    hisat2 -q -x /media/sf_AIDD/references/genome -p3 --dta-cufflinks -1 /media/sf_AIDD/working_directory/"$run"_1.fastq -2 /media/sf_AIDD/working_directory/"$run"_2.fastq -t --summary-file /media/sf_AIDD/quality_control/alignment_metrics/"$run".txt -S /media/sf_AIDD/working_directory/"$run".sam
    ##this will remove the fastq files when done
    rm /media/sf_AIDD/working_directory/"$run"_1.fastq
    rm /media/sf_AIDD/working_directory/"$run"_2.fastq
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/HISAT2.log