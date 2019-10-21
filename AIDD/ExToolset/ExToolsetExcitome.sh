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
create_edit_list() {
num=$(echo "$express_value")
express_value=$(($num + 0))
 if [ "$excit_express" -gt "$express_value" ];
      then
        ex_answer="1"
      else
        ex_answer="0" 
      fi
      header=$(echo "condition,"$excitome_gene"expression,"$excitome_gene"edited")
      if [[ "$excit_pres" == "$coord" && "$excit_pres" != "0" ]];
      then
        answer="1"
      else
        answer="0"
      fi
      if [ ! -f "$file_out" ];
      then
        echo "$header" >> "$file_out" 
        echo ""$sample_name","$ex_answer","$answer"" >> "$file_out"
      else
        echo ""$sample_name","$ex_answer","$answer"" >> "$file_out"
      fi
}
rename_files() {
cp "$file_in" "$file_out"
USCOUNTER=$(expr $USCOUNTER + 1)
echo "sample$USCOUNTER"
}
mergeR() {
Rscript /home/user/AIDD/AIDD/ExToolset/scripts/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$temp_file" #creates level of interest files
} # Runs multimerge R
#grep '^#' "$file_in" > "$file_out" && grep -v '^#' "$file_in" | LC_ALL=C sort -t $'\t' -k1,1 -k2,2n >> "$file_out
######################################################################################
# makes a text file with all lines from all vcf files with gene name in the line
# used these with reference search to find editing sites for excitome list.
######################################################################################
if [ "$1" == "1" ]; # if command line says 1 then run pull out all lines with gene name in it
then
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  ExToolset="$dir_path"/AIDD/ExToolset/scripts
  ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
  allcm="$dirres"/all_count_matrix.csv
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    file_in="$dir_path"/AIDD/config.cfg.defaults
    cat "$file_in" | sed 's/condition=//g' | sed 's/condition2=//g' >> "$dir_path"/temp.csv
    temp_file
    echo "condition="$condition"" >> "$dir_path"/AIDD/config.cfg.defaults
    echo "condition2="$condition2"" >> "$dir_path"/AIDD/config.cfg.defaults
    INPUT=/home/user/AIDD/AIDD/ExToolset/indexes/index/excitome_loc.csv
    OLDIFS=$IFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
    read
    while IFS=, read -r excitome_gene gene_id chrome coord express_value
    do
      source config.shlib; # load the config library functions
      condition="$(config_get condition)"
      echo "$condtion"
      condition2="$(config_get condition2)"
      dir_time=/media/sf_AIDD/openme/timepoint
      file_in="$dir_time"/tables/"$condition"__"$condition2".vcf
      echo "$file_in"
      var=$(cat "$file_in" | awk '/'$gene_id'/' | awk '/missense/') #add here to print specific columns right now they are all in one line even if multiple lines from file.
      if [ "$var" != "" ];
      then
        echo ""$condition"yes"
        echo ""$var"" >> "$dir_time"/Results/"$excite_gene"variants.csv
      fi
    done
    } < $INPUT
    IFS=$OLDIFS
  done
  } < $INPUT
  IFS=$OLDIFS
fi
######################################################################################
# makes list of excitome genes in each sample for guttmans test
######################################################################################
if [ "$1" == "2" ];
then
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  ExToolset="$dir_path"/AIDD/ExToolset/scripts
  ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
  allcm="$dirres"/all_count_matrix.csv
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres=$(config_get dirres);
    ExToolset="$dir_path"/AIDD/ExToolset/scripts
    ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
    allcm="$dirres"/all_count_matrix.csv
    dirresGuttman="$dirres"/Guttman
    new_dir="$dirresGuttman"
    create_dir
    dir_time="$dirresGuttman"/timepoint
    new_dir="$dir_time"
    create_dir
    dir_path_vcf="$dir_path"/raw_data/snpEff
    file_in="$dir_path_vcf"/"$run"filtered_snps_finalAnnADARediting.vcf
    file_out="$dir_time"/"$samp_name""$condition"-"$condition2"-"$sample".vcf
    tool=rename_files
    run_tools
  done
  } < $INPUT
  IFS=$OLDIFS
  INPUT="$ExToolsetix"/index/excitome_loc.csv
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r excitome_gene gene_id chrome coord express_value
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres=$(config_get dirres);
    ExToolset="$dir_path"/AIDD/ExToolset/scripts
    ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
    allcm="$dirres"/all_count_matrix.csv
    dirresGuttman="$dirres"/Guttman
    USCOUNTER="0"
    for files in "$dirresGuttman"/timepoint/* ;
    do
      file_in="$files"
      condition=$(echo "$files" | cut -d'/' -f8 | cut -d'.' -f1)
      condition_s=$(echo "$condition" | cut -d'-' -f3)
      sample_name=$(echo "$condition" | cut -d'-' -f1)
      USCOUNTER=$(expr $USCOUNTER + 1)
      new_dir="$dirresGuttman"/Results
      create_dir
      file_out="$dirresGuttman"/Results/"$excitome_gene"ExcitomeEditsAll.csv
      count_matrix="$dir_path"/Results/all_count_matrix.csv
      excit_pres=$(cat "$file_in" | awk '{if ($1 ~ /'"$chrome"'/) print $2}' | awk '{if ($1 ~ /'"$coord"'/) print $0}')
      excitome_gene_s=$(echo "$excitome_gene" | cut -d'_' -f1)
      if [ "$excitome_gene" == "ADAR.1" ];
      then
        express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene'/) print NR}')
      fi
      if [ "$excitome_gene" == "ADAR.B1" ];
      then
        express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene'/) print NR}')
      fi
      if [ "$excitome_gene" == "ADAR.B2" ];
      then
        express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene'/) print NR}')
      fi
      express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene_s'/) print NR}')
      if [ "$express_col" == "" ];
      then
        excit_express=$(echo "0")
        echo1=$(echo "sample"$USCOUNTER":"$condition".vcf "$excitome_gene_s" with editing coordinate "$chrome":"$coord" was not found in "$count_matrix" so expression is labeled 0")
        mes_out
      else
        express_row=$(cat "$count_matrix" | awk -F',' '{if (/'$condition_s'/) print NR}')
        excit_express=$(cat "$count_matrix" | awk -F',' 'NR=='$express_row'{print $'$express_col'}')
        echo1=$(echo "sample"$USCOUNTER":"$condition".vcf "$excitome_gene_s" with editing coordinate "$chrome":"$coord" is located at "$express_col":"$express_row" in "$count_matrix" having a TPM of "$excit_express" Expression is marked 1 if it is above "$express_value"")
        mes_out
      fi
        create_edit_list
    done
  done
  } < $INPUT
  IFS=$OLDIFS
  dirres="$dir_path"/Results
  dirresGuttman="$dirres"/Guttman
  dir_time="$dirresGuttman"/Results
  cd "$dir_time"
  cur_wkd="$dir_time"
  Rtool=$(echo "I_VEX")
  Rtype=$(echo "multi")
  summaryfile=none
  names=$(echo "condition")
  temp_file="$dirres"/temp2.csv
  file_out="$dirres"/guttman_count_matrix.csv
  cat "$file_out" | sed 's/_[0-9]*//g' >> "$dir_path"/temp.csv
  temp_file
  echo1=$(echo "CREATING "$file_out"")
  mes_out
  mergeR
fi
