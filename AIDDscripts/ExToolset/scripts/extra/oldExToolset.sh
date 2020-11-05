filter_impact() {
#any_no= # count how many lines contain no "$filecheckVC"/filecheck"$snptype"2.csv
#if [ "$any_no" == "0" ];
#then
addcondition=$(echo ""$con_name1"_"$condition"_"$con_name2"_"$condition2"_"$con_name3"_"$condition3"_"$con_name4"_"$condition4"")
  cat "$raw_input4" | sed '1,2d' | sed 's/	/,/g' | sed 's/    /,/g' | sed 's/  /,/g' | sed 's/ /,/g' | cut -d',' -f"$col_num" | sed '/,0$/d'  | sed 's/ /,/g' | awk '{a[$1]+=$2}END{for(k in a)print k,a[k]}' FS=, OFS=, | sort | sed '1i id,'$run'' >> "$VC_dir"/"$level"/"$impact"/"$run""$snptype""$addcondition".csv
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
file_in="$ExToolset"/DE.R
cat "$file_in" | sed 's/set_design/'$condition_name'/g' >> "$dir_path"/temp.R
Rscript "$dir_path"/temp.R "$file_in" "$pheno" "$set_design" "$level_name" "$rlog" "$log" "$transcounts" "$PoisHeatmap" "$PCA" "$PCA2" "$MDSplot" "$MDSpois" "$resultsall" "$upreg" "$upreg100" "$upregGlist" "$downreg" "$downreg100" "$downregGlist" "$heatmap" "$volcano"
rm "$dir_path"/temp.R
}
end_check() {
if [ "$var1" == "$varA" ];
then
  "$tool"
  cd "$home_dir"/scripts
fi
}
makeDESeq2() {
file_in="$resdir"/"$name"_count_matrixDESeq2.csv
file_out="$dir_path"/temp.csv
cat "$file_in" | cut -d, --complement -f2 | sed 's/.y//g' >> "$file_out" 
file_in="$resdir"/"$name"_count_matrixDESeq2.csv
temp_file
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
  file_in="$resdir"/"$name"_count_matrixDESeq2.csv
  cat "$file_in" | sed 's/'$run'/'$samp_name'/g' | sed 's/ /,/g' >> "$dir_path"/temp.csv
  temp_file
done 
} < $INPUT
IFS=$OLDIFS
header=$(head -n 1 "$file_in")
cat "$file_in" | sed '1d' | sed '1i samp_name'$header'' | csvtool transpose >> "$dir_path"/temp.csv
temp_file
count_matrix="$resdir"/"$name"_count_matrixDESeq2.csv
Rtool=finalmerge
Rtype=single2f
GOI_file="$dirres"/"$name"_count_matrixANOVA.csv
file_out="$dirres"/"$name"_count_matrixANOVA.csv
mergefile="$resdir"/"$name"_count_matrixDESeq2.csv
phenofile="$dir_path"/PHENO_DATA.csv
level_name=$(echo "samp_name")
echo1=$(echo "CREATING "$file_out"")
mes_out
mergeR
cp "$resdir"/"$name"_count_matrixDESeq2.csv "$dirres"/"$name"_count_matrixDESeq2.csv
}
GvennR() {
Rscript "$ExToolset"/Gvenn.R "$file_in" "$file_out" "$image_out"
}










if [ ! "$missing" == "0" ];
then
  echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
  mes_out
else
  #echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
  #mes_out
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
    human=$(config_get human);
    for level in gene transcript ;
    do
      file_out="$dirres"/"$level"_count_matrixeditedDESeq2.csv
      header=$(head -n 1 "$file_out")
      cat "$file_out" | sed '1d' | sed 's/'$sample'/'$samp_name'/g' | sed '1i '$header'' >> "$dir_path"/temp.csv
      file_in="$file_out"
      temp_file
    done
  done 
  } < $INPUT
  IFS=$OLDIFS
fi
Rscript "$ExToolset"/DE.R "$dir_path" condition
## combine all the files in desktop folder
## add them to the bottom of "$home_dir"/insert_"$level"_of_interest/"$level"ofinterest.csv
for level in gene transcript ;
do
  if [[ -s "$matrix_fileedit" && -s "$matrix_fileedit2" ]];
  then
    if [[ ! -s "$matrix_file3" && ! -s "$matrix_file3b" ]];
    then
      cur_wkd="$dirres"
      summaryfile=none
      Rtool=transpose
      Rtype=single2f
      file_out="$dirres"/"$level"ofinterest_count_matrix.csv #3
      ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
      mergefile="$ExToolsetix"/"$human"/"$level"ofinterest.csv #7
      phenofile="$dirres"/"$level"_count_matrixeditedDESeq2.csv #8
      GOI_file="$dirres"/temp.csv #10
      level_name=$(echo ""$level"_name")
      file_in="$mergefile"
      cat "$file_in" | sed 's/-/_/g' >> "$dir_path"/temp.csv
      temp_file
      echo1=$(echo "CREATING "$file_out"")
      mes_out
      mergeR
      name="$level"ofinterest
      add_conditions
      rm "$dirres"/temp.csv
      file_in="$file_out"
      cat "$file_in" | sed 's/   //g' | sed 's/  //g' >> "$dir_path"/temp.csv
      temp_file
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
    GOI_file="$dirres"/excitome_count_matrixDESeq2.csv
    file_out="$dirres"/excitome_count_matrix.csv
    mergefile="$ExToolsetix"/"$human"/excitome.csv
    phenofile="$dirres"/gene_count_matrixeditedDESeq2.csv
    level_name=$(echo "gene_name")
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    name=excitome
    add_conditions
  else
    echo1=$(echo "ALREADY FOUND "$matrix_file4"")
    mes_out
  fi
else
  echo1=$(echo "CANT FIND "$matrix_file"") 
  mes_out
