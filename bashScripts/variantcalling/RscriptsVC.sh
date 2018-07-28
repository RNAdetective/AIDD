#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin


##this starts with snpEff HIGH and Moderate gene lists
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT ile not found"; exit 99; }
while read  x run condition sample t_name2
do
sed -i "s/"insert_run"/"$run"/g"
Rscript /media/sf_AIDD/Rscripts/VCsnpEffprep.R
sed -i "s/"$run"/"insert_run"/g"       
done < $INPUT
IFS=$OLDIFS
##now have all VCsnpEff tables made in Results/variant_calling/haplotype/gene/ and ~/transcript/ (still need to work on this to get right columns)
## first take all the samples from each condition_1 nad condition_2 and make a csv file for each total of 8 tables. (these will be used for topGO)

## I need at least one HIGH impact site in at least one sample divided by condition_1 and condition_2 and then the same for moderate (these are for venn diagrams) then take these 4 tables for the gene level and 4 for the transcript level into 2 for each one for HIGH with the conditions
##then for topGO need to create four more files one for HIGH that is those genes only present in condition_2 and not in condition_1 and then those present in condition_1 but not present in condition_2.  Then the same for the moderate.

##this will do topGO when have tables of High and Moderate in each condition and a differences
Rscript /media/sf_AIDD/Rscripts/VCsnpEfftopGO.R
sed -i "s/"/gene"/"/transcript"/g" /media/sf_AIDD/Rscripts/VCsnpEfftopGO.R
Rscript /media/sf_AIDD/Rscripts/VCsnpEfftopGO.R
sed -i "s/"/transcript"/"/gene"/g" /media/sf_AIDD/Rscripts/VCsnpEfftopGO.R

##this will create venn diagrams for HIGH and moderate impact gene lists and  need to have a table with condition_1 and condition_2 in columns for HIGH and moderate
Rscript /media/sf_AIDD/Rscripts/VCsnpEffvenn.R
sed -i "s/"/gene"/"/transcript"/g" /media/sf_AIDD/Rscripts/VCsnpEffvenn.R
Rscript /media/sf_AIDD/Rscripts/VCsnpEffvenn.R
sed -i "s/"/transcript"/"/gene"/g" /media/sf_AIDD/Rscripts/VCsnpEffvenn.R 

## is there anything else to do with Gene lists from these???? Make a table of each of the 8 tables (HIGHcondition_1 HIGHcondition_2 Moderatecondition_1 Moderatecondition_2 X2 one for gene and one for transcript) pull out genes or transcript of interest the excitome list and save in /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact, ~/moderate_impact, ~/transcript/high_impact, and ~/transcript/moderate_impact.  
Rscript /media/sf_AIDD/Rscripts/VCsnpEffexcitome.R
sed -i "s/"/gene"/"/transcript"/g" /media/sf_AIDD/Rscripts/VCsnpEffexcitome.R
Rscript /media/sf_AIDD/Rscripts/VCsnpEffexcitome.R
sed -i "s/"/transcript"/"/gene"/g" /media/sf_AIDD/Rscripts/VCsnpEffexcitome.R


##Now to get nt_sub tables
## make the tables for each run /media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide take number of each sub possible. columns = subs and rows = runs.
## run t-tests on these and make bar graphs similar to GOI and excitome tables

##now to get aa_sub tables 
## make the tables for each run /media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid take number of each sub possible or just the important ones R/G, I/V, Q/R, and so on.
## run t-tests on these and make bar graphs similar to GOI and excitome tables

##now how to take information from /media/sf_AIDD/raw_data/vcf_files/

## then need to take the 6 vcf tables and figure out what to do with those /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/ and ~/transcript/vcf_tables/
##first need to label sites with gene name and transcript name.  Then pull out the excitome lists with base counts and figure out contingency table.

}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/RscriptsVC.log
