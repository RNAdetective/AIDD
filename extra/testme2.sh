#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/condition.csv)
conditionname4=$(awk -F, 'NR==5{print $2}' /media/sf_AIDD/condition.csv)
conditionname5=$(awk -F, 'NR==6{print $2}' /media/sf_AIDD/condition.csv)
condition1=$(awk -F, 'NR==3{print $1}' /media/sf_AIDD/condition.csv)
condition2=$(awk -F, 'NR==2{print $1}' /media/sf_AIDD/condition.csv)
condition3=$(awk -F, 'NR==4{print $1}' /media/sf_AIDD/condition.csv)
condition4=$(awk -F, 'NR==5{print $1}' /media/sf_AIDD/condition.csv)
condition5=$(awk -F, 'NR==6{print $1}' /media/sf_AIDD/condition.csv)
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$x"/Basechanges.csv
done < $INPUT
IFS=$OLDIFS
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample cell
do
    sed -i 's/cell_line/'$x'/g' /media/sf_AIDD/Rscripts/variantsubsallmerge.R
    Rscript /media/sf_AIDD/Rscripts/variantsubsallmerge.R
    sed -i "s/"$x"/cell_line/g" /media/sf_AIDD/Rscripts/variantsubsallmerge.R
done < $INPUT
IFS=$OLDIFS
for i in gene transcript ; do
mkdir /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/amino_acid/final/
mv /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/amino_acid/*final* /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/amino_acid/final/
done


