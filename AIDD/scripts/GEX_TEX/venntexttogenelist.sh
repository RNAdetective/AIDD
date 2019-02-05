#!/usr/bin/env bash
## this trades quote mark for a comma to begin transformation to csv file
INPUT=/media/sf_AIDD/listofconditions.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read condition
do
sed -i 's/"\+/,/g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
## this takes away extra commas for csv format
sed -i 's/,E/E/g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
## this gets rid of [#] counting the "$i" s
sed -i 's/\[//g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
sed -i 's/\]//g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
sed -i 's/[0-9]* //g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
## this puts them all in their own new line
sed -i 's/,/\n/g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
## this will get rid of extra spaces
sed -i 's/ //g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
## this gets rid of extra empty lines 
sed -i '/^\s*$/d' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_namevenn.txt
## this will change the $ sign infront to a < for the script to split the text file into multiple text files.
sed -i 's/\$/>/g' /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_namevenn.txt
## this transforms to csv format
sed -i 's/`//g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt
sed 's/:/_/g' /media/sf_AIDD/Results/DESeq2/"$i"/"$condition"/differential_expression/venndiagrams/file_namevenn.txt  > /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/file_namevenn.csv
## this will run the split fasta script to split into multiple csv files with "$i" lists.
sed -i 's/directory/file_namevenn/g' /media/sf_AIDD/ExToolset/splitfastachrom.sh
bash /media/sf_AIDD/ExToolset/splitfastachrom.sh
sed -i 's/file_namevenn/directory/g' /media/sf_AIDD/ExToolset/splitfastachrom.sh
done 
} < $INPUT
IFS=$OLDIFS
