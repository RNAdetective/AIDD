*create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
}
remove_stuff() {
if [ -f "$path" ];
then
 rm -f "$path"
fi
} # this removes $path
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
make_config() {
echo "home_dir=$home_dir
dir_path=$dir_path
ref_dir_path=$ref_dir_path" >> "$dir_path"/AIDD/config.cfg
}
make_cdef() {
echo "home_dir=Default Value
dir_path=Default Value
ref_dir_path=Default Value" >> "$dir_path"/AIDD/config.cfg.defaults
}
get_file() {
if [ -s "$to_move" ];
then
  cp "$to_move" "$file_move"
else
  echo1=$(echo "Can't find "$to_move"")
  mes_out
fi
}
cond_file() {
cat "$dir_path"/PHENO_DATA.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f"$coln" | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' >> "$dir_path"/"$nam".csv
}
make_cdef2() {
echo "con_name1=$con_name1
con_name2=$con_name2
con_name3=$con_name3" >> "$dir_path"/AIDD/config.cfg.defaults
}
move_directory() {
if [ -d "$dir_move" ];
then
  cp -r "$dir_move" "$final_dir"
else
  echo1=$(echo "Can't find "$dir_move"")
  mes_out
fi
} # moves a directory dir_move to a new directory final_dir
create_filecheck() {
if [ ! "$type1" == "none" ];
then
  if [ -s "$type1" ];
  then
echo ""$run""$snptype"1,yes" >> "$filecheckVC"/filecheck"$snptype"1.csv
  else
echo ""$run""$snptype"1,no" >> "$filecheckVC"/filecheck"$snptype"1.csv
  fi
fi
if [ ! "$type2" == "none" ];
then
  if [ -s "$type2" ];
  then
echo ""$run""$snptype"2,yes" >> "$filecheckVC"/filecheck"$snptype"2.csv
  else
echo ""$run""$snptype"2,no" >> "$filecheckVC"/filecheck"$snptype"2.csv
  fi
fi
}
summary_split() {
cat "$dirqcalign"/"$run"_alignment_metrics.txt | sed '/^#/d' | sed 's/PAIR/'$run'/g' | sed '/^FIR/d' | sed '/^SEC/d' | sed 's/\t/,/g' | sed '1d' >> "$dirqcalign"/"$run"_alignment_metrics.csv
}
combine_file() {
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" | sed '/^$/d' >> "$file_out"
}
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname"
}
sum_combine() {
cat "$dirqcalign"/*.csv | sed '/^$/d' >> "$dirqcalign"/all_summary.csv
sed -i '1!{/^CAT/d;}' "$dirqcalign"/all_summary.csv
file_in="$dirqcalign"/all_summary.csv
file_out="$dirqcalign"/all_summaryfilter.csv
col_num=$(echo "1,6,7,13,18,20,21,22,23")
tool=combine_file
run_tools
file_in="$dirqcalign"/all_summary.csv
file_out="$dirqcalign"/all_summarynorm.csv
col_num=$(echo "1,2")
tool=combine_file
run_tools
file_in="$dirqcalign"/all_summarynorm.csv
file_out="$dirqcalign"/all_summarynorm.tiff
bartype=$(echo "single")
tool=Rbar
run_tools
}
sum_divid() {
for colnum in 2 3 4 5 6 7 8 9 ; do
colname=$(awk -F, 'NR==1{print $'$colnum'}' "$dirqcalign"/all_summaryfilter.csv);
file_in="$dirqcalign"/all_summaryfilter.csv
file_out="$dirqcalign"/all_summary"$colname".csv
col_num=$(echo "1,"$colnum"")
tool=combine_file
run_tools
file_in="$dirqcalign"/all_summary"$colname".csv
sed -i '1d' "$file_in"
sed -i '1i name,freq' "$file_in"
file_out="$dirqcalign"/all_summary"$colname".tiff
bartype=$(echo "single")
tool=Rbar
#run_tools
done
}
temp_dir() {
if [ -d "$dir_path"/raw_data/ballgown/"$sample"/tmp.XX*/ ]; # IF TEMP_DIR IN SAMPLE FOLDER
then
  echo1=$(echo "FOUND TEMP DIRECTORY IN FOLDER FOR "$sample"")
  mes_out
  rm -f -R "$dir_path"/raw_data/ballgown/"$sample"/tmp.XX*/ #DELETE TMP_DIR
