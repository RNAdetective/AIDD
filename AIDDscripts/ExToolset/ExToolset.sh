#!/usr/bin/env bash
pheno_check() {
phenocheck=`awk 'BEGIN{FS=","}END{print NF}' "$pheno_file"`
tab_check=`awk -F "\t" 'NF != 6' "$pheno_file"`
tab_count=$(echo "$tab_check" | wc -l)
window_check=$(grep "\r" "$pheno_file")
if [ "$window_check" != "" ];
then
  sed -i 's/\r//g' "$pheno_file"
fi
if [ "$phenocheck" != 6 ] ; 
then
  echo1=$(echo "PHENO_DATA FILE DOES NOT HAVE CORRECT NUMBER OF COLUMNS: MAKE SURE IT IS IN THIS FORMAT sampname,run,condition,sample,condition2,condition3. If your experiment does not have 3 condition just put in NA in the unused columns")
  mes_out
  if [ "$tab_count" != "0" ];
  then
    sed -i 's/\t/,/g' "$pheno_file"
  fi
else
  echo1=$(echo "PHENO_DATA FILE IS READY")
  mes_out
fi
} # checks pheno_data file for tab instead of comman then fixes also checks for correct number of columns and removes any left over character from windows.
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
remove_stuff() {
if [ -f "$path" ];
then
 rm -f "$path"
fi
} # this removes $path
make_config() {
echo "home_dir="$home_dir"
dir_path="$dir_path"
ref_dir_path="$ref_dir_path"
ExToolset="$ExToolset"
dirqc="$dirqc"
dirqcalign="$dirqcalign"
dirres="$dirres"
dirraw="$dirraw"
dirVC="$dirVC"
dirVCsubs="$dirVCsubs"
ExToolsetix="$ExToolsetix"
summaryfile="$summaryfile"
matrix_file="$matrix_file" 
matrix_file2="$matrix_file2"
matrix_fileedit="$matrix_fileedit"
matrix_fileedit2="$matrix_fileedit2"
matrix_file3a="$matrix_file3a"
matrix_file3b="$matrix_file3b"
matrix_file3="$matrix_file3"
matrix_file4="$matrix_file4"
matrix_file5="$matrix_file5"
matrix_file6="$matrix_file6"
matrix_file7="$matrix_file7"
matrix_file8="$matrix_file8"
matrix_file9="$matrix_file9"
matrix_file10="$matrix_file10"
matrix_file11="$matrix_file11"
matrix_filefinal="$matrix_filefinal"
raw_input1="$raw_input1"
raw_input2="$raw_input2"
raw_input3="$raw_input3"
raw_input4="$raw_input4"
DATE_WITH_TIME="$DATE_WITH_TIME"
TIME_HOUR="$TIME_HOUR"
TIME_MIN="$TIME_MIN"
TIME_SEC="$TIME_SEC"
data_summary_file1="$data_summary_file1"
data_summary_file2="$data_summary_file2"
data_summary_file3="$data_summary_file3"
data_summary_file3a="$data_summary_file3a"
data_summary_file4="$data_summary_file4"
data_summary_file5="$data_summary_file5"
data_summary_file6="$data_summary_file6"
data_summary_file6a="$data_summary_file6a"
data_summary_filefinal="$data_summary_filefinal"" >> "$dir_path"/AIDD/config.cfg ###################add more to these
} # makes config.cfg file
make_cdef() {
echo "home_dir=Default Value
dir_path=Default Value
ref_dir_path=Default Value
ExToolset=Default Value
dirqc=Default Value 
dirqcalign=Default Value
dirres=Default Value
dirraw=Default Value
dirVC=Default Value
dirVCsubs=Default Value
ExToolsetix=Default Value
summaryfile=Default Value
matrix_file=Default Value
matrix_file2=Default Value
matrix_fileedit=Default Value
matrix_fileedit2=Default Value
matrix_file3a=Default Value
matrix_file3b=Default Value
matrix_file3=Default Value
matrix_file4=Default Value
matrix_file5=Default Value
matrix_file6=Default Value
matrix_file7=Default Value
matrix_file8=Default Value
matrix_file9=Default Value
matrix_file10=Default Value
matrix_file11=Default Value
matrix_filefinal=Default Value
raw_input1=Default Value
raw_input2=Default Value
raw_input3=Default Value
raw_input4=Default Value
DATE_WITH_TIME=Default Value
TIME_HOUR=Default Value
TIME_MIN=Default Value
TIME_SEC==Default Value
data_summary_file1=Default Value
data_summary_file2=Default Value
data_summary_file3=Default Value
data_summary_file3a=Default Value
data_summary_file4=Default Value
data_summary_file5=Default Value
data_summary_file6=Default Value
data_summary_file6a=Default Value
data_summary_filefinal=Default Value" >> "$dir_path"/AIDD/config.cfg.defaults
} # makes config.cfg.defualts file
get_file() {
if [ -s "$to_move" ];
then
  cp "$to_move" "$file_move"
else
  echo1=$(echo "CANT FIND "$to_move" STARTING PROCESS TO CREATE IT")
  mes_out
fi
} # gets to_move file and move to file_move
cond_file() {
cat "$dir_path"/PHENO_DATA.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f"$coln" | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed '1i freq,name' >> "$dir_path"/"$nam".csv
file_in="$dir_path"/"$nam".csv
file_out="$dir_path"/"$nam".tiff
bartype=single
tool=Rbar
run_tools
} # creates condition file
make_cdef2() {
echo "con_name1=$con_name1
con_name2=$con_name2
con_name3=$con_name3" >> "$dir_path"/AIDD/config.cfg.defaults
} # adds conditions to config files
move_directory() {
if [ -d "$dir_move" ];
then
  cp -r "$dir_move" "$final_dir"
else
  echo1=$(echo "CANT FIND "$dir_move" PLEASE MAKE SURE IT IS IN THE DESKTOP FOLDER")
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
if [ ! "$type3" == "none" ];
then
  if [ -s "$type3" ];
  then
    echo ""$run""$snptype"2,yes" >> "$filecheckVC"/filecheck"$snptype"3.csv
  else
    echo ""$run""$snptype"2,no" >> "$filecheckVC"/filecheck"$snptype"3.csv
  fi
fi
} # creates file check matrix each sample creates row in the new csv yes means files is there no means it is not
checkfile() {
  missing=$(grep -o 'no' "$in_file" | wc -l)
  if [ ! "$missing" == "0" ];
  then
    echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
    mes_out
  else
    echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
    mes_out
  fi
}
summary_split() {
cat "$dirqcalign"/"$run"_alignment_metrics.txt | sed '/^#/d' | sed 's/PAIR/'$run'/g' | sed '/^FIR/d' | sed '/^SEC/d' | sed 's/\t/,/g' | sed '1d' >> "$dirqcalign"/"$run"_alignment_metrics.csv
} #creates alignment matrix from txt file
combine_file() {
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" | sed '/^$/d' | awk -F',' '!x[$1]++' >> "$file_out"
} # cuts each column out of matrix and makes its own file
editmatrix() {
cat "$allcm" | sed 's/ADAR_001/ADARp150/g' | sed 's/ADAR_002/ADARp110/g' | sed 's/ADAR_007/ADARp80/g' | sed 's/ADARB1_/ADARB1./g' | sed 's/_[0-9]*//g' >> "$allcmedit"
}
createindex() {
cat "$allcmedit" | cut -d, --complement -f2-6 | sed 's/genename/sampname/g' | head -n 1 | tr ',' '\n' >> "$allindex"
}
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
sum_combine() {
cat "$dirqcalign"/*.csv | sed '/^$/d' | awk -F',' '!x[$1]++' >> "$dirqcalign"/all_summary.csv
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
bartype=$(echo "depth")
tool=Rbar
run_tools
} # makes big summary file matrix with all columns and creates bar graph
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
bartype=$(echo "depth")
tool=Rbar
run_tools
done
} # separates big summary into each category and creates bar graph
matrixeditor() {
Rscript "$ExToolset"/matrixedit.R "$file_out" "$file_in" "$index_file" "$pheno_file" "$Rtool" "$level_id" "$level_name" "$filter_type" "$level" "$tempf1" "$tempf2" "$tempf3"
} # creates matrix counts with names instead of ids and checks to make sure they are there
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$GOI_file" "$temp_file1" "$temp_file2" "$temp_file3" "$rename" #creates level of interest files
} # Runs multimerge R
creatematrix() {
cd "$dir_path"/raw_data/
python "$ExToolset"/prepDE.py -g "$dirres"/gene_count_matrix.csv -t "$dirres"/transcript_count_matrix.csv
cd "$dir_path"/AIDD/
} # runs python script to summarize gtf files in count matrix
filter_impact() {
#any_no= # count how many lines contain no "$filecheckVC"/filecheck"$snptype"2.csv
#if [ "$any_no" == "0" ];
#then
addcondition=$(echo ""$con_name1"_"$condition"_"$con_name2"_"$condition2"_"$con_name3"_"$condition3"_"$con_name4"_"$condition4"")
  cat "$raw_input4" | sed '1,2d' | sed 's/	/,/g' | sed 's/    /,/g' | sed 's/  /,/g' | sed 's/ /,/g' | cut -d',' -f"$col_num" | sed '/,0$/d'  | sed 's/ /,/g' | awk '{a[$1]+=$2}END{for(k in a)print k,a[k]}' FS=, OFS=, | sort | sed '1i id,'$run'' >> "$VC_dir"/"$level"/"$impact"/"$run""$snptype""$addcondition".csv
count=$(cat "$VC_dir"/"$level"/"$impact"/"$run""$snptype""$addcondition".csv | wc -l)
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
} # this will create impact files for each sample
splitallmatrix() {
var=$(head -n 1 "$olddirres"/all_count_matrix.csv)
grep -n -w -F  "$name" "$olddirres"/all_count_matrix.csv | sed '1i '$var'' | sed 's/[0-9]://g' >> "$dirres"/all/all_count_matrixedit.csv
}
PDsplit() {
header=$(head -n 1 "$dir_path"/PHENO_DATA.csv)
grep -n -w -F "$name" "$dir_path"/PHENO_DATA.csv | sed '1i '$header'' | sed 's/[0-9]://g' | sed 's/_[0-9]//g' >> "$dirres"/PHENO_DATA.csv
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
end_check() {
if [ "$var1" == "$varA" ];
then
  "$tool"
  cd "$home_dir"/scripts
fi
}

temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
temp_dir() {
if [ -d "$dir_path"/raw_data/ballgown/"$sample"/tmp.XX*/ ]; # IF TEMP_DIR IN SAMPLE FOLDER
then
  echo1=$(echo "FOUND TEMP DIRECTORY IN FOLDER FOR "$sample"")
  mes_out
  rm -f -R "$dir_path"/raw_data/ballgown/"$sample"/tmp.XX*/ #DELETE TMP_DIR
