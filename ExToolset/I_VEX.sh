#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
##move impact files to working directory and converting from txt to csv
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  sed '1,2d' /media/sf_AIDD/raw_data/snpEff/snpEff"$run".genes.txt > /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.txt
  sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.txt > /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.csv
  rm /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.txt
done < $INPUT
IFS=$OLDIFS
##seperate impact files to look at just moderate impact and high impact variants only as well as seperating by condition
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  awk '{print $2, $5}' /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high3.txt | column -t > /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high2.txt
   awk '!x[$1]++ { print $1}' /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high2.txt | column -t > /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high.txt 
   sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high.txt > /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high.csv
     sed -i "1i\ $condition" /media/sf_AIDD/Results/variant_calling/gene/high_impact/"$x""$condition"high.csv
      rm /media/sf_AIDD/Results/variant_calling/gene/high_impact/*.txt

  awk '{print $2, $7}' /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate3.txt| column -t > /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate2.txt
   awk '!x[$1]++ { print $1 }' /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate2.txt| column -t > /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.txt
   sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.txt > /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.csv
     sed -i "1i\ $condition" /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.csv 
      rm /media/sf_AIDD/Results/variant_calling/gene/moderate_impact/*.txt

  awk '{print $3, $5}' /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high3.txt > /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high2.txt
   awk '!x[$1]++ { print $1 }' /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high2.txt > /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high.txt
   sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high.txt > /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high.csv
     sed -i "1i\ $condition" /media/sf_AIDD/Results/variant_calling/transcript/high_impact/"$x""$condition"high.csv
      rm /media/sf_AIDD/Results/variant_calling/transcript/high_impact/*.txt

  awk '{print $3, $7}' /media/sf_AIDD/Results/variant_calling/impact/"$x"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate3.txt > /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate2.txt
   awk '!x[$1]++ { print $1 }' /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate2.txt > /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.txt
   sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.txt > /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.csv
     sed -i "1i\ $condition" /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.csv
      rm /media/sf_AIDD/Results/variant_calling/transcript/moderate_impact/*.txt
done < $INPUT
IFS=$OLDIFS
##divid files by condition to combine into gene list for venndiagrams.
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
for i in gene transcript ; do
for j in high moderate ; do
  mv /media/sf_AIDD/Results/variant_calling/"$i"/"$j"_impact/*$condition* /media/sf_AIDD/Results/variant_calling/"$i"/"$j"_impact/"$condition"/
done
done
done < $INPUT
IFS=$OLDIFS
## this will clean directories to get ready for analysis
for i in gene transcript ; do
for j in moderate high ; do
  rm /media/sf_AIDD/Results/variant_calling/$i/"$j"_impact/*condition*
done
done
## clean directories to get ready for analysis
for i in gene transcript ; do
for j in moderate high ; do
for l in $conditionname1 $conditionname2 ; do
  sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/condition/'$l'/g' /media/sf_AIDD/ExToolset/I_VEX/multimergeimpact.R 
  Rscript  /media/sf_AIDD/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/'$l'/condition/g' /media/sf_AIDD/ExToolset/I_VEX/multimergeimpact.R
done
done
done
## this will remove duplicates from final
for i in gene transcript ; do
for j in moderate high ; do
for l in $conditionname1 $conditionname2 ; do
   awk -F"," '!x[$1]++ { print $1 }' /media/sf_AIDD/Results/variant_calling/"$i"/"$j"_impact/final/"$l""$i""$j"final2.csv | column -t > /media/sf_AIDD/Results/variant_calling/"$i"/"$j"_impact/final/"$l""$i""$j"final.csv
   rm /media/sf_AIDD/Results/variant_calling/"$i"/"$j"_impact/final/"$l""$i""$j"final2.csv
done
done
done
##this combines gene lists
for i in gene transcript ; do
for j in moderate high ; do
paste -d , /media/sf_AIDD/Results/variant_calling/$i/"$j"_impact/final/* > /media/sf_AIDD/Results/variant_calling/"$i"/"$j"_impact/final/"$i""$j"final.csv
done
done
##to create venndiagrams
sed -i 's/DESeq2\/level\/differential_expression\/venndiagrams\/file_name/variant_calling\/level\/protein_effect_impact\/final\/levelprotein_effectfinal/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
for i in gene transcript ; do
for j in moderate high ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/set_column_name/"'$conditionname1'","'$conditionname2'"/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R 
sed -i 's/set_colors/"red","blue"/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/set_alpha/0.5,0.5/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
Rscript /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/"'$conditionname1'","'$conditionname2'"/set_column_name/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/"red","blue"/set_colors/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/0.5,0.5/set_alpha/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
done
done
sed -i 's/variant_calling\/level\/protein_effect_impact\/final\/levelprotein_effectfinal/DESeq2\/level\/differential_expression\/venndiagrams\/file_name/g' /media/sf_AIDD/ExToolset/I_VEX/Gvenn.R
##to create unique gene lists
sed -i 's/file_name/levelprotein_effectfinal/g' /media/sf_AIDD/ExToolset/I_VEX/venntexttogenelistimpact.sh
for i in gene transcript ; do
for j in moderate high ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/I_VEX/venntexttogenelistimpact.sh
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/ExToolset/I_VEX/venntexttogenelistimpact.sh
bash /media/sf_AIDD/ExToolset/I_VEX/venntexttogenelistimpact.sh
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/I_VEX/venntexttogenelistimpact.sh
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/ExToolset/I_VEX/venntexttogenelistimpact.sh
done
done
sed -i 's/levelprotein_effectfinal/file_name/g' /media/sf_AIDD/ExToolset/I_VEX/venntexttogenelistimpact.sh

