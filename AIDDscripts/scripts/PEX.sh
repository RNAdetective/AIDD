#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
conditionname1=$(awk -F, 'NR==1{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname3=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
con_name1=$(awk -F, 'NR==1{print $3}' /media/sf_AIDD/PHENO_DATA.csv)
con_name2=$(awk -F, 'NR==3{print $5}' /media/sf_AIDD/PHENO_DATA.csv)
con_name3=$(awk -F, 'NR==3{print $6}' /media/sf_AIDD/PHENO_DATA.csv)
con_name4=$(awk -F, 'NR==3{print $7}' /media/sf_AIDD/PHENO_DATA.csv)
##This will then run the pathway analysis at both gene and transcript level.
for i in gene transcript ; do
sed -i 's/con1/'$conditionname1'/g' /media/sf_AIDD/ExToolset/Gpathway.R
sed -i 's/con2/'$conditionname2'/g' /media/sf_AIDD/ExToolset/Gpathway.R
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/ExToolset/Gpathway.R 
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/Gpathway.R
INPUT=/media/sf_AIDD/indexes/gene_list/pathway/pathway_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x file_name
do
    sed -i 's/file_name/'$file_name'/g' /media/sf_AIDD/ExToolset/Gpathway.R
    Rscript /media/sf_AIDD/ExToolset/Gpathway.R
    sed -i 's/'$file_name'/file_name/g' /media/sf_AIDD/ExToolset/Gpathway.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/Gpathway.R
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/ExToolset/Gpathway.R
sed -i 's/'$conditionname1'/con1/g' /media/sf_AIDD/ExToolset/Gpathway.R
sed -i 's/'$conditionname2'/con2/g' /media/sf_AIDD/ExToolset/Gpathway.R
done
##this will run gene of interest count graph
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
sed -i 's/set_color/color=cell/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
sed -i 's/set_shape//g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
sed -i 's/set_condition_columns/"'$conditionname1'" "'$conditionname2'"/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$i"ofinterest.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
    sed -i "s/file_name/"$gene_name"/g" /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
    Rscript /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
    sed -i "s/"$gene_name"/file_name/g" /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
done
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
sed -i 's/color=cell/set_color/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
sed -i 's/set_color /set_color, set_shape/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
sed -i 's/"'$conditionname1'" "'$conditionname2'"/set_condition_columns/g' /media/sf_AIDD/ExToolset/geneofinterestcountgraph.R
## this creates differential_expression cell line folder
for l in $conditionname1 $conditionname2 ; do
    mkdir /media/sf_AIDD/Results/DESeq2/gene/differential_expression/$l/
    mkdir /media/sf_AIDD/Results/DESeq2/gene/differential_expression/$l/
done
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/PEX.log
