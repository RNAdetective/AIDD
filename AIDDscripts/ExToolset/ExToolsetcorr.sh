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
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
GvennR() {
Rscript "$ExToolset"/Gvenn.R "$file_in" "$file_out" "$image_out"
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
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  ExToolset="$dir_path"/AIDD/ExToolset/scripts
  file_in="$dirres"/all_count_matrix.csv;
  sed -i '/Inf/d' "$file_in"
  dirrescorr="$dirres"/all/correlations
  new_dir="$dirrescorr"
  create_dir
  con_name1=$(config_get con_name1);
  con_name2=$(config_get con_name2);
  con_name3=$(config_get con_name3);
  con_name4=$(echo "sampname");
  echo1=$(echo "STARTING CORRELATION FOR "$scatter_x" AND "$scatter_y"")
  mes_out
  file_out="$dirrescorr"/"$scatter_x""$scatter_y"scatterplot.tiff
  file_out2="$dirrescorr"/"$scatter_x""$scatter_y"scatterplot.txt
  bartype=scatter
  tool=Rbar
  sed -i 's/scatter_x/'$scatter_x'/g' "$ExToolset"/barchart.R
  sed -i 's/scatter_y/'$scatter_y'/g' "$ExToolset"/barchart.R
  sed -i 's/cond_1/'$con_name1'/g' "$ExToolset"/barchart.R
  sed -i 's/cond_2/'$con_name2'/g' "$ExToolset"/barchart.R
  sed -i 's/cond_4/'$con_name4'/g' "$ExToolset"/barchart.R
  run_tools
  sed -i 's/'$scatter_x'/scatter_x/g' "$ExToolset"/barchart.R
  sed -i 's/'$scatter_y'/scatter_y/g' "$ExToolset"/barchart.R
  sed -i 's/'$con_name1'/cond_1/g' "$ExToolset"/barchart.R
  sed -i 's/'$con_name2'/cond_2/g' "$ExToolset"/barchart.R
  sed -i 's/'$con_name4'/cond_4/g' "$ExToolset"/barchart.R
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
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  dirrescorr="$dirres"/all/correlations
  ExToolset="$dir_path"/AIDD/ExToolset/scripts
  file_in="$dirrescorr"/"$name"corr.txt
  file_out="$dirrescorr"/all_corr_data.cvs
  name=$(echo ""$scatter_x""$scatter_y"")
  corr_file="$dirrescorr"/"$name"scatterplot.txt
  pcorr=$(cat "$corr_file" | awk '/   cor/{nr[NR+1]}; NR in nr')
  new_file="$dir_path"/correlations/temp.csv
  lowCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $2}') 
  highCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $4}')
  p_value=$(cat "$corr_file" | awk '/p-value /{nr[NR]}; NR in nr' | sed 's/ //g' | sed 's/p-value=/p-value</g' | sed 's/</,/g' | awk -F ',' 'NR=1{print $4}')
  echo ""$name","$pcorr","$lowCI","$highCI","$p_value"" >> "$dirres"/all/all_corr_data.csv
done 
} < $INPUT
IFS=$OLDIFS
cat "$dirres"/all/all_corr_data.csv | sort -k5 |  >> "$dirres"/all/all_corr_datasig.csv