fi # NOW HAVE EXCTIOME MATRIX
if [ -s "$matrix_file" ];
then
  for level in gene transcript ;
  do
    user_GOI="$home_dir"/Desktop/insert_"$level"_of_interest
    for files in "$user_GOI"/* ;
    do
      dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 6 -d '.')
      file_name=$(echo "$dir_name" | cut -f 1 -d '.')
      echo "$file_name"
      echo ""$file_name"" >> "$dir_path"/AIDD/ExToolset/indexes/"$level"_list/user_input_"$level"list.csv
      matrix_file4a="$dirres"/"$file_name"_count_matrix.csv
      if [ ! -s "$matrix_file4a" ];
      then
        cur_wkd="$dirres"
        summaryfile=none
        Rtool=transpose
        Rtype=single2f
        file_out="$dirres"/"$file_name"_count_matrix.csv
        mergefile="$user_GOI"/"$file_name".csv
        phenofile="$dirres"/"$level"_count_matrixeditedDESeq2.csv
        level_name=$(echo ""$level"_name")
        summaryfile="$dir_path"/PHENO_DATA.csv
        GOI_file="$dirres"/temp.csv
        echo1=$(echo "CREATING "$file_out"")
        mes_out
        mergeR
        name="$file_name"
        add_conditions ###CHECK THIS
        rm "$dirres"/temp.csv
      else
        echo1=$(echo "ALREADY FOUND "$matrix_file4a"")
        mes_out
      fi
    done
  done
else
  echo1=$(echo "CANT FIND "$matrix_file"") 
  mes_out
fi # NOW HAVE USE SUPPLIED GENE OR TRANSCRIPT OF INTEREST FILES
if [[ -s "$matrix_file3a" && -s "$matrix_file3b" ]];
then
  if [ ! -s "$matrix_file5" ];
  then
    cur_wkd="$dirres"
    summaryfile=none
    Rtool=finalmerge
    Rtype=single2f
    level_name=$(echo "gene_name")
    summaryfile="$dir_path"/PHENO_DATA.csv
    GOI_file="$dirres"/genetrans_count_matrix.csv
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
    Rtool=finalmerge
    Rtype=single2f
    GOI_file="$dirres"/GTEX_count_matrix.csv
    file_out="$dirres"/GTEX_count_matrix.csv
    mergefile="$dirres"/excitome_count_matrix.csv
    phenofile="$dirres"/genetrans_count_matrix.csv
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
# Create Pathway matrix for user input                                                                                            *TESTED
############################################################################################################################################################### 
if [ -s "$matrix_file" ];
then
  for level in gene transcript ;
  do
    user_GOI="$home_dir"/Desktop/insert_"$level"_lists_for_pathways
    for files in "$user_GOI"/* ;
    do
      dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 6 -d '.')
      file_name=$(echo "$dir_name" | cut -f 1 -d '.')
      echo "$file_name"
      #echo ""$file_name"" >> "$dir_path"/AIDD/ExToolset/indexes/"$level"_list/user_input_pathway_"$level"list.csv
      #echo ""$file_name"" >> "$dir_path"/AIDD/ExToolset/indexes/user_input_pathway_"$level"list.csv
      matrix_file4a="$dirres"/"$file_name"_count_matrix.csv
      if [ ! -s "$matrix_file4a" ];
      then
        cur_wkd="$dirres"
        summaryfile=none
        Rtool=transpose
        Rtype=single2f
        file_out="$dirres"/"$file_name"pathway_count_matrix.csv
        mergefile="$user_GOI"/"$file_name".csv
        phenofile="$dirres"/"$level"_count_matrixeditedDESeq2.csv
        level_name=$(echo ""$level"_name")
        summaryfile="$dir_path"/PHENO_DATA.csv
        GOI_file="$dirres"/"$file_name"pathway_count_matrixDESeq2.csv
        echo1=$(echo "CREATING "$file_out"")
        mes_out
        mergeR
        name="$file_name"pathway
        add_conditions ###CHECK THIS
      else
        echo1=$(echo "ALREADY FOUND "$matrix_file4a"")
        mes_out
      fi
    done
  done
else
  echo1=$(echo "CANT FIND "$matrix_file"") 
  mes_out
fi # NOW HAVE USE SUPPLIED GENE OR TRANSCRIPT PATHWAY MATRIX

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
    human=$(config_get human);
    echo1="STARTING G_VEX FOR "$run" VARIANTS"
    mes_out
    for snptype in ADARediting APOBECediting AllNoSnpsediting ;
    do
      filecheck="$dirqc"/filecheckVC
      in_file="$filecheck"/filecheck"$snptype"1.csv
      missing=$(grep -o 'no' "$in_file" | wc -l)
      if [ ! "$missing" == "0" ];
      then
        echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
        mes_out
      else
        #echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
        #mes_out
        raw_input3="$dirraw"/snpEff/snpEff"$run""$snptype".csv
        count=$(echo "Count by effects")
        count2=$(echo "Count by genomic")
        cat "$raw_input3" | sed '1d' | sed 's/# />/g' | sed 's/\//_/g' | sed '/^\s*$/d' | sed 's/Base/'$run'nucleotide_count_matrixprep/g' | sed 's/Amino/'$run'amino_acid_count_matrixprep/g' >> "$dirVCsubs"/"$run""$snptype".csv
        new_dir="$dirVCsubs"/raw/
        create_dir
        new_dir="$dirVCsubs"/raw/"$run""$snptype"
        create_dir
        cd "$dirVCsubs"/raw/"$run""$snptype"
        csplit -s -z "$dirVCsubs"/"$run""$snptype".csv '/>/' '{*}' # take the sample new csv file and split"
        for i in xx* ; do \
          n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
          mv "$i" "$n.csv" ; \
          file_in="$n".csv
          cat "$file_in" | sed '1d' >> "$dir_path"/temp.csv
          temp_file
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
          cat "$file_in" | sed 's/  //g' | sed 's/ //g' >> "$dir_path"/temp.csv
          temp_file
          index_file="$ExToolsetix"/index/"$level"_names.csv
          pheno_file="$new_wkd"/"$run""$level"_count_matrixprep.csv # output file directory name
          Rtool=G_VEX
          tempf1="$dir_path"/tempR1.csv
          tempf2="$dir_path"/tempR2.csv
          tempf3="$dir_path"/tempR3.csv
          matrixeditor 
          cat "$pheno_file" | cut -d',' -f2,3 | sed '1d' | sed '1i sub_names,'$run'' >> "$dir_path"/temp.csv
          if [ -s ""$dir_path"/temp.csv" ];
          then
            rm "$pheno_file"
          fi
          mv "$dir_path"/temp.csv "$pheno_file"
          rm "$dirVCsubs"/raw/"$run""$snptype"/"$run""$level"_count_matrixprep.csv
        done
        current_dir="$dirVCsubs"/raw/"$run""$snptype"
        for file in "$current_dir"/* ;
        do
          file_in="$file"
          namefiles=$(echo "${file_in##*/}")
          name=$(echo "${namefiles%%.*}")
          new_dir="$dirVC"/"$name"
          create_dir
          new_wkd="$dirVC"/"$name"/merge"$snptype"
          new_dir="$new_wkd"
          create_dir
          cat "$file_in" | sed 's/  //g' | sed 's/ //g'  >> "$new_dir"/"$run""$name"

         # cat "$file_out" | cut -d',' -f1,2 | sed '1d' >> "$dir_path"/temp.csv
        done
      fi
    done
  done 
  } < $INPUT
  IFS=$OLDIFS
  summaryfile="$dir_path"/quality_control/alignment_metrics/all_summaryPF_READS_ALIGN.csv
  run=$(awk -F',' 'NR==2 { print $2 }' "$dir_path"/PHENO_DATA.csv)
  file_in="$summaryfile"
  cat "$file_in" | sed 's/'$run'/'$run'.x/g' >> "$dir_path"/temp.csv
  temp_file
  if [ -s "$summaryfile" ];
  then
    for snptype in ADARediting APOBECediting AllNoSnpsediting ;
    do
      for level in nucleotide amino_acid ;
      do
        cur_wkd="$dirVC"/"$level"/merge"$snptype";
        file_out="$dirVC"/"$level"/"$level""$snptype"_count_matrix.csv
        cd "$dirVC"/"$level"/merge"$snptype"
        Rtool=G_VEX
        Rtype=multi
        GOI_file="$dirVC"/"$level"/temp.csv
        names=$(echo "sub_names")
        mergefile=none
        phenofile=none
        temp_file1="$dirVC"/"$level"/temp2.csv
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
          cat "$file_out" | awk -F',' '{$'$newcol_num' = sprintf("%.5f", $'$sub_col' / $'$summary' * '$norm')}1' | sed 's/-nan/'$subname'norm/g' | sed 's/      /,/g' | sed 's/  /,/g' | sed 's/ /,/g' | sed 's/.x//g' | awk -F',' '!x[$1]++' >> "$dir_path"/temp3.csv
          if [ -s ""$dir_path"/temp3.csv" ];
          then
            rm "$file_out"
            mv "$dir_path"/temp3.csv "$file_out"
          fi
        done
      done
    done
  file_in="$summaryfile"
  cat "$file_in" | sed 's/.x//g' | sed 's/.y//g' >> "$dir_path"/temp.csv
  temp_file
  else
    echo1=$(echo "CANT FIND "$summaryfile"")
    mes_out
  fi
  cd "$dir_path"/AIDD/ 
  for level in nucleotide amino_acid ;
  do
    snptype=AllNoSnpsediting
    final_file="$dirVC"/"$level"/"$level""$snptype"_count_matrix.csv
    if [ -s "$final_file" ];
    then
      final_file2="$dirres"/"$level"_count_matrix.csv
      cp "$final_file" "$final_file2"
      if [ "$level" == "amino_acid" ];
      then
        cat "$final_file2" | sed 's/.x//g' | sed 's/.y//g' | cut -d',' --complement -f2-15 | sed '/inf/d' >> "$dir_path"/temp.csv
        file_in="$final_file2"
        temp_file
      fi
      if [ "$level" == "nucleotide" ];
      then
        cat "$final_file2" | sed 's/.x//g' | sed 's/.y//g' | cut -d',' --complement -f2-18 | sed '/inf/d' >> "$dir_path"/temp.csv
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
    level_name=$(echo "Category")
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    file_in="$file_out"
    cat "$file_in" | sed 's/\n//g' >> "$dir_path"/temp.csv
    temp_file
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
summaryfile="$dir_path"/quality_control/alignment_metrics/all_summaryPF_READS_ALIGN.csv
file_in="$summaryfile"
cat "$file_in" | sed 's/name/CATEGORY/g' >> "$dir_path"/temp.csv
temp_file
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
    file_in="$summaryfile"
    cat "$file_in" | sed 's/.x//g' >> "$dir_path"/temp.csv
    temp_file
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    file_in="$dir_path"/PHENO_DATAalign.csv
    file_out="$dir_path"/readdepth.tiff
    bartype=readdepth
    tool=Rbar
    run_tools
    file_in="$dir_path"/PHENO_DATAalign.csv
    cat "$file_in" | awk -F',' '!x[$0]++' >> "$dir_path"/temp.csv
    temp_file
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
      human=$(config_get human);
      dirqc="$dir_path"/quality_control; # qc directory 
      wkd="$dirres";
      VC_dir="$dirres"/variant_calling/impact
      con_name1=$(config_get con_name1);
      con_name2=$(config_get con_name2);
      con_name3=$(config_get con_name3);
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
          for snptype in ADARediting APOBECediting AllNoSnpsediting ;
          do
            filecheck="$dirqc"/filecheckVC
            in_file="$filecheck"/filecheck"$snptype"2.csv
            missing=$(grep -o 'no' "$in_file" | wc -l)
            if [ ! "$missing" == "0" ];
            then
              echo1=$(echo "MISSING RAW DATA FILES PLEASE CHECK "$in_file" FOR MORE DETAILS")
              mes_out
            else
              #echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
              #mes_out
              raw_input4="$dir_path"/raw_data/snpEff/snpEff"$run""$snptype".genes.txt
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
                col_num="3,7"
                filter_impact
              fi
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
    human=$(config_get human);
    dirres="$dir_path"/Results
    VC_dir="$dirres"/variant_calling/impact
    for level in gene transcript ;
    do
      for impact in high_impact moderate_impact ;
      do
        for snptype in ADARediting APOBECediting AllNoSnpsediting ;
        do
          file_in="$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv
          if [ -s "$file_in" ];
          then
            #cat "$file_in" | awk -F',' '!x[$1]++' >> "$dir_path"/temp.csv
            #temp_file
            #file_in="$VC_dir"/final/"$level""$impact""$snptype"_count_matrix.csv
            echo1=$(echo ""$file_in" FOUND")
            mes_out
            summary=$(head -n 1 "$file_in" | awk -F',' '{ print NF }')
            counts=$(expr "$summary" - "1")
            newcol_num=$(expr "$summary" + "1")
            norm=$(echo "10000")
            cut_col=$(echo "1,"$newcol_num"")
            cat "$file_in" | awk -F',' '{$'$newcol_num' = sprintf("%.5f", $'$counts' / $'$summary' * '$norm')}1'| sed 's/-nan/'$level''$impact''$snptype'normalized/g' | sed 's/ /,/g' | cut -d',' -f"$cut_col" | (read -r; printf "%s\n" "$REPLY"; sort) | uniq >> "$dir_path"/temp.csv
            temp_file
          else
            echo1=$(echo ""$file_in" NOT FOUND")
            mes_out
          fi
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
###############################################################################################################################################################
# COMBINING MATRICES                                                                                                        *TESTED
###############################################################################################################################################################
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
    GOI_file="$dirres"/VEX_count_matrix.csv
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
      human=$(config_get human);
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
    GOI_file="$dirres"/all_count_matrix.csv
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    mergeR
    file_in="$file_out"
    cat "$file_in" | sed '/Inf/d' | sed 's/gene_name/sampname/g' | sed 's/Var.1/sampname/g' >> "$dir_path"/temp.csv
    temp_file
    name=all
    add_conditions
  else
    echo1=$(echo "CANT FIND "$matrix_file11"")
    mes_out
  fi
