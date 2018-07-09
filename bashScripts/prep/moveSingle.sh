#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "moving fastq files and performing quality control. This can take several minutes."
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    prefetch "$run"
    mv /home/user/ncbi/public/sra/"$run".fastq media/sf_AIDD/working_directory/
    fastqc /media/sf_AIDD/working_directory/"$run".fastq --outdir=/media/sf_AIDD/quality_control/fastqc
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/moveSingle.log

