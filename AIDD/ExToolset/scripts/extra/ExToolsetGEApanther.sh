create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
}
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$temp_file1" "$temp_file2" "$temp_file3" "$Rtooltrans" #creates level of interest files
} # Runs multimerge R
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
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
mes_out() {
dirqc="$dir_path"/quality_control
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$run","$file_in","$tool"" >> "$dirqc"/time_check/"$run"time_check.csv
}
pan_out_csv() {
    cat "$file_in" | sed 's/\t/,/g' | sed 's/ /_/g' | sed 's/cellular/cell/g' | sed 's/response/res/g' | sed 's/biological/bio/g' | sed 's/(//g' | sed 's/)//g' | sed 's/:/_/g' | sed 's/%//g' | sed '1i row_num,GOterm,'$samp_name',percent1,percent2' | cut -d',' -f 2,3 >> "$file_out" #takes output text and converts to csv and removes spaces and ( ) and : and shortens some names
}
create_index() {
  cat "$file_in" | head -n 1 | tr ',' '\n' >> "$file_out"
}
dir_path="$1"
GEA_main="$dir_path"/Results/variant_calling/impact/GEA
GEA_output="$dir_path"/GEA_output
new_dir="$GEA_main"
create_dir
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  for f_name in biologicalprocess cellresstim cellularmetabolicprocess cellularprocess localization metabolicprocess signaltrans ;
  do
    dir_path="$1"
    GEA_main="$dir_path"/Results/variant_calling/impact/GEA
    GEA_output="$dir_path"/GEA_output
    GEA_ind="$GEA_main"/"$f_name"
    new_dir="$GEA_ind"
    create_dir
    file_in="$GEA_output"/"$run""$f_name".txt
    file_out="$GEA_ind"/"$run""$f_name".csv
    tool=pan_out_csv
    run_tools
  done
done 
} < $INPUT
IFS=$OLDIFS
for f_name in biologicalprocess cellresstim cellularmetabolicprocess cellularprocess localization metabolicprocess signaltrans ;
do
  GEA_ind="$GEA_main"/"$f_name"
  ExToolset=/home/user/AIDD/AIDD/ExToolset/scripts
  cur_wkd=$(echo ""$GEA_ind"");
  cd "$cur_wkd"
  names=$(echo "GOterm");
  GEA_all="$GEA_main"/all
  new_dir="$GEA_all"
  create_dir
  file_out="$GEA_all"/allsamp"$f_name".csv
  Rtool=$(echo "I_VEX");
  Rtype=$(echo "multi");
  temp_file1="$dir_path"/temp1.csv
  temp_file2="$dir_path"/temp2.csv
  temp_file3="$dir_path"/temp3.csv
  mergeR
  header=$(head -n 1 "$file_out")
  sed -i '1d' "$file_out"
  sed -i '1iGOTerm'$header'' "$file_out"
