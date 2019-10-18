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
cat "$ExToolset"/DE.R | sed 's/set_design/'$condition_name'/g' >> "$dir_path"/tempDE.R
Rscript "$dir_path"/tempDE.R "$file_in" "$pheno" "$set_design" "$level_name" "$rlog" "$log" "$transcounts" "$PoisHeatmap" "$PCA" "$PCA2" "$MDSplot" "$MDSpois" "$resultsall" "$upreg" "$upreg100" "$upregGlist" "$downreg" "$downreg100" "$downregGlist" "$heatmap" "$volcano"
rm "$dir_path"/tempDE.R
}
Rbar() {
Rscript "$dir_path"/tempbarchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
GvennR() {
Rscript "$dir_path"/temp.R "$file_in" "$file_out" "$image_out"
}
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
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
        echo1=$(echo "CANT FIND "$file_out" FOR THIS "$sample"")
        #mes_out # ERROR INPUT NOT THERE
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
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
source config.shlib
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path); 
ExToolset="$dir_path"/AIDD/ExToolset/scripts
####################################################################################################################
# RUNS EXTOOLSET FOR CORRELATION SUMMARY         *TESTED
####################################################################################################################
INPUT="$dir_path"/AIDD/ExToolset/indexes/index/scatterplots.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r scatter_x scatter_y
do
  source config.shlib;
  count_matrix="$1"
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  ExToolset="$dir_path"/AIDD/ExToolset/scripts
  file_in="$dirres"/"$count_matrix".csv;
  dirrescorr="$dirres"/correlations
  new_dir="$dirrescorr"
  create_dir
  dirrescorr2="$dirrescorr"/"$count_matrix"
  new_dir="$dirrescorr2"
  create_dir
  con_name1=$(config_get con_name1);
  con_name2=$(config_get con_name2);
  con_name3=$(config_get con_name3);
  con_name4=$(echo "sampname");
  echo1=$(echo "STARTING CORRELATION FOR "$scatter_x" AND "$scatter_y"")
  mes_out
  file_out="$dirrescorr2"/"$scatter_x""$scatter_y"scatterplot.tiff
  file_out2="$dirrescorr2"/"$scatter_x""$scatter_y"scatterplot.txt
  bartype=scatter
  tool=Rbar
  cat "$ExToolset"/barchart.R | sed 's/scatter_x/'$scatter_x'/g' | sed 's/scatter_y/'$scatter_y'/g' | sed 's/cond_1/'$con_name1'/g' | sed 's/cond_2/'$con_name2'/g' | sed 's/cond_4/'$con_name4'/g' >> "$dir_path"/tempbarchart.R
  run_tools
  rm "$dir_path"/tempbarchart.R
done 
} < $INPUT
IFS=$OLDIFS
echo1=$(echo "STARTING CORRELATION SUMMARIES")
mes_out
INPUT="$dir_path"/AIDD/ExToolset/indexes/index/scatterplots.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r scatter_x scatter_y
do
  source config.shlib;
  count_matrix="$1"
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  dirrescorr="$dirres"/correlations
  dirrescorr2="$dirres"/correlations/"$count_matrix"
  ExToolset="$dir_path"/AIDD/ExToolset/scripts
  file_in="$dirrescorr2"/"$name"corr.txt
  file_out="$dirrescorr"/all_corr_data.cvs
  name=$(echo ""$scatter_x""$scatter_y"")
  corr_file="$dirrescorr2"/"$name"scatterplot.txt
  pcorr=$(cat "$corr_file" | awk '/   cor/{nr[NR+1]}; NR in nr')
  new_file="$dir_rescorr2"/temp.csv
  lowCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $2}') 
  highCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $4}')
  p_value=$(cat "$corr_file" | awk '/p-value /{nr[NR]}; NR in nr' | sed 's/ //g' | sed 's/p-value=/p-value</g' | sed 's/</,/g' | awk -F ',' 'NR=1{print $4}')
  echo ""$name","$pcorr","$lowCI","$highCI","$p_value"" >> "$dirrescorr"/all_corr_data.csv
done 
} < $INPUT
IFS=$OLDIFS
cat "$dirrescorr"/all_corr_data.csv | sort -k5 -n -t, | awk -F',' '$5 < 0.05 { print $0 }'  >> "$dirrescorr"/all_corr_datasig.csv
