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
RFR() {
cat "$ExToolset"/randomforest.R | sed 's/file_name/"$bamfile"/g' >> "$dir_path"/tempRF.R # need to change alpha to number of conditions
#also need to add mtry best fit node size is currently set to 6
#also net to set model currently set to only have one condition in the matrix sampname.
Rscript "$dir_path"/tempRF.R "$file_in" "$image1" "$image2" "$image3" "$image4" "$image5" "$image6" "$image7" "$image8" "$image9" "$file_out"
rm "$dir_path"/tempRF.R
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
Rscript "$ExToolset"/guttman.R "$file_in" "$file_out1" "$file_out2" "$file_out3" "$file_out"
}
#grep '^#' "$file_in" > "$file_out" && grep -v '^#' "$file_in" | LC_ALL=C sort -t $'\t' -k1,1 -k2,2n >> "$file_out
######################################################################################
# makes editing frequency count matrix pulling stacks from aligned and assembled bam file
######################################################################################
source config.shlib;
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path);
dirres=$(config_get dirres);
ExToolset="$home_dir"/AIDD/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
con_name1=$(config_get con_name1);
con_name1=$(echo ""$con_name1"" | sed 's/_//g')
con_name2=$(config_get con_name2);
con_name2=$(echo ""$con_name2"" | sed 's/_//g')
con_name3=$(config_get con_name3);
con_name3=$(echo ""$con_name3"" | sed 's/_//g')
con_name4=$(echo "samp_name");
con_name4=$(echo ""$con_name4"" | sed 's/_//g')
guttcond="$dir_path"/Results/guttman/all
new_dir="$guttcond"
create_dir
gutt_scores="$guttcond"/scores
new_dir="$gutt_scores"
create_dir
gutt_items="$guttcond"/items
new_dir="$gutt_items"
create_dir
gutt_traits="$guttcond"/traits
new_dir="$gutt_traits"
create_dir
file_in=/media/sf_AIDD/Results/guttman/guttediting_count_matrixDESeq2.csv
file_out1=/media/sf_AIDD/Results/guttman/scores/guttediting_regionscores.csv
file_out2=/media/sf_AIDD/Results/guttman/items/guttediting_regionitems.csv
file_out3=/media/sf_AIDD/Results/guttman/traits/guttediting_regiontrait.csv
prob_gutt 
#then merge scores with PHENO_DATA.csv then save
#run Rscript for bargraph of scores 
for cond_name in "$con_name1" "$con_name2" "$con_name3" sampname samp_name ;
do
  guttcond="$dir_path"/Results/guttman/"$cond_name"
  new_dir="$guttcond"
  create_dir
  gutt_scores="$guttcond"/scores
  new_dir="$gutt_scores"
  create_dir
  gutt_items="$guttcond"/items
  new_dir="$gutt_items"
  create_dir
  gutt_traits="$guttcond"/traits
  new_dir="$gutt_traits"
  create_dir
  cd "$guttcond"
  awk -F',' '{print > "guttediting_count_matrix'$cond_name'"$1".csv"}' "$dir_path"/Results/guttman/guttediting_count_matrixDESeq2.csv #split by condition
  for files in "$guttcond"/* ;
  do
    file_in="$files"
    namefiles=$(echo "${file_in##*/}")
    count_matrix=$(echo "${namefiles%%.*}")
    file_out1="$guttcond"/scores/"$count_matrix"scores.csv
    file_out2="$guttcond"/items/"$count_matrix"items.csv
    file_out3="$guttcond"/traits/"$count_matrix"traits.csv
    prob_gutt
    #rename p and level in items for condition_name
    #INPUT "$dir_path"/"$cond_name".csv
    # num name
    guttcond="$dir_path"/Results/guttman/"$cond_name"/"$name"
    new_dir="$guttcond"
    create_dir
    gutt_scores="$guttcond"/scores
    new_dir="$gutt_scores"
    create_dir
    gutt_items="$guttcond"/items
    new_dir="$gutt_items"
    create_dir
    gutt_traits="$guttcond"/traits
    new_dir="$gutt_traits"
    create_dir
    awk -F',' '{print > "guttediting_count_matrix'$cond_name'"$1".csv}' "$guttcond"/guttediting_count_matrix$cond_name$1.csv
  done
  #combine all items in one 
  #sort by the first condition_name
  #put all p in one column and all level in another with condition as a column
  #then run R script for line graph
