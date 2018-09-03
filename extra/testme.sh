#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/condition.csv)
conditionname4=$(awk -F, 'NR==5{print $2}' /media/sf_AIDD/condition.csv)
conditionname5=$(awk -F, 'NR==6{print $2}' /media/sf_AIDD/condition.csv)
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  awk '{print $2, $5}' /media/sf_AIDD/raw_data/snpEff/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$x""$condition"high.txt
  sed -i "1i\gene_id $x" /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$x""$condition"high.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$x""$condition"high.txt > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$x""$condition"high.csv
  awk '{print $2, $7}' /media/sf_AIDD/raw_data/snpEff/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$x""$condition"moderate.txt
  sed -i "1i\gene_id $x" /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$x""$condition"moderate.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$x""$condition"moderate.txt > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$x""$condition"moderate.csv
  awk '{print $3, $5}' /media/sf_AIDD/raw_data/snpEff/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$x""$condition"high.txt
  sed -i "1i\transcript_id $x" /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$x""$condition"high.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$x""$condition"high.txt > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$x""$condition"high.csv
  awk '{print $3, $7}' /media/sf_AIDD/raw_data/snpEff/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$x""$condition"moderate.txt
  sed -i "1i\transcript_id $x" /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$x""$condition"moderate.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$x""$condition"moderate.txt > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$x""$condition"moderate.csv
done < $INPUT
IFS=$OLDIFS

INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
for i in gene transcript ; do
for j in high moderate ; do
  mv /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/*$condition* /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$condition"/
done
done
done < $INPUT
IFS=$OLDIFS
