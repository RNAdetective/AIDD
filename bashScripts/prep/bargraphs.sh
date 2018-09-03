#!/usr/bin/env bash

for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_barcolors/palette="Greens"/g' /media/sf_AIDD/Rscripts/bargraphs.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$i"ofinterest.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
    sed -i "s/file_name/"$x"/g" /media/sf_AIDD/Rscripts/bargraphs.R
    Rscript /media/sf_AIDD/Rscripts/bargraphs.R
    sed -i "s/"$x"/file_name/g" /media/sf_AIDD/Rscripts/bargraphs.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/palette="Greens"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
done
