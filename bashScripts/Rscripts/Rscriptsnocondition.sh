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
## creates cvs files for text output
sed -i 's/ /,/g' /media/sf_AIDD/condition.txt
sed 's/,,,,,,//g' /media/sf_AIDD/condition.txt > /media/sf_AIDD/condition.csv
sed -i 's/ /,/g' /media/sf_AIDD/cell_line.txt
sed 's/,,,,,,//g' /media/sf_AIDD/cell_line.txt > /media/sf_AIDD/cell_line.csv
rm /media/sf_AIDD/condition.txt
rm /media/sf_AIDD/cell_line.txt
echo "Assigning variables"
conditionname1=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/condition.csv)
conditionname4=$(awk -F, 'NR==5{print $2}' /media/sf_AIDD/condition.csv)
conditionname5=$(awk -F, 'NR==6{print $2}' /media/sf_AIDD/condition.csv)
condition1=$(awk -F, 'NR==3{print $1}' /media/sf_AIDD/condition.csv)
condition2=$(awk -F, 'NR==2{print $1}' /media/sf_AIDD/condition.csv)
condition3=$(awk -F, 'NR==4{print $1}' /media/sf_AIDD/condition.csv)
condition4=$(awk -F, 'NR==5{print $1}' /media/sf_AIDD/condition.csv)
condition5=$(awk -F, 'NR==6{print $1}' /media/sf_AIDD/condition.csv)
cell_linename1=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename2=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/cell_line.csv)
samp=`expr $condition1 + $condition2 + $condition3 + $condition4 + $condition5`
echo "Making gene count files"
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
for i in gene transcript ; do
sed -i 's/set_samp_num/1:'$samp'/g' /media/sf_AIDD/Rscripts/matrixedit.R
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/matrixedit.R
Rscript /media/sf_AIDD/Rscripts/matrixedit.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/matrixedit.R
sed -i 's/1:'$samp'/set_samp_num/g' /media/sf_AIDD/Rscripts/matrixedit.R
done
##this will create all gene_count_matrix and PHENO_DATA needed for further analysis
echo "Splitting files"
endfirst=`expr $condition1 + 1` #6
endsecond=`expr $condition1 + $condition2` #9
startthird=`expr $endsecond + 1` #10
endthird=`expr $condition1 + $condition2 + $condition3` #13
startfourth=`expr $endthird + 1` #14
endfourth=`expr $condition1 + $condition2 + $condition3 + $condition4` #17
startfifth=`expr $endfourth + 1` #18
endfifth=`expr $condition1 + $condition2 + $condition3 + $condition4 + $condition5` #21
sed -i 's/set_col_del_con1/1:'$endsecond'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con2/1:'$condition1', '$startthird':'$endthird'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con3/1:'$condition1', '$startfourth':'$endfourth'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con4/1:'$condition1', '$startfifth':'$endfifth'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con5/'$endfirst':'$endthird'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con6/'$endfirst':'$endsecond', '$startfourth':'$endfourth'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con7/'$endfirst':'$endsecond', '$startfifth':'$endfifth'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con8/'$startthird':'$endfourth'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con9/'$startthird':'$endthird', '$startfifth':'$endfifth'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/set_col_del_con_10/'$startfourth':'$endfifth'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/cell_linename1/'$conditionname1'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/cell_linename2/'$conditionname2'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/cell_linename3/'$conditionname3'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/cell_linename4/'$conditionname4'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/cell_linename5/'$conditionname5'/g' /media/sf_AIDD/Rscripts/createPHENO.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/createPHENO.R
Rscript /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/createPHENO.R
done
sed -i 's/1:'$endsecond'/set_col_del_con1/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/1:'$condition1', '$startthird':'$endthird'/set_col_del_con2/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/1:'$condition1', '$startfourth':'$endfourth'/set_col_del_con3/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/1:'$condition1', '$startfifth':'$endfifth'/set_col_del_con4/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$endfirst':'$endthird'/set_col_del_con5/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$endfirst':'$endsecond', '$startfourth':'$endfourth'/set_col_del_con6/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$endfirst':'$endsecond', '$startfifth':'$endfifth'/set_col_del_con7/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$startthird':'$endfourth'/set_col_del_con8/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$startthird':'$endthird', '$startfifth':'$endfifth'/set_col_del_con9/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$startfourth':'$endfifth'/set_col_del_con_10/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$conditionname1'/cell_linename1/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$conditionname2'/cell_linename2/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$conditionname3'/cell_linename3/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$conditionname4'/cell_linename4/g' /media/sf_AIDD/Rscripts/createPHENO.R
sed -i 's/'$conditionname5'/cell_linename5/g' /media/sf_AIDD/Rscripts/createPHENO.R
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
sed -i 's/set_design/~ condition/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/.csv/cell_line.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/.tiff/cell_line.tiff/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/readcell_line.csv/read.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/writecell_line.csv/write.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/interestcell_line.csv/interest.csv/g' /media/sf_AIDD/Rscripts/GLDE.R
##this runs gene level analysis with DESeq2 to generate PCA, QC, and differential expression analysis
for i in gene transcript ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
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
sed -i 's/~ condition/set_design/g' /media/sf_AIDD/Rscripts/GLDE.R
##this will create conditions file with counting samples by condition
##this will run GLDE with all 5 cell line split into two conditions.
sed -i 's/set_design/~ cell/g' /media/sf_AIDD/Rscripts/GLDE.R
##this runs gene level analysis with DESeq2 to generate PCA, QC, and differential expression analysis
for i in gene transcript ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/transcriptfilter/genefilter/g' /media/sf_AIDD/Rscripts/GLDE.R
Rscript /media/sf_AIDD/Rscripts/GLDE.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/GLDE.R
done
sed -i 's/~ cell/set_design/g' /media/sf_AIDD/Rscripts/GLDE.R
##create directories for gene of interest and excitome to create bar graphs
for i in gene transcript ; do
for j in "$i"ofinterestfinalresults excitomefinalresults venndiagrams ; do
mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"/
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"* /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"/
done
done
##this will create tables ready for upload to database and for bar graphs for gene of interest
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
sed -i 's/-/_/g' /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterestfinalresults/transcriptofinterestfinalresults"$l".csv
sed -i 's/-/_/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
done
for i in gene transcript ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
for m in "$i"ofinterest excitome ; do
sed -i 's/.csv/cell_line.csv/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/.jpeg/cell_line.jpeg/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/Listnames/'$m'finalresults/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/read'$l'.csv/read.csv/g' sed -i /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/write'$l'.csv/write.csv/g' sed -i /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_group/condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
if [ "$l" == ""$conditionname1"_"$conditionname2"" ]; then
sed -i 's/set_barcolors/"#FF6666", "#FFFF99"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname1"_"$conditionname3"" ]; then
sed -i 's/set_barcolors/"#FF6666", "#66FF66"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname1"_"$conditionname4"" ]; then
sed -i 's/set_barcolors/"#FF6666", "#6633FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname1"_"$conditionname5"" ]; then
sed -i 's/set_barcolors/"#FF6666", "#CC66FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname2"_"$conditionname3"" ]; then
sed -i 's/set_barcolors/"#FFFF99", "#66FF66"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname2"_"$conditionname4"" ]; then
sed -i 's/set_barcolors/"#FFFF99", "#6633FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname2"_"$conditionname5"" ]; then
sed -i 's/set_barcolors/"#FFFF99", "#CC66FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname3"_"$conditionname4"" ]; then
sed -i 's/set_barcolors/"#66FF66", "#6633FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname3"_"$conditionname5"" ]; then
sed -i 's/set_barcolors/"#66FF66", "#CC66FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname4"_"$conditionname5"" ]; then
sed -i 's/set_barcolors/"#6633FF", "#CC66FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
sed -i 's/set_x/x=condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$m".csv
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
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/'$m'finalresults/Listnames/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/'$i'/level/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/cell_line//g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/condition/set_group/g' /media/sf_AIDD/Rscripts/bargraphs.R
if [ "$l" == ""$conditionname1"_"$conditionname2"" ]; then
sed -i 's/"#FF6666", "#FFFF99"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname1"_"$conditionname3"" ]; then
sed -i 's/"#FF6666", "#66FF66"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname1"_"$conditionname4"" ]; then
sed -i 's/"#FF6666", "#6633FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname1"_"$conditionname5"" ]; then
sed -i 's/"#FF6666", "#CC66FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname2"_"$conditionname3"" ]; then
sed -i 's/"#FFFF99", "#66FF66"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname2"_"$conditionname4"" ]; then
sed -i 's/"#FFFF99", "#6633FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname2"_"$conditionname5"" ]; then
sed -i 's/"#FFFF99", "#CC66FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname3"_"$conditionname4"" ]; then
sed -i 's/"#66FF66", "#6633FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname3"_"$conditionname5"" ]; then
sed -i 's/"#66FF66", "#CC66FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
if [ "$l" == ""$conditionname4"_"$conditionname5"" ]; then
sed -i 's/"#6633FF", "#CC66FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
fi
sed -i 's/x=condition/set_x/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/Rscripts/bargraphs.R
done 
done
done
sed -i 's/cell_line//g' /media/sf_AIDD/Rscripts/bargraphs.R

