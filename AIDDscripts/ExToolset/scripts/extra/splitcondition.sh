#!/usr/bin/env bash
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
bartype=$(echo "single")
tool=Rbar
#run_tools
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
bartype=$(echo "single")
tool=Rbar
#run_tools
done
} # separates big summary into each category and creates bar graph
matrixeditor() {
Rscript "$ExToolset"/matrixedit.R "$file_out" "$file_in" "$index_file" "$pheno_file" "$Rtool" "$level_id" "$level_name" "$filter_type" "$level"
} # creates matrix counts with names instead of ids and checks to make sure they are there
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" #creates level of interest files
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
  cat "$raw_input4" | sed '1,2d' | sed 's/	/,/g' | sed 's/    /,/g' | sed 's/  /,/g' | sed 's/ /,/g' | cut -d',' -f"$col_num" | sed '1i\ '$impact''$variable''$snptype'' | sed '/,0$/d' | sort -t, -u | sed 's/ /,/g' >> "$VC_dir"/"$level"/"$impact"/"$run""$snptype""$addcondition".csv
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
####################################################################################################################
# RUNS EXTOOLSET FOR DE ANALYSIS INCLUDING PATHWAY DE
####################################################################################################################
source config.shlib
con_name1=$(config_get con_name1);
con_name2=$(config_get con_name2);
con_name3=$(config_get con_name3);
splitname="Sex"
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path); 
ref_dir_path="$home_dir"/AIDD/references  # this is where references are stored
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
dirqc="$dir_path"/quality_control; # qc directory 
dirqcalign="$dirqc"/alignment_metrics
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
####################################################################################################################
# RUNS EXTOOLSET FOR GTEX SUMMARY AND BARGRAPHS ADD ERROR BARS TO BARGRAPHS
####################################################################################################################
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  dirresall="$dirres"/all
  new_dir="$dirresall"
  create_dir
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
####################################################################################################################
# RUNS EXTOOLSET FOR CORRELATION SUMMARY
####################################################################################################################
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
