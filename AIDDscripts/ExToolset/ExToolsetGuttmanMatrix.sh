#!/usr/bin/env bash
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
##############################################################################################################################################################
# CREATE FREQUENCY MATRIX FROM BAM FILES FOR EXCTIOME EDITING SITES                                                                      *Working
###############################################################################################################################################################
cd "$dir_path"/AIDD
source config.shlib;
home_dir=$(config_get home_dir);
dir_path=$(config_get dir_path);
dirres=$(config_get dirres);
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
matrix_file_out="$dirres"/excitomefreq_count_matrix.csv
LOG_LOCATION="$dir_path"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/ExToolsetGuttmanMatrix.log)
exec 2>&1

echo "Log Location will be: [ $LOG_LOCATION ]"
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