##this does all conditions on one graph
sed -i 's/-/_/g' /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterestfinalresults/transcriptofinterestfinalresults.csv
sed -i 's/-/_/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
for i in gene transcript ; do
for m in "$i"ofinterest excitome ; do
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/Listnames/'$m'finalresults/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_group/condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_barcolors/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_x/x=condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$m".csv
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
sed -i 's/'$m'finalresults/Listnames/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/level/'$i'/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/set_group/condition/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/x=condition/set_x/g' /media/sf_AIDD/Rscripts/bargraphs.R
sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/Rscripts/bargraphs.R
done
done
sed -i 's/_/-/g' /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterestfinalresults/transcriptofinterestfinalresults.csv
sed -i 's/transcript-/transcript_/g' /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterestfinalresults/transcriptofinterestfinalresults.csv
sed -i 's/_/-/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
sed -i 's/transcript-/transcript_/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
##move files into folders
sed -i 's/-/_/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
for i in gene transcript ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
for m in "$i"ofinterest excitome ; do
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$m".csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
  mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/"$gene_name"/
  mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/*"$gene_name"* /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/"$gene_name"/
done < $INPUT
IFS=$OLDIFS
done
done
done
sed -i 's/_/-/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
sed -i 's/transcript-/transcript_/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
##this will move files to combine all files to put all ADAR transcript on one bar graph.
sed -i 's/-/_/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
for i in gene transcript ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
for m in "$i"ofinterest excitome ; do
INPUT=/media/sf_AIDD/"$i"_list/DESeq2/"$m".csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
  mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/final/
  mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/"$gene_name"/*"$l".csv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/final/
done < $INPUT
IFS=$OLDIFS
done
done
done
sed -i 's/_/-/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
sed -i 's/transcript-/transcript_/g' /media/sf_AIDD/transcript_list/DESeq2/transcriptofinterest.csv
##this will move ADARs into there own folders
for i in gene transcript ; do
for m in "$i"ofinterest excitome ; do
for n in ADARB1 ADARB2 ADAR ; do
mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/final/"$n"/
done
done
done
##this will move 
for i in gene transcript ; do
for m in "$i"ofinterest excitome ; do
for n in ADARB1 ADARB2 ADAR ; do
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/final/"$n"_0* /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$m"finalresults/final/"$n"/
done
done
done
##
for n in ADARB1 ADARB2 ADAR ; do
mkdir /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/transcriptofinterestfinalresults/final/"$n"/merged/
done
##this will combine ADAR files to make graphs with isoforms all in one graph by condition
for n in ADARB1 ADARB2 ADAR ; do
sed -i 's/gene/'$n'/g' /media/sf_AIDD/Rscripts/transcriptcombine.R
Rscript /media/sf_AIDD/Rscripts/transcriptcombine.R
sed -i 's/'$n'/gene/g' /media/sf_AIDD/Rscripts/transcriptcombine.R
done
done
done
#
#
#
#
#
##This will create lists for venn diagrams for all up regulated and down regulated genes and top100 up and down regulated genes found in differential expression analysis
for i in gene transcript ; do
for j in upreg downreg ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
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
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
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
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
paste -d , /media/sf_AIDD/Results/DESeq2/gene/differential_expression/"$l"/"$j"idGlist"$k""$l".csv /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/"$l"/"$j"idGlist"$k""$l".csv > /media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/"$j"idGlist"$k""$l"added.csv
done
done
done
## this will edit venn tables to make venn diagrams.
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
sed -i 's/regulation/'$j'/g' /media/sf_AIDD/Rscripts/editgenetransvenn.R
sed -i 's/cell_line/'$l'/g' /media/sf_AIDD/Rscripts/editgenetransvenn.R
sed -i 's/class/'$k'/g' /media/sf_AIDD/Rscripts/editgenetransvenn.R
Rscript /media/sf_AIDD/Rscripts/editgenetransvenn.R
sed -i 's/'$l'/cell_line/g' /media/sf_AIDD/Rscripts/editgenetransvenn.R
sed -i 's/'$j'/regulation/g' /media/sf_AIDD/Rscripts/editgenetransvenn.R
sed -i 's/'$k'/class/g' /media/sf_AIDD/Rscripts/editgenetransvenn.R
done
done
done
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
sed -i 's/level/gene/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/file_name/'$j'idGlist'$k''$l'added/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/set_column_names/"'$j''$l''$k'gene","'$j''$l''$k'transcript"/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/set_colors/"#6633FF", "#CC66FF"/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/set_alpha/0.5,0.5/g' /media/sf_AIDD/Rscripts/Gvenn.R
Rscript /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/gene/level/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/'$j'idGlist'$k''$l'added/file_name/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/"'$j''$l''$k'gene","'$j''$l''$k'transcript"/set_column_names/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/"#6633FF", "#CC66FF"/set_colors/g' /media/sf_AIDD/Rscripts/Gvenn.R
sed -i 's/0.5,0.5/set_alpha/g' /media/sf_AIDD/Rscripts/Gvenn.R
done
done
done
## this will create venn diagrams for each cell line comparing up reg gene to up reg transcripts and down reg as well regulationidGlistclasscell_line
sed -i 's/file_name/regulationidGlistclasscell_lineadded/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
sed -i 's/"$i"/gene/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
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
sed -i 's/regulationidGlistclasscell_lineadded/file_name/g' /media/sf_AIDD/bashScripts/prep/venntexttogenelist.sh
##this will run pathway analysis
INPUT=/media/sf_AIDD/gene_list/pathway/pathway_list.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x gene_name
do
sed -i 's/condition_1/'$cell_linename1'/g' /media/sf_AIDD/Rscripts/Gpathway.R 
sed -i 's/condition_2/'$cell_linename2'/g' /media/sf_AIDD/Rscripts/Gpathway.R 
    sed -i 's/set_design/~ cell/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/level/gene/g' /media/sf_AIDD/Rscripts/Gpathway.R
    sed -i 's/file_name/'$gene_name'/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/condition/cell/g' /media/sf_AIDD/Rscripts/Gpathway.R
    Rscript /media/sf_AIDD/Rscripts/Gpathway.R
    sed -i "s/"$gene_name"/file_name/g" /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/'$cell_linename1'/condition_1/g' /media/sf_AIDD/Rscripts/Gpathway.R 
sed -i 's/'$cell_linename2'/condition_2/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/gene/level/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/~ cell/set_design/g' /media/sf_AIDD/Rscripts/Gpathway.R
sed -i 's/cell/condition/g' /media/sf_AIDD/Rscripts/Gpathway.R 

done < $INPUT
IFS=$OLDIFS






Rscript /media/sf_AIDD/Rscripts/Gpathway2.R
##this cleans up files and organizes directories.
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$conditionname1"_"$conditionname2" "$conditionname1"_"$conditionname3" "$conditionname1"_"$conditionname4" "$conditionname1"_"$conditionname5" "$conditionname2"_"$conditionname3" "$conditionname2"_"$conditionname4" "$conditionname2"_"$conditionname5" "$conditionname3"_"$conditionname4" "$conditionname3"_"$conditionname5" "$conditionname4"_"$conditionname5" ; do
mkdir /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$l"/
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/*"$l".csv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$l"/
done
done
done
done

