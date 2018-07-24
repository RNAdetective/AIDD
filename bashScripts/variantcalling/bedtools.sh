#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    bedtools genomecov -bga -ibam /media/sf_AIDD/working_directory/"$run"recal_reads.bam > /media/sf_AIDD/working_directory/"$run"genomecov.bedgraph
    mv /media/sf_AIDD/working_directory/snpEff_* /media/sf_AIDD/working_directory/"$run"

done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/bedtools.log
