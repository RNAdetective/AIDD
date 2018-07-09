#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
## Rscripts run in order GLDE, GOF, POITables, heatmaps, GtopGO, Gvenn, TLDE, TOF, TPOITables, Theatmaps, TtopGO, Tvenn
## this is the command to run the gene level differential analysis in R using DESeq2 as the main package for analysis
sed -i "s/"design = ~ condition"/"design = ~ condition + cell + condition:cell"/g" /media/sf_AIDD/Rscripts/GLDE.R
Rscript /media/sf_AIDD/Rscripts/GLDE/GLDE.R
sed -i 's/gene/transcript/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/GLDE.R
Rscript /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/transcript/gene/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i "s/"design = ~ condition + cell + condition:cell"/"design = ~ condition"/g" /media/sf_AIDD/Rscripts/GLDE.R
##this will generate gene of interest line graphs showing counts grouped by condition
sed -i "s/"design = ~ condition"/"design = ~ condition + cell + condition:cell"/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R

INPUT=/media/sf_AIDD/gene_list/DESeq2G/GOI.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x GOI_name
do
    sed -i "s/GOI_name/"$GOI_name"/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
    Rscript /media/sf_AIDD/Rscripts/GOIcountgraph.R
    sed -i "s/"$GOI_name"/GOI_name/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
done < $INPUT
IFS=$OLDIFS
## this will change GOI to TOI to run with transcript of interest.
sed -i 's/gene/transcript/g' /media/sf_AIDD/Rscripts/GOIcountgraph.R
sed -i 's/ranscriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/GOIcountgraph.R
sed -i "s/GOI_name/TOI_name/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
INPUT=/media/sf_AIDD/gene_list/DESeq2T/TOI.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x TOI_name
do
    sed -i "s/TOI_name/"$TOI_name"/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
    Rscript /media/sf_AIDD/Rscripts/GOIcountgraph.R
    sed -i "s/"$TOI_name"/TOI_name/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/transcript/gene/g' /media/sf_AIDD/Rscripts/GOIcountgraph.R
sed -i "s/TOI_name/GOI_name/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
sed -i "s/"design = ~ condition + cell + condition:cell"/"design = ~ condition"/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
##this will generate pathway heatmaps and tables of pathways counts
sed -i "s/"design = ~ condition"/"design = ~ condition + cell + condition:cell"/g" /media/sf_AIDD/Rscripts/Gpathway.R
INPUT=/media/sf_AIDD/gene_list/pathway/pathway_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x file_name
do
    sed -i "s/file_genes/"$file_name"/g" /media/sf_AIDD/Rscripts/Gpathway.R
    Rscript /media/sf_AIDD/Rscripts/Gpathway.R
    sed -i "s/"$file_name"/file_genes/g" /media/sf_AIDD/Rscripts/Gpathway.R
done < $INPUT
IFS=$OLDIFS
##this will do transcript level pathway heatmaps and tables of pathway counts for transcript level pathways
sed -i 's/gene/transcript/g' /media/sf_AIDD/Rscripts/Gpathway.R
INPUT=/media/sf_AIDD/gene_list/pathwayT/pathwayT_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x file_name
do
    sed -i "s/file_genes/"$file_name"/g" /media/sf_AIDD/Rscripts/Gpathway.R
    Rscript /media/sf_AIDD/Rscripts/Gpathway.R
    sed -i "s/"$file_name"/file_genes/g" /media/sf_AIDD/Rscripts/Gpathway.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/transcript/gene/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i "s/"design = ~ condition + cell + condition:cell"/"design = ~ condition"/g" /media/sf_AIDD/Rscripts/Gpathway.R
##this will generate topGO analysis
Rscript /media/sf_AIDD/Rscripts/GtopGO.R
##this will generate topGO transcript level analysis
sed -i 's/gene/transcript/g' /media/sf_AIDD/Rscripts/GtopGO.R
Rscript /media/sf_AIDD/Rscripts/GtopGO.R
sed -i 's/transcript/gene/g' /media/sf_AIDD/Rscripts/GtopGO.R
## this will generate VennDiagrams of up and down regulated genes.
Rscript /media/sf_AIDD/Rscripts/Gvenn.R
## this will generate VennDiagrams of up and down regulated genes.
sed -i "s/"/gene"/"/transcript"/g" /media/sf_AIDD/Rscripts/Gvenn.R
Rscript /media/sf_AIDD/Rscripts/Gvenn.R
sed -i "s/"/transcript"/"/gene"/g" /media/sf_AIDD/Rscripts/Gvenn.R

}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/Rscripts.log
