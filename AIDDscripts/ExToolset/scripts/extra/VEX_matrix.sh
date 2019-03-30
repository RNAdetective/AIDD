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
raw_input4="$raw_input4"" >> "$dir_path"/AIDD/config.cfg ###################add more to these
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
raw_input4=Default Value" >> "$dir_path"/AIDD/config.cfg.defaults
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
cat "$dir_path"/PHENO_DATA.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f"$coln" | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' >> "$dir_path"/"$nam".csv
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
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" | sed '/^$/d' >> "$file_out"
} # cuts each column out of matrix and makes its own file
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname"
} # runs bargraph R script
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
  cat "$raw_input4" | sed '1,2d' | sed 's/	/,/g' | sed 's/    /,/g' | sed 's/  /,/g' | sed 's/ /,/g' | cut -d',' -f"$col_num" | sed '1i\ '$impact''$variable''$snptype'' | sed '/,0$/d' | sort -t, -u | sed 's/ /,/g' >> "$VC_dir"/"$level"/"$impact"/"$run""$snptype""$impact".csv
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
} # this will create impact files for each sample


GLDE() {
pheno_file="$dir_path"/PHENO_DATA.csv
index_dir="$dir_path"/AIDD/ExToolset/indexes
Rscript "$EXscript_dir"/GLDE.R "$dir_path" "$pheno_file" "$con_name" "$level" "$index_dir" "$set_design"
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
home_dir="$1" # home_dir=/home/user
dir_path="$2" # dir_path=/home/user/testAIDD 
ref_dir_path="$home_dir"/AIDD/references  # this is where references are stored
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix=/home/user/AIDD/AIDD/ExToolset/indexes
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
file_move="$dir_path"/PHENO_DATA.csv
get_file
file_in="$dir_path"/PHENO_DATA.csv
cat "$file_in" | sed 's/ //g' | sed '/^$/d' >> "$dir_path"/temp.csv
temp_file
cat "$dir_path"/PHENO_DATA.csv | awk 'NR==1' | sed 's/,/ /g' | sed "s/ /\n/g" | sed '1d' | sed '1d' | sed '2d' | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' >> "$dir_path"/AIDD/listofconditions.csv # creates list of conditions file 
cd "$dir_path"/AIDD
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
###############################################################################################################################################################
# CREATE FILE CHECK FILES TO CHECK FOR RAW DATA FILES                                                                                *TESTED
###############################################################################################################################################################
cd "$dir_path"/AIDD
echo1=$(echo "CHECKING DATA")
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
  snptype=gtf
  temp_dir # delete temp directories if present
  create_filecheck
  type1=none
  type2="$raw_input2"
  snptype=summary
  create_filecheck
  for snptype in AG ADARediting All ;
  do
    filecheckVC="$dirqc"/filecheckVC
    raw_input3="$dirraw"/snpEff/snpEff"$run""$snptype".csv
    type1="$raw_input3"
    type2=none
    create_filecheck
    filecheckVC="$dirqc"/filecheckVC
    raw_input4="$dir_path"/raw_data/snpEff/snpEff"$run""$snptype".genes.txt
    type2="$raw_input4"
    type1=none
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
for snptype in AG ADARediting All ;
do
  raw_check3="$dirqc"/filecheckVC/filecheck"$snptype"1.csv #snpeff.csv
  for in_file in "$raw_check3" ;
  do
    checkfile
  done
done
for snptype in AG ADARediting All ;
do
  raw_check4="$dirqc"/filecheckVC/filecheck"$snptype"2.csv #snpeff.txt
  for in_file in "$raw_check4" ;
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
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    #any_no= # count how many lines contain no "$filecheckVC"/filecheck"$snptype"2.csv
    #if [ "$any_no" == "0" ];
    #then
      summary_split
    #else
      #echo1=$(echo "missing alignment_metrics files check "$filecheckVC"/filecheck"$snptype"2.csv for more details")
    #fi
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
  #any_no= # count how many lines contain no "$filecheckVC"/filecheck"$snptype"1.csv
  #if [ "$any_no" == "0" ];
  #then
    creatematrix
  #else
  #  echo "Please check for misssing files"
  #fi
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
      file_out="$dirres"/"$level"_count_matrixedited.csv
      file_in="$dirres"/"$level"_count_matrix.csv
      index_file="$ExToolsetix"/index/"$level"_names.csv
      pheno_file="$dir_path"/PHENO_DATA.csv
      Rtool=GTEX
      level_id=$(echo ""$level"_id");
      level_name=$(echo ""$level"_name");
      filter_type=$(echo "protein_coding");
      level="$level"
      sed -i 's/-/_/g' "$index_file"
      echo1=$(echo "CREATING "$file_out"")
      mes_out
      matrixeditor
    else
      echo1=$(echo "ALREADY FOUND "$matrix_fileedit" OR "$matrix_fileedit2"")
      mes_out
    fi
  else
    echo1=$(echo "CANT FIND "$matrix_file" OR "$matrix_file2"")
    mes_out
  fi
done # NOW HAVE GENE AND TRANSCRIPT OF INTEREST FILES AND EDITED COUNT_MATRIX FILES
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
    cat "$file_out" | sed 's/'$sample'/'$samp_name'/g' >> "$dir_path"/temp.csv
    file_in="$file_out"
    temp_file
  done
done 
} < $INPUT
IFS=$OLDIFS
for level in gene transcript ;
do
  if [[ -s "$matrix_fileedit" && -s "$matrix_fileedit2" ]];
  then
    if [ ! -s "$matrix_file3" ];
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
      sed -i '2d' "$file_out"
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
    sed -i '2d' "$file_out"
  else
    echo1=$(echo "ALREADY FOUND "$matrix_file4"")
    mes_out
  fi
