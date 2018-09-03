#!/usr/bin/env bash
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
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
## creates working directory
for i in raw_data Results quality_control working_directory references Rscripts gene_list transcript_list variant_list index bashScripts tmp temp ; do
    mkdir /media/sf_AIDD/$i/
done
## creates bashScripts directory and moves scripts
for i in align_assemble prep Rscripts variantcalling ; do
    mkdir /media/sf_AIDD/bashScripts/$i/
    cp /home/user/AIDD/bashScripts/$i/* /media/sf_AIDD/bashScripts/$i/
done
## this moves indexes
cp /home/user/AIDD/index/* /media/sf_AIDD/index/
cp /home/user/AIDD/Rscripts/* /media/sf_AIDD/Rscripts/
## makes gene_list directory and moves gene lists
for i in DESeq2 pathway; do
    mkdir /media/sf_AIDD/gene_list/$i/
    cp /home/user/AIDD/gene_list/$i/* /media/sf_AIDD/gene_list/$i/
done
## makes transcript_list directory and moves gene lists
for i in DESeq2 pathway ; do
    mkdir /media/sf_AIDD/transcript_list/$i/
    cp /home/user/AIDD/transcript_list/$i/* /media/sf_AIDD/transcript_list/$i/
done
## makes variantcalling index
for i in DESeq2 pathway ; do
    mkdir /media/sf_AIDD/variant_list/$i/
    cp /home/user/AIDD/variant_list/$i/* /media/sf_AIDD/variant_list/$i/
done
## moves experimental gene_list to directory
cp /home/user/Desktop/insert_gene_of_interest/* /media/sf_AIDD/gene_list/DESeq2/
## Rscript to create GOI.csv file with added genes of interest
##Rscript /media/sf_AIDD/Rscripts/createGOI.R
## moves experimental transcript_list to directory
cp /home/user/Desktop/insert_transcript_of_interest/* /media/sf_AIDD/transcript_list/DESeq2/
## Rscript to create TOI.csv file with added genes of interest
##Rscript /media/sf_AIDD/Rscripts/createTOI.R
##copies any gene lists for heatmaps and volcano plots
cp /home/user/Desktop/insert_gene_lists_for_pathways/* /media/sf_AIDD/gene_list/pathway/
##copies any transcript lists for heatmaps and volcano plots
cp /home/user/Desktop/insert_transcript_lists_for_pathways/* /media/sf_AIDD/transcript_list/pathway/
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
## haplotype and mutech2 directories
for i in haplotype mutech2 ; do 
    mkdir /media/sf_AIDD/Results/variant_calling/$i/
done
## haplotype and mutech2 directories
for i in tables volcano heatmaps ; do 
    mkdir /media/sf_AIDD/Results/pathway/$i/
done
## this creates subdirectories for DESeq2 and topGO and variant calling
for i in gene transcript ; do
    mkdir /media/sf_AIDD/Results/DESeq2/$i/
    mkdir /media/sf_AIDD/Results/topGO/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/mutech2/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/haplotype/$i/
done
## this creates subdirectories in DESeq2/gene and DESeq2/transcript
for i in counts differential_expression calibration PCA ; do
    mkdir /media/sf_AIDD/Results/DESeq2/gene/$i/
    mkdir /media/sf_AIDD/Results/DESeq2/transcript/$i/
done
## this creates subdirectories in variant_calling
for i in nucleotide amino_acid high_impact moderate_impact vcf_tables ; do
    mkdir /media/sf_AIDD/Results/variant_calling/mutech2/gene/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/mutech2/transcript/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/haplotype/transcript/$i/
done
## this creates subdirectories in variant_calling/.../high_impact
for i in topGO vennD excitome; do
    mkdir /media/sf_AIDD/Results/variant_calling/mutech2/gene/high_impact/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/mutech2/transcript/high_impact/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/mutech2/gene/moderate_impact/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/mutech2/transcript/moderate_impact/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/$i/
    mkdir /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/$i/
done
##add in here Rscript to rbind all the rows into one GOI.csv file
##Rscript 
##now have to make GOIbar files

##now have to make GOIbar files
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
##this creates subdirectories for ballgown analysis
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    mkdir /media/sf_AIDD/raw_data/ballgown_in/$sample/
done < $INPUT
IFS=$OLDIFS