else
  echo1=$(echo "ALREADY FOUND "$matrix_filefinal"")
  mes_out
fi
###############################################################################################################################################################
# CREATES NUMBER OF EDITING SITES WITHIN EACH GENE THAT IMPACT PROTEIN FUNCTION                                                                 *TESTED
###############################################################################################################################################################
for level in gene transcript ;
do
  for impact in high_impact moderate_impact ;
  do
    for snptype in ADARediting APOBECediting AllNoSnpsediting ;
    do
      new_dir="$dirres"/variant_calling/impact/"$level"/"$impact"/"$snptype"
      create_dir
      exten=$(echo ".csv")
      mv "$dirres"/variant_calling/impact/"$level"/"$impact"/*"$snptype"*"$exten" "$new_dir"
    done
  done
done
for level in gene transcript ;
do
  for impact in high_impact moderate_impact ;
  do
    for snptype in ADARediting APOBECediting AllNoSnpsediting ;
    do
      #impact="$VC_dir"/"$level"/"$impact"/"$snptype"
      #cat "$impact"/* | awk -vORS=, '{ print $1 }' | sed 's/,$//' | awk -vORS=, '{ print $0 }' >> "$VC_dir"/"$level"/"$impact"/"$snptype"GListallsamp.csv
      VC_dir="$dir_path"/Results/variant_calling/impact
      cd "$VC_dir"/"$level"/"$impact"/"$snptype"
      file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrix.csv
      Rtool=I_VEX
      Rtype=multi
      level_name=$(echo "id")
      names=$(echo "id")
      GOI_file="$VC_dir"/"$level"/"$impact"/temp.csv
      mergefile=none
      phenofile=none
      echo1=$(echo "CREATING "$file_out"")
      mes_out
      mergeR
      header=$(head -n 1 "$file_out")
      newheader=$(echo ""$level"_id"$header"")
      cat "$file_out" | cut -d, --complement -f2 | sed 's/.y//g' | sed 's/NA/0/g' | sed '1d' | sed '1i '$newheader'' >> "$dir_path"/temp.csv
      file_in="$file_out"
      temp_file
      cd "$dir_path"/AIDD
      file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixDESeq2.csv
      file_in="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrix.csv
      if [ -s "$file_in" ] ;
      then
        if [ ! -s "$file_out" ];
        then
          index_file="$ExToolsetix"/"$human"/"$level"_names.csv
          pheno_file="$dir_path"/PHENO_DATAalign.csv
          Rtool=GTEX
          level_id=$(echo ""$level"_id");
          level_name=$(echo ""$level"_name");
          filter_type=$(echo "protein_coding");
          level="$level"
          tempf1="$dir_path"/tempR1.csv
          tempf2="$dir_path"/tempR2.csv
          tempf3="$dir_path"/tempR3.csv
          file_in="$index_file"
          cat "$file_in" | sed 's/-/_/g' >> "$dir_path"/temp.csv
          temp_file
          file_in="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrix.csv
          echo1=$(echo "CREATING "$file_out"")
          mes_out
          matrixeditor
          header=$(head -n 1 "$file_out")
          cat "$file_out" | sed '1d' | awk -F',' 'NR > 1{s=0; for (i=3;i<=NF;i++) s+=$i; if (s!=0)print}' | sort -u -k1 | sed '1i '$level'_name'$header'' >> "$dir_path"/temp.csv
          file_in="$file_out"
          temp_file
        else
          echo1=$(echo "ALREADY FOUND "$file_out"")
          mes_out
        fi
      else
        echo1=$(echo "CANT FIND "$file_in"")
        mes_out
      fi
    done
  done
done
cd "$dir_path"/AIDD
for level in gene transcript ;
do
  for snptype in ADARediting APOBECediting AllNoSnpsediting ;
  do
    for impact in high_impact moderate_impact ;
    do
      file_in="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixDESeq2.csv
      cat "$file_in" | awk -F',' 'NF{NF-=1};1' | sed 's/ /,/g' >> "$dir_path"/temp.csv
      temp_file
    done
  done
done
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
  human=$(config_get human);
  for level in gene transcript ;
  do
    for snptype in ADARediting APOBECediting AllNoSnpsediting ;
    do
      for impact in high_impact moderate_impact ;
      do
        file_in="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixDESeq2.csv
        cat "$file_in" | sed 's/'$run'/'$samp_name'/g' | sed 's/ /,/g' >> "$dir_path"/temp.csv
        temp_file
      done
    done
  done
done 
} < $INPUT
IFS=$OLDIFS
for level in gene transcript ;
do
  for snptype in ADARediting APOBECediting AllNoSnpsediting ;
  do
    for impact in high_impact moderate_impact ;
    do
        file_out="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixDESeq2.csv
        cat "$file_out" | sed 's/ /,/g' | awk -F',' '{for(i=1;i<=NF;i++){A[NR,i]=$i};if(NF>n){n=NF}}
        END{for(i=1;i<=n;i++){
        for(j=1;j<=NR;j++){
        s=s?s","A[j,i]:A[j,i]}
        print s;s=""}}' | sed 's/'$level'_name/sampname/g' >> "$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixeditedANOVA.csv
        summaryfile=none
        Rtool=finalmerge
        Rtype=single2f
        file_out="$dir_path"/temp.csv
        mergefile="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixeditedANOVA.csv
        phenofile="$dir_path"/PHENO_DATA.csv
        GOI_file="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixeditedANOVA.csv
        level_name=$(echo "sampname")
        echo1=$(echo "CREATING "$mergefile"")
        mes_out
        mergeR
        file_in="$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixeditedANOVA.csv
        temp_file
        #rm "$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrixedited.csv
        #rm "$dirres"/"$level"_"$impact"_"$snptype"edits_count_matrix.csv
    done
  done
done
###############################################################################################################################################################
# COMBINE ALL FILES IN EACH SNPTYPE SO HAVE EACH SAMPLE IS A COLUMN OF GENES FOR GENE ENRICHMENT INPUT                                   *Working
###############################################################################################################################################################
for level in gene transcript ;
do
  for impact in high_impact moderate_impact ;
  do
    for snptype in ADARediting APOBECediting AllNoSnpsediting ;
    do
      matrix_dir="$dirres"/variant_calling/impact/"$level"/"$impact"/"$snptype"
      for file in "$matrix_dir" ;
      do
        new_dir="$matrix_dir"/merge
        create_dir
        file_in="$file"
        namefiles=$(echo "${file_in##*/}")
        name=$(echo "${namefiles%%.*}")
        #cat "$file" | awk -F',' {print $1} | sed 's/id/'$name'/g' >> "$matrix_dir"/merge/"$level""$impact""$snptype"GeneLists.csv
      done
    done
  done
