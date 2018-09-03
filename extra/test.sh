## this will split tables into appropriate variables and moves then to the correct directory for futher analysis
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
