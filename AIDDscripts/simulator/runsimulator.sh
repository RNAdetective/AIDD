export PATH=$PATH:~/AIDD/AIDD_tools/flux-simulator-1.2.1/bin
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
cat "$wkd"/"$name".pro | awk '{ print $2, $8 }' | column -t | sed 's/\t/,/g' | sed '1d' | sed '1i transcript_id,'$name'sim' >> "$wkd"/"$name"sim.csv
cp "$wkd"/"$name"sim.csv "$dir_path"/correlations/"$name"sim.csv
cp 
}
PHENO() {
mkdir "$dir_path"/PHENO_DATA/
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
cat "$wkd"/"$name"_transcript_count_matrix.csv | sed '1d' | sed '1i transcript_id,'$name'AIDD' >> "$wkd"/"$name"AIDD.csv
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
path_to_file_check="$dir_path"/ballgown/$sample/"$file_name_gtf" 
file_check # makes temp file with yes or no
makecheckfile
}
m_corr() {
join -1 1 -2 1 "$corr"/"$name"AIDD.csv "$corr"/"$name"sim.csv  -o1.1,1.2,2.2 -e0 >> "$corr"/"$name"all.csv
}
compress() {
tar -cvzf "$dir_path"/"$name".tar.gz "$wkd"
}
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
dir_path="$2"
home_dir="$1"
new_dir="$dir_path"
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
  dir_path="$2"
  ref_path="$home_dir"/AIDD/references
  home_dir="$1"
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
      get_gtf
      get_chromfa
      sim_tool
      move_files
      PHENO
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
      run_tools
      tool=splitfq 
      file_in="$wkd"/"$name".fastq
      file_out="$wkd"/"$name"_1.fastq
      run_tools
      use_java=8
      setjavaversion
      tool=fastqcpaired
      file_in="$wkd"/"$name"_1.fastq
      file_out="$wkd"/"$name"_1_fastqc.html
      run_tools
      use_java=11
      setjavaversion
      export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
      tool=HISAT2_paired
      file_in="$wkd"/"$name"_1.fastq
      file_out="$wkd"/"$name".sam
      run_tools
      tool=samtobam
      file_in="$wkd"/"$name".sam
      file_out="$wkd"/"$name".bam
      run_tools
      tool=assem_string
      file_in="$wkd"/"$name".bam
      file_out="$wkd"/"$name".tab
      run_tools
      tool=align_metric
      file_in="$wkd"/"$name".bam
      file_out="$wkd"/summary/"$name"_summary.txt
      run_tools
      tool=count_AIDD
      file_in="$wkd"/"$name".tab
      file_out="$wkd"/"$name"AIDD.csv
      run_tools
      tool=compress
      file_in="$wkd"/"$name"AIDD.csv
      file_out="$dir_path"/"$name".tar.gz
      run_tools
      if [[ -s "$corr"/"$name"AIDD.csv && "$corr"/"$name"sim.csv ]];
      then
        m_corr
        variables
      else 
        echo "can't find "$name" transcript count files"
      fi
        gtfcheck
        Rscript "$sim_scripts"/simcorr.R
    else
      echo "Can't find pro file for "$name""
    fi
done
} < $INPUT
IFS=$OLDIFS
###########################################################################################
# RUN ANALYSIS
###########################################################################################
createPHENO
if [ ! -s ""$dir_path"/file_check/CheckTheseFiles.csv" ]; # IF ALL INPUT FILES ARE THERE CHECKFILE EMPTY
then
  matrix
else
  echo "there are missing gtf files please check file_check directory for more information"
fi
if [[ -s "$dir_path"/DE/gene_count_matrix.csv && -s "$dir_path"/DE/transcript_count_matrix.csv ]];
then
Rscript Deseq2DE.R
Rscript EdgeRDE.R
fi 
source config.shlib; # load the config library functions
#merge correlation files all.csv

