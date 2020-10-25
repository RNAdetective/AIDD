#!/usr/bin/env bash
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
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
editmatrix() {
cat "$allcm" | sed 's/ADAR_001/ADARp150/g' | sed 's/ADAR_002/ADARp110/g' | sed 's/ADAR_007/ADARp80/g' | sed 's/ADARB1_/ADARB1./g' | sed 's/_[0-9]*//g' >> "$allcmedit"
}
createindex() {
cat "$allcmedit" | cut -d, --complement -f2-6 | sed 's/genename/sampname/g' | head -n 1 | tr ',' '\n' >> "$allindex"
}
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
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
####################################################################################################################
# RUNS EXTOOLSET FOR DE ANALYSIS WHEN ONE CONDITION IS SPLIT INTO ITS OWN FILE
####################################################################################################################
source config.shlib
con_name1=$(config_get con_name1);
con_name2=$(config_get con_name2);
con_name3=$(config_get con_name3);
splitname="$1"
if [ ! "$splitname" == "" ];
then
  name1=$(awk -F, 'NR==3{print $2}' "$dir_path"/"$splitname".csv)
  name2=$(awk -F, 'NR==4{print $2}' "$dir_path"/"$splitname".csv)
  name3=$(awk -F, 'NR==2{print $2}' "$dir_path"/"$splitname".csv)
####################################################################################################################
# RUNS EXTOOLSET FOR GTEX SUMMARY AND BARGRAPHS ADD ERROR BARS TO BARGRAPHS
####################################################################################################################
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  for name in "$name1" "$name2" "$name3" ;
  do
    dirres="$dir_path"/Results/"$name"
    new_dir="$dirres"
    create_dir
    sed -i '/^dirres=/d' "$dir_path"/AIDD/config.cfg
    echo "dirres="$dirres"" >> "$dir_path"/AIDD/config.cfg
    dirresall="$dirres"/all
    new_dir="$dirresall"
    create_dir
    olddirres="$dir_path"/Results
    file_in="$olddirres"/all/all_count_matrixedit.csv
    file_out="$dirres"/all/all_count_matrixedit.csv
    tool=splitallmatrix
    run_tools
    file_in=
    file_out=
    tool=PDsplit
    run_tools
    ExToolset="$dir_path"/AIDD/ExToolset/scripts
    ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
    allcm="$dirres"/all_count_matrix.csv
    allcmedit="$dirresall"/all_count_matrixedit.csv
    allindex="$dirresall"/allindex.csv
    file_in="$allcm"
    file_out="$allcmedit"
    tool=editmatrix
    run_tools
    file_in="$allcmedit"
    file_out="$allindex"
    tool=createindex
    run_tools
    INPUT="$allindex"
    OLDIFS=$IFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    read
    while IFS=, read -r freq
    do
      source config.shlib;
      home_dir=$(config_get home_dir);
      dir_path=$(config_get dir_path);
      dirres=$(config_get dirres);
      con_name1=$(config_get con_name1);
      con_name2=$(config_get con_name2);
      con_name3=$(config_get con_name3);
      con_name4=$(echo "sampname");
      echo1=$(echo "STARTING ANOVA FOR "$freq"")
      mes_out
      for cond_name in "$con_name1" "$con_name3" "$con_name4";
      do
        dirrescon="$dirres"/all/"$cond_name";
        new_dir="$dirrescon";
        create_dir
        file_in="$dirres"/all/all_count_matrixedit.csv;
        file_out="$dirrescon"/"$freq"summary.tiff;
        bartype=ANOVA
        pheno="$dirres"/PHENO_DATA.csv
        count_of_interest="$freq"
        sum_file="$dirrescon"/"$freq"summary.csv
        condition_name="$cond_name"
        sum_file2="$dirrescon"/"$freq"ANOVA.txt
        tool=Rbar
        sum_file="$dirres"/all/"$cond_name"/"$freq"summary.csv
        sed -i 's/freq_name/'$freq'/g' "$ExToolset"/barchart.R
        sed -i 's/condition_name/'$cond_name'/g' "$ExToolset"/barchart.R
        run_tools
        sed -i 's/'$freq'/freq_name/g' "$ExToolset"/barchart.R
        sed -i 's/'$cond_name'/condition_name/g' "$ExToolset"/barchart.R
        if [ -s "$dirrescon"/"$freq"ANOVA.txt ];
        then
          line=$(echo "11")
          pvalue=$(sed -n "$line p" "$dirrescon"/"$freq"ANOVA.txt)
          justp=${pvalue#*:}
          if [ ! -s "$dirres"/all/"$cond_name"allANOVA.csv ];
          then
            echo "variable,ANOVApvalue" >> "$dirres"/all/"$cond_name"allANOVA.csv
          fi
          echo ""$freq","$justp"" >> "$dirres"/all/"$cond_name"allANOVA.csv
        fi
      done
    done 
    } < $INPUT
    IFS=$OLDIFS
    con_name1=$(config_get con_name1);
    con_name2=$(config_get con_name2);
    con_name3=$(config_get con_name3);
    con_name4=$(echo "sampname");
    for cond_name in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ;
    do
      echo1=$(echo "STARTING SUMMARY COLLECTION FOR "$cond_name"")
      mes_out
      cat "$dirres"/all/"$cond_name"/*summary.csv | sed '2,${/^sampname/d;}' >> "$dirres"/all/"$cond_name"allsummaries.csv
      file_in="$dirres"/all/"$cond_name"allsummaries.csv
      file_out="$dirres"/all/"$cond_name"allsummaries.tiff
      bartype=substitutions
      tool=Rbar
      sed -i 's/condition_name/'$cond_name'/g' "$ExToolset"/barchart.R
      run_tools
      sed -i 's/'$cond_name'/condition_name/g' "$ExToolset"/barchart.R
    done
####################################################################################################################
# RUNS EXTOOLSET FOR CORRELATION SUMMARY
####################################################################################################################
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
      ExToolset="$dir_path"/AIDD/ExToolset/scripts
      file_in="$dirres"/all_count_matrix.csv;
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
      pcorr=$(cat "$corr_file" | awk '/   cor/{nr[NR+1]}; NR in nr')
      new_file="$dir_path"/correlations/temp.csv
      lowCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $2}') 
      highCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $3}')
      p_value=$(cat "$corr_file" | awk '/p-value /{nr[NR]}; NR in nr' | sed 's/ //g' | sed 's/p-value=/p-value</g' | sed 's/</,/g' | awk -F ',' 'NR=1{print $4}')
      echo ""$name","$pcorr","$lowCI","$highCI","$p_value"" >> "$dirres"/all/all_corr_data.csv
    done 
    } < $INPUT
    IFS=$OLDIFS
    cat "$dirres"/all/all_corr_data.csv | sort -k5 |  >> "$dirres"/all/all_corr_datasig.csv
  done
fi
