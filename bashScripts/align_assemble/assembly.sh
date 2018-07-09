#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    java -Djava.io.tmpdir=/media/sf_AIDD/tmp -jar /home/user/AIDD/AIDD_tools/picard.jar SortSam INPUT=/media/sf_AIDD/working_directory/"$run".sam OUTPUT=/media/sf_AIDD/raw_data/bam_files/"$run".bam SORT_ORDER=coordinate
    stringtie /media/sf_AIDD/raw_data/bam_files/"$run".bam -p3 -G /media/sf_AIDD/references/ref.gtf -A /media/sf_AIDD/raw_data/counts/"$run".tab -l -B -b /media/sf_AIDD/raw_data/ballgown_in/"$sample"/"$run" -e -o /media/sf_AIDD/raw_data/ballgown/"$sample"/"$sample".gtf
    
   
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/assembly.log
