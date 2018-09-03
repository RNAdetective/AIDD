#!/usr/bin/env bash
##this will create conditions file with counting samples by condition
main_function() {
cut -d',' -f3 /media/sf_AIDD/PHENO_DATA.csv | sort | uniq -ci
}
main_function 2>&1 | tee -a /media/sf_AIDD/condition.txt  
## creates cvs files for text output
for i in condition ; do
sed -i 's/ /,/g' /media/sf_AIDD/$i.txt
sed 's/,,,,,,//g' /media/sf_AIDD/$i.txt > /media/sf_AIDD/$i.csv
rm /media/sf_AIDD/$i.txt
done
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
conditionname3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/condition.csv)
conditionname4=$(awk -F, 'NR==5{print $2}' /media/sf_AIDD/condition.csv)
conditionname5=$(awk -F, 'NR==6{print $2}' /media/sf_AIDD/condition.csv)
condition1=$(awk -F, 'NR==2{print $1}' /media/sf_AIDD/condition.csv)
condition2=$(awk -F, 'NR==3{print $1}' /media/sf_AIDD/condition.csv)
condition3=$(awk -F, 'NR==4{print $1}' /media/sf_AIDD/condition.csv)
condition4=$(awk -F, 'NR==5{print $1}' /media/sf_AIDD/condition.csv)
condition5=$(awk -F, 'NR==6{print $1}' /media/sf_AIDD/condition.csv)
samp=`expr $condition1 + $condition2 + $condition3 + $condition4 + $condition5`
echo "Starting differential expression analysis with DESeq2"
sed -i 's/1:'$samp'/set_samp_num/g' /media/sf_AIDD/Rscripts/matrixedit.R
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
for i in gene transcript ; do
if [ "$i" == "transcript" ]; then
sed -i 's/set_column_order/1,3,2/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
if [ "$i" == "gene" ]; then
sed -i 's/set_column_order/1,2/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/matrixedit.R
Rscript /media/sf_AIDD/Rscripts/matrixedit.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/GLDE.R
if [ "$i" == "transcript" ]; then
sed -i 's/1,3,2/set_column_order/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
if [ "$i" == "gene" ]; then
sed -i 's/1,2/set_column_order/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
done
sed -i 's/set_samp_num/1:'$samp'/g' /media/sf_AIDD/Rscripts/matrixedit.R
echo "Starting differential expression analysis with DESeq2"
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/Rscripts/GLDE.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/GLDE.R
Rscript /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/GLDE.R
done
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/Rscripts/GLDE.R
##This will create lists for venn diagrams for all up regulated and down regulated genes and top100 up and down regulated genes found in differential expression analysis
for i in gene transcript ; do
for j in upreg downreg ; do
for l in $conditionname1 $conditionname2 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/Gvennlists.R
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/Rscripts/Gvennlists.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/Gvennlists.R
Rscript /media/sf_AIDD/Rscripts/Gvennlists.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/Gvennlists.R
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/Rscripts/Gvennlists.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/Gvennlists.R
done
done
done
## this is the output file regulationregtop100cell_line.csv
##input needed regulationregclasscell_line.csv
##this adds id instead of gene name to gene and transcript level, up and down regulated g/t and all in the list and also only the top 100 for each cell line.
##input needed regulationregclasscell_line.csv
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $conditionname1 $conditionname2 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
sed -i 's/class/'$k'/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
Rscript /media/sf_AIDD/Rscripts/changeidGvenn.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
sed -i 's/'$k'/class/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/changeidGvenn.R
done
done
done
done
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $conditionname1 $conditionname2 ; do
paste -d , /media/sf_AIDD/Results/DESeq2/gene/differential_expression/"$j"idGlist"$k""$l".csv /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/"$j"idGlist"$k""$l".csv > /media/sf_AIDD/Results/DESeq2/gene/differential_expression/"$j"idGlist"$k""$l"added.csv
done
done
done
##
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
sed -i 's/set_alpha/0.5,0.5/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/set_colors/"purple","blue"/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/set_column_name/"regulationcell_lineclassgene","regulationcell_lineclasstranscript"/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/file_name/regulationidGlistclasscell_lineadded/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/level/gene/g' /media/sf_AIDD/Rscripts/Gvenn.R
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $conditionname1 $conditionname2 ; do
sed -i 's/class/'$k'/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/Gvenn.R
Rscript /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/'$k'/class/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/Gvenn.R
done
done
done
sed -i 's/gene/level/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/0.5,0.5/set_alpha/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/"purple","blue"/set_colors/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/"regulationcell_lineclassgene","regulationcell_lineclasstranscript"/set_column_name/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/regulationidGlistclasscell_lineadded/file_name/g' /media/sf_AIDD/Rscripts/Gvenn.R
## this will create venn diagrams for each cell line comparing up reg gene to up reg transcripts and down reg as well regulationidGlistclasscell_line
sed -i 's/file_name/regulationidGlistclasscell_lineadded/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/"$i"/gene/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $conditionname1 $conditionname2 ; do
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/class/'$k'/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
bash /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/'$k'/class/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
done
done
done
sed -i 's/gene/"$i"/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/in "$i"/in gene/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/regulationidGlistclasscell_lineadded/file_name/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
##This will then run the pathway analysis at both gene and transcript level.
for i in gene transcript ; do
sed -i 's/condition_1/'$conditionname1'/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/condition_2/'$conditionname2'/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/Rscripts/Gpathway.R 
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/Gpathway.R
INPUT=/media/sf_AIDD/gene_list/pathway/pathway_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x file_name
do
    sed -i 's/file_name/'$file_name'/g' /media/sf_AIDD/Rscripts/Gpathway.R
    Rscript /media/sf_AIDD/Rscripts/Gpathway.R
    sed -i 's/'$file_name'/file_name/g' /media/sf_AIDD/Rscripts/Gpathway.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/'$conditionname1'/condition_1/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/'$conditionname2'/condition_2/g' /media/sf_AIDD/Rscripts/Gpathway.R
done
##this will run gene of interest count graph
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/set_color/color=cell/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/set_shape//g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/set_condition_columns/"'$conditionname1'" "'$conditionname2'"/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$i"ofinterest.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
    sed -i "s/file_name/"$gene_name"/g" /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
    Rscript /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
    sed -i "s/"$gene_name"/file_name/g" /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
done
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/color=cell/set_color/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/set_color /set_color, set_shape/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/"'$conditionname1'" "'$conditionname2'"/set_condition_columns/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
## this creates differential_expression cell line folder
for l in $conditionname1 $conditionname2 ; do
    mkdir /media/sf_AIDD/Results/DESeq2/gene/differential_expression/$l/
    mkdir /media/sf_AIDD/Results/DESeq2/gene/differential_expression/$l/
done

}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/Rscripts.log
