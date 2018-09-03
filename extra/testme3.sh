#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/condition.csv)
conditionname4=$(awk -F, 'NR==5{print $2}' /media/sf_AIDD/condition.csv)
conditionname5=$(awk -F, 'NR==6{print $2}' /media/sf_AIDD/condition.csv)
#this willcreate directories for snpEff mod and high impact folders
for i in gene transcript ; do
for j in high moderate ; do
for k in $conditionname1 $conditionname2 $conditionname3 $conditionname4 $conditionname5 ; do
  mkdir /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k"/
done 
done
done
#this will convert txt files to csv files to get ready to create high and mod impact files.
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
for i in gene transcript ; do
for j in high moderate ; do
  sed -i '1d' /media/sf_AIDD/raw_data/snpEff/"$run".genes.txt 
  sed 's/ \+/,/g' /media/sf_AIDD/raw_data/snpEff/"$run".genes.txt > /media/sf_AIDD/raw_data/snpEff/"$x"genes.csv
done
done
done < $INPUT
IFS=$OLDIFS
#this will create the high and mod files in gene level