done
##RUN TOPGO TO CREATE LIST OF GOTERMS WITH HOW MANY GENES ARE IN PATHWAY HOW MNAY OF THESE HAVE EDITING SITES
#bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetGEA.sh GOID,Term,annotated,sig,expected,rankinfisher,classicfisher,classicelim
#maybe do annotated,sigincontrol,sigincondition1,expected
###############################################################################################################################################################
# CREATE FREQUENCY MATRIX FROM BAM FILES FOR EXCTIOME EDITING SITES                                                                      *Working
###############################################################################################################################################################
cd "$dir_path"/AIDD
source config.shlib;
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path);
dirres=$(config_get dirres);
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
matrix_file_out="$dirres"/excitomefreq_count_matrix.csv
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
    human=$(config_get human);
    ExToolset="$home_dir"/AIDD/AIDD/ExToolset/scripts
    ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
    express_value=$(echo "$express_value")
    #express_value=$(($num + 0))
    edit_value=$(echo "$edit_value")
   # edit_value=$(($num + 0))
    allcm="$dirres"/all_count_matrix.csv
    dirresRF="$dirres"/random_forest
    new_dir="$dirresRF"
    create_dir
    dirresgutt="$dirres"/guttman
    new_dir="$dirresgutt"
    create_dir
    AIDDtool="$home_dir"/AIDD/AIDD_tools
    USCOUNTER="0"
    for files in "$dir_path"/raw_data/bam_files/* ;
    do
      file_in="$files"
      bamfiles=$(echo "${file_in##*/}")
      bamfile=$(echo "${bamfiles%%.*}")
      #extension=$(echo "${bamfiles##*.}")
      new_dir="$dirresRF"/"$bamfile"
      create_dir
      temp_file="$dirresRF"/"$bamfile"/"$excitome_gene".csv
      if [ "$coord" != "0" ];
      then
        cat "$ExToolset"/basecount.R | sed 's/coord/'$coord'/g' | sed 's/chrome/'$chrome'/g' >> "$dir_path"/tempbasecount.R
        bambai="$dir_path"/raw_data/bam_files/"$bamfile".bai
        bambai2="$dir_path"/raw_data/bam_files/"$bamfile".bam.bai
        if [ "$file_in" != "$bambai2" ];
        then
          echo "Now starting editing profiles in $bamfile for "$excitome_gene""
          if [ ! -f "$bambai2" ];
          then
            java -jar $AIDDtool/picard.jar BuildBamIndex INPUT="$file_in"
            mv "$bambai" "$bambai2"
          fi
          file_out="$temp_file"
          tool=basecount
          run_tools
          nucA=$(awk -F',' 'NR==2{print $1}' "$temp_file")
          nucC=$(awk -F',' 'NR==2{print $2}' "$temp_file")
          nucG=$(awk -F',' 'NR==2{print $3}' "$temp_file")
          nucT=$(awk -F',' 'NR==2{print $4}' "$temp_file")
          nuctotal=$(expr "$nucA" + "$nucG" + "$nucC" + "$nucT")
          dirresguttSD="$dirresgutt"/stackdepth
          new_dir="$dirresguttSD"
          create_dir
          echo ""$excitome_gene","$nuctotal"" >> "$dirresguttSD"/"$bamfile"stackdepth.csv
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
          gutt_matrix_dir1="$dirresgutt"/mergesamples1
          new_dir="$gutt_matrix_dir1"
          create_dir
          gutt_matrix_dir2="$dirresgutt"/mergesamples2
          new_dir="$gutt_matrix_dir2"
          create_dir
          RF_matrix="$RF_matrix_dir"/"$bamfile"editingfreq.csv
          RF_matrixerror="$dirresRF"/"$bamfile"editingfreqErrorlog.csv
          gutt_matrix1="$gutt_matrix_dir1"/"$bamfile"editing_gutt.csv
          gutt_matrix2="$gutt_matrix_dir2"/"$bamfile"expression_gutt.csv
          if [ ! -f "$RF_matrix" ];
          then
            echo "excitome_site,$bamfile" >> "$RF_matrix"
          fi
          if [ ! -f "$gutt_matrix1" ];
          then
            echo "excitome_site,"$bamfile"" >> "$gutt_matrix1"
          fi
          if [ ! -f "$gutt_matrix2" ];
          then
            echo "excitome_site,"$bamfile"" >> "$gutt_matrix2"
          fi
          if [ "$nuctotal" -gt "10" ];
          then
            if [[ "$percentC" != "0" && "$nucC" -gt "$nucG" ]];
            then
              phrase=$(echo "$excitome_gene")
              missing=$(grep -o "$phrase" "$in_file" | wc -l)
              if [ ! "$missing" == "0" ];
              then
                echo1=$(echo "ALREADY FOUND "$excitome_gene" in "$RF_matrix"")
                mes_out                
              else
                echo ""$excitome_gene","$percentC"" >> "$RF_matrix"
              fi
              percentCint=${percentC%.*}
              if [ "$percentCint" -gt "0" ];
              then 
                answer="1"
              fi 
            fi
            if [[ "$percentG" != "0" && "$nucG" -gt "$nucC" ]];
            then
              phrase=$(echo "$excitome_gene")
              missing=$(grep -o "$phrase" "$in_file" | wc -l)
              if [ ! "$missing" == "0" ];
              then
                echo1=$(echo "ALREADY FOUND "$excitome_gene" in "$RF_matrix"")
                mes_out
              else
                echo ""$excitome_gene","$percentG"" >> "$RF_matrix"
              fi
              percentGint=${percentG%.*}
              if [ "$percentGint" -gt "0" ];
              then 
                answer="1"
              fi  
            fi
            if [[ "$percentG" == "0" && "$percentC" == "0" ]];
            then
              phrase=$(echo "$excitome_gene")
              missing=$(grep -o "$phrase" "$in_file" | wc -l)
              if [ ! "$missing" == "0" ];
              then
                echo1=$(echo "ALREADY FOUND "$excitome_gene" in "$RF_matrix"")
                mes_out
              else
                echo ""$excitome_gene",0" >> "$RF_matrix"
              fi
              answer="0"
            fi
            echo ""$bamfile" has "$nucA" A's "$nucC" C's "$nucG" G's "$nucT" T's for a total of "$nuctotal" read depth which a "$percentG" % edited to a G or "$percentC" % edited to a C"
          else
            phrase=$(echo "$excitome_gene")
            missing=$(grep -o "$phrase" "$in_file" | wc -l)
            if [ ! "$missing" == "0" ];
            then
              echo1=$(echo "ALREADY FOUND "$excitome_gene" in "$RF_matrix"")
              mes_out
            else
              echo ""$excitome_gene",0" >> "$RF_matrix"
              echo ""$excitome_gene",removed,readcoveragebelow10" >> "$RF_matrixerror"
            fi
            answer="0"
            echo ""$bamfile" has "$nucA" A's "$nucC" C's "$nucG" G's "$nucT" T's for a total of "$nuctotal" read depth which a is too low to determine frequency"
          fi
          count_matrix="$dir_path"/Results/excitome_count_matrixANOVA.csv
          excit_pres=$(cat "$file_in" | awk '{if ($1 ~ /'"$chrome"'/) print $2}' | awk '{if ($1 ~ /'"$coord"'/) print $0}')
          excitome_gene_short=${excitome_gene%_*}
          if [ "$excitome_gene" == "ADAR.1" ];
          then
            express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene_short'/) print NR}')
          fi
          if [ "$excitome_gene" == "ADAR.B1" ];
          then
            express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene_short'/) print NR}')
          fi
          if [ "$excitome_gene" == "ADAR.B2" ];
          then
            express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene_short'/) print NR}')
          fi
          express_col=$(cat "$count_matrix" | head -n 1 | sed 's/,/\n/g' | awk '{if (/'$excitome_gene_short'/) print NR}')
          if [ "$express_col" == "" ];
          then
            excit_express=$(echo "0")
            echo1=$(echo ""$bamfile".bam shows "$excitome_gene" with editing coordinate "$chrome":"$coord" was not found in "$count_matrix" so expression is labeled 0")
            mes_out
          else
            express_row=$(cat "$count_matrix" | awk -F',' '{if (/'$bamfile'/) print NR}')
            excit_express=$(cat "$count_matrix" | awk -F',' 'NR=='$express_row'{print $'$express_col'}')
            echo1=$(echo ""$bamfile".bam "$excitome_gene" with editing coordinate "$chrome":"$coord" is located at "$express_col":"$express_row" in "$count_matrix" having a TPM of "$excit_express" Expression is marked 1 if it is above "$express_value"")
            mes_out
            if [ "$excit_express" -gt "$express_value" ];
            then
              ex_answer="1"
            else
              ex_answer="0" 
            fi
            echo ""$excitome_gene","$answer"" >> "$gutt_matrix1"
            cat "$gutt_matrix1" | sed 's/"//g' >> "$dir_path"/temp.csv
            file_in="$gutt_matrix1"
            temp_file
            in_file="$gutt_matrix2"
            phrase=$(echo "$excitome_gene_short")
            missing=$(grep -o "$phrase" "$in_file" | wc -l)
            if [ ! "$missing" == "0" ];
            then
              echo1=$(echo "ALREADY FOUND "$excitome_gene_short" in "$gutt_matrix2"")
              mes_out
            else
              echo ""$excitome_gene_short","$ex_answer"" >> "$gutt_matrix2"
              cat "$gutt_matrix2" | sed 's/"//g' >> "$dir_path"/temp.csv
              file_in="$gutt_matrix2"
              temp_file
            fi
          fi
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
  dirresgutt="$dirres"/guttman
  gutt_matrix_dir1="$dirresgutt"/mergesamples1
  gutt_matrix_dir2="$dirresgutt"/mergesamples2
  cd "$RF_matrix_dir"
  cur_wkd="$RF_matrix_dir"
  Rtool=$(echo "I_VEX")
  Rtype=$(echo "multi")
  GOI_file="$dirresRF"/excitomefreq_count_matrixDESeq2.csv
  summaryfile=none
  tempfile3=transpose
  names=$(echo "excitome_site")
  file_out="$dirres"/excitomefreq_count_matrixDESeq2.csv
  echo1=$(echo "CREATING "$file_out"")
  mes_out
  mergeR
  name=excitomefreq
  resdir="$dirresRF"
  makeDESeq2
  cd "$gutt_matrix_dir1"
  cur_wkd="$RF_matrix_dir1"
  Rtool=$(echo "I_VEX")
  Rtype=$(echo "multi")
  GOI_file="$dirresgutt"/temp.csv
  summaryfile=none
  tempfile3=transpose
  names=$(echo "excitome_site")
  file_out="$dirresgutt"/guttediting_count_matrixDESeq2.csv
  echo1=$(echo "CREATING "$file_out"")
  mes_out
  mergeR
  name=guttediting
  resdir="$dirresgutt"
  makeDESeq2
  cd "$gutt_matrix_dir2"
  cur_wkd="$RF_matrix_dir2"
  Rtool=$(echo "I_VEX")
  Rtype=$(echo "multi")
  GOI_file="$dirresgutt"/temp.csv
  summaryfile=none
  tempfile3=transpose
  names=$(echo "excitome_site")
  file_out="$dirresgutt"/guttexpression_count_matrixDESeq2.csv
  echo1=$(echo "CREATING "$file_out"")
  mes_out
  mergeR
  name=guttexpression
  resdir="$dirresgutt"
  makeDESeq2