done
cur_wkd=$(echo ""$GEA_all"");
file_out="$GEA_main"/allsamp.csv 
cat "$cur_wkd"/* >> "$file_out"
header=$(head -n 1 "$file_out")
cat "$file_out" | sort -u | uniq -u | sed 's/ /,/g' | sed '/^GOTerm/d' | sed '1i'$header'' | sed 's/NA/0/g' | cut -d',' --complement -f2 | sed 's/.y//g'  >> "$dir_path"/temp.csv
if [ "$dir_path"/temp.csv ];
then
  rm "$file_out"
  mv "$dir_path"/temp.csv "$file_out"
fi
  Rtooltrans=transpose
  Rtype=transpose
  temp_file1="$GEA_main"/allsamptrans.csv
  file_out="$GEA_main"/allsamp.csv 
  mergeR
  header=$(head -n 1 "$temp_file1")
  sed -i '1d' "$temp_file1"
  sed -i '1isampname'$header'' "$temp_file1"
  file_in="$GEA_main"/allsamptrans.csv
  mergefile="$file_in"
  phenofile="$dir_path"/PHENO_DATA.csv
  Rtype=single2f
  file_out="$GEA_main"/allsamptrans2.csv
  level_name=$(echo "sampname")
  tool=mergeR
  run_tools
  file_in="$GEA_main"/allsamptrans2.csv
  file_out="$GEA_main"/allsampindex.csv
  tool=create_index
  run_tools
cd "$dir_path"/AIDD
INPUT="$GEA_main"/allsampindex.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r GOterm
do
  source config.shlib;
  con_name1=$(config_get con_name1);
  con_name2=$(config_get con_name2);
  con_name3=$(config_get con_name3);
  con_name4=$(echo "sampname");
  echo1=$(echo "STARTING ANOVA FOR "$GOterm"")
  mes_out
  for cond_name in "$con_name1" "$con_name2" "$con_name3" "$con_name4";
  do
    dir_path="$1"
    GEA_main="$dir_path"/Results/variant_calling/impact/GEA
    GEA_output="$dir_path"/GEA_output
    GEA_ind="$GEA_main"
    GEA_cond="$GEA_ind"/"$con_name"
    new_dir="$GEA_cond"
    create_dir
    GEA_ANOVA="$GEA_ind"/"$con_name"/ANOVA
    new_dir=GEA_ANOVA
    create_dir
    file_in="$GEA_ind"/allsamptrans2.csv;
    file_out="$GEA_cond"/"$GOterm".tiff;
    file_out2="$GEA_cond"/"$GOterm"2.tiff;
    bartype=ANOVA
    pheno="$dir_path"/PHENO_DATA.csv
    count_of_interest="$GOterm"
    sum_file="$GEA_ANOVA"/"$GOterm"summary.csv
    sum_file2="$GEA_ANOVA"/"$GOterm"ANOVA.txt
    tool=Rbar
    sed -i 's/freq_name/'$GOterm'/g' "$ExToolset"/barchart.R
    sed -i 's/condition_name/'$cond_name'/g' "$ExToolset"/barchart.R
    run_tools
    sed -i 's/'$GOterm'/freq_name/g' "$ExToolset"/barchart.R 
    sed -i 's/'$cond_name'/condition_name/g' "$ExToolset"/barchart.R
  done # now will have ind ANOVA results in a directory
done 
} < $INPUT
IFS=$OLDIFS
for cond_name in "$con_name1" "$con_name2" "$con_name3" "$con_name4";
do
  for f_name in biologicalprocess cellresstim cellularmetabolicprocess cellularprocess localization metabolicprocess signaltrans ;
  do
#    cat "$GEA_ANOVA"/*ANOVA.txt >> "$GEA_cond"/"$f_name""$cond_name"ANOVAsummary.csv #collect all ANOVA to one summary file
#    cat "$GEA_cond"/"$f_name""$cond_name"ANOVAsummary.csv | awk -F ',' '($2 > 0.05) {print $1}' >> "$GEA_cond"/"$con_name""$f_name"ANOVAremove.csv
    INPUT="$GEA_cond"/"$con_name""$f_name"ANOVAremove.csv
    OLDIFS=$IFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while IFS=, read -r GOTerm
    do
#      mv "$GEA_ANOVA"/"$f_name""$GOterm"summary.csv "$GEA_ANOVA"/"$f_name""$GOterm"sumremoved.csv
    done 
    } < $INPUT
    IFS=$OLDIFS
#    cat "$GEA_ANOVA"/*summary.csv >> "$GEA_cond"/"$f_name""$cond_name"summary.csv #collect all summary files not removed because of not significant p-value to one summary file
    file_in="$GEA_cond"/"$f_name""$cond_name"summary.csv
    file_out="$GEA_cond"/"$f_name""$cond_name"summary.tiff
    bartype=substitutions
    tool=Rbar
#    sed -i 's/condition_name/'$cond_name'/g' "$ExToolset"/barchart.R
#    run_tools
#    sed -i 's/'$cond_name'/condition_name/g' "$ExToolset"/barchart.R
  done
done
