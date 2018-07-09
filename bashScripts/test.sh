#!/usr/bin/env bash
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_tutorial/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    prefetch $run
done < $INPUT
IFS=$OLDIFS
