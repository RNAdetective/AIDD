#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "Starting differential expression analysis with DESeq2"

## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
Rscript /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/gene/transcript/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/goi/toi/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/GOI/TOI/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/gene_list/transcript_list/g' /media/sf_AIDD/Rscripts/GLDE.R
Rscript /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/transcript/gene/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/toi/goi/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/TOI/GOI/g' /media/sf_AIDD/Rscripts/GLDE.R
##this will generate gene of interest line graphs showing counts grouped by condition
INPUT=/media/sf_AIDD/gene_list/DESeq2/GOI.csv
OLDIFS=$IF
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
##sed -i 's/gene/transcript/g' /media/sf_AIDD/Rscripts/GOIcountgraph.R
##sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/GOIcountgraph.R
##sed -i "s/GOI_name/TOI_name/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
##INPUT=/media/sf_AIDD/transcript_list/DESeq2/TOI.csv
##OLDIFS=$IFS
##IFS=,
##[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
##while read  TOI_name transcript_id
##do
##    sed -i "s/TOI_name/"$TOI_name"/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
##    Rscript /media/sf_AIDD/Rscripts/GOIcountgraph.R
##    sed -i "s/"$TOI_name"/TOI_name/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
##done < $INPUT
##IFS=$OLDIFS
sed -i 's/transcript/gene/g' /media/sf_AIDD/Rscripts/GOIcountgraph.R
sed -i "s/TOI_name/GOI_name/g" /media/sf_AIDD/Rscripts/GOIcountgraph.R
##this will generate pathway heatmaps and tables of pathways counts
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
INPUT=/media/sf_AIDD/transcript_list/pathway/pathwayT_list.csv
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
## still need to create the .csv files for the topGO analysis and the venn diagrams.  These need to be top100 DE, all down above FC=1 and all up reg same FC=2.  one set for gene and one set for transcript.
Rscript /media/sf_AIDD/Rscripts/createDEtables.R
##this will generate topGO analysis
Rscript /media/sf_AIDD/Rscripts/GtopGO.R
##this will generate topGO transcript level analysis
sed -i 's/gene/transcript/g' /media/sf_AIDD/Rscripts/GtopGO.R
Rscript /media/sf_AIDD/Rscripts/GtopGO.R
sed -i 's/transcript/gene/g' /media/sf_AIDD/Rscripts/GtopGO.R
## this will generate VennDiagrams of up and down regulated genes.
##Rscript /media/sf_AIDD/Rscripts/Gvenn.R
## this will generate VennDiagrams of up and down regulated genes.
##sed -i "s/"/gene"/"/transcript"/g" /media/sf_AIDD/Rscripts/Gvenn.R
##Rscript /media/sf_AIDD/Rscripts/Gvenn.R
##sed -i "s/"/transcript"/"/gene"/g" /media/sf_AIDD/Rscripts/Gvenn.R

## take the tables /media/sf_AIDD/Results/DESeq2/gene/differential_expression/goifinalresults.csv ~/excitomefinalresults.csv ~/transcript/differential_expression/toifinalresults.csv ~/excitomefinalresults.csv and run t-tests on then and create an average for each condition column and make a column for standard deviation for error bars.  
##Then make bar graphs for each group of interest from averages with error bars from standard deviations mark with astrix for sig.

##this will generate bargraph of gene of interst with counts and averages tables as well.

}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/Rscripts.log
