#!/usr/bin/env bash
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

##this will edit all files that have cell_line
##need to set variables: level and set_sam_num (sample number in experiment) in matrixedit.R to relabel gene_count_matrix file with correct samples names
##count how many rows in PHENODATA file to set sample variable
for i in gene transcript ; do
count=$(awk '{n+=1} END {print n}' /media/sf_AIDD/PHENO_DATA.csv)
header=1
samp=`expr $count - $header`
if [ "$i" == "transcript" ]; then
sed -i 's/set_column_order/1,3,2/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
if [ "$i" == "gene" ]; then
sed -i 's/set_column_order/1,2/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/matrixedit.R
sed -i 's/set_samp_num/1:'$samp'/g' /media/sf_AIDD/Rscripts/matrixedit.R
Rscript  /media/sf_AIDD/Rscripts/matrixedit.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/matrixedit.R
sed -i 's/1:'$samp'/set_samp_num/g' /media/sf_AIDD/Rscripts/matrixedit.R
if [ "$i" == "transcript" ]; then
sed -i 's/1,3,2/set_column_order/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
if [ "$i" == "gene" ]; then
sed -i 's/1,2/set_column_order/g' /media/sf_AIDD/Rscripts/matrixedit.R
fi
done
##this will create all gene_count_matrix and PHENO_DATA needed for further analysis
cell_linename1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/cell_line.csv)
condition1=$(awk -F, 'NR==2{print $1}' /media/sf_AIDD/cell_line.csv)
condition2=$(awk -F, 'NR==3{print $1}' /media/sf_AIDD/cell_line.csv)
condition3=$(awk -F, 'NR==4{print $1}' /media/sf_AIDD/cell_line.csv)
totalconditions=`expr $condition1 + $condition2 + $condition3`
startofsecond=`expr $condition1 + 1`
endofsecond=`expr $condition1 + $condition2`
startofthird=`expr $endofsecond + 1`
sed -i 's/set_col_del_con1/'$startofsecond':'$totalconditions'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con2/1:'$condition1', '$startofthird':'$totalconditions'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con3/1:'$endofsecond'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/condition_1/'$cell_linename1'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/condition_2/'$cell_linename2'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/condition_3/'$cell_linename3'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/condition_4/'$cell_linename4'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/condition_5/'$cell_linename5'/g' /media/sf_AIDD/Rscripts/createPHENO.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/createPHENO.R
Rscript /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/createPHENO.R
done
sed -i 's/'$startofsecond':'$totalconditions'/set_col_del_con1/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/1:'$condition1', '$startofthird':'$totalconditions'/set_col_del_con2/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/1:'$endofsecond'/set_col_del_con3/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$cell_linename1'/condition_1/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$cell_linename2'/condition_2/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$cell_linename3'/condition_3/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$cell_linename4'/condition_4/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$cell_linename5'/condition_5/g' /media/sf_AIDD/Rscripts/createPHENO.R
##this runs the analysis with both conditions between the two main conditions only taking into account cell line
sed -i 's/set_design/~ condition + cell + condition:cell/g' /media/sf_AIDD/Rscripts/GLDE.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/GLDE.R 
Rscript /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/GLDE.R
done
sed -i 's/~ condition + cell + condition:cell/set_design/g' /media/sf_AIDD/Rscripts/GLDE.R
##this will start individual experiments with only one condition in each as the study design.
sed -i 's/set_design/~condition/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/.csv/cell_line.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/.tiff/cell_line.tiff/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/readcell_line.csv/read.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/writecell_line.csv/write.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/interestcell_line.csv/interest.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
##this runs gene level analysis with DESeq2 to generate PCA, QC, and differential expression analysis
for i in gene transcript ; do
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/excitome'$l'.csv/excitome.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
Rscript /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/GLDE.R
done
done
sed -i 's/cell_line.csv/.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/cell_line.tiff/.tiff/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/~condition/set_design/g' /media/sf_AIDD/Rscripts/GLDE.R
##create directories for gene of interest and excitome to create bar graphs
for i in gene transcript ; do
for j in "$i"ofinterestfinalresults excitomefinalresults venndiagrams ; do
mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"/
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"* /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"/
done
done
##this will create tables ready for upload to database and for bar graphs for gene of interest
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_barcolors/palette="Greens"/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/List_names/'$i'ofinterestfinalresults/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_group/condition,cell/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_x/x=cell/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/cell_line/'$i'/g' /media/sf_AIDD/Rscripts/bargraphs.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$i"ofinterest.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
    sed -i "s/file_name/"$gene_name"/g" /media/sf_AIDD/Rscripts/bargraphs.R
    Rscript /media/sf_AIDD/Rscripts/bargraphs.R
    sed -i "s/"$gene_name"/file_name/g" /media/sf_AIDD/Rscripts/bargraphs.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'ofinterestfinalresults/List_names/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/List_names/excitomefinalresults/g' /media/sf_AIDD/Rscripts/bargraphs.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/excitome.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
    sed -i "s/file_name/"$gene_name"/g" /media/sf_AIDD/Rscripts/bargraphs.R
    Rscript /media/sf_AIDD/Rscripts/bargraphs.R
    sed -i "s/"$gene_name"/file_name/g" /media/sf_AIDD/Rscripts/bargraphs.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/palette="Greens"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/excitomefinalresults/List_names/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/condition,cell/set_group/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/x=cell/set_x/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/bargraphs.R
