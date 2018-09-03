#!/usr/bin/env bash
for i in "$i" transcript ; do
## this trades quote mark for a comma to begin transformation to csv file
sed -i 's/"\+/,/g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
## this takes away extra commas for csv format
sed -i 's/,E/E/g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
## this gets rid of [#] counting the "$i" s
sed -i 's/\[//g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
sed -i 's/\]//g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
sed -i 's/[0-9]* //g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
## this puts them all in their own new line
sed -i 's/,/\n/g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
## this will get rid of extra spaces
sed -i 's/ //g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
## this gets rid of extra empty lines 
sed -i '/^\s*$/d' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
## this will change the $ sign infront to a < for the script to split the text file into multiple text files.
sed -i 's/\$/>/g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
## this transforms to csv format
sed -i 's/`//g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt
sed 's/:/_/g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.txt  > /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name.csv
## this will run the split fasta script to split into multiple csv files with "$i" lists.
sed -i 's/directory/file_name/g' /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom.sh
sed -i 's/level/"$i"/g' /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom.sh
bash /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom.sh
sed -i 's/file_name/directory/g' /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom.sh
sed -i 's/"$i"/level/g' /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom.sh
##rm /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/*.txt
##mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name* /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_name/
done
