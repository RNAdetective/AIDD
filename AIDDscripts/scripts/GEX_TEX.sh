#!/usr/bin/env bash
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
source config.shlib; # load the config library functions
dir_path="$(config_get dir_path)"; # main directory
wd="$dir_path"/working_directory; # working directory
ref_dir_path="$dir_path"/references; # reference directory
dirqc="$dir_path"/quality_control; # qc directory
AIDDtool=~/AIDD/AIDD_tools; # AIDD tool directory
rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
rdbam="$dir_path"/raw_data/bam_files # directory for bam files
con_name1="$(config_get con_name1)"; # condition 1
con_name2="$(config_get con_name2)"; # condition 2
con_name3="$(config_get con_name3)"; # condition 3
con_name4="$(config_get con_name4)"; # condition 4
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
echo "RENAMING MATRIX FILE"
for i in gene transcript ; do
Rscript  "$dir_path"/ExToolset/GEX_TEX/matrixedit.R
echo "DE WITH DESeq2"
## this is the command to run the gene level differential analysis and then change to transcript level differential analysis
INPUT= "$dir_path"/listofconditions.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read condition
do
for i in gene transcript ; do
sed -i 's/level/'$i'/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
sed -i 's/transcriptfilter/genefilter/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
Rscript  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
sed -i 's/'$i'/level/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
done
sed -i 's/~ '$condition'/set_design/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
sed -i 's/level\/'$condition'/level\//g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
done 
} < $INPUT
IFS=$OLDIFS
## this runs with multifactoral design
sed -i 's/set_design/~ '$con_name2' + '$con_name3' + '$con_name2':'$con_name3'/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
sed -i 's/transcriptfilter/genefilter/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
Rscript  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
sed -i 's/'$i'/level/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
done
sed -i 's/~ '$con_name2' + '$con_name3' + '$con_name2':'$con_name3'/set_design/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
done 
## this runs with multifactoral design
sed -i 's/set_design/~ '$con_name2' + '$con_name4' + '$con_name2':'$con_name4'/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
for i in gene transcript ; do
sed -i 's/level/'$i'/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
sed -i 's/transcriptfilter/genefilter/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
Rscript  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
sed -i 's/'$i'/level/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
done
sed -i 's/~ '$con_name2' + '$con_name4' + '$con_name2':'$con_name4'/set_design/g'  "$dir_path"/ExToolset/GEX_TEX/GLDE.R
done 
##this will create up and down regulated gene and transcript lists both in gene id to calculate how many new genes are added because of transcript level analysis
echo "No getting venn diagram list ready"
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ; do
sed -i 's/level\//level\/'$l'\//g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/level/'$i'/g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/regulation/'$j'/g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/class/'$k'/g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
Rscript  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/'$i'/level/g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/'$j'/regulation/g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/'$k'/class/g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
sed -i 's/level\/'$l'/level\//g'  "$dir_path"/ExToolset/GEX_TEX/changeidGvenn.R
done
done
done
done
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ; do
paste -d ,  "$dir_path"/Results/DESeq2/gene/"$l"/differential_expression/venndiagrams/"$j"idGList"$k".csv  "$dir_path"/Results/DESeq2/transcript/"$l"/differential_expression/venndiagrams/"$j"idGList"$k".csv >  "$dir_path"/Results/DESeq2/gene/"$l"/differential_expression/venndiagrams/"$j"idGList"$k"added.csv
done
done
done
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
INPUT= "$dir_path"/listofconditions.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read condition
do
echo "Creating Venn diagrams"
sed -i 's/set_alpha/0.5,0.5/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/set_colors/"red","blue"/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/set_column_name/"gene","transcript"/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/file_name/regulationidGlistclassadded/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/level\//level\/'$condition'\//g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/level/gene/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
for j in upreg downreg ; do
for k in vennall top100 ; do
sed -i 's/class/'$k'/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/regulation/'$j'/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
Rscript  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/'$j'/regulation/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/'$k'/class/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
done
done
sed -i 's/"gene","transcript"/set_column_name/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/gene/level/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/level\/'$condition'\//level\//g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/0.5,0.5/set_alpha/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/"red","blue"/set_colors/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
sed -i 's/regulationidGlistclassadded/file_name/g'  "$dir_path"/ExToolset/GEX_TEX/Gvenn.R
done 
} < $INPUT
IFS=$OLDIFS
## this will create venn diagrams for each cell line comparing up reg gene to up reg transcripts and down reg as well regulationidGlistclasscell_line
echo "Creating final gene lists for gene enrichment"
sed -i 's/file_name/regulationidGlistclassadded/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/"$i"/gene/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
for j in upreg downreg ; do
for k in vennall top100 ; do
sed -i 's/regulation/'$j'/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/class/'$k'/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
bash  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/'$j'/regulation/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/'$k'/class/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
done
done
sed -i 's/gene/"$i"/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/in "$i"/in gene/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
sed -i 's/regulationidGlistclassadded/file_name/g'  "$dir_path"/ExToolset/GEX_TEX/venntexttogenelist.sh
##this will create finall
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ; do
paste -d ,  "$dir_path"/Results/DESeq2/gene/$l/differential_expression/venndiagrams/"$j"idGList"$k"addedvenn/*.csv >  "$dir_path"/Results/DESeq2/gene/$l/differential_expression/venndiagrams/final"$j"idGList"$k"addedvenn.csv
done
done
done
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ; do
rm  "$dir_path"/Results/DESeq2/$i/$l/differential_expression/venndiagrams/*.txt
rm  "$dir_path"/Results/DESeq2/$i/$l/differential_expression/venndiagrams/"$j"*Glist"$k".csv
done
done
done
done
##this will create final
echo "Cleaning up unused files"
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ; do
rm  "$dir_path"/Results/DESeq2/"$i"/"$l"/differential_expression/venndiagrams/*.txt
rm  "$dir_path"/Results/DESeq2/"$i"/"$l"/differential_expression/venndiagrams/"$j"Glist"$k".csv
rm  "$dir_path"/Results/DESeq2/"$i"/"$l"/differential_expression/venndiagrams/"$j"idGlist"$k".csv
rm  "$dir_path"/Results/DESeq2/"$i"/"$l"/differential_expression/venndiagrams/"$j"idGlist"$k"added.csv
rm  "$dir_path"/Results/DESeq2/"$i"/"$l"/differential_expression/venndiagrams/"$j"idGlist"$k"addedvenn.csv
done
done
done
done
##this will great bargraphs for each gene of interest and transcript of interest
"Starting gene of interest bar graphs"
for i in gene transcript ; do
for l in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ; do
INPUT= "$dir_path"/indexes/"$i"_list/DESeq2/"$i"ofinterest.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r x file_name
do
if [ "$i" == "transcript" ] ; then
sed -i 's/set_column_order/2,1,3:24/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R 
fi
if [ "$i" == "gene" ] ; then
sed -i 's/set_column_order/1,2,3:24/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R 
fi
sed -i 's/List_names/'$i'ofinterest/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/file_name/'$file_name'/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/level\//level\/'$l'\//g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/level/'$i'/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_group/condition/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_barcolors/"red","blue"/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_x/x=condition/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/set_fill/fill=condition/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
Rscript  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/'$i'ofinterest/List_names/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/'$file_name'/file_name/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/'$i'/level/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/level\/'$l'\//level\//g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/condition/set_group/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/"red","blue"/set_barcolors/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/x=condition/set_x/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
sed -i 's/fill=condition/set_fill/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R
if [ "$i" == "transcript" ] ; then
sed -i 's/2,1,3:24/set_column_order/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R 
fi
if [ "$i" == "gene" ] ; then
sed -i 's/1,2,3:24/set_column_order/g'  "$dir_path"/ExToolset/GEX_TEX/bargraphs.R 
fi
done
} < $INPUT
IFS=$OLDIFS
done
echo "creating one figure of ADAR and VEGF"
##this will run all graphs on one figure
for l in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ; do
sed -i 's/level\//level\/'$l'\//g'  "$dir_path"/ExToolset/GEX_TEX/allVEGFADARbargraph.R
Rscript  "$dir_path"/ExToolset/GEX_TEX/allVEGFADARbargraph.R
sed -i 's/level\/'$l'\//level\//g'  "$dir_path"/ExToolset/GEX_TEX/allVEGFADARbargraph.R
done