fi
} # deletes any temp directories created in error from stringtie
run_tools() {
if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
then
  if [ -f "$file_in" ]; # IF INPUT THERE
  then
    echo1=$(echo "FOUND $file_in STARTING $tool");
    mes_out
    $tool # TOOL
  else
    echo1=$(echo "CANNOT FIND "$file_in" FOR "$sample"");
  fi
  if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND $file_out FINISHED $tool");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND $file_out FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$(echo "FOUND $file_out FINISHED $tool")
  mes_out # ERROR OUTPUT IS THERE
fi
}
mes_out() {
dirqc="$dir_path"/quality_control
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$run","$file_in","$tool"" >> "$dirqc"/time_check/"$run"time_check.csv
}
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
TIME_HOUR=$(date +%H)
TIME_MIN=$(date +%M)
TIME_SEC=$(date +%S)
default="$1"
home_dir="$2" # home_dir=/home/user
dir_path="$3" # dir_path=/home/user/testAIDD 
ref_dir_path="$home_dir"/AIDD/references  # this is where references are stored
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
dirqc="$dir_path"/quality_control; # qc directory 
dirqcalign="$dirqc"/alignment_metrics
dirres="$dir_path"/Results; #
dirraw="$dir_path"/raw_data;
dirVC="$dirres"/variant_calling;
dirVCsubs="$dirVC"/substitutions;
summaryfile="$dir_path"/quality_control/alignment_metrics/all_summaryPF_READS_ALIGNED.csv
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
data_summary_file2="$dirres"/transcriptofinterest/transcriptofinterest.csv;
data_summary_file3="$dirres"/excitome/excitomeallsummaries.csv;
data_summary_file3a="$dirres"/GTEXallsummaries.csv;
data_summary_file4="$dirres"/nucleotide/nucleotideallsummaries.csv;
data_summary_file5="$dirres"/amino_acid/amino_acidallsummaries.csv;
data_summary_file6="$dirres"/impact/impactallsummaries.csv;
data_summary_file6a="$dirres"/VEXallsummaries.csv;
data_summary_filefinal="$dirres"/allsummaries.csv;
if [ "$default" == "2" ];
then
###############################################################################################################################################################
# CREATE DIRECTORIES                                                                                                                           *TESTED
###############################################################################################################################################################
echo1=$(echo "CREATING DIRECTORIES")
mes_out
new_dir="$dir_path"
create_dir # creates new directory to store results
new_dir="$dirres"
#add in move matrix files 
create_dir # creates Results directory
new_dir="$dir_path"/raw_data # creates directories for raw data
create_dir
new_dir="$dir_path"/raw_data/vcf_files # creates directories for vcf files 
create_dir
new_dir="$dirqc" # creates directories for quality control
create_dir
new_dir="$dir_path"/AIDD # creates directory for scripts and config files
create_dir
if [ -d "$home_dir"/AIDD/AIDD ];
then
  cp -r "$home_dir"/AIDD/AIDD/* "$dir_path"/AIDD # get AIDD scripts with ExToolset
else
  new_dir="$dir_path"/AIDD/ExToolset
  create_dir
  cp -r "$home_dir"/ExToolset/* "$dir_path"/AIDD/ExToolset # get ExToolset scripts
fi
###############################################################################################################################################################
# CREATE CONFIG FILES AND ADD CONDITION VARIABLES                                                                                              *TESTED
###############################################################################################################################################################
echo1=$(echo "CREATING CONFIG FILES")
mes_out
for config in config.cfg config.cfg.defaults config.R listofconditions.csv ;
do
  path="$dir_path"/AIDD/"$config"
  remove_stuff # get rid of existing config files
done
make_config # makes config files
make_cdef # makes config default files
to_move="$home_dir"/Desktop/PHENO_DATA.csv
pheno_file=$to_move
pheno_check
sed -i 's/\r//g' "$to_move"
file_move="$dir_path"/PHENO_DATA.csv
sed -i 's/\r//g' "$file_move"
if [ ! -f "$file_move" ];
then
  get_file
fi
file_in="$dir_path"/PHENO_DATA.csv
cat "$file_in" | sed 's/ //g' | sed '/^$/d' >> "$dir_path"/temp.csv
temp_file
cat "$dir_path"/PHENO_DATA.csv | awk 'NR==1' | sed 's/,/ /g' | sed "s/ /\n/g" | sed '1d' | sed '1d' | sed '2d' | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' >> "$dir_path"/AIDD/listofconditions.csv # creates list of conditions file 
cd "$dir_path"/AIDD
cat "$dir_path"/PHENO_DATA.csv | sed 's/_[0-9]*//g' >> "$dir_path"/PHENO_DATAtemp.csv
allcon=$(awk -F, 'NR==1{print $1}' "$dir_path"/PHENO_DATAtemp.csv)
nam="$allcon"
cat "$dir_path"/PHENO_DATAtemp.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f1 | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed '1i freq,name' >> "$dir_path"/"$nam".csv
file_in="$dir_path"/"$nam".csv
file_out="$dir_path"/"$nam".tiff
bartype=single
tool=Rbar
run_tools
con_name1=$(awk -F, 'NR==1{print $3}' "$dir_path"/PHENO_DATA.csv)
coln=3
nam="$con_name1"
cond_file
con_name2=$(awk -F, 'NR==1{print $5}' "$dir_path"/PHENO_DATA.csv)
coln=5
nam="$con_name2"
cond_file
con_name3=$(awk -F, 'NR==1{print $6}' "$dir_path"/PHENO_DATA.csv)
coln=6
nam="$con_name3"
cond_file
make_cdef2
###############################################################################################################################################################
# MOVES AVAILABLE MATRIX AND/OR RAW DATA                                                                                                       *TESTED
###############################################################################################################################################################
echo1=$(echo "MOVING RAW DATA")
mes_out
for type in all amino_acid impact nucleotide subs gene transcript GTEX ; # enter matrixes to grab here if they are not here and can't be moved they will be created later.
do
  to_move="$home_dir"/Desktop/put_counts_here/"$type"_count_matrix.csv
  file_move="$dirres"/"$type"_count_matrix.csv
  get_file
