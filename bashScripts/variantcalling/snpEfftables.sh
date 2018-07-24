#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  sed 's/ \+/,/g' /media/sf_AIDD/raw_data/snpEff/snpEff"$run".genes.txt > /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv
  awk '{print $3, $5}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run"high.txt
  sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run"high.txt > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run"high.csv
  grep -v -e "^0$" /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run"high.csv > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run""$condition"highFinal.csv
  awk '{print $2, $5}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run"high.txt
  sort /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run"high.txt | uniq -u > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run"highUnique.txt
  sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run"highUnique.txt > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run"high.csv
  grep -v -e "^0$" /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run"high.csv > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run""$condition"highFinal.csv
  awk '{print $3, $7}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run"moderate.txt
  sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run"moderate.txt > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run"moderate.csv
  grep -v -e "^0$" /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run"moderate.csv > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run""$condition"moderateFinal.csv
  awk '{print $2, $7}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run"moderate.txt
  sort /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run"moderate.txt | uniq -u > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run"moderateUnique.txt
  sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run"moderateUnique.txt > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run"moderate.csv 
  grep -v -e "^0$" /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run"moderate.csv > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run""$condition"moderateFinal.csv
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/snpEfftables.log
