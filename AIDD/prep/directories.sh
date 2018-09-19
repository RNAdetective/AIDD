#!/usr/bin/env bash
echo "Creating Directory system and moving indexes, references and scripts for analysis"
##copies PHENO_DATA file into directories for analysis
cp /home/user/Desktop/PHENO_DATA.csv /media/sf_AIDD/PHENO_DATA.csv
##this will create conditions file with counting samples by condition
main_function() {
cut -d',' -f3 /media/sf_AIDD/PHENO_DATA.csv | sort | uniq -ci
}
main_function 2>&1 | tee -a /media/sf_AIDD/condition.txt  
##this will create cell_line file counting how many samples are by cell line
main_function() {
cut -d',' -f5 /media/sf_AIDD/PHENO_DATA.csv | sort | uniq -ci 
}
main_function 2>&1 | tee -a /media/sf_AIDD/cell_line.txt
##this will create a file counting both how many cell lines and condition
main_function() {
cut -d',' -f3,5 /media/sf_AIDD/PHENO_DATA.csv | sort | uniq -ci 
}
main_function 2>&1 | tee -a /media/sf_AIDD/condition_cell_line.txt
## creates cvs files for text output
for i in condition cell_line condition_cell_line ; do
sed -i 's/ /,/g' /media/sf_AIDD/$i.txt
sed 's/,,,,,,//g' /media/sf_AIDD/$i.txt > /media/sf_AIDD/$i.csv
rm /media/sf_AIDD/$i.txt
done
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
## creates main directory in sf_AIDD folder
for i in raw_data Results quality_control working_directory references AIDD ExToolset indexes tmp temp ; do
    mkdir /media/sf_AIDD/$i/
done
##This will create subdirectories for script transfer of AIDD and tool sets
for i in align_assemble prep Rscripts variantcalling ; do
    mkdir /media/sf_AIDD/AIDD/$i/
    cp /home/user/AIDD/AIDD/$i/* /media/sf_AIDD/AIDD/$i/
done
##This will create subdirectories for prebuilt indexes
for i in gene_list index transcript_list variant_list ; do
    mkdir /media/sf_AIDD/indexes/$i/
    cp /home/user/AIDD/indexes/$i/* /media/sf_AIDD/indexes/$i/
done
## makes subdirectories under indexes directory and moves respective indexes to there correct folders
for i in DESeq2 pathway; do
for j in gene transcript variant
    mkdir /media/sf_AIDD/indexes/"$j"_list/$i/
    cp /home/user/AIDD/indexes/"$j"_list/$i/* /media/sf_AIDD/gene_list/$i/
done
done
## moves experimental gene/transcript list from the desktop to the correct index folder to be used for building own on the fly indexes for GEX and TEX tools
for i in gene transcript ; do
cp /home/user/Desktop/insert_"$i"_of_interest/* /media/sf_AIDD/indexes/"$i"_list/DESeq2/
cp /home/user/Desktop/insert_"$i"_lists_for_pathways/* /media/sf_AIDD/indexes/"$i"_list/pathway/
done
## raw_data directory
for i in counts ballgown ballgown_in bam_files snpEff vcf_files ; do
    mkdir /media/sf_AIDD/raw_data/$i/
done
##vcf_file directories
for i in NoCounts final filtered raw ; do
mkdir /media/sf_AIDD/raw_data/vcf_files/"$i"
done
##Nocount directories
for i in final filtered raw ; do
mkdir /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"
done
## quality_control directory
for i in alignment_metrics fastqc recalibration_plots insert_metrics logs; do
    mkdir /media/sf_AIDD/quality_control/$i/
done
## Results directory
for i in DESeq2 topGO pathway variant_calling ; do
    mkdir /media/sf_AIDD/Results/$i/
done
## Results/variant_calling subdirectories
for i in substitutions high_impact moderate_impact amino_acid nucleotide ; do 
    mkdir /media/sf_AIDD/Results/variant_calling/$i/
done
##this will add subdirectories for G_VEX
for i in amino_acid nucleotide ; do
    mkdir /media/sf_AIDD/Results/variant_calling/$i/largegraph/
done
    mkdir /media/sf_AIDD/Results/variant_calling/substitutions/raw/
## this creates subdirectories for PEX tool
for i in tables volcano heatmaps ; do 
    mkdir /media/sf_AIDD/Results/pathway/$i/
done
## this creates subdirectories for gene level and transcript level for DESeq2 and topGO and variant calling
for i in gene transcript ; do
    mkdir /media/sf_AIDD/Results/DESeq2/$i/
    mkdir /media/sf_AIDD/Results/topGO/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/$i/
done
## this creates subdirectories in DESeq2/gene and DESeq2/transcript
for i in counts differential_expression calibration PCA ; do
for j in gene transcript ; do
    mkdir /media/sf_AIDD/Results/DESeq2/$j/$i/
done
done
## this will create a directory for venndiagrams
    mkdir /media/sf_AIDD/Results/DESeq2/$j/differential_expression/venndiagrams/
## this creates subdirectories for GEX nad TEX
for j in gene transcript ; do
for i in excitome "$i"ofinterest ; do
    mkdir /media/sf_AIDD/Results/DESeq2/$j/differential_expression/$i
done
done
## this creates subdirectories in variant_calling
for i in high_impact moderate_impact ; do
for j in gene transcript ; do
    mkdir /media/sf_AIDD/Results/variant_calling/$j/$i/
done
done
done
##this will create directories for I-VEX
for i in gene transcript ; do
for j in high moderate ; do
for k in $conditionname1 $conditionname2 final ; do
  mkdir /media/sf_AIDD/Results/variant_calling/"$i"/"$j"_impact/"$k"/
done 
done
done
##this creates subdirectories for python script to convert to gene_count_matrix for DESeq2
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    mkdir /media/sf_AIDD/raw_data/ballgown/$sample/
done < $INPUT
IFS=$OLDIFS
rm -rf /media/sf_AIDD/raw_data/ballgown/sample/
##this creates subdirectories for ballgown analysis
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    mkdir /media/sf_AIDD/raw_data/ballgown_in/$sample/
done < $INPUT
rm -rf /media/sf_AIDD/raw_data/ballgown_in/sample/
IFS=$OLDIFS
