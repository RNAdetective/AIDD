export PATH=$PATH:~/AIDD/AIDD_tools/flux-simulator-1.2.1/bin
time_check(){
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $tool
___________________________________________________________________________" >> "$dir_path"/"$name"time_check.txt
}
check_tools() {
for tools in flux-simulator ;
do
  if ! [ -x "$(command -v "$tools")" ]; then
    echo "Need to install "$tools" to continue"
    exit
  fi
done
}
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
}
create_par() {
cat "$sim_scripts"/par_file.par | sed 's/read_num/'$num'000000/g' | sed 's/read_len/'$len'/g' >> "$par_dir"/"$name".par
}
get_gtf() {
if [ ! -s "$sim_ref"/GRCh37.gtf ] ;
then
grep ^[0-9XYM] "$ref_path"/ref.gtf > "$sim_ref"/GRCh37.gtf
fi
}
get_chromfa() {
dir_ref="$dir_path"/genome_references/chromFa
if [ ! -d "$dir_ref" ];
then
  mkdir "$dir_ref"
  cd "$dir_ref"
  for i in {1..22} MT X Y ;
  do
    if [ ! -s "$dir_ref"/"$i".fa ];
    then
      wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.chromosome."$i".fa.gz -O "$i"raw.fa.gz
      gunzip "$i"raw.fa.gz
      cat "$dir_ref"/"$i"raw.fa | sed '1d' | sed '1i >'$i'' > "$dir_ref"/"$i".fa
      rm "$dir_ref"/"$i"raw.fa
    fi 
  done
fi
}
sim_tool() {
export FLUX_MEM="30G"; flux-simulator -p "$par_dir"/"$name".par
}
setjavaversion() {
JDK8=/usr/lib/jvm/java-8-oracle/jre/  
JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
                                                                                                                 
case $use_java in
  8)
     export JAVA_HOME="$JDK8"
     export PATH=$JAVA_HOME/bin:$PATH     ;
  ;;
  11)
     export JAVA_HOME="$JDK11"
     export PATH=$JAVA_HOME/bin:$PATH     ;
  ;;
  *)
     error java version can only be 1.8 or 1.11
  ;;
esac
}
move_files() {
mv "$par_dir"/"$name"* "$wkd"/
}
Simcounts() {
cat "$wkd"/"$name".pro | sed 's/\t/,/g' | awk -F',' '{ print $2, $8 }' | sed '1d' | sed '1i transcript_id,sim' | sort -r | sed 's/ /,/g' >> "$wkd"/"$name"sim.csv
cp "$wkd"/"$name"sim.csv "$dir_path"/correlations/"$name"sim.csv
}
PHENO() {
new_dir="$dir_path"/PHENO_DATA/
create_dir
echo ""$name","$name",none,"$sample"" >> "$dir_path"/PHENO_DATA/PHENO_DATA"$name".csv
}
createPHENO() {
if [ -s "$dir_path"/PHENO_DATA.csv ];
then
  rm "$dir_path"/PHENO_DATA.csv
fi
cat "$dir_path"/PHENO_DATA/*.csv | sed '1i samp_name,Run,condition,sample' >> "$dir_path"/PHENO_DATA.csv
}
splitfq() {
perl "$sim_scripts"/splitfq.pl "$wkd"/"$name".fastq
mv "$wkd"/"$name".fastq_1 "$wkd"/"$name"_1.fastq
mv "$wkd"/"$name".fastq_2 "$wkd"/"$name"_2.fastq
}
fastqcpaired() { 
wkd="$dir_path"/sim_out/"$name"
fastqc "$wkd"/"$name"_1.fastq "$wkd"/"$name"_2.fastq --outdir="$wkd"
 }
filterfq() {
cat "$wkd"/"$name"_1.fastq | paste - - - - | awk 'length($2)  >= 5' | sed 's/\t/\n/g' > "$wkd"/filter"$name"_1.fastq
cat "$wkd"/"$name"_2.fastq | paste - - - - | awk 'length($2)  >= 5' | sed 's/\t/\n/g' > "$wkd"/filter"$name"_2.fastq
}
HISAT2_paired() { 
hisat2 -q -x "$ref_path"/genome -p3 --dta-cufflinks -1 "$wkd"/"$name"_1.fastq -2 "$wkd"/"$name"_2.fastq -t --summary-file "$wkd"/"$name".txt -S "$wkd"/"$name".sam 
}
samtobam() { 
java -Djava.io.tmpdir="$dir_path"/tmp -jar "$tools"/picard.jar SortSam INPUT="$wkd"/"$name".sam OUTPUT="$wkd"/"$name".bam SORT_ORDER=coordinate
}
assem_string() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin 
mkdir "$prep_dir" 
mkdir "$prep_dir"/"$sample"
stringtie "$wkd"/"$name".bam -p3 -G "$sim_ref"/GRCh37.gtf -A "$wkd"/"$name".tab -l -B -b "$wkd"/"$name" -e -o "$prep_dir"/"$sample"/"$name".gtf 
cp -r "$wkd"/ballgown/"$sample" "$dir_path"/ballgown/
}
align_metric() {
mkdir "$wkd"/summary/
java -jar "$tools"/picard.jar CollectAlignmentSummaryMetrics R="$ref_path"/ref.fa I="$wkd"/"$name".bam O="$wkd"/summary/"$name"_summary.txt
cp "$wkd"/summary/"$name"_summary.txt "$dir_path"/summary/
}
count_AIDD() {
cd "$wkd"/
python "$tools"/prepDE.py -g "$wkd"/"$name"_gene_count_matrix.csv -t "$wkd"/"$name"_transcript_count_matrix.csv # CREATE MATRIX FILES
cat "$wkd"/"$name"_transcript_count_matrix.csv | sed '1d' | sed '1i transcript_id,AIDD' | sort -r >> "$wkd"/"$name"AIDD.csv
cp "$wkd"/"$name"AIDD.csv "$dir_path"/correlations/"$name"AIDD.csv
cd
}
variables() {
for i in AIDD sim all ; do
  echo ""$i""$sample"="$corr"/"$name""$i".csv" >> "$sim_scripts"/config.cfg
  echo ""$i""$sample"=Default Value" >> "$sim_scripts"/config.cfg.defaults
done
}
var_R() {
echo "print0("name <- ","$name")" >> "$sim_scripts"/config.R
echo "print0("data <- ","$corr"/"$name"all.csv)" >> "$sim_scripts"/config.R
echo "print0("AIDD <- ","$name","AIDD")" >> "$sim_scripts"/config.R
echo "print0("sim <- ","$name","sim")" >> "$sim_scripts"/config.R
}
temp_dir() {
if [ -d "$dir_path"/ballgown/$sample/tmp.XX*/ ]; # IF TEMP_DIR IN SAMPLE FOLDER
then
  rm -f -R "$dir_path"/ballgown/$sample/tmp.XX*/ #DELETE TMP_DIR
