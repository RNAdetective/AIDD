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
fastx_trimmer -f start -l end -i /media/sf_AIDD/working_directory/"$run".fastq -o /media/sf_AIDD/working_directory/"$run"_trim.fastq
rm /media/sf_AIDD/working_directory/"$run".fastq
fastqc "$run"_trim.fastq --outdir=/media/sf_AIDD/quality_control/fastqc
mv /media/sf_AIDD/working_directory/"$run"_trim.fastq /media/sf_AIDD/working_directory/"$run".fastq
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/trim.log
