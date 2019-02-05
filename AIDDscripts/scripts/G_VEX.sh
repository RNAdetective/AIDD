#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
##this will move files from raw_data into working directory and prep them for splitting into individual tables for analysis.
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  sed '1d' /media/sf_AIDD/raw_data/snpEff/snpEff"$run".csv > /media/sf_AIDD/Results/variant_calling/substitutions/"$x".csv
  sed -i 's/# />/g' /media/sf_AIDD/Results/variant_calling/substitutions/"$x".csv
  sed -i 's/\//_/g' /media/sf_AIDD/Results/variant_calling/substitutions/"$x".csv
  sed -i  '/^\s*$/d' /media/sf_AIDD/Results/variant_calling/substitutions/"$x".csv 
  sed -i 's/Base/nucleotide/g' /media/sf_AIDD/Results/variant_calling/substitutions/"$x".csv
  sed -i 's/Amino/amino_acid/g' /media/sf_AIDD/Results/variant_calling/substitutions/"$x".csv
  sed -i 's/file_name/'$x'/g' /media/sf_AIDD/ExToolset/G_VEX/splitfastachromsubs.sh
  bash /media/sf_AIDD/ExToolset/G_VEX/splitfastachromsubs.sh
  sed -i 's/'$x'/file_name/g' /media/sf_AIDD/ExToolset/G_VEX/splitfastachromsubs.sh
done 
} < $INPUT
IFS=$OLDIFS
##this will turn matrixes into vector and add substitutions names to the tables.
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  for i in nucleotide amino_acid ; do
  sed -i 's/file_name/'$x'/g' /media/sf_AIDD/ExToolset/G_VEX/subtovector.R
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/subtovector.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/subtovector.R
  sed -i 's/'$x'/file_name/g' /media/sf_AIDD/ExToolset/G_VEX/subtovector.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/subtovector.R
  if [ "$i" == "nucleotide" ] ; then
  sed -i '1,5d' /media/sf_AIDD/Results/variant_calling/$i/$x.csv
  fi
  if [ "$i" == "amino_acid" ] ; then
  sed -i '1,23d' /media/sf_AIDD/Results/variant_calling/$i/$x.csv
  fi
  sed -i "1i\x, sub_names" /media/sf_AIDD/Results/variant_calling/$i/$x.csv
  sed -i 's/file_name/'$x'/g' /media/sf_AIDD/ExToolset/G_VEX/labelvector.R
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/labelvector.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/labelvector.R
  sed -i 's/'$x'/file_name/g' /media/sf_AIDD/ExToolset/G_VEX/labelvector.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/labelvector.R
done
done < $INPUT
IFS=$OLDIFS
##This merges all vectors together for raw substitution table
for i in nucleotide amino_acid ; do
  mkdir /media/sf_AIDD/Results/variant_calling/"$i"/merge
  mv /media/sf_AIDD/Results/variant_calling/"$i"/*.csv /media/sf_AIDD/Results/variant_calling/"$i"/merge/
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/multimergesubs.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/multimergesubs.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/multimergesubs.R
done
## /media/sf_AIDD/Results/variant_calling/sub_level/sub_levelfinal.csv
##this will normalize substitutions
for i in nucleotide amino_acid ; do
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/normalizedsubs.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/normalizedsubs.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/normalizedsubs.R
done
##this will create individual averages and bargraphs for each individual substitution
for i in nucleotide amino_acid ; do
IFS=$OLDIFS
INPUT=/media/sf_AIDD/indexes/index/"$i"imp.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  sub_names
do
    sed -i 's/file_name/'$sub_names'/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_x/x='$sub_names'avg/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_barcolors/"red", "blue"/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/set_group/condition/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
Rscript  /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/'$sub_names'/file_name/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/x=file_nameavg/set_x/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/"red", "blue"/set_barcolors/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
    sed -i 's/condition/set_group/g' /media/sf_AIDD/ExToolset/G_VEX/bargraphssubs.R
done < $INPUT
IFS=$OLDIFS
done
##adds names to averages tables for merging into one big figure
  for i in nucleotide amino_acid ; do
INPUT=/media/sf_AIDD/indexes/index/"$i"imp.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  sub_names
do
  sed -i 's/file_name/'$sub_names'/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  sed -i 's/'$sub_names'/file_name/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/relabelsubs.R
done < $INPUT
IFS=$OLDIFS
done
##combines averages and SD for all substitutions in one figure
for i in nucleotide amino_acid ; do
  sed -i 's/sub_level/'$i'/g' /media/sf_AIDD/ExToolset/G_VEX/rbindsubs.R
  Rscript /media/sf_AIDD/ExToolset/G_VEX/rbindsubs.R
  sed -i 's/'$i'/sub_level/g' /media/sf_AIDD/ExToolset/G_VEX/rbindsubs.R
done
##makes all in one figure
Rscript /media/sf_AIDD/ExToolset/G_VEX/subsbargraphs.R
