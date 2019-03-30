IFS=$OLDIFS # excitome summaries
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
  con_name1=$(config_get con_name1);
  con_name2=$(config_get con_name2);
  con_name3=$(config_get con_name3);
  for cond_name in "$con_name1" "$con_name2" "$con_name3" ;
  do
    file_in="$dirres"/excitome_count_matrix.csv;
    new_dir="$dirres"/excitome/"$cond_name"
    create_dir
    file_out="$dirres"/excitome/"$cond_name"/"$freq"summary.tiff;
    bartype=excitome
    sampname=samp_name
    pheno="$dir_path"/PHENO_DATA.csv
    tool=Rbar
    sum_file="$dirres"/excitome/"$cond_name"/"$freq"summary.csv
    sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    sed -i 's/condition_name/'$cond_name'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    run_tools
    sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R 
    sed -i 's/'$cond_name'/condition_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
  done
done 
} < $INPUT
IFS=$OLDIFS # excitome summaries
cd "$dir_path"/AIDD
for level in gene transcript ;
do
  sed -i '/^level/d' "$dir_path"/AIDD/config.cfg.defaults
  echo "level="$level"" >> "$dir_path"/AIDD/config.cfg.defaults
  INPUT="$ExToolsetix"/"$level"_list/DESeq2/"$level"ofinterest.csv
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
    level=$(config_get level);
    dirresex="$dirres"/"$level"ofinterest
    new_dir="$dirresex"
    create_dir
    echo "NOW STARTING SUMMARY ANALYSIS OF "$freq""
    con_name1=$(config_get con_name1);
    con_name2=$(config_get con_name2);
    con_name3=$(config_get con_name3);
    for cond_name in "$con_name1" "$con_name2" "$con_name3" ;
    do
      new_dir="$dirres"/"$level"ofinterest/"$cond_name"
      create_dir
      file_in="$dirres"/"$level"ofinterest_count_matrix.csv;
      file_out="$dirres"/"$level"ofinterest/"$cond_name"/"$freq"summary.tiff;
      bartype=excitome
      sampname=samp_name
      pheno="$dir_path"/PHENO_DATA.csv
      tool=Rbar
      sum_file="$dirres"/"$level"ofinterest/"$cond_name"/"$freq"summary.csv
      sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
      sed -i 's/condition_name/'$cond_name'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
      run_tools
      sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R 
      sed -i 's/'$cond_name'/condition_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    done
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
    con_name1=$(config_get con_name1);
    con_name2=$(config_get con_name2);
    con_name3=$(config_get con_name3);
    for cond_name in "$con_name1" "$con_name2" "$con_name3" ;
    do
      file_in="$dirres"/"$level"_count_matrix.csv;
      new_dir="$dirres"/"$level"/"$cond_name"
      create_dir
      file_out="$dirres"/"$level"/"$cond_name"/"$freq"summary.tiff;
      bartype=excitome
      pheno="$dir_path"/PHENO_DATA.csv
      sampname=run
      tool=Rbar
      sum_file="$dirres"/"$level"/"$cond_name"/"$freq"summary.csv
      sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
      sed -i 's/condition_name/'$cond_name'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
      run_tools
      sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R 
      sed -i 's/'$cond_name'/condition_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    done
  done 
  } < $INPUT
  IFS=$OLDIFS
done
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
    con_name1=$(config_get con_name1);
    con_name2=$(config_get con_name2);
    con_name3=$(config_get con_name3);
    for cond_name in "$con_name1" "$con_name2" "$con_name3" ;
    do
      file_in="$dirres"/impact_count_matrix.csv;
      new_dir="$dirres"/impact/"$cond_name"
      create_dir
      file_out="$dirres"/impact/"$cond_name"/"$freq"summary.tiff;
      bartype=excitome
      pheno="$dir_path"/PHENO_DATA.csv
      tool=Rbar
      sampname=run
      sum_file="$dirres"/impact/"$cond_name"/"$freq"summary.csv
      sed -i 's/condition_name/'$cond_name'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
      sed -i 's/freq_name/'$freq'/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
      run_tools
      sed -i 's/'$freq'/freq_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
      sed -i 's/'$cond_name'/condition_name/g' "$dir_path"/AIDD/ExToolset/scripts/barchart.R
    done
  done 
for cond_name in "$con_name1" "$con_name2" "$con_name3" ;
do
  new_dir="$dirres"/"$cond_name"
  create_dir
  data_summary_file1="$dirres"/geneofinterest/"$cond_name"/geneofinterestallsummaries.csv;
  data_summary_file2="$dirres"/transcriptofinterest/"$cond_name"/transcriptofinterest.csv;
  data_summary_file3="$dirres"/excitome/"$cond_name"/excitomeallsummaries.csv;
  data_summary_file3a="$dirres"/"$cond_name"/GTEXallsummaries.csv;
  data_summary_file4="$dirres"/nucleotide/"$cond_name"/nucleotideallsummaries.csv;
  data_summary_file5="$dirres"/amino_acid/"$cond_name"/amino_acidallsummaries.csv;
  data_summary_file6="$dirres"/impact/"$cond_name"/impactallsummaries.csv;
  data_summary_file6a="$dirres"/"$cond_name"/VEXallsummaries.csv;
  data_summary_filefinal="$dirres"/"$cond_name"/allsummaries.csv;
  if [[ -s "$data_summary_file1" && -s "$data_summary_file2" && -s "$data_summary_file3" ]];
  then
    if [ ! -s "$data_summary_file3a" ];
    then
      echo1=$(echo "CREATING "$data_summary_file3a"")
      mes_out
      cat "$data_summary_file1" "$data_summary_file2" "$data_summary_file3" >> "$data_summary_file3a"
    else
      echo1=$(echo "ALREADY FOUND "$data_summary_file3a"")
      mes_out
    fi
  else
    echo1=$(echo "CANT FIND "$data_summary_file1" OR "$data_summary_file2" OR "$data_summary_file3"")
    mes_out
  fi
  if [[ -s "$data_summary_file4" && -s "$data_summary_file5" && -s "$data_summary_file6" ]];
  then
    if [ ! -s "$data_summary_file6a" ];
    then
      echo1=$(echo "CREATING "$data_summary_file6a"")
    mes_out
    cat "$data_summary_file4" "$data_summary_file5" "$data_summary_file6" >> "$data_summary_file6a"
    else
      echo1=$(echo "ALREADY FOUND "$data_summary_file6a"")
      mes_out
    fi
  else
    echo1=$(echo "CANT FIND "$data_summary_file4" OR "$data_summary_file5" OR "$data_summary_file6"")
    mes_out
  fi
  if [[ -s "$data_summary_file3a" && -s "$data_summary_file6a" ]];
  then
    if [ ! -s "$data_summary_filefinal" ];
    then
      echo1=$(echo "CREATING "$data_summary_filefinal"")
      mes_out
      cat "$data_summary_file3a" "$data_summary_file6a" >> "$data_summary_filefinal"
    else
      echo1=$(echo "ALREADY FOUND "$data_summary_filefinal"")
      mes_out
    fi
  else
    echo1=$(echo "CANT FIND "$data_summary_file3a" OR "$data_summary_file6a"")
    mes_out
  fi # CREATES ALL DATA SUMMARY FILE
done