done
##This will create lists for venn diagrams for all up regulated and down regulated genes and top100 up and down regulated genes found in differential expression analysis
for i in gene transcript ; do
for j in upreg downreg ; do
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
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
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
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
##this is the output file regulationregidGlistclasscell_line.csv
##this will combine all 3 cell types into one table for gene level and transcript level and well as for up and down regulated and all genes/transcripts or just the top 100 genes/transcripts into a csv 
bash /media/sf_AIDD/bashScripts/prep/makevenntables2.sh
##this will make venn diagrams for the above files created with ids for all up or down regulated genes or transcripts or the top 100 comparing the three cell lines.
sed -i 's/file_name/regulationidGlistclass/g' /media/sf_AIDD/Rscripts/Gvenn.R
##this changes the alpha setting in the venn diagram
sed -i 's/set_alpha/0.5,0.5,0.5/g' /media/sf_AIDD/Rscripts/Gvenn.R
##this will change the colors for venn diagram
sed -i 's/set_colors/"red","blue","yellow"/g' /media/sf_AIDD/Rscripts/Gvenn.R
##this will set column names to cell_lineregulationreg
sed -i 's/set_column_names/"regulationclasslevel'$cell_linename3'","regulationclasslevel'$cell_linename1'","regulationclasslevel'$cell_linename2'"/g' /media/sf_AIDD/Rscripts/Gvenn.R
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
##this changes for level, class, and regulaion and runs the Gvenn script
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/class/'$k'/g' /media/sf_AIDD/Rscripts/Gvenn.R
Rscript /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/'$k'/class/g' /media/sf_AIDD/Rscripts/Gvenn.R
done
done
done
sed -i 's/0.5,0.5,0.5/set_alpha/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/"red","blue","yellow"/set_colors/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/"regulationclasslevel'$cell_linename3'","regulationclasslevel'$cell_linename1'","regulationclasslevel'$cell_linename2'"/set_column_names/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/regulationidGlistclass/file_name/g' /media/sf_AIDD/Rscripts/Gvenn.R
##this will make gene and transcript lists from venn diagram output for gene enrichment analysis by
##this will make gene and transcript lists from venn diagram output for gene enrichment analysis by
sed -i 's/file_name/regulationidGlistclass/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
for j in upreg downreg ; do
for k in vennall top100 ; do
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/class/'$k'/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
bash /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/'$k'/class/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
done
done
sed -i 's/regulationidGlistclass/file_name/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
##this is the output file regulationregidGlistclasscell_line.csv
##this will combine all 3 cell types into one table for gene level and transcript level and well as for up and down regulated and all genes/transcripts or just the top 100 genes/transcripts into a csv 
bash /media/sf_AIDD/bashScripts/prep/makevenntables.sh
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
sed -i 's/set_alpha/0.5,0.5/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/set_colors/"purple","blue"/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/set_column_names/"regulationcell_lineclassgene","regulationcell_lineclasstranscript"/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/file_name/regulationidGlistclasscell_lineadded/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/level/gene/g' /media/sf_AIDD/Rscripts/Gvenn.R
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
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
sed -i 's/"regulationcell_lineclassgene","regulationcell_lineclasstranscript"/set_column_names/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/regulationidGlistclasscell_lineadded/file_name/g' /media/sf_AIDD/Rscripts/Gvenn.R
## this will create venn diagrams for each cell line comparing up reg gene to up reg transcripts and down reg as well regulationidGlistclasscell_line
sed -i 's/file_name/regulationidGlistclasscell_lineadded/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/"$i"/gene/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
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
##this cleans up files and organizes directories.
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$l"/
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/*"$l".csv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$l"/
done
done
done
done

##This will then run the pathway analysis at both gene and transcript level.
for i in gene transcript ; do
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
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
##This will run pathway by cell line seperately by first condition
sed -i 's/.csv/cell_line.csv/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/readcell_line/read/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/writecell_line/write/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/file_namecell_line/file_name/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/resultsallcell_line.csv/resultsall.csv/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/Rscripts/Gpathway.R 
sed -i 's/.tiff/cell_line.tiff/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/condition_1/'$conditionname1'/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/condition_2/'$conditionname2'/g' /media/sf_AIDD/Rscripts/Gpathway.R
for i in gene transcript ; do
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/Gpathway.R
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
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/Gpathway.R
done
done
sed -i 's/cell_line//g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/'$condition1'/condition_1/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/'$condition2'/condition_2/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/Rscripts/Gpathway.R
##this will do bargraphs for IFN gene pathway list
for i in gene transcript ; do
for m in IFN ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_barcolors/palette="Greens"/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/List_names/'$m'/g' /media/sf_AIDD/Rscripts/bargraphs.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$i"ofinterest.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
    sed -i "s/file_name/"$gene_name"/g" /media/sf_AIDD/Rscripts/bargraphs.R
    Rscript /media/sf_AIDD/Rscripts/bargraphs.R
    sed -i "s/"$gene_name"/file_name/g" /media/sf_AIDD/Rscripts/bargraphs.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/palette="Greens"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/'$m'/List_names/g' /media/sf_AIDD/Rscripts/bargraphs.R
done
done
##this will run gene of interest count graph
sed -i 's/set_design/~ condition + cell + condition:cell/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/set_color/color=cell/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/set_shape/shape=condition/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/set_condition_columns/"condition","cell"/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
for i in gene ; do
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
sed -i 's/~ condition + cell + condition:cell/set_design/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/color=cell/set_color/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/shape=condition/set_shape/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R
sed -i 's/"condition","cell"/set_condition_columns/g' /media/sf_AIDD/Rscripts/geneofinterestcountgraph.R

## use /media/sf_AIDD/Results/DESeq2/gene/differential_expression/regulationregidGlistclasscell_line/regulationregcell_lineclasstranscript.csv as gene lists for topGO.R
## use /media/sf_AIDD/Results/DESeq2/level/differential_expression/regulationGlistclass.txt for previous step to create folders to find gene lists in only the K048 K054 and G010 uniques only
#sed -i 's/directory/regulationregidGlistclasscell_lineadded/g' /media/sf_AIDD/Rscripts/GtopGO.R
#sed -i 's/file_name/regulationregcell_lineclasstranscript/g' /media/sf_AIDD/Rscripts/GtopGO.R 
#for i in K048 K054 G010 ; do
#for j in top100 vennall ; do
#for k in up down ; do
#sed -i 's/class/'$j'/g' /media/sf_AIDD/Rscripts/GtopGO.R
#sed -i 's/regulation/'$k'/g' /media/sf_AIDD/Rscripts/GtopGO.R
#sed -i 's/cell_line/'$i'/g' /media/sf_AIDD/Rscripts/GtopGO.R
#Rscript /media/sf_AIDD/Rscripts/GtopGO.R
#sed -i 's/'$i'/cell_line/g' /media/sf_AIDD/Rscripts/GtopGO.R
#sed -i 's/'$j'/class/g' /media/sf_AIDD/Rscripts/GtopGO.R
#sed -i 's/'$k'/regulation/g' /media/sf_AIDD/Rscripts/GtopGO.R
#done
#done
#done
#sed -i 's/regulationregidGlistclasscell_lineadded/directory/g' /media/sf_AIDD/Rscripts/GtopGO.R
#sed -i 's/regulationregcell_lineclasstranscript/file_name/g' /media/sf_AIDD/Rscripts/GtopGO.R
##this will move files into the right folder for count graphs bar graphs and t-tests
##
