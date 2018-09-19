#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "Now downloading sra files this can take  few hours depending on size of files"
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ##this will download SRA files from NCBI
    prefetch "$run"
    ##this moves sra files from local directory to the sf_AIDD folder for further analysis
    mv /home/user/ncbi/public/sra/"$run".sra /media/sf_AIDD/working_directory/"$run".sra
    ## this will convert condensed sra format into workable fastq format and will split paired end reads into seperate files
    fastq-dump /media/sf_AIDD/working_directory/$run.sra -I --split-files --read-filter pass -O /media/sf_AIDD/working_directory/
    ##this removes sra file when done with it
    rm /media/sf_AIDD/working_directory/"$run".sra
    ##this will rename files for quality control step
    mv /media/sf_AIDD/working_directory/"$run"_pass_1.fastq /media/sf_AIDD/working_directory/"$run"_1.fastq
    mv /media/sf_AIDD/working_directory/"$run"_pass_2.fastq /media/sf_AIDD/working_directory/"$run"_2.fastq
    ##this used fastqc tool to generate a quality control report for quality of fastq files
    fastqc /media/sf_AIDD/working_directory/"$run"_1.fastq /media/sf_AIDD/working_directory/"$run"_2.fastq --outdir=/media/sf_AIDD/quality_control/fastqc
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/downloads_sra.log