fi
}
gtfcheck() { 
echo ""$run","$sample","$answer"
" > "$dir_path"/file_check/"$sample".csv
}
file_check() {
if [ -f "$path_fc" ] # IF FILE IS THERE
  then
    answer=$"yes"; 
      gtfcheck # ANSWER YES
  else
    answer=$"no"; 
      gtfcheck # ANSWER NO
  fi
}
makecheckfile() { cat $dir_path/file_check/sample* | grep -w no$ | while read run exist; do echo "$run","$sample"; done > "$dir_path"/file_check/CheckTheseFiles.csv ; rm -f "$dir_path"/file_check/sample* ; }
matrix() {
cd "$dir_path"
python "$tools"/prepDE.py -g "$dir_path"/DE/gene_count_matrix.csv -t "$dir_path"/DE/transcript_count_matrix.csv # CREATE MATRIX FILES
cd
}
gtfcheck() {
temp_dir
path_fc="$dir_path"/ballgown/$sample/"$file_name_gtf" 
file_check # makes temp file with yes or no
makecheckfile
}
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
m_corr() {
join -1 1 -2 1 "$corr"/"$name"AIDD.csv "$corr"/"$name"sim.csv  -o1.1,1.2,2.2 -e0 >> "$corr"/"$name"all.csv
}
compress() {
tar -cvzf "$dir_path"/"$name".tar.gz "$wkd"
}
summary_split() {
cat "$dir_path"/summary/"$name"_summary.txt | sed '/^#/d' | sed 's/PAIR/'$run'/g' | sed '/^FIR/d' | sed '/^SEC/d' | sed 's/\t/,/g' | sed '1d' >> "$dir_path"/"$name"_summary.csv
} #creates alignment matrix from txt file
combine_file() {
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" | sed '/^$/d' | awk -F',' '!x[$1]++' >> "$file_out"
} # cuts each column out of matrix and makes its own file
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
sum_combine() {
cat "$dir_path"/summary/*.csv | sed '/^$/d' | awk -F',' '!x[$1]++' >> "$dir_path"/summary/all_summary.csv
sed -i '1!{/^CAT/d;}' "$dir_path"/summary/all_summary.csv
file_in="$dir_path"/summary/all_summary.csv
file_out="$dir_path"/summary/all_summaryfilter.csv
col_num=$(echo "1,6,7,13,18,20,21,22,23")
tool=combine_file
run_tools
file_in="$dir_path"/summary/all_summary.csv
file_out="$dir_path"/summary/all_summarynorm.csv
col_num=$(echo "1,2")
tool=combine_file
run_tools
file_in="$dir_path"/summary/all_summarynorm.csv
file_out="$dir_path"/summary/all_summarynorm.tiff
bartype=$(echo "single")
tool=Rbar
run_tools
} # makes big summary file matrix with all columns and creates bar graph
sum_divid() {
for colnum in 2 3 4 5 6 7 8 9 ; do
colname=$(awk -F, 'NR==1{print $'$colnum'}' "$dir_path"/summary/all_summaryfilter.csv);
file_in="$dir_path"/summary/all_summaryfilter.csv
file_out="$dir_path"/summary/all_summary"$colname".csv
col_num=$(echo "1,"$colnum"")
tool=combine_file
run_tools
file_in="$dir_path"/summary/all_summary"$colname".csv
sed -i '1d' "$file_in"
sed -i '1i name,freq' "$file_in"
file_out="$dir_path"/summary/all_summary"$colname".tiff
bartype=$(echo "single")
tool=Rbar
#run_tools
done
} # separates big summary into each category and creates bar graph
run_tools() {
if [ ! -s "$file_out" ];
then
  if [ -s "$file_in" ];
  then
    "$tool"
  else
    echo "Can't find "$file_in""
  fi
else
  echo ""$file_out" found moving on"
fi
} 
###########################################################################################
# RUN FLUX SIMULATOR
###########################################################################################
dir_path=/media/sf_AIDD/sim
home_dir=/home/user
new_dir="$dir_path"
tool=start_time
time_check
check_tools
create_dir
sim_scripts="$dir_path"/simulator
new_dir="$sim_scripts"
create_dir
cp "$home_dir"/AIDD/AIDD/simulator/* "$sim_scripts"/
for i in par_files PHENO_DATA sim_out tmp correlations summary ballgown DE file_check AIDD genome_references ; 
do
  new_dir="$dir_path"/"$i"/
  create_dir
  if [ "$i" == AIDD ];
  then
    new_dir="$dir_path"/AIDD/counts
    create_dir
  fi
done
INPUT="$sim_scripts"/experiments.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
while IFS=, read -r num len sample
do
  dir_path=/media/sf_AIDD/sim
  ref_path="$home_dir"/AIDD/references
  home_dir=/home/user
  name="$num"M"$len"length
  wkd="$dir_path"/sim_out/"$name"
  tools="$home_dir"/AIDD/AIDD_tools
  sim_scripts="$dir_path"/simulator
  par_dir="$dir_path"/par_files
  scripts_dir="$home_dir"/AIDD/AIDD/scripts
  prep_dir="$wkd"/ballgown
  sim_ref="$dir_path"/genome_references
  corr="$dir_path"/correlations
  if [[ ! -s "$par_dir"/"$name".par && ! -s "$wkd"/"$name"_1.fastq ]]; # IF NO PAR FILE ARE THERE
  then
    create_par # CREATE PAR FILES
    mkdir "$wkd"
  fi
  if [ -s "$par_dir"/"$name".par ]; # IF PAR FILE ARE THERE
  then
    if [ ! -s "$wkd"/"$name".fastq ];
    then
      tool=references_start
      time_check
      get_gtf
      get_chromfa
      tool=references_end
      time_check
      tool=simulation_start
      time_check
      sim_tool
      move_files
      PHENO
      tool=simulation_end
      time_check
    else
      echo ""$name" already done"
    fi
  else
    echo ""$name".par files not found"
  fi
  if [[ -s "$wkd"/"$name".pro && -s "$wkd"/"$name".fastq ]]
  then
    tool=Simcounts
    file_in="$wkd"/"$name".pro
    file_out="$wkd"/"$name"sim.csv
    time_check
    run_tools
    tool=splitfq 
    file_in="$wkd"/"$name".fastq
    file_out="$wkd"/"$name"_1.fastq
    time_check
    run_tools
    use_java=11
    setjavaversion
    tool=fastqcpaired
    file_in="$wkd"/"$name"_1.fastq
    file_out="$wkd"/"$name"_1_fastqc.html
    time_check
    run_tools
    use_java=8
    setjavaversion
    export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
    tool=HISAT2_paired
    file_in="$wkd"/"$name"_1.fastq
    file_out="$wkd"/"$name".sam
    time_check
    run_tools
    tool=samtobam
    file_in="$wkd"/"$name".sam
    file_out="$wkd"/"$name".bam
    time_check
    run_tools
    tool=assem_string
    file_in="$wkd"/"$name".bam
    file_out="$wkd"/"$name".tab
    time_check
    run_tools
    tool=align_metric
    file_in="$wkd"/"$name".bam
    file_out="$wkd"/summary/"$name"_summary.txt
    time_check
    run_tools
    tool=count_AIDD
    file_in="$wkd"/"$name".tab
    file_out="$wkd"/"$name"AIDD.csv
    time_check
    run_tools
    tool=compress
    file_in="$wkd"/"$name"AIDD.csv
    file_out="$dir_path"/"$name".tar.gz
    time_check
    run_tools
    tool=AIDD_done
    time_check
    tool=start_corr
    time_check
    if [[ -s "$corr"/"$name"AIDD.csv && -s "$corr"/"$name"sim.csv ]];
    then
      dir_path=/media/sf_AIDD/sim
      ref_path="$home_dir"/AIDD/references
      home_dir=/home/user
      name="$num"M"$len"length
      echo ""$name""
      wkd="$dir_path"/sim_out/"$name"
      tools="$home_dir"/AIDD/AIDD_tools
      sim_scripts="$dir_path"/simulator
      par_dir="$dir_path"/par_files
      scripts_dir="$home_dir"/AIDD/AIDD/scripts
      prep_dir="$wkd"/ballgown
      sim_ref="$dir_path"/genome_references
      corr="$dir_path"/correlations
      file_in1="$corr"/"$name"sim.csv
      sed -i 's/  /,/g' "$file_in1"
      file_in2="$corr"/"$name"AIDD.csv
      file_out1="$corr"/"$name"corr.tiff
      file_out2="$corr"/"$name"corr.txt
      file_outAll="$corr"/"$name"All.csv
      if [ ! -s "$file_outAll" ];
      then
        Rscript "$sim_scripts"/simcorr.R "$name" "$file_in1" "$file_in2" "$file_out1" "$file_out2" "$file_outAll"
      fi
      if [ -s "$file_outAll" ];
      then
        echo ""$name" DONE"
      fi
      dirrescorr="$dir_path"/correlations
      file_in="$dirrescorr"/"$name"corr.txt
      file_out="$dirrescorr"/all_corr_data.cvs
      corr_file="$dirrescorr"/"$name"corr.txt
      pcorr=$(cat "$corr_file" | awk '/   cor/{nr[NR+1]}; NR in nr')
      new_file="$dir_path"/correlations/temp.csv
      lowCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $2}') 
      highCI=$(cat "$corr_file" | awk '/95 percent confidence interval/{nr[NR+1]}; NR in nr' | sed 's/ /,/g' | awk -F',' 'NR=1{print $3}')
      p_value=$(cat "$corr_file" | awk '/p-value /{nr[NR]}; NR in nr' | sed 's/ //g' | sed 's/p-value=/p-value</g' | sed 's/</,/g' | awk -F ',' 'NR=1{print $4}')
      echo ""$name","$pcorr","$lowCI","$highCI","$p_value"" >> "$dirrescorr"/all_corr_data.csv
    else 
      echo "can't find "$name" transcript count files"
    fi
    #gtfcheck
  else
    echo "Can't find pro file for "$name""
  fi
tool=alignment_stats
time_check
file_in="$dir_path"/summary/"$name"_summary.txt
file_out="$dir_path"/summary/"$name"_summary.csv
tool=summary_split
run_tools
tool=corr_end
time_check
done
} < $INPUT
IFS=$OLDIFS
sum_combine
sum_divid
tool=end_time
time_check
###########################################################################################
# RUN ANALYSIS
###########################################################################################
#createPHENO
#if [ ! -s ""$dir_path"/file_check/CheckTheseFiles.csv" ]; # IF ALL INPUT FILES ARE THERE CHECKFILE EMPTY
#then
#  matrix
#else
#  echo "there are missing gtf files please check file_check directory for more information"
#fi
#if [[ -s "$dir_path"/DE/gene_count_matrix.csv && -s "$dir_path"/DE/transcript_count_matrix.csv ]];
#then
#Rscript Deseq2DE.R
#Rscript EdgeRDE.R
#fi 
#source config.shlib; # load the config library functions
####################################################################################################################
# RUNS EXTOOLSET FOR CORRELATION SUMMARY
####################################################################################################################
#cat "$dirres"/all/all_corr_data.csv | sort -k5 |  >> "$dirrescorr"/all_corr_datasig.csv