fi
} # deletes any temp directories created in error from stringtie
creatematrix() {
dir_path=$dir_path
cd "$dir_path"/raw_data/
python "$ExToolset"/prepDE.py -g "$dirres"/gene_count_matrix.csv -t "$dirres"/transcript_count_matrix.csv # CREATE MATRIX FILES
cd "$dir_path"/AIDD/
}
matrixeditor() {
Rscript "$ExToolset"/matrixedit.R "$file_out" "$file_in" "$index_file" "$pheno_file" "$Rtool" "$level_id" "$level_name" "$filter_type" "$level"
} # creates matrix counts with names instead of ids and checks to make sure they are there
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" #creates level of interest files
} # Runs multimerge R
filter_impact() {
filecheckVC="$dirqc"/filecheckVC
type2="$dir_path"/raw_data/snpEff/snpEff"$run""$snptype".genes.txt
type1=none
create_filecheck
#any_no= # count how many lines contain no "$filecheckVC"/filecheck"$snptype"2.csv
#if [ "$any_no" == "0" ];
#then
  cat "$type2" | sed '1,2d' | sed 's/	/,/g' | sed 's//,/g' | sed 's/  /,/g' | sed 's/ /,/g' | cut -d',' -f"$col_num" | sed '1i\ '$impact''$variable''$snptype'' | sed '/,0$/d' | sort -u | sed 's/ /,/g' >> "$VC_dir"/"$level"/"$impact"/"$run""$snptype""$impact".csv
count=$(cat "$VC_dir"/"$level"/"$impact"/"$run""$snptype""$impact".csv | wc -l)
  new_dir="$VC_dir"/final
  create_dir
  if [ ! -s "$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv ];
  then
echo "run,"$level""$impact""$snptype",readdepth" >> "$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv
  fi
  echo ""$run","$count","$readdepth"" >> "$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv
#else
  #echo "Can't find files for GVEX" ; exit ;
#fi
}
run_tools() {
if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
then
  if [ -f "$file_in" ]; # IF INPUT THERE
  then
echo1=$(echo "FOUND "$file_in" STARTING "$tool"")
mes_out
$tool # TOOL
  else
echo1=$(echo "CANT FIND "$file_in" FOR_THIS "$sample"")
mes_out # ERROR INPUT NOT THERE
  fi
  if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
  then
echo1=$(echo "FOUND "$file_out" FINISHED "$tool"")
mes_out # ERROR OUTPUT IS THERE
  else 
echo1=$(echo "CANT FIND "$file_out" FOR THIS "$sample"")
mes_out # ERROR INPUT NOT THERE
  fi
  else
echo1=FOUND_"$file_out"_FINISHED_"$tool"
mes_out # ERROR OUTPUT IS THERE
  fi
}
mes_out() {
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
}
DE_R() {
rlog="$dirresDEcal"/rlogandvariance.tiff
log="$dirresDEcal"/logtranscounts.tiff
transcounts="$dirresDEcal"/transcounts2sam.tiff
PoisHeatmap="$dirresDEcal"/PoisHeatmap.tiff
PCA="$dirresDEPCA"/PCAplot.tiff
PCA2="$dirresDEPCA"/PCAplot2.tiff
MDSplot="$dirresDEPCA"/MDSplot.tiff
MDSpois="$dirresDEPCA"/MDSpois.tiff
resultsall="$dirresDELDE"/resultsall.csv
upreg="$dirresDELDE"/upreg.csv
upreg100="$dirresDELDEvd"/upregGListtop100.csv
upregGlist="$dirresDELDEvd"/upregGList.csv
downreg="$dirresDELDE"/downreg.csv
downreg100="$dirresDELDEvd"/downregGListtop100.csv
downregGlist="$dirresDELDEvd"/downregGList.csv
heatmap="$dirresDELDE"/top60heatmap.tiff
volcano="$dirresDELDE"/VolcanoPlot.tiff
sed -i 's/set_design/'$condition_name'/g' "$ExToolset"/DE.R
Rscript "$ExToolset"/DE.R "$file_in" "$pheno" "$set_design" "$level_name" "$rlog" "$log" "$transcounts" "$PoisHeatmap" "$PCA" "$PCA2" "$MDSplot" "$MDSpois" "$resultsall" "$upreg" "$upreg100" "$upregGlist" "$downreg" "$downreg100" "$downregGlist" "$heatmap" "$volcano"
sed -i 's/'$condition_name'/set_design/g' "$ExToolset"/DE.R
}
GvennR() {
Rscript "$ExToolset"/Gvenn.R "$file_in" "$file_out" "$image_out"
}
home_dir="$1"
dir_path="$2"
ref_dir_path="$home_dir"/AIDD/references  # this is where references are stored
dirqc="$dir_path"/quality_control; # qc directory 
dirqcalign="$dirqc"/alignment_metrics
dirres="$dir_path"/Results; #
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix=$dir_path/AIDD/ExToolset/indexes
dirraw="$dir_path"/raw_data;
dirVC="$dirres"/variant_calling;
dirVCsubs="$dirVC"/substitutions;
matrix_file="$dirres"/gene_count_matrix.csv; 
matrix_file2="$dirres"/transcript_count_matrix.csv; 
matrix_fileedit="$dirres"/gene_count_matrixedited.csv;
matrix_fileedit2="$dirres"/transcript_count_matrixedited.csv;
matrix_file3="$dirres"/"$level"ofinterest_count_matrix.csv;
matrix_file3a="$dirres"/geneofinterest_count_matrix.csv;
matrix_file3b="$dirres"/transcriptofinterest_count_matrix.csv;
matrix_file4="$dirres"/excitome_count_matrix.csv;
matrix_file5="$dirres"/genetrans_count_matrix.csv;
matrix_file6="$dirres"/GTEX_count_matrix.csv;
matrix_file7="$dirres"/nucleotide_count_matrix.csv; 
matrix_file8="$dirres"/amino_acid_count_matrix.csv;
matrix_file9="$dirres"/subs_count_matrix.csv;
matrix_file10="$dirres"/impact_count_matrix.csv;
matrix_file11="$dirres"/VEX_count_matrix.csv;
matrix_filefinal="$dirres"/all_count_matrix.csv; 
data_summary_file1="$dirres"/geneofinterest/geneofinterestallsummaries.csv;
data_summary_file2="$dirres"/transcriptofinterest/transcriptofinterestallsummaries.csv;
data_summary_file3="$dirres"/excitome/excitomeallsummaries.csv;
data_summary_file3a="$dirres"/GTEXallsummaries.csv;
data_summary_file4="$dirres"/nucleotide/nucleotideallsummaries.csv;
data_summary_file5="$dirres"/amino_acid/amino_acidallsummaries.csv;
data_summary_file6="$dirres"/impact/impactallsummaries.csv;
data_summary_file6a="$dirres"/VEXallsummaries.csv;
data_summary_filefinal="$dirres"/allsummaries.csv;
cd "$dir_path"/AIDD
source config.shlib
con_name1=$(config_get con_name1);
con_name2=$(config_get con_name2);
con_name3=$(config_get con_name3);
cell_line="$3"
file_in="$dirres"/"$level"_count_matrixedited.csv
cat "$file_in" | awk -F',' '!v[$1]++' >> "$dir_path"/temp.csv
temp_file
echo1=$(echo "STARTING "$file_in"")
mes_out
file_in="$dirres"/"$level"_count_matrixedited.csv
pheno="$dir_path"/PHENO_DATA.csv
set_design="$condition_name"
level_name=level_name
dirresDE="$dirres"/DESeq2
new_dir="$dirresDE"
create_dir
dirresDElevel="$dirresDE"/"$level"
new_dir="$dirresDElevel"
create_dir
dirresDElevelcon="$dirresDElevel"/"$condition_name"
new_dir="$dirresDElevelcon"
create_dir
dirresDEcal="$dirresDElevelcon"/calibration
new_dir="$dirresDEcal"
create_dir
dirresDEPCA="$dirresDElevelcon"/PCA
new_dir="$dirresDEPCA"
create_dir
dirresDELDE="$dirresDElevelcon"/DE
new_dir="$dirresDELDE"
create_dir
dirresDELDEvd="$dirresDElevelcon"/DE/vennD
new_dir="$dirresDELDEvd"
create_dir
file_out="$dirresDELDE"/resultsall.csv
tool=DE_R
run_tools
for updown in upregGlist upreg100 downreg100 downregGlist ;
do
  file_in="$dirresDELDEvd"/"$updown".csv
  file_out="$dirresDELDEvd"/"$updown".txt
  image_out="$dirresDELDEvd"/"$updown".tiff
  tool=GvennR
  #run_tools
done
