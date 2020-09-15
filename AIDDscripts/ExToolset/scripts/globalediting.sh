create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
}
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$GOI_file" "$temp_file1" "$temp_file2" "$temp_file3" "$rename" #creates level of interest files
} # Runs multimerge R
echo "Moving and editing files"
for batch in COVID19single ; 
do 
  dir=/media/sf_AIDD/"$batch"/Results/guttman/stackdepth ;
  fdir=/media/sf_AIDD/"$batch"/Results/guttman ;
  for files in "$dir"/* ;
  do 
    dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 7 -d '.')
    file_name=$(echo "$dir_name" | cut -f 1 -d '.')
    cat "$files" | sed '1i excitome_site,'$file_name'' | sed 's/stackdepth//g' >> "$fdir"/"$file_name".csv
  done
  for type in ADAR APOBEC AllNoSnps ;
  do     
    for folder in Effects Quality Change Count ;
    do  
      dir=/media/sf_AIDD/"$batch"/Results/variant_calling ;     
      fdir=/media/sf_AIDD/"$batch"/Results/variant_calling/"$folder";
      new_dir="$fdir"/"$type";
      create_dir;
      new_dir="$fdir"/"$type"/"$folder";
      create_dir;
      for files in "$dir"/"$folder"/merge"$type"editing/* ;
      do
        dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 9 -d '.')
        file_name=$(echo "$dir_name" | cut -f 1 -d '.')
        new_dir="$fdir"/"$type"/"$folder"/Edited
        create_dir
        if [ "$folder" == "Change" ];
        then
          file_out="$new_dir"/"$file_name"Rate.csv
          cat "$files" | awk -F',' '!seen[$3]++' | sed 's/Change_rate/'$file_name'/g' | sed 's/'$folder'//g' | cut -d',' -f1,4 >> "$file_out"
        else
          file_out="$new_dir"/"$file_name"Percent.csv
          cat "$files" | awk -F',' '!seen[$3]++' | cut -d',' -f 1,3 | sed 's/Percent/'$file_name'/g' | sed 's/'$folder'//g' >> "$file_out"
        fi
      done
    done
  done
done
echo "combining files"
for type in ADAR APOBEC AllNoSnps ;
do
  for folder in Effects Count Change Quality ;
  do
    cd "$fdir"/"$type"/"$folder"/Edited
    Rtool=G_VEX
    Rtype=multi
    GOI_file="$fdir"/"$type"/"$folder"/temp.csv
    temp_file1="$fdir"/"$type""$folder".csv
    file_out="$fdir"/"$type"/"$folder"/temp2.csv
    if [ "$folder" == "Change" ];
    then
      names=$(echo "Chromosome")
    else
      names=$(echo "Type")
    fi
    ExToolset=/home/user/AIDD/AIDD/ExToolset/scripts
    mergeR
    file_out="$fdir"/"$type""$folder".csv
    header=$(head -n 1 "$file_out")
    newheader=$(echo "run"$header"")
    cat "$file_out" | sed '/.y/ d' | sed 's/.x//g' | sed '1d' | sed '1i '$newheader'' | sed 's/NA/0/g' >> /media/sf_AIDD/temp.csv
    if [ -f /media/sf_AIDD/temp.csv ];
    then
      rm "$file_out"
      mv /media/sf_AIDD/temp.csv "$file_out"
    fi
    Rtype=single
    level_name=$(echo "run")
    file_out="$fdir"/"$type""$folder"final.csv
    mergefile="$fdir"/PHENO_DATA.csv
    phenofile="$fdir"/"$type""$folder".csv
   # mergeR
    if [ -f "$file_out" ];
    then
      rm -d -f -r "$fdir"/"$type"/"$folder"/Edited
      rm "$fdir"/"$type""$folder".csv
    fi
  done
done
fdir=/media/sf_AIDD/"$batch"/Results/guttman/stackdepth ;
cd "$fdir"
Rtool=G_VEX
Rtype=multi
GOI_file="$fdir"/temp.csv
temp_file1="$fdir"/allstackdepth.csv
file_out="$fdir"/temp2.csv
names=$(echo "excitome_site")
ExToolset=/home/user/AIDD/AIDD/ExToolset/scripts
mergeR



