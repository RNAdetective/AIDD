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
cell_linename1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/cell_line.csv)
##this will make folders in the proper directory for following analysis
for i in gene transcript ; do
for j in high moderate ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
  mkdir /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$l"/
done 
done
done
##this converts snpEff protein effect output into a csv file labeled with the correct sample name
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
for i in gene transcript ; do
for j in high moderate ; do
  sed -i '1d' /media/sf_AIDD/raw_data/snpEff/snpEff"$run".genes.txt 
  sed 's/ \+/,/g' /media/sf_AIDD/raw_data/snpEff/snpEff"$run".genes.txt > /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv
done
done
done < $INPUT
IFS=$OLDIFS
## this will split tables into appropriate variables and moves then to the correct directory for futher analysis
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  awk '{print $2, $5}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run""$condition"high.txt
  sed -i "1i\gene_id $run" /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run""$condition"high.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run""$condition"high.txt > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run""$condition"high.csv
  awk '{print $2, $7}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run""$condition"moderate.txt
  sed -i "1i\gene_id $run" /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run""$condition"moderate.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run""$condition"moderate.txt > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run""$condition"moderate.csv
  awk '{print $3, $5}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run""$condition"high.txt
  sed -i "1i\transcript_id $run" /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run""$condition"high.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run""$condition"high.txt > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run""$condition"high.csv
  awk '{print $3, $7}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run""$condition"moderate.txt
  sed -i "1i\transcript_id $run" /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run""$condition"moderate.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run""$condition"moderate.txt > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run""$condition"moderate.csv
done < $INPUT
IFS=$OLDIFS
##this moves files into proper directory for merging all tables in each condition into one file
for i in gene transcript ; do
for j in high moderate ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
  mv /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/*$l* /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$l"/
done
done
done
##this will remove all unnecessary files before combining gene lists for venn diagrams.
for i in gene transcript ; do
for j in high moderate ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
rm /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$l"/*.txt
done
done
done
##this will remove duplicates and remove zeros from tables for easier merging.
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
for i in gene transcript ; do
for j in high moderate ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/removedupandzero.R
sed -i 's/cell_line/'$condition'/g' /media/sf_AIDD/Rscripts/removedupandzero.R
sed -i 's/sample/'$run'/g' /media/sf_AIDD/Rscripts/removedupandzero.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/removedupandzero.R
Rscript /media/sf_AIDD/Rscripts/removedupandzero.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/removedupandzero.R
sed -i 's/'$condition'/cell_line/g' /media/sf_AIDD/Rscripts/removedupandzero.R
sed -i 's/'$run'/sample/g' /media/sf_AIDD/Rscripts/removedupandzero.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/removedupandzero.R
done
done
done < $INPUT
##
for i in gene transcript ; do
for j in moderate high ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
Rscript /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
done
done
done
mkdir /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/final/
##now have to combine all conditions into one count table for each impact and each gene or transcript levels
for i in gene transcript ; do
for j in moderate high ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
rm /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/Runcondition*
mv /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$l"/"$l""$j"merged.csv /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/final/
done
done
done
##now combine individual cell lines to one big file
sed -i 's/cell_line/protein_effect/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
for i in gene transcript ; do
for j in moderate high ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
Rscript /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
done
done
sed -i 's/protein_effect/cell_line/g' /media/sf_AIDD/Rscripts/combineconditionssnpEff.R
##now combine individual cell lines to one big file
for i in gene transcript ; do
for j in moderate high ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/renamecolumns.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/renamecolumns.R
Rscript /media/sf_AIDD/Rscripts/renamecolumns.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/renamecolumns.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/renamecolumns.R
done
done
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
for i in gene transcript ; do
for j in moderate high ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
awk -F "," '{ print $1 }' /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$l"/"$run""$l""$j".csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$l"GeneList.csv
sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$l"GeneList.csv
sed '1i '$x'' /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$l"GeneList.csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$l"finalGene.csv
done
done
done
done < $INPUT
IFS=$OLDIFS
for i in gene transcript ; do
for j in moderate high ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
paste -d , /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/*"$l"finalGene.csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/$l.csv
done
done
done
for i in gene transcript ; do
for j in moderate high ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/cell_line/'$j'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/set_names/"'$conditionname1'","'$conditionname2'","'$conditionname3'","'$conditionname4'","'$conditionname5'"/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/set_alpha/0.5,0.5,0.5,0.5,0.5/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/set_colors/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
Rscript /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$j'/cell_line/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/"'$conditionname1'","'$conditionname2'","'$conditionname3'","'$conditionname4'","'$conditionname5'"/set_names/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/0.5,0.5,0.5,0.5,0.5/set_alpha/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/set_colors/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
done
done
done 

for i in gene transcript ; do
for j in moderate high ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
Rscript /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R
done
done
done 

for i in gene transcript ; do
for j in moderate high ; do
for l in "$conditionname1" "$conditionname2" "$conditionname3" "$conditionname4" "$conditionname5" ; do
for m in $cell_linename1 $cell_linename2 ; do
sed "1i $l" /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$l""$m"GeneList.csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$l""$m"GeneListbycondition.csv
done
done
done
done

for i in gene transcript ; do
for j in moderate high ; do
for m in $cell_linename1 $cell_linename2 ; do
paste -d , /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/*"$m"GeneListbycondition* > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/$m.csv
done
done
done

for i in gene transcript ; do
for j in moderate high ; do
for m in $cell_linename1 $cell_linename2 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/protein_effect/'$j'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/infection/'$m'/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
Rscript /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/'$j'/protein_effect/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
sed -i 's/'$m'/infection/g' /media/sf_AIDD/Rscripts/snpEffvenndiagrams2.R
done
done
done 

Rscript /media/sf_AIDD/Rscripts/snpEffvenndiagrams.R



