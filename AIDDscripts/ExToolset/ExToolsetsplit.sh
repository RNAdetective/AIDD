####################################################################################################################
# RUNS EXTOOLSET FOR DE ANALYSIS WHEN ONE CONDITION IS SPLIT INTO ITS OWN FILE
####################################################################################################################
cd "$dir_path"/AIDD
source config.shlib
con_name1=$(config_get con_name1);
con_name2=$(config_get con_name2);
con_name3=$(config_get con_name3);
splitname="$4"
if [ ! "$splitname" == "" ];
then
  name1=$(awk -F, 'NR==3{print $2}' "$dir_path"/"$splitname".csv)
  name2=$(awk -F, 'NR==4{print $2}' "$dir_path"/"$splitname".csv)
  name3=$(awk -F, 'NR==2{print $2}' "$dir_path"/"$splitname".csv)
####################################################################################################################
# RUNS EXTOOLSET FOR GTEX SUMMARY AND BARGRAPHS ADD ERROR BARS TO BARGRAPHS
####################################################################################################################
  source config.shlib;
  home_dir=$(config_get home_dir);
  dir_path=$(config_get dir_path);
  for name in "$name1" "$name2" "$name3" ;
  do
    dirres="$dir_path"/Results/"$name"
    new_dir="$dirres"
    create_dir
    sed -i '/^dirres=/d' "$dir_path"/AIDD/config.cfg
    echo "dirres="$dirres"" >> "$dir_path"/AIDD/config.cfg
    dirresall="$dirres"/all
    new_dir="$dirresall"
    create_dir
    olddirres="$dir_path"/Results
    file_in="$olddirres"/all/all_count_matrixedit.csv
    file_out="$dirres"/all/all_count_matrixedit.csv
    tool=splitallmatrix
    run_tools
    file_in=
    file_out=
    tool=PDsplit
    run_tools
    ExToolset="$dir_path"/AIDD/ExToolset/scripts
    ExToolsetix="$dir_path"/AIDD/ExToolset/indexes
    allcm="$dirres"/all_count_matrix.csv
    allcmedit="$dirresall"/all_count_matrixedit.csv
    allindex="$dirresall"/allindex.csv
    file_in="$allcm"
    file_out="$allcmedit"
    tool=editmatrix
    run_tools
    file_in="$allcmedit"
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
      home_dir=$(config_get home_dir);
      dir_path=$(config_get dir_path);
      dirres=$(config_get dirres);
      con_name1=$(config_get con_name1);
      con_name2=$(config_get con_name2);
      con_name3=$(config_get con_name3);
      con_name4=$(echo "sampname");
      echo1=$(echo "STARTING ANOVA FOR "$freq"")
      mes_out
      for cond_name in "$con_name1" "$con_name3" "$con_name4";
      do
        dirrescon="$dirres"/all/"$cond_name";
        new_dir="$dirrescon";
        create_dir
        file_in="$dirres"/all/all_count_matrixedit.csv;
        file_out="$dirrescon"/"$freq"summary.tiff;
        bartype=ANOVA
        pheno="$dirres"/PHENO_DATA.csv
        count_of_interest="$freq"
        sum_file="$dirrescon"/"$freq"summary.csv
        condition_name="$cond_name"
        sum_file2="$dirrescon"/"$freq"ANOVA.txt
        tool=Rbar
        sum_file="$dirres"/all/"$cond_name"/"$freq"summary.csv
        sed -i 's/freq_name/'$freq'/g' "$ExToolset"/barchart.R
        sed -i 's/condition_name/'$cond_name'/g' "$ExToolset"/barchart.R
        run_tools
        sed -i 's/'$freq'/freq_name/g' "$ExToolset"/barchart.R
        sed -i 's/'$cond_name'/condition_name/g' "$ExToolset"/barchart.R
        if [ -s "$dirrescon"/"$freq"ANOVA.txt ];
        then
          line=$(echo "11")
          pvalue=$(sed -n "$line p" "$dirrescon"/"$freq"ANOVA.txt)
          justp=${pvalue#*:}
          if [ ! -s "$dirres"/all/"$cond_name"allANOVA.csv ];
          then
            echo "variable,ANOVApvalue" >> "$dirres"/all/"$cond_name"allANOVA.csv
          fi
          echo ""$freq","$justp"" >> "$dirres"/all/"$cond_name"allANOVA.csv
        fi
      done
    done 
    } < $INPUT
    IFS=$OLDIFS
    con_name1=$(config_get con_name1);
    con_name2=$(config_get con_name2);
    con_name3=$(config_get con_name3);
    con_name4=$(echo "sampname");
    for cond_name in "$con_name1" "$con_name2" "$con_name3" "$con_name4" ;
    do
      echo1=$(echo "STARTING SUMMARY COLLECTION FOR "$cond_name"")
      mes_out
      cat "$dirres"/all/"$cond_name"/*summary.csv | sed '2,${/^sampname/d;}' >> "$dirres"/all/"$cond_name"allsummaries.csv
      file_in="$dirres"/all/"$cond_name"allsummaries.csv
      file_out="$dirres"/all/"$cond_name"allsummaries.tiff
      bartype=substitutions
      tool=Rbar
      sed -i 's/condition_name/'$cond_name'/g' "$ExToolset"/barchart.R
      run_tools
      sed -i 's/'$cond_name'/condition_name/g' "$ExToolset"/barchart.R
    done
####################################################################################################################
# RUNS EXTOOLSET FOR CORRELATION SUMMARY
####################################################################################################################
    INPUT="$ExToolsetix"/index/scatterplots.csv
    OLDIFS=$IFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    read
    while IFS=, read -r scatter_x scatter_y
    do
      source config.shlib;
      home_dir=$(config_get home_dir);
      dir_path=$(config_get dir_path);
      dirres=$(config_get dirres);
      ExToolset="$dir_path"/AIDD/ExToolset/scripts
      file_in="$dirres"/all_count_matrix.csv;
      dirrescorr="$dirres"/all/correlations
      new_dir="$dirrescorr"
      create_dir
      con_name1=$(config_get con_name1);
      con_name2=$(config_get con_name2);
      con_name3=$(config_get con_name3);
      con_name4=$(echo "sampname");
      echo1=$(echo "STARTING CORRELATION FOR "$scatter_x" AND "$scatter_y"")
      mes_out
      file_out="$dirrescorr"/"$scatter_x""$scatter_y"scatterplot.tiff
      file_out2="$dirrescorr"/"$scatter_x""$scatter_y"scatterplot.txt
      bartype=scatter
      tool=Rbar
      sed -i 's/scatter_x/'$scatter_x'/g' "$ExToolset"/barchart.R
      sed -i 's/scatter_y/'$scatter_y'/g' "$ExToolset"/barchart.R
      sed -i 's/cond_1/'$con_name1'/g' "$ExToolset"/barchart.R
      sed -i 's/cond_2/'$con_name2'/g' "$ExToolset"/barchart.R
      sed -i 's/cond_4/'$con_name4'/g' "$ExToolset"/barchart.R
      run_tools
      sed -i 's/'$scatter_x'/scatter_x/g' "$ExToolset"/barchart.R
      sed -i 's/'$scatter_y'/scatter_y/g' "$ExToolset"/barchart.R
      sed -i 's/'$con_name1'/cond_1/g' "$ExToolset"/barchart.R
      sed -i 's/'$con_name2'/cond_2/g' "$ExToolset"/barchart.R
      sed -i 's/'$con_name4'/cond_4/g' "$ExToolset"/barchart.R
    done 
    } < $INPUT
    IFS=$OLDIFS

    echo1=$(echo "STARTING CORRELATION SUMMARIES")
    mes_out
    INPUT="$ExToolsetix"/index/scatterplots.csv
    OLDIFS=$IFS
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    read
    while IFS=, read -r scatter_x scatter_y
    do
      source config.shlib;
      home_dir=$(config_get home_dir);
      dir_path=$(config_get dir_path);
      dirres=$(config_get dirres);
      dirrescorr="$dirres"/all/correlations
      ExToolset="$dir_path"/AIDD/ExToolset/scripts
      file_in="$dirrescorr"/"$name"corr.txt
      file_out="$dirrescorr"/all_corr_data.cvs
      name=$(echo ""$scatter_x""$scatter_y"")
      corr_file="$dirrescorr"/"$name"scatterplot.txt
      pcorr=$(cat "$corr_file" | awk '/   cor/{nr[NR+1]}; NR in nr')
      new_file="$dir_path"/correlations/temp.csv
      lowCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $2}') 
      highCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $3}')
      p_value=$(cat "$corr_file" | awk '/p-value /{nr[NR]}; NR in nr' | sed 's/ //g' | sed 's/p-value=/p-value</g' | sed 's/</,/g' | awk -F ',' 'NR=1{print $4}')
      echo ""$name","$pcorr","$lowCI","$highCI","$p_value"" >> "$dirres"/all/all_corr_data.csv
    done 
    } < $INPUT
    IFS=$OLDIFS
    cat "$dirres"/all/all_corr_data.csv | sort -k5 |  >> "$dirres"/all/all_corr_datasig.csv
  done
fi