done
for type in ballgown alignment_metrics snpEff ; # raw data files
do
  dir_move="$home_dir"/Desktop/put_counts_here/"$type"
  final_dir="$dir_path"/raw_data/"$type"
  if [ "$type" == "alignment_metrics" ];
  then
    final_dir="$dirqc"/"$type"
  fi
  move_directory
done
fi
###############################################################################################################################################################
# CREATE FILE CHECK FILES TO CHECK FOR RAW DATA FILES                                                                                *TESTED
###############################################################################################################################################################
cd "$dir_path"/AIDD
new_dir="$dir_path"/Results
create_dir
echo1=$(echo "CHECKING DATA")
mes_out
sed -i 's/\r//g' "$dir_path"/PHENO_DATA.csv
#sed -i 's/\r//g' "$dir_path"/PHENO_DATAalign.csv
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path); 
  dirqc=$(config_get dirqc);
  dirraw=$(config_get dirraw);
  dirVC=$(config_get dirVC);
  dirVCsubs=$(config_get dirVCsubs);
  raw_input1="$dir_path"/raw_data/ballgown/"$sample"/"$sample".gtf
  raw_input2="$dirqc"/alignment_metrics/"$run"_alignment_metrics.txt
  new_dir="$dirqc"
  create_dir
  new_dir="$dirqc"/filecheck
  create_dir
  new_dir="$dirqc"/filecheckVC
  create_dir
  filecheckVC="$dirqc"/filecheck
  type1="$raw_input1"
  type2=none
  type3=none
  snptype=gtf
  temp_dir # delete temp directories if present
  create_filecheck
  type1=none
  type2="$raw_input2"
  type3=none
  snptype=summary
  create_filecheck
  for snptype in ADARediting APOBECediting All ;
  do
    filecheckVC="$dirqc"/filecheckVC
    raw_input3="$dirraw"/snpEff/snpEff"$run""$snptype".csv
    type1="$raw_input3"
    type2=none
    type3=none
    create_filecheck
    filecheckVC="$dirqc"/filecheckVC
    raw_input4="$dir_path"/raw_data/snpEff/snpEff"$run""$snptype".genes.txt
    type2="$raw_input4"
    type1=none
    type3=none
    create_filecheck
    filecheckVC="$dirqc"/filecheckVC
    raw_input5="$dir_path"/raw_data/snpEff/"$run"filtered_snps_finalAnn"$snptype".vcf
    type2=none
    type1=none
    type3="$raw_input5"
    create_filecheck
  done
done 
} < $INPUT
IFS=$OLDIFS
raw_check1="$dirqc"/filecheck/filecheckgtf1.csv #gtf
raw_check2="$dirqc"/filecheck/filechecksummary2.csv #align
for in_file in "$raw_check1" "$raw_check2" ;
do
  checkfile
done
for snptype in ADARediting APOBECediting All ;
do
  raw_check3="$dirqc"/filecheckVC/filecheck"$snptype"1.csv #snpeff.csv
  for in_file in "$raw_check3" ;
  do
    checkfile
  done
done
for snptype in ADARediting APOBECediting All ;
do
  raw_check4="$dirqc"/filecheckVC/filecheck"$snptype"2.csv #snpeff.txt
  for in_file in "$raw_check4" ;
  do
    checkfile
  done
done
for snptype in ADARediting APOBECediting All ;
do
  raw_check5="$dirqc"/filecheckVC/filecheck"$snptype"3.csv #Ann.vcf
  for in_file in "$raw_check5" ;
  do
    checkfile
  done
