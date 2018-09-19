#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ##runs single end read alignment with HISAT2 creating an alignment summary file to quality check alignments before proceeding to assembly.  Also creates a count table that can be compared to assembly count table to confirm accuracy.
    hisat2 -q -x /media/sf_AIDD/references/genome -p3 --dta-cufflinks -U /media/sf_AIDD/working_directory/$run.fastq -t --summary-file /media/sf_AIDD/raw_data/counts/$run.txt -S /media/sf_AIDD/working_directory/$run.sam
    ##this will remove fastq files when done.
    rm /media/sf_AIDD/working_directory/$run.fastq
    

done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/HISAT2Single.log

