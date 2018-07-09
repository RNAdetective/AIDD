#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "Now downloading sra files this can take  few hours depending on size of files"
INPUT=/media/sf_AIDD/gene_list/pathway/pathway_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_list
    sed -i 's//22:26/g' /media/sf_AIDD/Rscripts/GLDE/GOF.R
    sed -i 's/VEGFGene/Zgenes/g' /media/sf_AIDD/Rscripts/GLDE/GOF.R
    Rscript /media/sf_AIDD/Rscripts/GLDE/GPOItables.R
do
    
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/downloads_sra.log