done
###############################################################################################################################################################
# CREATE ALIGNMENT SUMMARY FILE FOR NORMALIZATION IN EXTOOLSET                                                                                 *TESTED
###############################################################################################################################################################
echo1=$(echo "COLLECTING ALIGNMENT SUMMARIES")
mes_out
if [ ! -s "$matrix_file" ]; # can't find edited matrix
then
  cd "$dir_path"/AIDD
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirqc=$(config_get dirqc);
    filecheck="$dirqc"/filecheck
    in_file="$filecheck"/filechecksummary2.csv
    missing=$(grep -o 'no' "$in_file" | wc -l)
    if [ ! "$missing" == "0" ];
    then
      echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
      mes_out
    else
      echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
      mes_out
      summary_split
    fi
  done
  } < $INPUT
  IFS=$OLDIFS
  sum_combine
  sum_divid
  cd "$dir_path"/AIDD
else
  echo1=$(echo "found "$matrix_file" moving on")
  mes_out
fi
###############################################################################################################################################################
# CREATES GTEX                                                                                                                                    *TESTED
###############################################################################################################################################################
echo1=$(echo "CREATING GTEX MATRIX")
mes_out
if [[ ! -s "$matrix_file" || ! -s "$matrix_file2" ]]; # can't find edited matrix
then
  filecheck="$dirqc"/filecheck
  in_file="$filecheck"/filecheckgtf1.csv
  missing=$(grep -o 'no' "$in_file" | wc -l)
  if [ ! "$missing" == "0" ];
  then
    echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
    mes_out
  else
    echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
    mes_out
    creatematrix
  fi
else
  echo1=$(echo "ALREADY FOUND "$matrix_file" AND "$matrix_file2"")
  mes_out
fi # THIS WILL CREATE GENE_COUNT_MATRIX AND TRANSCRIPT_COUNT_MATRIX
cd "$dir_path"/AIDD
for level in gene transcript ;
do
  if [[ -s "$matrix_file" && -s "$matrix_file2" ]];
  then
    if [[ ! -s "$matrix_fileedit" || ! -s "$matrix_fileedit2" ]];
    then
      filecheck="$dirqc"/filecheck
      in_file="$filecheck"/filecheckgtf1.csv
      missing=$(grep -o 'no' "$in_file" | wc -l)
      if [ ! "$missing" == "0" ];
      then
        echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
        mes_out
      else
        echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
        mes_out
        file_out="$dirres"/"$level"_count_matrixedited.csv
        file_in="$dirres"/"$level"_count_matrix.csv
        index_file="$ExToolsetix"/index/"$level"_names.csv
        pheno_file="$dir_path"/PHENO_DATA.csv
        Rtool=GTEX
        level_id=$(echo ""$level"_id");
        level_name=$(echo ""$level"_name");
        filter_type=$(echo "protein_coding");
        level="$level"
        tempf1="$dir_path"/tempR1.csv
        tempf2="$dir_path"/tempR2.csv
        tempf3="$dir_path"/tempR3.csv
        sed -i 's/-/_/g' "$index_file"
        echo1=$(echo "CREATING "$file_out"")
        mes_out
        matrixeditor
        header=$(head -n 1 "$file_out")
        cat "$file_out" | awk -F',' 'NR > 1{s=0; for (i=3;i<=NF;i++) s+=$i; if (s!=0)print}' | sort -u -k1 | sed '1i '$level'_name'$header'' >> "$dir_path"/temp.csv
        file_in="$file_out"
        temp_file
      fi
    else
      echo1=$(echo "ALREADY FOUND "$matrix_fileedit" OR "$matrix_fileedit2"")
      mes_out
    fi
  else
    echo1=$(echo "CANT FIND "$matrix_file" OR "$matrix_file2"")
    mes_out
  fi
done # NOW HAVE GENE AND TRANSCRIPT OF INTEREST FILES AND EDITED COUNT_MATRIX FILES
if [ ! "$missing" == "0" ];
then
  echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
  mes_out
else
  echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
  mes_out
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres=$(config_get dirres);
    for level in gene transcript ;
    do
      file_out="$dirres"/"$level"_count_matrixedited.csv
      header=$(head -n 1 "$file_out")
      cat "$file_out" | sed '1d' | sed 's/'$sample'/'$samp_name'/g' | sed '1i '$header'' >> "$dir_path"/temp.csv
      file_in="$file_out"
      temp_file
    done
  done 
  } < $INPUT
  IFS=$OLDIFS
fi
## combine all the files in desktop folder
## add them to the bottom of "$home_dir"/insert_"$level"_of_interest/"$level"ofinterest.csv
for level in gene transcript ;
do
  if [[ -s "$matrix_fileedit" && -s "$matrix_fileedit2" ]];
  then
    if [[ ! -s "$matrix_file3" && ! -s "$matrix_file3b" ]];
    then
      cur_wkd="$dirres"
      summaryfile=none
      Rtool=transpose
      Rtype=single2f
      file_out="$dirres"/"$level"ofinterest_count_matrix.csv #3
      mergefile="$ExToolsetix"/"$level"_list/DESeq2/"$level"ofinterest.csv #7
      phenofile="$dirres"/"$level"_count_matrixedited.csv #8
      level_name=$(echo ""$level"_name")
      sed -i 's/-/_/g' "$mergefile"
      echo1=$(echo "CREATING "$file_out"")
      mes_out
      mergeR
      sed -i 's/   //g' "$file_out"
      sed -i 's/  //g' "$file_out"
    else
      echo1=$(echo "ALREADY FOUND "$matrix_file3"")
      mes_out
    fi
  else
    echo1=$(echo "CANT FIND "$matrix_fileedit" OR "$matrix_fileedit2"")
    mes_out
  fi
done
if [ -s "$matrix_file" ];
then
  if [ ! -s "$matrix_file4" ];
  then
    cur_wkd="$dirres"
    summaryfile=none
    Rtool=transpose
    Rtype=single2f
    file_out="$dirres"/excitome_count_matrix.csv
    mergefile="$ExToolsetix"/gene_list/DESeq2/excitome.csv
    phenofile="$dirres"/gene_count_matrixedited.csv
    level_name=$(echo "gene_name")
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
  else
    echo1=$(echo "ALREADY FOUND "$matrix_file4"")
    mes_out
  fi
else
  echo1=$(echo "CANT FIND "$matrix_file"") 
  mes_out
