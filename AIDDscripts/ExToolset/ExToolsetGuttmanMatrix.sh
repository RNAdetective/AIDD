#!/usr/bin/env bash
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
name_files() {
  temp=$(echo "$dir_count" | sed 's/\//,/g')
  dirnum=$(echo "$temp" | grep -o "," | wc -l)
  filenum=$(expr "$dirnum" + 2)
  extnum=$(expr "$dirnum" + 3) 
  dir_name=$(echo "$files" | sed 's/\//./g' | cut -f "$filenum" -d '.')
  res="${dir_name//[^_]}"
  if [ "$res" == "" ];
  then
    file_name=$(echo "$dir_name" | cut -f 1 -d '.') 
    #sample=$(echo "$file_name" | cut -f 1 -d ':')
  else
    file_name=$(echo "$dir_name" | cut -f 1 -d '.' | cut -f 1-"${#res}" -d '_' )
    #sample=$(echo "$file_name" | cut -f 1 -d ':')
  fi
  file_ext=$(echo "$files" | sed 's/\//./g' | cut -f "$extnum" -d '.') 
}
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
mes_out() {
dirqc="$dir_path"/quality_control
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$file_name","$file_in","$tool"" >> "$dirqc"/time_check/"$file_name"time_check.csv
}
matrixeditor() {
Rscript "$ExToolset"/matrixedit.R "$file_out" "$file_in" "$index_file" "$pheno_file" "$Rtool" "$level_id" "$level_name" "$filter_type" "$level" "$tempf1" "$tempf2" "$tempf3"
} # creates matrix counts with names instead of ids and checks to make sure they are there
mergeR() {
Rscript "$ExToolset"/multimerge.R "$cur_wkd" "$names" "$file_out" "$Rtool" "$Rtype" "$summaryfile" "$mergefile" "$phenofile" "$level_name" "$GOI_file" "$temp_file1" "$temp_file2" "$temp_file3" "$rename" #creates level of interest files
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
add_conditions() {
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
count_matrix="$dirres"/"$name"_count_matrix.csv
Rtool=finalmerge
Rtype=single2f
GOI_file="$dirres"/"$name"_count_matrixANOVA.csv
file_out="$dirres"/"$name"_count_matrixANOVA.csv
mergefile="$dirres"/"$name"_count_matrix.csv
phenofile="$dir_path"/PHENO_DATA.csv
level_name=$(echo "samp_name")
echo1=$(echo "CREATING "$file_out"")
mes_out
mergeR
}
basecount() {
Rscript "$dir_path"/tempbasecount.R "$file_in" "$temp_file"
rm "$dir_path"/tempbasecount.R
}
##############################################################################################################################################################
# CREATE FREQUENCY MATRIX FROM BAM FILES FOR EXCTIOME EDITING SITES                                                                      *Working
###############################################################################################################################################################
home_dir=$1;
dir_path=$2;
human="$3";
dirres="$dir_path"/Results;
new_dir="$dirres"
create_dir
ExToolset="$home_dir"/AIDD/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
matrix_file_out="$dirres"/excitomefreq_count_matrix.csv
LOG_LOCATION="$dir_path"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/ExToolsetGuttmanMatrix.log)
exec 2>&1

echo "Log Location will be: [ $LOG_LOCATION ]"
matrix_file="$dirres"/gene_count_matrix.csv
matrix_file2="$dirres"/transcript_count_matrix.csv
matrix_fileedit="$dirres"/gene__count_matrixeditedDESeq2.csv
matrix_fileedit2="$dirres"/transcript_count_matrixeditedDESeq2.csv
level=$(echo "gene")
if [ -s "$matrix_file" ];
then
  if [ ! -s "$matrix_fileedit" ];
  then
    #echo1=$(echo "RAW DATA FILES FOR "$in_file" FOUND")
    #mes_out
    file_out="$dirres"/"$level"_count_matrixeditedDESeq2.csv
    file_in="$dirres"/"$level"_count_matrix.csv
    ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
    index_file="$ExToolsetix"/"$human"/"$level"_names.csv
    pheno_file="$dir_path"/PHENO_DATA.csv
    Rtool=GTEX
    level_id=$(echo ""$level"_id");
    level_name=$(echo ""$level"_id");
    filter_type=$(echo "protein_coding");
    level="$level"
    tempf1="$dir_path"/tempR1.csv
    tempf2="$dir_path"/tempR2.csv
    tempf3="$dir_path"/tempR3.csv
    file_in="$index_file"
    cat "$index_file" | sed 's/-/_/g' >> "$dir_path"/temp.csv
    temp_file
    file_in="$dirres"/"$level"_count_matrix.csv
    file_out="$dirres"/"$level"_count_matrixeditedDESeq2.csv
    echo1=$(echo "CREATING "$file_out"")
    mes_out
    matrixeditor
    header=$(cat "$file_out" | head -n 1 | cut -d"," -f1 --complement)
    cat "$file_out" | awk -F',' 'NR > 1{s=0; for (i=3;i<=NF;i++) s+=$i; if (s!=0)print}' | sort -u -k1 | sed '1d' | sed '1i '$level'_name',$header'' | awk -F',' '!a[$1]++' >> "$dir_path"/temp.csv
    file_in="$dirres"/"$level"_count_matrixeditedDESeq2.csv
    temp_file
  else
    echo1=$(echo "ALREADY FOUND "$matrix_fileedit" OR "$matrix_fileedit2"")
    mes_out
  fi
else
  echo1=$(echo "CANT FIND "$matrix_file" OR "$matrix_file2"")
  mes_out
fi
matrix_file="$dirres"/gene_count_matrixeditedDESeq2.csv
matrix_file4="$dirres"/excitome_count_matrix.csv
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
  echo1=$(echo "ALREADY FOUND "$matrix_file"")
  mes_out
fi
  INPUT="$ExToolsetix"/"$human"/excitome_loc.csv
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r excitome_gene gene_id snp_database chrome coord strand annotation AAsubstitution AAposition exon codon_position express_value edit_value
  do
    home_dir=$1;
    dir_path=$2;
    dirres="$dir_path"/Results;
    new_dir="$dirres"
    create_dir
    human=$3;
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
  cat "$file_out" | sed 's/edited//g' >> "$dir_path"/temp.csv
  temp_file
  Rtool=G_VEX
  Rtype=multi
  GOI_file="$file_out"
  names=$(echo "sample")
  mergefile=none
  phenofile=none
  summaryfile="$dir_path"/PHENO_DATA.csv
  temp_file1="$dirres"/temp2.csv
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