###############################################################################################################################################################
# Creates graphs showing vcf filtering results and removal of known snps                                                                     *TESTED
###############################################################################################################################################################
VarQC="$dir_path"/quality_control/variant_filtering
new_dir="$VarQC"
create_dir 
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  VarQC="$dir_path"/quality_control/variant_filtering
  for name in filtered_snps_finalAll raw_snps filtered_snps raw_snps_recal ;
  do
    if [ "$name" == "filtered_snps_finalAll" ];
    then
      rdvcf="$dir_path"/raw_data/vcf_files/final
    fi
    if [ "$name" == "filtered_snps" ];
    then
      rdvcf="$dir_path"/raw_data/vcf_files/filtered
    fi
    if [[ "$name" == "raw_snps" || "$name" == "raw_snps_recal" ]];
    then
      rdvcf="$dir_path"/raw_data/vcf_files/raw
    fi
    file_vcf_finalAll="$rdvcf"/"$run""$name".vcf
    if [ -s "$file_vcf_finallAll" ];
    then
      echo "Running analysis for visualizing variant filtration for "$run" and variant filtering type "$name""
      ACcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "C")) { print } }' | wc -l)
      ATcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "T")) { print } }' | wc -l)
      AGcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "G")) { print } }' | wc -l)
      CAcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "A")) { print } }' | wc -l)
      CGcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "G")) { print } }' | wc -l)
      CTcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "T")) { print } }' | wc -l)
      GAcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "A")) { print } }' | wc -l)
      GCcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "C")) { print } }' | wc -l)
      GTcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "T")) { print } }' | wc -l)
      TAcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "A")) { print } }' | wc -l)
      TGcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "G")) { print } }' | wc -l)
      TCcount=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "C")) { print } }' | wc -l)
      ACcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "C") && ($3 == ".")) { print } }' | wc -l)
      ATcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "T") && ($3 == ".")) { print } }' | wc -l)
      AGcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "G") && ($3 == ".")) { print } }' | wc -l)
      CAcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "A") && ($3 == ".")) { print } }' | wc -l)
      CGcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "G") && ($3 == ".")) { print } }' | wc -l)
      CTcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "T") && ($3 == ".")) { print } }' | wc -l)
      GAcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "A") && ($3 == ".")) { print } }' | wc -l)
      GCcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "C") && ($3 == ".")) { print } }' | wc -l)
      GTcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "T") && ($3 == ".")) { print } }' | wc -l)
      TAcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "A") && ($3 == ".")) { print } }' | wc -l)
      TGcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "G") && ($3 == ".")) { print } }' | wc -l)
      TCcountsnps=$(cat "$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "C") && ($3 == ".")) { print } }' | wc -l)
      final_file="$VarQC"/VariantFilteringVisual.csv
      if [ ! -s "$final_file" ];
      then
        echo "samp_name,condition,condition2,name,type,ACcount,AGcount,ATcount,CAcount,CGcount,CTcount,GAcount,GCcount,GTcount,TAcount,TCcount,TGcount" >> "$final_file"
      fi
      echo ""$samp_name","$condition","$condition2","$name",total,"$ACcount","$AGcount","$ATcount","$CAcount","$CGcount","$CTcount","$GAcount","$GCcount","$GTcount","$TAcount","$TCcount","$TGcount"" >> "$final_file"
      echo ""$samp_name","$condition","$condition2","$name",nonsnps,"$ACcountsnps","$AGcountsnps","$ATcountsnps","$CAcountsnps","$CGcountsnps","$CTcountsnps","$GAcountsnps","$GCcountsnps","$GTcountsnps","$TAcountsnps","$TCcountsnps","$TGcountsnps"" >> "$final_file"
      ACsnp=$(expr "$ACcount" - "$ACcountsnps")
      ATsnp=$(expr "$ATcount" - "$ATcountsnps")
      AGsnp=$(expr "$AGcount" - "$AGcountsnps")
      CAsnp=$(expr "$CAcount" - "$CAcountsnps")
      CGsnp=$(expr "$CGcount" - "$CGcountsnps")
      CTsnp=$(expr "$CTcount" - "$CTcountsnps")
      GAsnp=$(expr "$GAcount" - "$GAcountsnps")
      GCsnp=$(expr "$GCcount" - "$GCcountsnps")
      GTsnp=$(expr "$GTcount" - "$GTcountsnps")
      TAsnp=$(expr "$TAcount" - "$TAcountsnps")
      TGsnp=$(expr "$TGcount" - "$TGcountsnps")
      TCsnp=$(expr "$TCcount" - "$TCcountsnps")
      echo ""$samp_name","$condition","$condition2","$name",withsnps,"$ACsnp","$AGsnp","$ATsnp","$CAsnp","$CGsnp","$CTsnp","$GAsnp","$GCsnp","$GTsnp","$TAsnp","$TCsnp","$TGsnp"" >> "$final_file"
      ACsnps=$(echo "scale=4 ; "$ACcountsnps"/"$ACcount"" | bc)
      ATsnps=$(echo "scale=4 ; "$ATcountsnps"/"$ATcount"" | bc)
      AGsnps=$(echo "scale=4 ; "$AGcountsnps"/"$AGcount"" | bc)
      CAsnps=$(echo "scale=4 ; "$CAcountsnps"/"$CAcount"" | bc)
      CGsnps=$(echo "scale=4 ; "$CGcountsnps"/"$CGcount"" | bc)
      CTsnps=$(echo "scale=4 ; "$CTcountsnps"/"$CTcount"" | bc)
      GAsnps=$(echo "scale=4 ; "$GAcountsnps"/"$GAcount"" | bc)
      GCsnps=$(echo "scale=4 ; "$GCcountsnps"/"$GCcount"" | bc)
      GTsnps=$(echo "scale=4 ; "$GTcountsnps"/"$GTcount"" | bc)
      TAsnps=$(echo "scale=4 ; "$TAcountsnps"/"$TAcount"" | bc)
      TGsnps=$(echo "scale=4 ; "$TGcountsnps"/"$TGcount"" | bc)
      TCsnps=$(echo "scale=4 ; "$TCcountsnps"/"$TCcount"" | bc)
      echo ""$samp_name","$condition","$condition2","$name",percent,"$ACsnps","$AGsnps","$ATsnps","$CAsnps","$CGsnps","$CTsnps","$GAsnps","$GCsnps","$GTsnps","$TAsnps","$TCsnps","$TGsnps"" >> "$final_file"
    done
  done
} < $INPUT
IFS=$OLDIFS
file_in <- "$VarQC"/VariantFilteringVisual.csv
file_out <- "$VarQC"/VariantFilteringVisualSummary.csv
image_out1 <- "$VarQC"/VariantFilteringVisualfiltered_snps_finalAllTotal.tiff
image_out2 <- "$VarQC"/VariantFilteringVisualfiltered_snps_finalAllNoSnps.tiff
image_out3 <- "$VarQC"/VariantFilteringVisualNoSnps.tiff
image_out4 <- "$VarQC"/VariantFilteringVisualTotal.tiff
image_out5 <- "$VarQC"/VariantFilteringVisualfiltered_snps_finalTotalNoSnps.tiff
image_out6 <- "$VarQC"/VariantFilteringVisualraw_snpsTotalNoSnps.tiff
image_out7 <- "$VarQC"/VariantFilteringVisualAll.tiff
image_out8 <- "$VarQC"/VariantFilteringVisualAll2.tiff
tool=varfilter
run_tools
###############################################################################################################################################################
# Statistical Analysis section:DESeq2                                                                                                   *WORKING ON IT
###############################################################################################################################################################
cd "$dir_path"/AIDD
dirresDE="$dirres"/DESeq2
new_dir="$dirresDE"
create_dir
mv "$dirres"/*DESeq2* "$dirresDE"
for files in "$dirresDE"/* ;
do
  file_in="$files"
  namefiles=$(echo "${file_in##*/}")
  count_matrix=$(echo "${namefiles%%.*}")
  #bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetDESeq2.sh "$count_matrix" #run DE with DESEq2 for each gene and transcript count matrix for each condition
