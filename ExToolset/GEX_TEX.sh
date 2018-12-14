#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
conditionname1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
echo "getting count files ready"
for i in gene transcript ; do
if [ "$i" == "gene" ]; then
sed -i 's/set_column_order/1,2/g' /media/sf_AIDD/ExToolset/GEX_TEX/matrixedit.R
fi
if [ "$i" == "transcript" ]; then
sed -i 's/set_column_order/1,3,2/g' /media/sf_AIDD/ExToolset/GEX_TEX/matrixedit.R
fi
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/GEX_TEX/matrixedit.R
Rscript /media/sf_AIDD/ExToolset/GEX_TEX/matrixedit.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/GEX_TEX/matrixedit.R
if [ "$i" == "gene" ]; then
sed -i 's/1,2/set_column_order/g' /media/sf_AIDD/ExToolset/GEX_TEX/matrixedit.R
fi
if [ "$i" == "transcript" ]; then
sed -i 's/1,3,2/set_column_order/g' /media/sf_AIDD/ExToolset/GEX_TEX/matrixedit.R
fi
done
echo "Starting differential expression analysis with DESeq2"
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/ExToolset/GEX_TEX/GLDE.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/GEX_TEX/GLDE.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/ExToolset/GEX_TEX/GLDE.R
Rscript /media/sf_AIDD/ExToolset/GEX_TEX/GLDE.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/GEX_TEX/GLDE.R
done
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/ExToolset/GEX_TEX/GLDE.R
##this will create up and down regulated gene and transcript lists both in gene id to calculate how many new genes are added because of transcript level analysis
echo "No getting venn diagram list ready"
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/class/'$k'/g' /media/sf_AIDD/ExToolset/GEX_TEX/changeidGvenn.R
Rscript /media/sf_AIDD/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/'$k'/class/g' /media/sf_AIDD/ExToolset/GEX_TEX/changeidGvenn.R
done
done
done
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
for j in upreg downreg ; do
for k in vennall top100 ; do
paste -d , /media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/"$j"idGList"$k".csv /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/venndiagrams/"$j"idGList"$k".csv > /media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/"$j"idGList"$k"added.csv
done
done
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
echo "Creating Venn diagrams"
sed -i 's/set_alpha/0.5,0.5/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/set_colors/"red","blue"/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/set_column_name/"gene","transcript"/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/file_name/regulationidGlistclassadded/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/level/gene/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
for j in upreg downreg ; do
for k in vennall top100 ; do
sed -i 's/class/'$k'/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
Rscript /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/'$k'/class/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
done
done
sed -i 's/"gene","transcript"/set_column_name/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/gene/level/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/0.5,0.5/set_alpha/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/"red","blue"/set_colors/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/regulationidGlistclassadded/file_name/g' /media/sf_AIDD/ExToolset/GEX_TEX/Gvenn.R
## this will create venn diagrams for each cell line comparing up reg gene to up reg transcripts and down reg as well regulationidGlistclasscell_line
echo "Creating final gene lists for gene enrichment"
sed -i 's/file_name/regulationidGlistclassadded/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/"$i"/gene/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
for j in upreg downreg ; do
for k in vennall top100 ; do
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/class/'$k'/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
bash /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/'$k'/class/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
done
done
sed -i 's/gene/"$i"/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/in "$i"/in gene/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/regulationidGlistclassadded/file_name/g' /media/sf_AIDD/ExToolset/GEX_TEX/venntexttogenelist.sh
##this will create finall
for j in upreg downreg ; do
for k in vennall top100 ; do
paste -d , /media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/"$j"idGList"$k"addedvenn/*.csv > /media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/final"$j"idGList"$k"addedvenn.csv
done
done
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
rm /media/sf_AIDD/Results/DESeq2/$i/differential_expression/venndiagrams/*.txt
rm /media/sf_AIDD/Results/DESeq2/$i/differential_expression/venndiagrams/"$j"*Glist"$k".csv
done
done
done
##this will create final
echo "Cleaning up unused files"
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
rm /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/*.txt
rm /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/"$j"Glist"$k".csv
rm /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/"$j"idGlist"$k".csv
rm /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/"$j"idGlist"$k"added.csv
rm /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/"$j"idGlist"$k"addedvenn.csv
done
done
done
##this will great bargraphs for each gene of interest and transcript of interest
"Starting gene of interest bar graphs"
for i in gene transcript ; do
INPUT=/media/sf_AIDD/indexes/"$i"_list/DESeq2/"$i"ofinterest.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x file_name
do
if [ "$i" == "transcript" ] ; then
sed -i 's/set_column_order/2,1,3:24/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R 
fi
if [ "$i" == "gene" ] ; then
sed -i 's/set_column_order/1,2,3:24/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R 
fi
sed -i 's/List_names/'$i'ofinterest/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/file_name/'$file_name'/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/level/'$i'/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_group/condition/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_barcolors/"red","blue"/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_x/x=condition/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
Rscript /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/'$i'ofinterest/List_names/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/'$file_name'/file_name/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/condition/set_group/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/"red","blue"/set_barcolors/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/x=condition/set_x/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R
if [ "$i" == "transcript" ] ; then
sed -i 's/2,1,3:24/set_column_order/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R 
fi
if [ "$i" == "gene" ] ; then
sed -i 's/1,2,3:24/set_column_order/g' /media/sf_AIDD/ExToolset/GEX_TEX/bargraphs.R 
fi
done < $INPUT
IFS=$OLDIFS
done
echo "creating one figure of ADAR and VEGF"
##this will run all graphs on one figure
Rscript /media/sf_AIDD/ExToolset/GEX_TEX/allVEGFADARbargraph.R
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/GEX_TEX.log