fi # NOW HAVE EXCTIOME MATRIX
if [ -s "$matrix_file" ];
then
  for level in gene transcript ;
  do
    user_GOI="$home_dir"/Desktop/insert_"$level"_of_interest
    for files in "$user_GOI"/* ;
    do
      dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 6 -d '.')
      file_name=$(echo "$dir_name" | cut -f 1 -d '.')
      echo "$file_name"
      echo ""$file_name"" >> "$dir_path"/AIDD/ExToolset/indexes/"$level"_list/user_input_"$level"list.csv
      matrix_file4a="$dirres"/"$file_name"_count_matrix.csv
      if [ ! -s "$matrix_file4a" ];
      then
        cur_wkd="$dirres"
        summaryfile=none
        Rtool=transpose
        Rtype=single2f
        file_out="$dirres"/"$file_name"_count_matrix.csv
        mergefile="$user_GOI"/"$file_name".csv
        phenofile="$dirres"/"$level"_count_matrixedited.csv
        level_name=$(echo ""$level"_name")
        summaryfile="$dir_path"/PHENO_DATA.csv
        GOI_file=GOItrue
        echo1=$(echo "CREATING "$file_out"")
        mes_out
        mergeR
      else
        echo1=$(echo "ALREADY FOUND "$matrix_file4a"")
        mes_out
      fi
    done
  done
else
  echo1=$(echo "CANT FIND "$matrix_file"") 
  mes_out
fi # NOW HAVE USE SUPPLIED GENE OR TRANSCRIPT OF INTEREST FILES
if [[ -s "$matrix_file3a" && -s "$matrix_file3b" ]];
then
  if [ ! -s "$matrix_file5" ];
  then
    cur_wkd="$dirres"
    summaryfile=none
    Rtool=finalmerge
    Rtype=single2f
    level_name=$(echo "gene_name")
    summaryfile="$dir_path"/PHENO_DATA.csv
    GOI_file=GOItrue
    file_out="$dirres"/genetrans_count_matrix.csv
    mergefile="$dirres"/geneofinterest_count_matrix.csv
    phenofile="$dirres"/transcriptofinterest_count_matrix.csv
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
  else
    echo1=$(echo "ALREADY FOUND "$matrix_file5"")
    mes_out
  fi
else
  echo1=$(echo "CANT FIND "$matrix_file3a" OR "$matrix_file3b"") 
  mes_out
fi # NOW HAVE genetrans MATRIX
if [[ -s "$matrix_file5" && -s "$matrix_file4" ]];
then
  if [ ! -s "$matrix_file6" ];
  then
    Rtool=finalmerge
    Rtype=single2f
    GOI_file=none
    file_out="$dirres"/GTEX_count_matrix.csv
    mergefile="$dirres"/excitome_count_matrix.csv
    phenofile="$dirres"/genetrans_count_matrix.csv
    level_name=$(echo "gene_name")
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
  else
    echo1=$(echo "ALREADY FOUND "$matrix_file6"")
    mes_out
  fi
else
  echo1=$(echo "CANT FIND "$matrix_file5" OR "$matrix_file4"") 
  mes_out
fi # NOW HAVE GTEX MATRIX
###############################################################################################################################################################
# Global substitution variant matrix G_VEX matrix                                                                                            *TESTED
############################################################################################################################################################### 
echo1=$(echo "CREATING G_VEX MATRIX")
mes_out
new_dir="$dirVC"
create_dir
new_dir="$dirVCsubs"
create_dir
if [[ ! -s "$matrix_file7"  && ! -s "$matrix_file8" ]]; # can't find edited matrix
then
  cd "$dir_path"/AIDD
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path); 
    dirqc=$(config_get dirqc);
    dirraw=$(config_get dirraw);
    dirVC=$(config_get dirVC);
    dirVCsubs=$(config_get dirVCsubs);
    echo1="STARTING G_VEX FOR "$run" VARIANTS"
    mes_out
    for snptype in ADARediting APOBECediting All ;
    do
      filecheck="$dirqc"/filecheckVC
      in_file="$filecheck"/filecheck"$snptype"1.csv
      missing=$(grep -o 'no' "$in_file" | wc -l)
      if [ ! "$missing" == "0" ];
      then
        echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
        mes_out
      else
        echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
        mes_out
        raw_input3="$dirraw"/snpEff/snpEff"$run""$snptype".csv
        cat "$raw_input3" | sed '1d' | sed 's/# />/g' | sed 's/\//_/g' | sed  '/^\s*$/d' | sed 's/Base/'$run'nucleotide_count_matrixprep/g' | sed 's/Amino/'$run'amino_acid_count_matrixprep/g' >> "$dirVCsubs"/"$run""$snptype".csv
        new_dir="$dirVCsubs"/raw/
        create_dir
        new_dir="$dirVCsubs"/raw/"$run""$snptype"
        create_dir
        cd "$dirVCsubs"/raw/"$run""$snptype"
        csplit -s -z "$dirVCsubs"/"$run""$snptype".csv '/>/' '{*}' # take the sample new csv file and split"
        for i in xx* ; do \
          n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
          mv "$i" "$n.csv" ; \
          sed -i '1d' ""$n".csv"
        done # now you have split files for each sample in the folder
        cd "$dir_path"/AIDD/
        for level in nucleotide amino_acid ;
        do
          new_dir="$dirVC"/"$level"
          create_dir
          file_in="$dirVCsubs"/raw/"$run""$snptype"/"$run""$level"_count_matrixprep.csv # this has the raw matrix for need to vector
          new_wkd="$dirVC"/"$level"/merge"$snptype"
          new_dir="$new_wkd"
          create_dir
          sed -i 's/  //g'  "$file_in"
          sed -i 's/ //g' "$file_in"
          index_file="$ExToolsetix"/index/"$level"_names.csv
          pheno_file="$new_wkd"/"$run""$level"_count_matrixprep.csv # output file directory name
          Rtool=G_VEX
          tempf1="$dir_path"/tempR1.csv
          tempf2="$dir_path"/tempR2.csv
          tempf3="$dir_path"/tempR3.csv
          matrixeditor 
          cat "$pheno_file" | cut -d',' -f2,3 | sed '1d' | sed '1i sub_names,'$run'' >> "$dir_path"/temp.csv
          if [ -s ""$dir_path"/temp.csv" ];
          then
            rm "$pheno_file"
          fi
          mv "$dir_path"/temp.csv "$pheno_file"
        done
      fi
    done
  done 
  } < $INPUT
  IFS=$OLDIFS
  summaryfile="$dir_path"/quality_control/alignment_metrics/all_summaryPF_READS_ALIGNED.csv
  run=$(awk -F',' 'NR==2 { print $2 }' "$dir_path"/PHENO_DATA.csv)
  sed -i 's/'$run'/'$run'.x/g' "$summaryfile"
  if [ -s "$summaryfile" ];
  then
    for snptype in ADARediting APOBECediting All ;
    do
      for level in nucleotide amino_acid ;
      do
        cur_wkd="$dirVC"/"$level"/merge"$snptype";
        file_out="$dirVC"/"$level"/"$level""$snptype"_count_matrix.csv
        cd "$dirVC"/"$level"/merge"$snptype"
        Rtool=G_VEX
        Rtype=multi
        GOI_file="$dirVC"/"$level"/temp.csv
        names=$(echo "sub_names")
        mergefile=none
        phenofile=none
        temp_file1="$dirVC"/"$level"/temp2.csv
        echo1=$(echo "CREATING "$file_out"")
        mes_out
        mergeR
        summary=$(head -n 1 "$file_out" | awk -F',' '{ print NF }')
        totcol=$(expr "$summary" - "1")
        newcol_num=$(expr "$summary" + "1")
        for sub_col in $(seq "2" "$totcol") ;
        do
          newcol_num=$(expr "$totcol" + "$sub_col")
          subname=$(awk -F',' 'NR==1 { print $'$sub_col' }' "$file_out")
          norm=$(echo "10000")
          cat "$file_out" | awk -F',' '{$'$newcol_num' = sprintf("%.5f", $'$sub_col' / $'$summary' * '$norm')}1' | sed 's/-nan/'$subname'norm/g' | sed 's/      /,/g' | sed 's/  /,/g' | sed 's/ /,/g' | sed 's/.x//g' | awk -F',' '!x[$1]++' >> "$dir_path"/temp3.csv
          if [ -s ""$dir_path"/temp3.csv" ];
          then
            rm "$file_out"
            mv "$dir_path"/temp3.csv "$file_out"
          fi
        done
      done
    done
  sed -i 's/.x//g' "$summaryfile"
  sed -i 's/.y//g' "$summaryfile"
  else
    echo1=$(echo "CANT FIND "$summaryfile"")
    mes_out
  fi
  cd "$dir_path"/AIDD/ 
  for level in nucleotide amino_acid ;
  do
    snptype=All
    final_file="$dirVC"/"$level"/"$level""$snptype"_count_matrix.csv
    if [ -s "$final_file" ];
    then
      final_file2="$dirres"/"$level"_count_matrix.csv
      cp "$final_file" "$final_file2"
      if [ "$level" == "amino_acid" ];
      then
        cat "$final_file2" | sed 's/.x//g' | sed 's/.y//g' | cut -d',' --complement -f2-15 | sed '/inf/d' >> "$dir_path"/temp.csv
        file_in="$final_file2"
        temp_file
      fi
      if [ "$level" == "nucleotide" ];
      then
        cat "$final_file2" | sed 's/.x//g' | sed 's/.y//g' | cut -d',' --complement -f2-18 | sed '/inf/d' >> "$dir_path"/temp.csv
        file_in="$final_file2"
        temp_file
      fi
    fi
  done
else
  echo1=$(echo "ALREADY FOUND "$matrix_file7" OR "$matrix_file7"")
  mes_out
fi # NOW YOU HAVE AMINO_ACID AND NUCLEOTIDE MATRIX  
if [[ -s "$matrix_file7" && -s "$matrix_file8" ]];
then
  if [ ! -s "$matrix_file9" ]; # can't find edited matrix
  then
    cur_wkd="$dirVC"
    summaryfile="$dirres"/amino_acid_count_matrix.csv #

    Rtool=none
    Rtype=single
    file_out="$dirres"/subs_count_matrix.csv
    mergefile="$dirres"/nucleotide_count_matrix.csv #file_in
    phenofile="$dir_path"/PHENO_DATA.csv
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    sed -i 's/\n//g' "$file_out"
  else
    echo1=$(echo "ALREADY FOUND "$matrix_file9"")
    mes_out
  fi
else
  echo1=$(echo "CANT FIND "$matrix_file7" OR "$matrix_file8"")
  mes_out
fi
###############################################################################################################################################################
# Impact of RNA editing matrix I_VEX matrix                                                                                                        *TESTED
###############################################################################################################################################################
echo1=$(echo "CREATING I_VEX MATRIX")
mes_out
cd "$dir_path"/AIDD
summaryfile="$dir_path"/quality_control/alignment_metrics/all_summaryPF_READS_ALIGNED.csv
sed -i 's/name/CATEGORY/g' "$summaryfile"
if [ ! -s "$matrix_file10" ]; # can't find edited matrix
then 
  if [ -s "$summaryfile" ];
  then
    cur_wkd="$dirres"/variant_calling
    Rtool=none
    Rtype=onesingle
    file_out="$dir_path"/PHENO_DATAalign.csv
    mergefile=none
    phenofile="$dir_path"/PHENO_DATA.csv
    sed -i 's/.x//g' "$summaryfile"
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    file_in="$dir_path"/PHENO_DATAalign.csv
    file_out="$dir_path"/readdepth.tiff
    bartype=readdepth
    tool=Rbar
    run_tools
    file_in="$dir_path"/PHENO_DATAalign.csv
    cat "$file_in" | awk -F',' '!x[$0]++' >> "$dir_path"/temp.csv
    temp_file
    INPUT="$dir_path"/PHENO_DATAalign.csv
    OLDIFS=$IFS
    {
    IFS=,
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    read
    while read  run samp_name condition sample condition2 condition3 readdepth
    do
      source config.shlib
      dir_path="$(config_get dir_path)"; # main directory
      home_dir="$(config_get home_dir)"; # home directory
      dirqc="$dir_path"/quality_control; # qc directory 
      wkd="$dirres";
      VC_dir="$dirres"/variant_calling/impact
      con_name1=$(config_get con_name1);
      con_name2=$(config_get con_name2);
      con_name3=$(config_get con_name3);
      echo1=$(echo "Now starting "$run" which is "$con_name1"="$condition", "$con_name2"="$condition2", "$con_name3"="$condition3", and has read depth of "$readdepth"")
      mes_out
      new_dir="$VC_dir"
      create_dir
      for level in gene transcript ;
      do
        new_dir="$VC_dir"/"$level"
        create_dir
        for impact in high_impact moderate_impact ;
        do
          new_dir="$VC_dir"/"$level"/"$impact"
          create_dir      
          for snptype in ADARediting APOBECediting All ;
          do
            filecheck="$dirqc"/filecheckVC
            in_file="$filecheck"/filecheck"$snptype"2.csv
            missing=$(grep -o 'no' "$in_file" | wc -l)
            if [ ! "$missing" == "0" ];
            then
              echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
              mes_out
            else
              echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
              mes_out
              raw_input4="$dir_path"/raw_data/snpEff/snpEff"$run""$snptype".genes.txt
              if [[ "$level" == "gene" && "$impact" == "high_impact" ]];
              then
                col_num="2,5"
                filter_impact
              fi
              if [[ "$level" == "gene" && "$impact" == "moderate_impact" ]];
              then
                col_num="2,7"
                filter_impact
              fi
              if [[ "$level" == "transcript" && "$impact" == "high_impact" ]];
              then
                col_num="3,5"
                filter_impact
              fi
              if [[ "$level" == "transcript" && "$impact" == "moderate_impact" ]];
              then
                col_num="3,7"
                filter_impact
              fi
            fi
          done
        done
      done
    done
    } < $INPUT
    IFS=$OLDIFS # creates count matrix
    source config.shlib
    dir_path="$(config_get dir_path)"; # main directory
    home_dir="$(config_get home_dir)"; # home directory
    dirres="$dir_path"/Results
    VC_dir="$dirres"/variant_calling/impact
    for level in gene transcript ;
    do
      for impact in high_impact moderate_impact ;
      do
        for snptype in ADARediting APOBECediting All ;
        do
          file_in="$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv
          if [ -s "$file_in" ];
          then
            #cat "$file_in" | awk -F',' '!x[$1]++' >> "$dir_path"/temp.csv
            #temp_file
            #file_in="$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv
            echo1=$(echo ""$file_in" FOUND")
            mes_out
            summary=$(head -n 1 "$file_in" | awk -F',' '{ print NF }')
            counts=$(expr "$summary" - "1")
            newcol_num=$(expr "$summary" + "1")
            norm=$(echo "10000")
            cut_col=$(echo "1,"$newcol_num"")
            cat "$file_in" | awk -F',' '{$'$newcol_num' = sprintf("%.5f", $'$counts' / $'$summary' * '$norm')}1'| sed 's/-nan/'$level''$impact''$snptype'normalized/g' | sed 's/ /,/g' | cut -d',' -f"$cut_col" | (read -r; printf "%s\n" "$REPLY"; sort) | uniq >> "$dir_path"/temp.csv
            temp_file
          else
            echo1=$(echo ""$file_in" NOT FOUND")
            mes_out
          fi
        done
      done
    done
    cd "$VC_dir"/final
    cur_wkd="$VC_dir"
    Rtool=$(echo "I_VEX")
    Rtype=$(echo "multi")
    summaryfile=none
    names=$(echo "run")
    file_out="$dirres"/variant_calling/impact/impact_count_matrix.csv
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    file_in="$dirres"/variant_calling/impact/impact_count_matrix.csv
    cat "$file_in" | cut -d',' --complement -f2 | sed 's/.y//g' >> "$dir_path"/temp.csv
    temp_file
    cp "$file_in" "$dirres"/
  else
    echo1=$(echo "CANT FIND "$summaryfile"")
    mes_out
  fi
else
  echo1=$(echo "ALREADY HAVE "$matrix_file10"")
  mes_out
fi
###############################################################################################################################################################
# COMBINING MATRICES                                                                                                        *TESTED
###############################################################################################################################################################
if [ ! -s "$matrix_file11" ];
then
  if [[ -s "$matrix_file10" && -s "$matrix_file9" ]];
  then
    cur_wkd="$dirres"/variant_calling
    summaryfile=none
    Rtool=finalmerge
    Rtype=single2f
    file_out="$dirres"/VEX_count_matrix.csv
    mergefile="$dirres"/subs_count_matrix.csv
    phenofile="$dirres"/impact_count_matrix.csv
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
  else
    echo1=$(echo "CANT FIND "$matrix_file10" OR "$matrix_file9"")
    mes_out
  fi
else
  echo1=$(echo "ALREADY FOUND "$matrix_file11"")
  mes_out
fi
if [ ! -s "$matrix_filefinal" ];
then
  if [ -s "$matrix_file11" ];
  then
    cd "$dir_path"/AIDD
    INPUT="$dir_path"/PHENO_DATA.csv
    OLDIFS=$IFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    read
    while IFS=, read -r samp_name run condition sample condition2 condition3
    do
      source config.shlib;
      home_dir=$(config_get home_dir);
      dir_path=$(config_get dir_path);
      dirres=$(config_get dirres);
      for level in gene transcript ;
      do
        file_out="$dirres"/VEX_count_matrix.csv
        cat "$file_out" | sed 's/'$run'/'$samp_name'/g' >> "$dir_path"/temp.csv
        file_in="$file_out"
        temp_file
      done
    done 
    } < $INPUT
    IFS=$OLDIFS
    cur_wkd="$dirres"/variant_calling
    summaryfile=none
    Rtool=finalmerge
    Rtype=single2f
    file_out="$dirres"/all_count_matrix.csv
    mergefile="$dirres"/VEX_count_matrix.csv
    phenofile="$dirres"/GTEX_count_matrix.csv
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    sed -i '/Inf/d' "$file_out"
    sed -i 's/gene_name/sampname/g' "$file_out"
    sed -i 's/Var.1/sampname/g' "$file_out"
    sed -i 's/_[0-9]*//g' "$file_out"
  else
    echo1=$(echo "CANT FIND "$matrix_file11"")
    mes_out
  fi
