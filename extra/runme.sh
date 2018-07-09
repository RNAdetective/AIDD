#!/usr/bin/env bash
echo "moving fastq files and performing quality control.  This can take several minutes."
INPUT=/media/sf_AIDD/GOI.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_of_interest
do
    sed -i "s/ge_name/"$gene_of_interest"/g" /media/sf_AIDD/Rscripts/GLDE/GOIcountgraph.R
    Rscript /media/sf_AIDD/Rscripts/GLDE/GOIcountgraph.R
    sed -i "s/"$gene_of_interest"/ge_name/g" /media/sf_AIDD/Rscripts/GLDE/GOIcountgraph.R
done < $INPUT
IFS=$OLDIFS
