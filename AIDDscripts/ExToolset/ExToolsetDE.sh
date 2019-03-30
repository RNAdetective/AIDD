#!/usr/bin/env bash
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
editmatrix() {
cat "$allcm" | sed 's/ADAR_001/ADARp150/g' | sed 's/ADAR_002/ADARp110/g' | sed 's/ADAR_007/ADARp80/g' | sed 's/ADARB1_/ADARB1./g' | sed 's/_[0-9]*//g' >> "$allcmedit"
}
createindex() {
cat "$allcmedit" | cut -d, --complement -f2-6 | sed 's/genename/sampname/g' | head -n 1 | tr ',' '\n' >> "$allindex"
}
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script

cond_file() {
cat "$dir_path"/PHENO_DATA.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f"$coln" | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed '1i freq,name' >> "$dir_path"/"$nam".csv
file_in="$dir_path"/"$nam".csv
file_out="$dir_path"/"$nam".tiff
bartype=cond
tool=Rbar
run_tools
} # creates condition file
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
remove_stuff() {
if [ -f "$path" ];
then
 rm -f "$path"
fi
} # this removes $path
run_tools() {
if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
then
  if [ -f "$file_in" ]; # IF INPUT THERE
  then
echo1=$(echo "FOUND "$file_in" STARTING "$tool"")
#mes_out
$tool # TOOL
  else
echo1=$(echo "CANT FIND "$file_in" FOR_THIS "$sample"")
mes_out # ERROR INPUT NOT THERE
  fi
  if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
  then
echo1=$(echo "FOUND "$file_out" FINISHED "$tool"")
#mes_out # ERROR OUTPUT IS THERE
  else 
echo1=$(echo "CANT FIND "$file_in" FOR THIS "$sample"")
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
corr_summary() {
pcorr=$(cat "$corr_file" | awk '/   cor/{nr[NR+1]}; NR in nr')
new_file="$dir_path"/correlations/temp.csv
lowCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $2}') 
highCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $3}')
p_value=$(cat "$corr_file" | awk '/p-value /{nr[NR]}; NR in nr' | sed 's/ //g' | sed 's/</,/g' | awk -F ',' 'NR=1{print $4}')
echo ""$name","$pcorr","$lowCI","$highCI","$p_value"" >> "$dirrescorr"/all_corr_data.csv
}
corr_chart() {
file_in="$dirrescorr"/all_corr_data.csv
file_out="$dirrescorr"/all_corr_data.tiff
sed -i '1i variables,Corr,lowCI,highCI,p_value' "$file_in"
sed -i 's/ //' "$file_in"
tool=Rbar
bartype=linewerr
#run_tools
}
####################################################################################################################
# RUNS EXTOOLSET FOR GTEX SUMMARY AND BARGRAPHS ADD ERROR BARS TO BARGRAPHS
####################################################################################################################
source config.shlib;
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path);
dirres=$(config_get dirres);
dirrescorr="$dirres"/all/correlations
ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
INPUT="$ExToolsetix"/index/scatterplots.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r scatter_x scatter_y
do
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  dirrescorr="$dirres"/all/correlations
  ExToolset="$dir_path"/AIDD/ExToolset/scripts
  file_in="$dirrescorr"/"$name"corr.txt
  file_out="$dirrescorr"/all_corr_data.cvs
  name=$(echo ""$scatter_x""$scatter_y"")
  corr_file="$dirrescorr"/"$name"scatterplot.txt
  echo ""$name""
  pcorr=$(cat "$corr_file" | awk '/   cor/{nr[NR+1]}; NR in nr')
  new_file="$dir_path"/correlations/temp.csv
  lowCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $2}') 
  highCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $3}')
  p_value=$(cat "$corr_file" | awk '/p-value /{nr[NR]}; NR in nr' | sed 's/ //g' | sed 's/p-value=/p-value</g' | sed 's/</,/g' | awk -F ',' 'NR=1{print $4}')
  echo ""$p_value""
  echo ""$name","$pcorr","$lowCI","$highCI","$p_value"" >> "$dirrescorr"/all_corr_data.csv
done 
} < $INPUT
IFS=$OLDIFS
cat "$dirrescorr"/all_corr_data.csv | sort -k5 >> "$dirrescorr"/all_corr_datasig.csv
  




