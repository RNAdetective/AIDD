#!/usr/bin/env bash
main_function() {
for k in high moderate ; do
for j in transcript gene ; do
  for i in mock zika; do
  ## this copies all mock to /transcript/high_impact/Mock
  cp /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/*"$i""$k"Final.csv /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/"$i"/
  ## this takes all csv files in the previous folder to one big csv file
  awk 'FNR > 1' /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/"$i"/*.csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/"$i"/"$i""$k"Final.csv
  ## this will select only the unique genes
  sort /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/"$i"/"$i""$k"Final.csv | uniq -u > /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/"$i""$k"Unique.txt
  ##this will convert the text file to csv format 
  sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/"$i""$k"Unique.txt > /media/sf_AIDD/Results/variant_calling/haplotype/"$j"/"$k"_impact/"$i""$k"Unique.csv
done
done
done
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/snpEfftables2.log
