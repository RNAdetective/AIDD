#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "trimming fastq files and performing quality control.  Each sample can run for hours dep97ing on size."
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ##runs fastx trimmer on both paired end read sequence files with user defined start and end points
    fastx_trimmer -f start -l end -i /media/sf_AIDD/working_directory/"$run"_1.fastq -o /media/sf_AIDD/working_directory/"$run"_trim_1.fastq    
    fastx_trimmer -f start -l end -i /media/sf_AIDD/working_directory/"$run"_2.fastq -o /media/sf_AIDD/working_directory/"$run"_trim_2.fastq
    ##re-run fastqc to recheck quality of reads after trimming
    fastqc /media/sf_AIDD/working_directory/"$run"_trim_1.fastq /media/sf_AIDD/working_directory/"$run"_trim_2.fastq --outdir=/media/sf_AIDD/quality_control/fastqc
    ##this will remove old fastq files and replace then will newly renamed trimmed fastq files for the alignment step.
    rm /media/sf_AIDD/working_directory/"$run"_1.fastq
    rm /media/sf_AIDD/working_directory/"$run"_2.fastq
    mv /media/sf_AIDD/working_directory/"$run"_trim_1.fastq /media/sf_AIDD/working_directory/"$run"_1.fastq
    mv /media/sf_AIDD/working_directory/"$run"_trim_2.fastq /media/sf_AIDD/working_directory/"$run"_2.fastq

done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/trim.log