else
  echo1=$(echo "ALREADY FOUND "$matrix_filefinal"")
  mes_out
fi
###############################################################################################################################################################
# Moves and creates editing impact count matrices                                                                                          *TESTED
###############################################################################################################################################################
for level in gene transcript ;
do
  for impact in high_impact moderate_impact ;
  do
    for snptype in ADARediting APOBECediting All ;
    do
      new_dir="$dirres"/variant_calling/impact/"$level"/"$impact"/"$snptype"
      create_dir
      exten=$(echo ".csv")
      mv "$dirres"/variant_calling/impact/"$level"/"$impact"/*"$snptype"*"$exten" "$new_dir"
    done
  done
done
for level in gene transcript ;
do
  for impact in high_impact moderate_impact ;
  do
    for snptype in ADARediting APOBECediting All ;
    do
      #impact="$VC_dir"/"$level"/"$impact"/"$snptype"
      #cat "$impact"/* | awk -vORS=, '{ print $1 }' | sed 's/,$//' | awk -vORS=, '{ print $0 }' >> "$VC_dir"/"$level"/"$impact"/"$snptype"GListallsamp.csv
      VC_dir="$dir_path"/Results/variant_calling/impact
      cd "$VC_dir"/"$level"/"$impact"/"$snptype"
      file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrix.csv
      Rtool=I_VEX
      Rtype=multi
      level_name=$(echo "id")
      names=$(echo "id")
      GOI_file="$VC_dir"/"$level"/"$impact"/temp.csv
      mergefile=none
      phenofile=none
      echo1=$(echo "CREATING "$file_out"")
      mes_out
      mergeR
      header=$(head -n 1 "$file_out")
      newheader=$(echo ""$level"_id"$header"")
      cat "$file_out" | cut -d, --complement -f2 | sed 's/.y//g' | sed 's/NA/0/g' | sed '1d' | sed '1i '$newheader'' >> "$dir_path"/temp.csv
      file_in="$file_out"
      temp_file
      cd "$dir_path"/AIDD
      file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixedited.csv
      file_in="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrix.csv
      if [ -s "$file_in" ] ;
      then
        if [ ! -s "$file_out" ];
        then
          index_file="$ExToolsetix"/index/"$level"_names.csv
          pheno_file="$dir_path"/PHENO_DATAalign.csv
          Rtool=GTEX
          level_id=$(echo ""$level"_id");
          level_name=$(echo ""$level"_name");
          filter_type=$(echo "protein_coding");
          level="$level"
          tempf1="$dir_path"/tempR1.csv
          tempf2="$dir_path"/tempR2.csv
          tempf3="$dir_path"/tempR3.csv
          sed -i 's/-/_/g' "$index_file"
          echo1=$(echo "CREATING "$file_out"")
          mes_out
          matrixeditor
          header=$(head -n 1 "$file_out")
          cat "$file_out" | sed '1d' | awk -F',' 'NR > 1{s=0; for (i=3;i<=NF;i++) s+=$i; if (s!=0)print}' | sort -u -k1 | sed '1i '$level'_name'$header'' >> "$dir_path"/temp.csv
          file_in="$file_out"
          temp_file
        else
          echo1=$(echo "ALREADY FOUND "$file_out"")
          mes_out
        fi
      else
        echo1=$(echo "CANT FIND "$file_in"")
        mes_out
      fi
    done
  done
done
cd "$dir_path"/AIDD
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  for level in gene transcript ;
  do
    for snptype in ADARediting APOBECediting All ;
    do
      for impact in high_impact moderate_impact ;
      do
        file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixedited.csv
        cat "$file_out" | sed 's/'$run'/'$samp_name'/g' | sed 's/ /,/g' >> "$dir_path"/temp.csv
        file_in="$file_out"
        temp_file
      done
    done
  done
done 
} < $INPUT
IFS=$OLDIFS
for level in gene transcript ;
do
  for snptype in ADARediting APOBECediting All ;
  do
    for impact in high_impact moderate_impact ;
    do
      file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixedited.csv
      cat "$file_out" | awk -F',' 'NF{NF-=1};1' | sed 's/ /,/g' >> "$dir_path"/temp.csv
      file_in="$file_out"
      temp_file
    done
  done
done
for level in gene transcript ;
do
  for snptype in ADARediting APOBECediting All ;
  do
    for impact in high_impact moderate_impact ;
    do
        file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixedited.csv
        cat "$file_out" | sed 's/ /,/g' | awk -F',' '{for(i=1;i<=NF;i++){A[NR,i]=$i};if(NF>n){n=NF}}
        END{for(i=1;i<=n;i++){
        for(j=1;j<=NR;j++){
        s=s?s","A[j,i]:A[j,i]}
        print s;s=""}}' | sed 's/'$level'_name/sampname/g' >> "$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixeditedall.csv
        summaryfile=none
        Rtool=finalmerge
        Rtype=single2f
        file_out="$dir_path"/temp.csv
        mergefile="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixeditedall.csv
        phenofile="$dir_path"/PHENO_DATA.csv
        level_name=$(echo "sampname")
        echo1=$(echo "CREATING "$mergefile"")
        mes_out
        mergeR
        file_in="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixeditedall.csv
        temp_file
    done
  done
done

## TO COMBINE ALL FILES IN EACH SNPTYPE SO HAVE EACH SAMPLE IS A COLUMN OF GENES FOR GENE ENRICHMENT INPUT
#for level in gene transcript ;
#do
#  for impact in high_impact moderate_impact ;
#  do
#    for snptype in ADARediting APOBECediting All ;
#    do
#      for file in "$dirres"/variant_calling/impact/"$level"/"$impact"/"$snptype"/
#      cat "$file" | awk -F',' {print $1} >> "$dirres"/variant_calling/impact/"$level""$impact""$snptype"GeneLists.csv
#    done
#  done
#done
##RUN TOPGO TO CREATE LIST OF GOTERMS WITH HOW MANY GENES ARE IN PATHWAY HOW MNAY OF THESE HAVE EDITING SITES
#bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetGEA.sh GOID,Term,annotated,sig,expected,rankinfisher,classicfisher,classicelim
#maybe do annotated,sigincontrol,sigincondition1,expected
###############################################################################################################################################################
# Statistical Analysis section                                                                                                         *WORKING ON IT
###############################################################################################################################################################
cd "$dir_path"/AIDD
#bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetExcitome.sh 2 #creates guttman_count_matrix.csv and runs guttman tests (need to add this part)
#bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetExcitome.sh 1
count_matrix=all_count_matrix
bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetANOVA.sh "$count_matrix" #runs ANOVA on each gene in the excitome, each nt and AA substitution, and impact of subs.
for level in gene transcript ;
do
  for impact in high_impact moderate_impact ;
  do
    for snptype in ADARediting APOBECediting All ;
    do
      count_matrix="$level"_"$impact"_"$snptype"edits_count_matrixeditedall
      #bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetANOVA.sh "$count_matrix" #runs ANOVA on number of edits found in each gene or transcript
    done
  done
done
dir_path=/media/sf_AIDD/germ_layer
for level in gene transcript ;
do
  user_input=$(echo ""$dir_path"/AIDD/ExToolset/indexes/"$level"_list/user_input_"$level"list.csv")
  if [ -f "$user_input" ];
  then
    INPUT="$user_input"
    OLDIFS=$IFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while IFS=, read -r GOI
    do
      source config.shlib;
      home_dir=$(config_get home_dir);
      dir_path=$(config_get dir_path);
      dirres=$(config_get dirres);
      count_matrix="$GOI"_count_matrix
      new_dir="$dirres"/"$count_matrix"
      create_dir
      tool=DEBUG
      echo1="NOW RUNNING STATISTICS FOR "$count_matrix""
      mes_out
      bash "$dir_path"/AIDD/ExToolset/ExToolsetANOVA.sh "$count_matrix" #runs ANOVA for each gene list provided by the user
    done
    } < $INPUT
    IFS=$OLDIFS # creates count matrix
  fi
done
cd "$dir_path"/AIDD
count_matrix=all_count_matrix
  bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetcorr.sh "$count_matrix" #runs correlations
  cd "$dir_path"/AIDD
for level in gene transcript ;
do
  count_matrix="$level"_count_matrixedited
  bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetDESeq2.sh "$count_matrix" #run DE with DESEq2 for each gene and transcript count matrix for each condition
done
for level in transcript ;
do
  for impact in high_impact moderate_impact ;
  do
    for snptype in ADARediting APOBECediting All ;
    do
        count_matrix="$level"_"$impact"_"$snptype"edits_count_matrixedited
        bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetDESeq2.sh "$count_matrix" #runs DE with DESeq2 for each editing impact count matrix (these counts are how many edits are found in each gene
    done
  done
done
if [ ! "$4" == "" ];
then
    bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetsplit.sh "$count_matrix" "$4" # this will split the matrices by a certain condition and create new pheno-data files and matrices by condition supplied by the user.
fi
####################################################################################################################
# CLEAN UP AND EXIT
####################################################################################################################
cd "$dir_path"/AIDD
source config.shlib
DATE_WITH_TIME=$(config_get DATE_WITH_TIME)
TIME_HOUR=$(config_get TIME_HOUR)
TIME_MIN=$(config_get TIME_MIN)
TIME_SEC=(config_get TIME_SEC)
END_DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
END_TIME_HOUR=$(date +%H)
END_TIME_MIN=$(date +%M)
END_TIME_SEC=$(date +%S)
echo "EXTOOLSET STARTED "$DATE_WITH_TIME" AND ENDED "$END_DATE_WITH_TIME""
