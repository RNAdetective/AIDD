#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
cell_linename1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/cell_line.csv)
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
for i in gene transcript ; do
for j in high moderate ; do
for k in $conditionname1 $conditionname2 ; do
  mkdir /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k"/
done 
done
done
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

for i in gene transcript ; do
for j in moderate high ; do
for k in $cell_linename1 $cell_linename2 $cell_linename3 ; do
for l in $condition1 $condition2 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/snpEfftables.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/snpEfftables.R
sed -i 's/cell_line/'$k'/g' /media/sf_AIDD/Rscripts/snpEfftables.R
sed -i 's/infection/'$l'/g' /media/sf_AIDD/Rscripts/snpEfftables.R
Rscript /media/sf_AIDD/Rscripts/snpEfftables.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/snpEfftables.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/snpEfftables.R
sed -i 's/'$k'/cell_line/g' /media/sf_AIDD/Rscripts/snpEfftables.R
sed -i 's/'$l'/infection/g' /media/sf_AIDD/Rscripts/snpEfftables.R
done
done
done
done 

for i in gene transcript ; do
for j in moderate high ; do
for k in $cell_linename1 $cell_linename2 $cell_linename3 ; do
for l in $condition1 $condition2 ; do
awk -F "," '{ print $1 }' /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k""$l".csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k""$l"GeneList.csv
sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k""$l"GeneList.csv
sed "1i $h" /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k""$l"GeneList.csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k""$l"GeneListbycelltype.csv
done
done
done
done

for i in gene transcript ; do
for j in moderate high ; do
for k in $cell_linename1 $cell_linename2 $cell_linename3 ; do
paste -d , /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k"*GeneListbycelltype* > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/$k.csv
done
done
done

for i in gene transcript ; do
for j in moderate high ; do
for k in $cell_linename1 $cell_linename2 $cell_linename3 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/cell_line/'$k'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
Rscript /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$k'/cell_line/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
done
done
done 

for i in gene transcript ; do
for j in moderate high ; do
for k in $cell_linename1 $cell_linename2 $cell_linename3 ; do
for l in $condition1 $condition2 ; do
sed "1i $k" /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k""$l"GeneList.csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$k""$l"GeneListbycondition.csv
done
done
done
done

for i in gene transcript ; do
for j in moderate high ; do
for l in $condition1 $condition2 ; do
paste -d , /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/*"$l"GeneListbycondition* > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/$l.csv
done
done
done

for i in gene transcript ; do
for j in moderate high ; do
for l in $condition1 $condition2 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/infection/'$l'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
Rscript /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/'$l'/infection/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
done
done
done 

Rscript /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R



