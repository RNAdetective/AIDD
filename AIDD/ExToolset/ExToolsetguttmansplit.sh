create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$GOI_file" "$temp_file1" "$temp_file2" "$temp_file3" "$rename" #creates level of interest files
} # Runs multimerge R
guttman() {
Rscript "$ExToolset"/guttman.R  "$file_in" "$file_out1" "$file_out2" "$file_out3"
}
single_col() {
header=$(head -n 1 "$resdir"/"$filter".csv)
cat "$resdir"/"$filter".csv | awk -F "," ' { if (($'$col_num' == "'$infection'")) { print } }' | sed 's/ /,/g' | sed '1i '$header'' > "$new_dir"/"$infection".csv
}
double_col(){
header=$(head -n 1 "$resdir"/"$filter".csv)
cat "$resdir"/"$filter".csv | awk -F "," ' { if (($'$col_num1' == "'$infection'") && ($'$col_num2' == "'$Timepoint'")) { print } }' | sed 's/ /,/g' | sed '1i '$header'' > "$new_dir"/"$infection"_"$Timepoint".csv
}
triple_col() {
header=$(head -n 1 "$resdir"/"$filter".csv)
cat "$resdir"/"$filter".csv | awk -F "," ' { if (($'$col_num1' == "'$infection'") && ($'$col_num2' == "'$Timepoint'") && ($'$col_num3' == "'$CellLine'")) { print } }' | sed 's/ /,/g' | sed '1i '$header'' > "$new_dir"/"$infection"_"$Timepoint"_"$CellLine".csv
}
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
remove_temp1() {
if [ -s "$file_out" ];
then
  rm "$dir_path"/temp1.csv
fi
}
cut_col() {
cat "$file_out2" | cut -d',' -f "$col_num" | sed 's/'$type'/'$type''$file_name'/g' >> "$new_dir"/"$file_name".csv
}
rm_empty() {
for files in "$cur_wkd"/* ;
do
  if [ ! -s "$files" ];
  then
    rm "$files"
  fi
done
}
mes_out() {
dirqc="$dir_path"/quality_control
new_dir="$dirqc"
create_dir
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$run","$file_in","$tool"" >> "$dirqc"/time_check/"$run"time_check.csv
}
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
home_dir="$1"
dir_path="$2"

LOG_LOCATION="$dir_path"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/ExToolsetGuttmanSplit.log)
exec 2>&1

echo "Log Location will be: [ $LOG_LOCATION ]"
dirres="$dir_path"/Results
con1=Cause_of_death
con1_name1=Suicide
con1_name2=Natural
con2=MDD_Diagnosis
con2_name1=MDD
con2_name2=CTRL
con3=Brain_Region
con3_name1=aINS
con3_name2=Cg25
con3_name3=dlPFC
con3_name4=PFCB9
con3_name5=Sub
con3_name6=Nac
con3_name7=OFC
cat "$dirres"/random_forest/excitomefreq_count_matrixDESeq2.csv | cut -d',' -f 2 --complement | csvtools transpose | 
for mainfolder in MDDall ;
do
  for filter in guttman0percent guttman1percent guttman5percent ;
  do
    
    resdir="$dir_path"/"$mainfolder"/Results/"$filter"
    ExToolset=/home/user/AIDD/AIDD/ExToolset/scripts
    new_dir="$resdir"/GuttmanAll
    create_dir
    for infection in "$con1_name1" "$con1_name2" ;
    do
      for Timepoint in "$con2_name1" "$con2_name2" ;
      do
        for CellLine in "$con3_name1" "$con3_name2" "$con3_name3" "$con3_name4" "$con3_name5" "$con3_name6" "$con3_name7" ;
        do
          col_num1=3
          col_num2=5
          col_num3=6
          triple_col
        done
      done
    done
    new_dir="$resdir"/Guttman"$con2""$con3"
    create_dir
    for infection in "$con1_name1" "$con1_name2" ;
    do
      for Timepoint in "$con3_name1" "$con3_name2" "$con3_name3" "$con3_name4" "$con3_name5" "$con3_name6" "$con3_name7" ;
      do
        col_num1=3
        col_num2=6
        double_col
      done
    done
    new_dir="$resdir"/Guttman"$con2""$con1"
    create_dir
    for infection in "$con1_name1" "$con1_name2" ;
    do
      for Timepoint in "$con2_name1" "$con2_name2" ;
      do
        col_num1=3
        col_num2=5
        double_col
      done
    done
    new_dir="$resdir"/Guttman"$con2""$con3"
    create_dir
    for infection in "$con2_name1" "$con2_name2" ;
    do
      for Timepoint in "$con3_name1" "$con3_name2" "$con3_name3" "$con3_name4" "$con3_name5" "$con3_name6" "$con3_name7" ;
      do
        col_num1=5
        col_num2=6
        double_col
      done
    done
    new_dir="$resdir"/Guttman"$con1"
    create_dir
    for infection in "$con1_name1" "$con1_name2" ;
    do
      col_num=3
      single_col
    done
    new_dir="$resdir"/Guttman"$con2"
    create_dir
    for infection in "$con2_name1" "$con2_name2" ;
    do
      col_num=5
      single_col
    done
    new_dir="$resdir"/Guttman"$con3"
    create_dir
    for infection in "$con3_name1" "$con3_name2" "$con3_name3" "$con3_name4" "$con3_name5" "$con3_name6" "$con3_name7" ;
    do
      col_num=6
      single_col
    done
    for guttman in scores item trait ;
    do
      new_dir="$resdir"/"$guttman"
      create_dir
    done
    file_in="$resdir"/"$filter".csv
    file_out1="$resdir"/scores/allscores.csv
    file_out2="$resdir"/item/allitems.csv
    file_out3="$resdir"/trait/alltrait.csv
    Rscript "$ExToolset"/guttman.R "$file_in" "$file_out1" "$file_out2" "$file_out3"
    for batch in Guttman"$con1" Guttman"$con2" Guttman"$con3" Guttman"$con1""$con2" Guttman"$con1""$con3" Guttman"$con2""$con3" GuttmanAll ;
    do
      b_path="$resdir"/"$batch"
      for files in "$b_path"/* ;
      do
        if [ -f "$files" ];
        then
          for guttman in scores item trait ;
          do
            new_dir="$b_path"/"$guttman"
            create_dir
          done
          dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 9 -d '.')
          file_name=$(echo "$dir_name" | cut -f 1 -d '.')
          file_in="$files"
          file_out1="$b_path"/scores/all"$file_name"scores.csv
          file_out2="$b_path"/item/all"$file_name"items.csv
          file_out3="$b_path"/trait/all"$file_name"trait.csv
          tool=guttman
          file_out="$file_out1"
          run_tools
          for type in p level ;
          do
            new_dir="$b_path"/item/"$type"
            create_dir
            if [ "$type" == "p" ];
            then
              col_num="2,3"
            fi
            if [ "$type" == "level" ];
            then
              col_num="2,4"
            fi
            cut_col
          done 
        fi 
       done
    done
    for batch in Guttman"$con1" Guttman"$con2" Guttman"$con3" Guttman"$con1""$con2" Guttman"$con1""$con3" Guttman"$con2""$con3" GuttmanAll ;
    do
      cd "$b_path"/item
      cur_wkd="$b_path"/item
      rm_empty
      names=item
      file_out="$b_path"item.csv
      Rtool=I_VEX 
      Rtype=multi 
      GOI_file="$resdir"/temp1.csv 
      mergeR
      remove_temp1
      for type in p level ;
      do
        cd "$b_path"/item/"$type"
        cur_wkd="$b_path"/item/"$type"
        rm_empty
        names=item
        file_out="$b_path"item"$type".csv
        Rtool=I_VEX 
        Rtype=multi 
        GOI_file="$resdir"/temp1.csv 
        mergeR
        remove_temp1
      done
    done
    d_scores="$resdir"/scores
    Rtype=single 
    mergefile="$d_scores"/allscores.csv 
    file_in="$mergefile"
    cat "$file_in" | sed 's/pid/CATEGORY/g' >> "$dir_path"/temp.csv
    temp_file
    summaryfile="$resdir"/"$filter".csv
    phenofile="$resdir"/"$filter".csv 
    level_name=pid 
    file_in="$mergefile"
    file_out="$d_scores"/allscoresfinal.csv
    tool=mergeR
    run_tools
    file_in="$file_out"
    cat "$file_in" | cut -d',' -f 1,2,3,4,5,6,7,8,9,10 >> "$dir_path"/temp.csv
    temp_file
    for s_type in MAP MLE score ;
    do
      for Var_infection in All ;
      do
        new_dir="$d_scores"/"$s_type"
        create_dir
        new_dir="$d_scores"/"$s_type"/"$Var_infection"
        create_dir
        file_in="$d_scores"/allscoresfinal.csv
        file_out2="$new_dir"/"$Var_infection""$s_type""$con1""$con2""$con3"
        file_out3="$new_dir"/"$Var_infection""$s_type""$con1""$con2"
        file_out4="$new_dir"/"$Var_infection""$s_type""$con1""$con3"
        file_out5="$new_dir"/"$Var_infection""$s_type""$con2""$con3"
        file_out6="$new_dir"/"$Var_infection""$s_type""$con1"
        file_out7="$new_dir"/"$Var_infection""$s_type""$con2"
        file_out8="$new_dir"/"$Var_infection""$s_type""$con3"
        image1="$new_dir"/"$Var_infection""$s_type"1.tiff
        image2="$new_dir"/"$Var_infection""$s_type"2.tiff
        image3= "$new_dir"/"$Var_infection""$s_type"3.tiff
        image4="$new_dir"/"$Var_infection""$s_type"4.tiff
        cat "$ExToolset"/guttmanscore.R | sed 's/s_type/'$s_type'/g' | sed 's/Var_infection/'$Var_infection'/g' >> "$dir_path"/temp.R
        Rscript "$dir_path"/temp.R "$file_in" "$file_out2" "$file_out3" "$file_out4" "$file_out5" "$file_out6" "$file_out7" "$file_out8" "$image1" "$image2" "$image3" "$image4"
        rm "$dir_path"/temp.R
        echo "testing"$s_type""$Varinfection"
_________________________________
_________________________________
_________________________________"
      done
    done
  done
done

