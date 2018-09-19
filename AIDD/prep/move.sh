#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "moving fastq files and performing quality control.  This can take several minutes.  If you wish to download files from ncbi instead of providing your own please restart pipeline with default setting of downloading sra files.  Also make sure your files are in fastq format and if paired end they need to be split into file_name_1.fastq and file_name_2.fastq.  Make sure the file_names also match the ones you entered into the PHENO_DATA file on the desktop."
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ## this will move local fastq files from the desktop folder into working directory for analysis.
    mv /home/user/Desktop/insert_fastq_files/"$run"_1.fastq /media/sf_AIDD/working_directory/
    mv /home/user/Desktop/insert_fastq_files/"$run"_2.fastq /media/sf_AIDD/working_directory/
    fastqc /media/sf_AIDD/working_directory/"$run"_1.fastq /media/sf_AIDD/working_directory/"$run"_2.fastq --outdir=/media/sf_AIDD/quality_control/fastqc
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/move.log

