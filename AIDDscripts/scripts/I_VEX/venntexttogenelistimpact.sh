#!/usr/bin/env bash
## this trades quote mark for a comma to begin transformation to csv file
sed -i 's/"\+/,/g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
## this takes away extra commas for csv format
sed -i 's/,E/E/g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
## this gets rid of [#] counting the "$i" s
sed -i 's/\[//g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
sed -i 's/\]//g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
sed -i 's/[0-9]* //g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
## this puts them all in their own new line
sed -i 's/,/\n/g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
## this will get rid of extra spaces
sed -i 's/ //g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
## this gets rid of extra empty lines 
sed -i '/^\s*$/d' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
## this will change the $ sign infront to a < for the script to split the text file into multiple text files.
sed -i 's/\$/>/g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
## this transforms to csv format
sed -i 's/`//g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt
sed 's/:/_/g' /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.txt  > /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/file_namevenn.csv

