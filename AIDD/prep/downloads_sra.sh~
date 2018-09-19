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
    prefetch "$run"
    mv /home/user/ncbi/public/sra/"$run".sra /media/sf_AIDD/working_directory/"$run".sra
    fastq-dump /media/sf_AIDD/working_directory/$run.sra -I --split-files --read-filter pass -O /media/sf_AIDD/working_directory/
    rm /media/sf_AIDD/working_directory/"$run".sra
    mv /media/sf_AIDD/working_directory/"$run"_pass_1.fastq /media/sf_AIDD/working_directory/"$run"_1.fastq
    mv /media/sf_AIDD/working_directory/"$run"_pass_2.fastq /media/sf_AIDD/working_directory/"$run"_2.fastq
    fastqc /media/sf_AIDD/working_directory/"$run"_1.fastq /media/sf_AIDD/working_directory/"$run"_2.fastq --outdir=/media/sf_AIDD/quality_control/fastqc
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/downloads_sra.log

