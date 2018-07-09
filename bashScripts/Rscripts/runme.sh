##this will generate pathway heatmaps and tables of pathways counts
INPUT=/media/sf_AIDD/gene_list/pathway/pathway_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x file_genes
do
    sed -i "s/file_genes/"$file_genes"/g" /media/sf_AIDD/Rscripts/GLDE/Gpathway.R
    Rscript /media/sf_AIDD/Rscripts/GLDE/Gpathway.R
    sed -i "s/"$file_genes"/file_genes/g" /media/sf_AIDD/Rscripts/GLDE/Gpathway.R
done < $INPUT
IFS=$OLDIFS