else
  echo1=$(echo "CANT FIND "$matrix_file"") 
  mes_out
fi # NOW HAVE EXCTIOME MATRIX
if [[ -s "$matrix_file3a" && -s "$matrix_file3b" ]];
then
  if [ ! -s "$matrix_file5" ];
  then
    cur_wkd="$dirres"
    summaryfile=none
    Rtool=finalmerge
    Rtype=single2f
    level_name=$(echo "gene_name")
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
    cur_wkd="$dirres"
    summaryfile=none
    Rtool=finalmerge
    Rtype=single2f
    file_out="$dirres"/GTEX_count_matrix.csv
    mergefile="$dirres"/genetrans_count_matrix.csv
    phenofile="$dirres"/excitome_count_matrix.csv
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
    raw_input3="$dirraw"/snpEff/snpEff"$run""$snptype".csv
    echo1="Starting G_VEX for "$run""
    mes_out
    for snptype in AG ADARediting All ;
    do
      #any_no= # count how many lines contain no "$filecheckVC"/filecheck"$snptype"1.csv
      #if [ "$any_no" == "0" ];
      #then
        cat "$raw_input3" | sed '1d' | sed 's/# />/g' | sed 's/\//_/g' | sed  '/^\s*$/d' | sed 's/Base/'$run'nucleotide_count_matrixprep/g' | sed 's/Amino/'$run'amino_acid_count_matrixprep/g' >> "$dirVCsubs"/"$run""$snptype".csv
      #else
        #echo "Can't find files for GVEX" ; exit ;
      #fi
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
        matrixeditor 
        cat "$pheno_file" | cut -d',' -f2,3 | sed '1d' | sed '1i sub_names,'$run'' >> "$dir_path"/temp.csv
        if [ -s ""$dir_path"/temp.csv" ];
        then
          rm "$pheno_file"
        fi
        mv "$dir_path"/temp.csv "$pheno_file"
      done
    done
  done 
  } < $INPUT
  IFS=$OLDIFS
  summaryfile="$dir_path"/quality_control/alignment_metrics/all_summaryPF_READS_ALIGNED.csv
  run=$(awk -F',' 'NR==2 { print $2 }' "$dir_path"/PHENO_DATA.csv)
  sed -i 's/'$run'/'$run'.x/g' "$summaryfile"
  if [ -s "$summaryfile" ];
  then
    for snptype in AG ADARediting All ;
    do
      for level in nucleotide amino_acid ;
      do
        cur_wkd="$dirVC"/"$level"/merge"$snptype";
        file_out="$dirVC"/"$level"/"$level""$snptype"_count_matrix.csv
        cd "$dirVC"/"$level"/merge"$snptype"
        Rtool=G_VEX
        Rtype=multi
        names=$(echo "sub_names")
        mergefile=none
        phenofile=none
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
          cat "$file_out" | awk -F',' '{$'$newcol_num' = sprintf("%.5f", $'$sub_col' / $'$summary' * '$norm')}1' | sed 's/-nan/'$subname'norm/g' | sed 's/      /,/g' | sed 's/  /,/g' | sed 's/ /,/g' | sed 's/.x//g' >> "$dir_path"/temp2.csv
          if [ -s ""$dir_path"/temp2.csv" ];
          then
            rm "$file_out"
            mv "$dir_path"/temp2.csv "$file_out"
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
        cat "$final_file2" | sed 's/.x//g' | sed 's/.y//g' | cut -d',' --complement -f2-15 >> "$dir_path"/temp.csv
        file_in="$final_file2"
        temp_file
      fi
      if [ "$level" == "nucleotide" ];
      then
        cat "$final_file2" | sed 's/.x//g' | sed 's/.y//g' | cut -d',' --complement -f2-18 >> "$dir_path"/temp.csv
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
      end_VC="$VC_dir"/"$level"/"$impact"/"$cond_name"
      con_name1=$(config_get con_name1);
      con_name2=$(config_get con_name2);
      con_name3=$(config_get con_name3);
      raw_input4="$dir_path"/raw_data/snpEff/snpEff"$run""$snptype".genes.txt
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
          for snptype in AG ADARediting All ;
          do
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
              col_num="2,7"
              filter_impact
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
    VC_dir="$dirres"/variant_calling/impact
    for level in gene transcript ;
    do
      for impact in high_impact moderate_impact ;
      do
        for snptype in All AG ADARediting ;
        do
          file_in="$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv
          summary=$(head -n 1 "$file_in" | awk -F',' '{ print NF }')
          counts=$(expr "$summary" - "1")
          newcol_num=$(expr "$summary" + "1")
          norm=$(echo "10000")
          cut_col=$(echo "1,"$newcol_num"")
          cat "$file_in" | awk -F',' '{$'$newcol_num' = sprintf("%.5f", $'$counts' / $'$summary' * '$norm')}1'| sed 's/-nan/'$level''$impact''$snptype'normalized/g' | sed 's/ /,/g' | cut -d',' -f"$cut_col" | sort | uniq >> "$dir_path"/temp.csv
          temp_file
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
  else
    echo1=$(echo "CANT FIND "$matrix_file11"")
    mes_out
  fi