done

  








  INPUT="$ExToolsetix"/"$human"/excitome_loc.csv
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r excitome_gene gene_id snp_database chrome coord strand annotation AAsubstitution AAposition exon codon_position express_value edit_value
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres=$(config_get dirres);
    ExToolset="$home_dir"/AIDD/AIDD/ExToolset/scripts
    ExToolsetix="$home_dir"/AIDD/ExToolset/indexes
    allcm="$dirres"/all_count_matrix.csv
    dirresRF="$dirres"/random_forest
    new_dir="$dirresRF"
    create_dir
    AIDDtool="$home_dir"/AIDD/AIDD_tools
    USCOUNTER="0"
    for files in "$dir_path"/raw_data/bam_files/* ;
    do
      file_in="$files"
      bamfiles=$(echo "${file_in##*/}")
      bamfile=$(echo "${bamfiles%%.*}")
      #extension=$(echo "${bamfiles##*.}")
      echo "Now starting editing profiles for $bamfile in "$excitome_gene""
      new_dir="$dirresRF"/"$bamfile"
      create_dir
      temp_file="$dirresRF"/"$bamfile"/"$excitome_gene".csv
      if [ "$coord" != "0" ];
      then
        cat "$ExToolset"/basecount.R | sed 's/coord/'$coord'/g' | sed 's/chrome/'$chrome'/g' >> "$dir_path"/tempbasecount.R
        bambai="$dir_path"/raw_data/bam_files/"$bamfile".bai
        if [ "$file_in" != "$bambai" ];
        then
          if [ ! -f "$bambai" ];
          then
            java -jar $AIDDtool/picard.jar BuildBamIndex INPUT="$file_in"
          fi
          Rscript "$dir_path"/tempbasecount.R "$file_in" "$temp_file"
          rm "$dir_path"/tempbasecount.R
          nucA=$(awk -F',' 'NR==2{print $1}' "$temp_file")
          nucC=$(awk -F',' 'NR==2{print $2}' "$temp_file")
          nucG=$(awk -F',' 'NR==2{print $3}' "$temp_file")
          nucT=$(awk -F',' 'NR==2{print $4}' "$temp_file")
          nuctotal=$(expr "$nucA" + "$nucG" + "$nucC" + "$nucT")
          if [ "$nucG" == "0" ];
          then
            percentG="0"
          else
            freqG=$(expr "$nucG" / "$nuctotal")
            percentG=$(awk 'BEGIN{print '$nucG' / '$nuctotal' * 100}')
          fi
          if [ "$nucC" == "0" ];
          then
            percentC="0"
          else
            freqC=$(expr "$nucC" / "$nuctotal")
            percentC=$(awk 'BEGIN{print '$nucC' / '$nuctotal' * 100}')
          fi
          RF_matrix_dir="$dirresRF"/mergesamples
          new_dir="$RF_matrix_dir"
          create_dir
          RF_matrix="$RF_matrix_dir"/"$bamfile"editingfreq.csv
          if [ ! -f "$RF_matrix" ];
          then
            echo "excitome_site,$bamfile" >> "$RF_matrix"
          fi
          if [[ "$percentC" != "0" && "$nucC" -gt "$nucG" ]];
          then
            echo ""$excitome_gene","$percentC"" >> "$RF_matrix" 
          fi
          if [[ "$percentG" != "0" && "$nucG" -gt "$nucC" ]];
          then
            echo ""$excitome_gene","$percentG"" >> "$RF_matrix" 
          fi
          if [[ "$percentG" == "0" && "$percentC" == "0" ]];
          then
            echo ""$excitome_gene",0" >> "$RF_matrix"
          fi
            echo ""$bamfile" has "$nucA" A's "$nucC" C's "$nucG" G's "$nucT" T's for a total of "$nuctotal" read depth which a "$percentG" % edited to a G or "$percentC" % edited to a C"
        fi
      else
        echo "Moving on to next sample"
      fi
    done
  done
  } < $INPUT
  IFS=$OLDIFS
dirres="$dir_path"/Results
dirresRF="$dirres"/random_forest
RF_matrix_dir="$dirresRF"/mergesamples
cd "$RF_matrix_dir"
cur_wkd="$RF_matrix_dir"
Rtool=$(echo "I_VEX")
Rtype=$(echo "multi")
GOI_file="$dirresRF"/temp.csv
summaryfile=none
tempfile3=transpose
names=$(echo "excitome_site")
file_out="$dirresRF"/excitomefreq_count_matrix.csv
echo1=$(echo "CREATING "$file_out"")
mes_out
mergeR
#file_out="$dirresRF"/excitomefreq_count_matrix.csv
#Rtool=transpose
#GOI_file="$dirresRF"/excitomefreq_count_matrixtrans.csv
#mergeR
#cat "$GOI_file" | sed 's/excitome_site/run/g' >> "$dir_path"/temp.csv
#file_in="$GOI_file"
#temp_file
# next transpose
# cat all "$RF_matrix_dir"/* files together into "$dirres"/RF_count_matrix.csv
# then run random_forest R for this file
file_in="$dirresRF"/excitomefreq_count_matrixtrans.csv
bamfiles=$(echo "${file_in##*/}")
bamfile=$(echo "${bamfiles%%.*}")
image1="$dirresRF"/"$bamfile"plot1.tiff
image2="$dirresRF"/"$bamfile"plot2.tiff
image3="$dirresRF"/"$bamfile"plot3.tiff
image4="$dirresRF"/"$bamfile"plot4.tiff
image5="$dirresRF"/"$bamfile"plot5.tiff
image6="$dirresRF"/"$bamfile"plot6.tiff
image7="$dirresRF"/"$bamfile"plot7.tiff
image8="$dirresRF"/"$bamfile"plot8.tiff
image9="$dirresRF"/"$bamfile"plot9.tiff
file_out="$dirresRF"/"$bamfile"RFstats.txt
#RFR
#run_tools



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
  human=$(config_get human);
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
    human=$(config_get human);
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
  INPUT="$ExToolsetix"/"$human"/excitome_loc.csv
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r excitome_gene gene_id chrome coord express_value
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres=$(config_get dirres);
    human=$(config_get human);
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