done
###############################################################################################################################################################
# Statistical Analysis section:ANOVA                                                                                                         *WORKING ON IT
###############################################################################################################################################################
cd "$dir_path"/AIDD
dirresANOVA="$dirres"/ANOVA
new_dir="$dirresANOVA"
create_dir
mv "$dirres"/*ANOVA* "$dirresANOVA"
for files in "$dirresANOVA"/* ;
do
  file_in="$files"
  namefiles=$(echo "${file_in##*/}")
  count_matrix=$(echo "${namefiles%%.*}")
  #bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetANOVA.sh "$count_matrix" #runs ANOVA on each gene in the excitome, each nt and AA substitution, and impact of subs.
done

bash "$home_dir"/AIDD/AIDD/ExToolset/scripts/basecountsfrombam.sh "$home_dir" "$dir_path"
###############################################################################################################################################################
# Statistical Analysis section: Correlaions                                                                                          *WORKING ON IT
###############################################################################################################################################################
count_matrix=all_count_matrix
  #bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetcorr.sh "$count_matrix" #runs correlations
  cd "$dir_path"/AIDD
  rm
###############################################################################################################################################################
# Statistical Analysis section: Guttman and RF                                                                                                  *WORKING ON IT
###############################################################################################################################################################

#count_matrix="$dir_path"/Results/guttman_count_matrix.csv
#if [ -f "$count_matrix ];
 # echo1="NOW RUNNING STATISTICS FOR "$count_matrix""
 # mes_out
  #bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetML.sh #this will 
#else
#  echo1="NOW RUNNING STATISTICS FOR "$count_matrix""
#  mes_out
#fi
###############################################################################################################################################################
# Option to split matrix to re-run AIDD with a subset                                                                                         *WORKING ON IT
###############################################################################################################################################################
if [ ! "$4" == "" ];
then
    bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetsplit.sh "$count_matrix" "$4" # this will split the matrices by a certain condition and create new pheno-data files and matrices by condition supplied by the user.
fi
####################################################################################################################
# CLEAN UP AND EXIT
####################################################################################################################
cd "$dir_path"/AIDD
source config.shlib
DATE_WITH_TIME=$(config_get DATE_WITH_TIME)
TIME_HOUR=$(config_get TIME_HOUR)
TIME_MIN=$(config_get TIME_MIN)
TIME_SEC=(config_get TIME_SEC)
END_DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
END_TIME_HOUR=$(date +%H)
END_TIME_MIN=$(date +%M)
END_TIME_SEC=$(date +%S)
echo "EXTOOLSET STARTED "$DATE_WITH_TIME" AND ENDED "$END_DATE_WITH_TIME""
smart_script
