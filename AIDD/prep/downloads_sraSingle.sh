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
    ##this will download sra files from NCBI
    prefetch "$run"
    ##moves sra files from local directory into working directory for processing
    mv /home/user/ncbi/public/sra/"$run".sra /media/sf_AIDD/working_directory/"$run".sra
    ##fastq-dump will uncompress the sra format into fastq format
    fastq-dump /media/sf_AIDD/working_directory/"$run".sra --read-filter pass -O /media/sf_AIDD/working_directory/
    ## this remove sra files when done with them
    rm /media/sf_AIDD/working_directory/"$run".sra
    ##renames file for processing with quality control
    mv /media/sf_AIDD/working_directory/"$run"_pass.fastq /media/sf_AIDD/working_directory/"$run".fastq
    ##fastqc generate a quality control report to see if fastq files need to be cleaned
    fastqc /media/sf_AIDD/working_directory/"$run".fastq --outdir=/media/sf_AIDD/quality_control/fastqc
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/downloads_sraSingle.log

