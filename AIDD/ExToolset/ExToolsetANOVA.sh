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
cat "$allcm" | cut -d, --complement -f2-6 | sed 's/genename/sampname/g' | head -n 1 | tr ',' '\n' >> "$allindex"
}
Rbar() {
Rscript "$dir_path"/temp.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
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
mes_out # ERROR OUTPUT IS THERE
  else 
echo1=$(echo "CANT FIND "$file_in" FOR THIS "$sample"")
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
cat "$file_in" | sed '1i variables,Corr,lowCI,highCI,p_value' | sed 's/ //g' >> "$dir_path"/temp.R
temp_file
tool=Rbar
bartype=linewerr
#run_tools
}
####################################################################################################################
# RUNS EXTOOLSET FOR GTEX SUMMARY AND BARGRAPHS ADD ERROR BARS TO BARGRAPHS *TESTED
####################################################################################################################
source config.shlib;
count_matrix="$1"
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path);
echo "$dir_path"
dirres=$(config_get dirres);
dirresANOVA="$dirres"/ANOVA
dirresall="$dirresANOVA"/"$count_matrix"
new_dir="$dirresall"
create_dir
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
allcm="$dirresANOVA"/"$count_matrix"ANOVA.csv
allindex="$dirresall"/"$count_matrix"_index.csv
file_in="$allcm"
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
  count_matrix="$1"
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  dirres=$(config_get dirres);
  dirresANOVA="$dirres"/ANOVA
  con_name1=$(config_get con_name1);
  con_name1=$(echo ""$con_name1"" | sed 's/_//g')
  con_name2=$(config_get con_name2);
  con_name2=$(echo ""$con_name2"" | sed 's/_//g')
  con_name3=$(config_get con_name3);
  con_name3=$(echo ""$con_name3"" | sed 's/_//g')
  con_name4=$(echo "samp_name");
  con_name4=$(echo ""$con_name4"" | sed 's/_//g')
  echo1=$(echo "STARTING ANOVA FOR "$freq"")
  mes_out
  for cond_name in "$con_name1" "$con_name2" "$con_name3" sampname samp_name ;
  do
    cond_col=$(cat "$dir_path"/PHENO_DATA.csv | 
awk -F',' '{for(i=1;i<=NF;i++){A[NR,i]=$i};if(NF>n){n=NF}}
END{for(i=1;i<=n;i++){
for(j=1;j<=NR;j++){
s=s?s","A[j,i]:A[j,i]}
print s;s=""}}' | awk -F',' '{print $1}' | grep -n "$cond_name")
    cond_namecol=${cond_col%:*}
    condcount=$(cat "$dir_path"/PHENO_DATA.csv | awk -F ',' '{print $'$cond_namecol'}' | sort | uniq -c | sort -n | sed '1d' | wc -l)
    if [ "$condcount" > "2" ];
    then # if the number of conditions is greater then 2 run ANOVA
      dirrescon="$dirresANOVA"/"$count_matrix"/"$cond_name";
      new_dir="$dirrescon";
      create_dir
      file_in="$dirresANOVA"/"$count_matrix"ANOVA.csv;
      cat "$file_in" | sed 's/'$cond_name'.x/'$cond_name'/g' >> "$dir_path"/temp.csv
      temp_file
      file_out="$dirrescon"/"$freq"summary.tiff;
      file_out2="$dirrescon"/"$freq"summary2.tiff;
      bartype=ANOVA
      pheno="$dir_path"/PHENO_DATA.csv
      count_of_interest="$freq"
      sum_file="$dirrescon"/"$freq"summary.csv
      condition_name="$cond_name"
      sum_file2="$dirrescon"/"$freq"ANOVA.txt
      tool=Rbar
      sum_file="$dirresANOVA"/"$count_matrix"/"$cond_name"/"$freq"summary.csv
      cat "$ExToolset"/barchart.R | sed 's/freq_name/'$freq'/g' | sed 's/condition_name/'$cond_name'/g' >> "$dir_path"/temp.R
      run_tools
      rm "$dir_path"/temp.R
      if [ -s "$dirrescon"/"$freq"ANOVA.txt ];
      then
        line=$(echo "11")
        pvalue=$(sed -n "$line p" "$dirrescon"/"$freq"ANOVA.txt)
        justp=${pvalue#*:}
        if [ ! -s "$dirresANOVA"/"$count_matrix"/"$cond_name"allANOVA.csv ];
        then
          echo "variable,ANOVApvalue" >> "$dirresANOVA"/"$count_matrix"/"$cond_name"allANOVA.csv
        fi
        echo ""$freq","$justp"" >> "$dirresANOVA"/"$count_matrix"/"$cond_name"allANOVA.csv
      fi
    fi
    if [ "$condcount" == "2" ];
    then # if the number of conditions is only 2 run t-test
      new_dir="$dirresANOVA"/"$count_matrix"/Ttest
      create_dir
      dirrescon="$dirresANOVA"/"$count_matrix"/Ttest/"$cond_name";
      new_dir="$dirrescon";
      create_dir
      file_in="$dirresANOVA"/"$count_matrix"ANOVA.csv;
      cat "$file_in" | sed 's/'$cond_name'.x/'$cond_name'/g' >> "$dir_path"/temp.csv
      temp_file
      file_out="$dirrescon"/"$freq"summary.tiff;
      file_out2="$dirrescon"/"$freq"summary2.tiff;
      bartype=ANOVA
      pheno="$dir_path"/PHENO_DATA.csv
      count_of_interest="$freq"
      sum_file="$dirrescon"/"$freq"summary.csv
      condition_name="$cond_name"
      sum_file2="$dirrescon"/"$freq"Ttest.txt
      tool=Rbar
      sum_file="$dirrescon"/"$freq"summary.csv
      cat "$ExToolset"/barchart.R | sed 's/freq_name/'$freq'/g' | sed 's/condition_name/'$cond_name'/g' >> "$dir_path"/temp.R
      run_tools
      rm "$dir_path"/temp.R
      if [ -s "$dirrescon"/"$freq"Ttest.txt ];
      then
        line=$(echo "11")
        pvalue=$(sed -n "$line p" "$dirrescon"/"$freq"Ttest.txt)
        justp=${pvalue#*:}
        if [ ! -s "$dirresANOVA"/"$count_matrix"/"$cond_name"allTtest.csv ];
        then
          echo "variable,Ttestpvalue" >> "$dirresANOVA"/"$count_matrix"/"$cond_name"allTtest.csv
        fi
        echo ""$freq","$justp"" >> "$dirresANOVA"/"$count_matrix"/"$cond_name"allTtest.csv
      fi
    fi
    if [[ "$condcount" == "1" || "$condcount" == "" ]];
    then # if the number of conditions is only 1 or there is no column for that condition 
      echo1=$(echo ""$cond_name" ONLY HAS ONE VARIABLE OR DOES NOT EXIST EXTOOLSET CAN NOT RUN STATISTICS CHECK YOUR PHENO_DATA FILE")
      mes_out
    fi
  done
done 
rm "$dirresANOVA"/"$count_matrix"ANOVA.csv
} < $INPUT
IFS=$OLDIFS
con_name1=$(config_get con_name1);
con_name1=$(echo ""$con_name1"" | sed 's/_//g')
con_name2=$(config_get con_name2);
con_name2=$(echo ""$con_name2"" | sed 's/_//g')
con_name3=$(config_get con_name3);
con_name3=$(echo ""$con_name3"" | sed 's/_//g')
con_name4=$(echo "sampname");
con_name4=$(echo ""$con_name4"" | sed 's/_//g')
for cond_name in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ;
do
   cond_col=$(cat "$dir_path"/PHENO_DATA.csv | 
awk -F',' '{for(i=1;i<=NF;i++){A[NR,i]=$i};if(NF>n){n=NF}}
END{for(i=1;i<=n;i++){
for(j=1;j<=NR;j++){
s=s?s","A[j,i]:A[j,i]}
print s;s=""}}' | awk -F',' '{print $1}' | grep -n "$cond_name")
cond_namecol=${cond_col%:*}
  condcount=$(cat "$dir_path"/PHENO_DATA.csv | awk -F ',' '{print $'$cond_namecol'}' | sort | uniq -c | sort -n | sed '1d' | wc -l)
  if [ "$condcount" > "1" ];
  then
    echo1=$(echo "STARTING SUMMARY COLLECTION FOR "$cond_name"")
    mes_out
    cat "$dirres"/"$count_matrix"/"$cond_name"/*summary.csv | sed '2,${/^'$cond_name'/d;}' >> "$dirres"/"$count_matrix"/"$cond_name"allsummaries.csv
    file_in="$dirres"/"$count_matrix"/"$cond_name"allsummaries.csv
    file_out="$dirres"/"$count_matrix"/"$cond_name"allsummaries.tiff
    bartype=substitutions
    tool=Rbar
    cat "$ExToolset"/barchart.R | sed 's/condition_name/'$cond_name'/g' >> "$dir_path"/temp.R
    run_tools
    rm "$dir_path"/temp.R
  fi
  if [[ "$condcount" == "1" || "$condcount" == "" ]];
  then
    echo1=$(echo ""$cond_name" ONLY HAS ONE VARIABLE OR DOES NOT EXIST EXTOOLSET CAN NOT RUN STATISTICS CHECK YOUR PHENO_DATA FILE")
    mes_out
  fi
done
