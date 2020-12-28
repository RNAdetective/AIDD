#!/usr/bin/env bash
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
dir_path=/home/user/AIDDtest
dirresVC="$dir_path"/Results/variant_calling
dirgl="$dirresVC"/impact/final/genelists
con_name1=$(echo "suicide"); #suicide
con_name2=$(echo "Sex"); #sex
con_name3=$(echo "MDD"); #MDD
for level in gene transcript ;
do
  for impact in moderate_impact high_impact ;
  do
    for snptype in All AG ADAR ;
    do
      for cond_2 in male female ;
      do
        for con_nam in "$con_name3" "$con_name1" ;
        do
          file_in="$dirgl"/"$snptype"/"$level""$impact""$con_name2"_"$cond_2""$con_nam""$snptype".csv
          file_out="$dirgl"/"$snptype"/VENND"$level""$impact""$con_name2"_"$cond_2""$con_nam""$snptype".csv
          bartype=Venn
          file_out2="$dirgl"/"$snptype"/"$level""$impact""$con_name2"_"$cond_2""$con_nam""$snptype".tiff
          tool=Rbar
          column_nam1=$(echo ""$level""$impact""$con_name2"_"$cond_2""$con_name3"_yes"$snptype"")
          column_nam2=$(echo ""$level""$impact""$con_name2"_"$cond_2""$con_name3"_no"$snptype"")
          set_column_name=$(echo ""$column_nam1","$column_nam2"")
          sed 's/set_column_name/'$set_column_name'/g' "$ExToolset"/barcharts.R
          run_tools
          sed 's/'$set_column_name'/set_column_name/g' "$ExToolset"/barcharts.R
        done
      done
    done
  done
done
for level in gene transcript ;
do
  for condition_name in "$con_name1" "$con_name2" "$con_name3" ;
  do
    file_in="$dirres"/"$level"_count_matrixedited.csv
    cat "$file_in" | awk -F',' '!v[$1]++' >> "$dir_path"/temp.csv
    temp_file
    echo1=$(echo "STARTING "$file_in"")
    mes_out
    file_in="$dirres"/"$level"_count_matrixedited.csv
    pheno="$dir_path"/PHENO_DATA.csv
    set_design="$condition_name"
    level_name=level_name
    dirresDE="$dirres"/DESeq2
    new_dir="$dirresDE"
    create_dir
    dirresDElevel="$dirresDE"/"$level"
    new_dir="$dirresDElevel"
    create_dir
    dirresDElevelcon="$dirresDElevel"/"$condition_name"
    new_dir="$dirresDElevelcon"
    create_dir
    dirresDEcal="$dirresDElevelcon"/calibration
    new_dir="$dirresDEcal"
    create_dir
    dirresDEPCA="$dirresDElevelcon"/PCA
    new_dir="$dirresDEPCA"
    create_dir
    dirresDELDE="$dirresDElevelcon"/DE
    new_dir="$dirresDELDE"
    create_dir
    dirresDELDEvd="$dirresDElevelcon"/DE/vennD
    new_dir="$dirresDELDEvd"
    create_dir
    file_out="$dirresDELDE"/resultsall.csv
    tool=DE_R
    run_tools
    for updown in upregGlist upreg100 downreg100 downregGlist ;
    do
      file_in="$dirresDELDEvd"/"$updown".csv
      file_out="$dirresDELDEvd"/"$updown".txt
      image_out="$dirresDELDEvd"/"$updown".tiff
      bartool=Venn
      tool=Rbar
          column_nam1=$(echo ""$level""$impact""$con_name2"_"$cond_2""$con_name3"_yes"$snptype"")
          column_nam2=$(echo ""$level""$impact""$con_name2"_"$cond_2""$con_name3"_no"$snptype"")
          set_column_name=$(echo ""$column_nam1","$column_nam2"")
         # sed 's/set_column_name/'$set_column_name'/g' "$ExToolset"/barcharts.R
          #run_tools
         # sed 's/'$set_column_name'/set_column_name/g' "$ExToolset"/barcharts.R
    done
  done
done