else
  echo1=$(echo "ALREADY FOUND "$matrix_filefinal"")
  mes_out
fi
####################################################################################################################
# RUNS EXTOOLSET FOR GTEX SUMMARY AND BARGRAPHS ADD ERROR BARS TO BARGRAPHS
####################################################################################################################
INPUT="$ExToolsetix"/gene_list/DESeq2/excitome.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r x freq
do
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  dirresex="$dirres"/excitome
  new_dir="$dirresex"
  create_dir
  echo ""$freq""
  file_in="$dirres"/excitome_count_matrix.csv;
  file_out="$dirres"/excitome/"$freq"summary.tiff;
  bartype=excitome
  sampname=samp_name
  pheno="$dir_path"/PHENO_DATA.csv
  tool=Rbar
  sum_file="$dirres"/excitome/"$freq"summary.csv
  sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
  run_tools
  sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R 
done 
} < $INPUT
IFS=$OLDIFS # excitome summaries
cd "$dir_path"/AIDD
for level in gene transcript ;
do
  INPUT="$ExToolsetix"/gene_list/DESeq2/"$level"ofinterest.csv
  OLDIFS=$IFS  
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  read
  while IFS=, read -r x freq
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres=$(config_get dirres);
    dirresex="$dirres"/"$level"ofinterest
    new_dir="$dirresex"
    create_dir
    echo "NOW STARTING SUMMARY ANALYSIS OF "$freq""
    file_in="$dirres"/"$level"ofinterest_count_matrix.csv;
    file_out="$dirres"/"$level"ofinterest/"$freq"summary.tiff;
    bartype=excitome
    sampname=samp_name
    pheno="$dir_path"/PHENO_DATA.csv
    tool=Rbar
    sum_file="$dirres"/"$level"ofinterest/"$freq"summary.csv
    sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    run_tools
    sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R 
  done 
  } < $INPUT
  IFS=$OLDIFS
