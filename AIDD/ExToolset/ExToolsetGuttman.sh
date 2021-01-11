#!/usr/bin/env bash
mes_out() {
dirqc="$dir_path_vcf"/quality_control
new_dir="$dirqc"
create_dir
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$echo1"" >> "$dirqc"/time_check/time_check.csv
}
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$GOI_file" "$temp_file1" "$temp_file2" "$temp_file3" "$rename" #creates level of interest files
} # Runs multimerge R
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
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$GOI_file" "$temp_file1" "$temp_file2" "$temp_file3" "$rename" #creates level of interest files
} # Runs multimerge R
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
prob_gutt() {
Rscript "$ExToolset"/guttman.R "$file_in" "$file_out1" "$file_out2" "$file_out3"
}
rename() {
cat "$file_in" | sed 's/,p,/,'$filename'p,/g' | sed 's/,level,/,'$filename'rank/g' >> "$dir_path"/temp.csv
temp_file
}
#grep '^#' "$file_in" > "$file_out" && grep -v '^#' "$file_in" | LC_ALL=C sort -t $'\t' -k1,1 -k2,2n >> "$file_out
######################################################################################
# makes editing frequency count matrix pulling stacks from aligned and assembled bam file
######################################################################################
#source config.shlib;
#home_dir=$(config_get home_dir);
#dir_path=$(config_get dir_path);
#dirres=$(config_get dirres);
home_dir="$1"
ExToolset="$home_dir"/AIDD/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
dir_path="$2"
resgutt="$dir_path"/Results/guttman
#file_in="$resgutt"/guttediting_count_matrixDESeq2.csv
#cat "$file_in" | csvtool transpose >> "$dir_path"/temp.csv
#temp_file
#count_matrix="$resgutt"/guttediting_count_matrixDESeq2B.csv
#Rtool=finalmerge
#Rtype=single2f
#GOI_file="$resgutt"/guttediting_count_matrixANOVA.csv
#file_out="$resgutt"/guttediting_count_matrixANOVA.csv
#mergefile="$resgutt"/guttediting_count_matrixDESeq2B.csv
#phenofile="$dir_path"/PHENO_DATA.csv
#level_name=$(echo "samp_name")
#echo1=$(echo "CREATING "$file_out"")
#mes_out
#mergeR
# merge with PHENO_DATA.csv by "samp_name" name it guttediting_count_matrixAll.csv
mainfile="$resgutt"/guttediting_count_matrixANOVA.csv
resgutt1="$resgutt"/scores
new_dir="$resgutt1"
create_dir
resgutt2="$resgutt"/items
new_dir="$resgutt2"
create_dir
resgutt3="$resgutt"/traits
new_dir="$resgutt3"
create_dir
guttcond1="$resgutt"/regions
new_dir="$guttcond1"
create_dir
gutt_scores1="$guttcond1"/scores
new_dir="$gutt_scores1"
create_dir
gutt_items1="$guttcond1"/items
new_dir="$gutt_items1"
create_dir
gutt_traits1="$guttcond1"/traits
new_dir="$gutt_traits1"
create_dir
guttcond1_2="$guttcond1"/timepoint
new_dir="$guttcond1_2"
create_dir
gutt_scores1_2="$guttcond1_2"/scores
new_dir="$gutt_scores1_2"
create_dir
gutt_items1_2="$guttcond1_2"/items
new_dir="$gutt_items1_2"
create_dir
gutt_traits1_2="$guttcond1_2"/traits
new_dir="$gutt_traits1_2"
create_dir
guttcond2="$resgutt"/timepoint
new_dir="$guttcond2"
create_dir
gutt_scores2="$guttcond2"/scores
new_dir="$gutt_scores2"
create_dir
gutt_items2="$guttcond2"/items
new_dir="$gutt_items2"
create_dir
gutt_traits2="$guttcond2"/traits
new_dir="$gutt_traits2"
create_dir
cd "$guttcond1"
col_num="5"
awk -F ',' 'NR==1{h=$0; next};!seen[$5]++{f=$5".csv"; print h > f};{f=$5".csv"; print >> f; close(f)}' "$mainfile"
cd "$guttcond2"
awk -F ',' 'NR==1{h=$0; next};!seen[$3]++{f=$3".csv"; print h > f};{f=$3".csv"; print >> f; close(f)}' "$mainfile"
cd "$guttcond1_2"
for files in "$guttcond1"/* ;
do
  awk -F ',' 'NR==1{h=$0; next};!seen[$3]++{f=$3$5".csv"; print h > f};{f=$3$5".csv"; print >> f; close(f)}' "$files"
done
cd
file_in="$mainfile"
filesdir=$(echo "${file_in##*/}")
filename=$(echo "${filesdir%%.*}")
file_out1="$resgutt1"/"$filename"scores.csv
file_out2="$resgutt2"/"$filename"items.csv
file_out3="$resgutt3"/"$filename"trait.csv
prob_gutt
for files in "$guttcond1"/* ;
do
  file_in="$files"
  filesdir=$(echo "${file_in##*/}")
  filename=$(echo "${filesdir%%.*}")
  file_out1="$guttcond1"/scores/guttediting_"$filename"scores.csv
  file_out2="$guttcond1"/items/guttediting_"$filename"items.csv
  file_out3="$guttcond1"/traits/guttediting_"$filename"trait.csv
  prob_gutt
  file_in="$guttcond1"/items/guttediting_"$filename"items.csv
  rename
done
# merge all files in "$guttcond1"/items
for files in "$guttcond2"/* ;
do
  file_in="$files"
  filesdir=$(echo "${file_in##*/}")
  filename=$(echo "${filesdir%%.*}")
  file_out1="$guttcond2"/scores/guttediting_"$filename"scores.csv
  file_out2="$guttcond2"/items/guttediting_"$filename"items.csv
  file_out3="$guttcond2"/traits/guttediting_"$filename"trait.csv
  prob_gutt
  file_in="$guttcond2"/items/guttediting_"$filename"items.csv
  rename
done
# merge all files in "$guttcond2"/items
for files in "$guttcond1_2"/* ;
do
  file_in="$files"
  filesdir=$(echo "${file_in##*/}")
  filename=$(echo "${filesdir%%.*}")
  file_out1="$guttcond1_2"/scores/guttediting_"$filename"scores.csv
  file_out2="$guttcond1_2"/items/guttediting_"$filename"items.csv
  file_out3="$guttcond1_2"/traits/guttediting_"$filename"trait.csv
  prob_gutt
  file_in="$guttcond1_2"/items/guttediting_"$filename"items.csv
  rename
done
# merge all files in "$guttcond1_2"/items