done #gene and transcript of interest summaries
cd "$dir_path"/AIDD
for level in amino_acid nucleotide ;
do
  if [ "$level" == "nucleotide" ];
  then
    cat "$dirres"/"$level"_count_matrix.csv | cut -d',' --complement -f2,7,12,17 >> "$dir_path"/temp.csv
    temp_file
    fi
  INPUT="$ExToolsetix"/index/"$level"_names.csv
  OLDIFS=$IFS  
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  read
  while IFS=, read -r x freq
  do
    source config.shlib;
    home_dir=$(config_get home_dir);
    dir_path=$(config_get dir_path);
    dirres=$(config_get dirres);
    dirresex="$dirres"/"$level"
    freq=$(echo ""$freq"norm")
    new_dir="$dirresex"
    create_dir
    echo "NOW STARTING SUMMARY ANALYSIS OF "$freq""
    file_in="$dirres"/"$level"_count_matrix.csv;
    file_out="$dirres"/"$level"/"$freq"summary.tiff;
    bartype=excitome
    pheno="$dir_path"/PHENO_DATA.csv
    sampname=run
    tool=Rbar
    sum_file="$dirres"/"$level"/"$freq"summary.csv
    sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    run_tools
    sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R 
  done 
  } < $INPUT
  IFS=$OLDIFS
done
for level in amino_acid nucleotide ;
do
  cat "$dirres"/"$level"/*.csv | sed '2,${/^condition/d;}' >> "$dirres"/"$level"/"$level"allsummaries.csv
  file_in="$dirres"/"$level"/"$level"allsummaries.csv
  file_out="$dirres"/"$level"/"$level"allsummaries.tiff
  bartype=substitutions
  tool=Rbar
  run_tools
done #amino_acid and nucleotide substitution summaries 
cd "$dir_path"/AIDD
  path="$dir_path"/tempindex.csv
  remove_stuff
  cat "$dirres"/impact_count_matrix.csv | head -n 1 | tr ',' '\n' >> "$dir_path"/tempindex.csv
  INPUT="$dir_path"/tempindex.csv
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
    dirresex="$dirres"/impact
    freq=$(echo "$freq")
    new_dir="$dirresex"
    create_dir
    echo "NOW STARTING SUMMARY ANALYSIS OF "$freq""
    file_in="$dirres"/impact_count_matrix.csv;
    file_out="$dirres"/impact/"$freq"summary.tiff;
    bartype=excitome
    pheno="$dir_path"/PHENO_DATA.csv
    tool=Rbar
    sampname=run
    sum_file="$dirres"/impact/"$freq"summary.csv
    sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    run_tools
    sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R 
  done 
  } < $INPUT
  IFS=$OLDIFS
for level in amino_acid nucleotide ;
do
  cat "$dirres"/impact/*.csv | sed '2,${/^condition/d;}' >> "$dirres"/impact/impactallsummaries.csv
  file_in="$dirres"/impact/impactallsummaries.csv
  file_out="$dirres"/impact/impactallsummaries.tiff
  bartype=substitutions
  tool=Rbar
  run_tools
done # summarize variant impact 
####################################################################################################################
# RUNS EXTOOLSET FOR ANOVA AND CORRELATION BETWEEN GTEX AND VEX
####################################################################################################################
##For all_count_matrix.csv do ANOVA
#merge nucleo_tide and amino acid with excitome and interest files
#merge those with high and impact counts final file with have following columns
#samp_name,run,con1,sample,con2,con3,excitome_genes.....,excitome_trans....,AtoGsubs,AminoAcidsubs.....,TotalAAsubs,high,moderate
#then the rows will be each sample
##correlations between
#for condition in con_name1 con_name2 con_name3 con_name4 con_name5 con_name6 con_name7 ; do
  #for gene in ADAR1 ADAR1p150 ADAR2 ADAR2isoforms... ADAR3 ; do #put these in an index file csv to input to read rows
    #for var in AtoG AA.... AAimptotal high moderate ; do #put these in an index file to imput to read rows
      #gene and var
    #done
  #done
  #for gene in ADAR2 ADAR3 GRIA1-4 ; do
    #for gene2 in ADAR1 ADAR1p150 ADARp110; do
      #gene and ADAR1
      ##collect correlations in a csv for each one so rows would be ADAR1 to AtoG, ADAR1 to AA1 ..... ADAR3 to moderate and the columns will be name,correlation,highCI.lowCI,p-value >> excitomecorrelations.csv
      ##low .4<corr>.6 , moderate .61<corr>.80 ,high .81<corr>1.0 
      ##then graph each blue 1 x=corr_names y=corr for low,mod and high
    #done
  #done
#done
##then create bargraphs for this correlation table 
  #filter by correlations low .4<corr>.6 , moderate .61<corr>.80 ,high .81<corr>1.0
  #graph with colored/grouped by condition1-7
##ANOVA run anova on 
