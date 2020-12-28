#!/usr/bin/env bash
source config.shlib; # load the config library functions
export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
####################################################################################################################
# this sets up variables for options
####################################################################################################################
dir_path="$(config_get dir_path)"; # main directory
wd="$dir_path"/working_directory; # working directory
home_dir="$(config_get home_dir)"; # home directory
export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
ref_dir_path="$(config_get ref_dir_path)"; # reference directory
dirqc="$dir_path"/quality_control; # qc directory
AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
ExToolset="$home_dir"/AIDD/AIDD/ExToolset/scripts # AIDD script directory
rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
rdbam="$dir_path"/raw_data/bam_files # directory for bam files
rdsnp="$dir_path"/raw_data/snpEff #directory for snp files
javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M ulimit -c unlimited -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
sra="$(config_get dir_path)";
scRNA="$(config_get scRNA)";
miRNA="$(config_get miRNA)";
miRNAtype="$(config_get miRNAtype)";
library="$(config_get library)";
aligner="$(config_get aligner)";
assembler="$(config_get assembler)";
variant="$(config_get variant)";
savesra="$(config_get savesra)";
savefastq="$(config_get savefastq)";
bamvcf="$(config_get bamvcf)";
start=12;
end=400;
####################################################################################################################
####################################################################################################################
####################################################################################################################
#defines the functions
####################################################################################################################
####################################################################################################################
####################################################################################################################
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
mes_out() {
dirqc="$dir_path"/quality_control
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$run","$file_in","$tool"" >> "$dirqc"/time_check/"$run"time_check.csv
file_size
echo "'$DATE_WITH_TIME' $echo1 $file_name $file_ext $file_size_kb
___________________________________________________________________________"
}
file_size() {
file_size_kb=`du -k "$file_in" | cut -f1`
#dir_name=$(echo "$file_in" | sed 's/\//./g' | cut -f 6 -d '.')
#file_name=$(echo "$dir_name" | cut -f 1 -d '.')
#file_ext=$(echo "$file_in" | sed 's/\//./g' | cut -f 7 -d '.')
new_dir="$dirqc"/file_size
create_dir
sizefile="$dirqc"/file_size/sizefile.csv
if [ ! -f "$sizefile" ];
then
  echo "run,file" >> "$sizefile"
fi
echo ""$run","$file_size_kb","$file_in"" >> "$sizefile"
}
next_samp() {
sam_num=${sample:7:8}
new_sam=$(("$sam_num" + 1));
next_sample=$(echo "sample"$new_sam"");
echo1=$(echo "FOUND "$sample" NOW STARTING "$next_sample"");
mes_out
}

steps() {
echo1=$(echo "DONE WITH "$step1" NOW STARTING "$step2"");
file_in="$step2"
tool="$step1"
mes_out
}
setjavaversion() {
   
JDK8="$AIDDtool"/jdk-8u221-linux-x64/jdk1.8.0_221/  
JDK11=/usr/lib/jvm/java-11-openjdk-amd64/                                                                                              
case $version in
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
run_tools2o() {
if [[ ! -f "$file_out" && ! -f "$file_out2" ]]; # IF OUTPUT FILE IS NOT THERE
then
  if [ -f "$file_in" ]; # IF INPUT THERE
  then
    echo1=$(echo "FOUND "$file_in" STARTING "$tool"");
    mes_out
    $tool # TOOL
  else
    echo1=$(echo "CANNOT FIND $file_in FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
  if [[ -f "$file_out" && -f "$file_out2" ]]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND $file_out FINISHED $tool");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND "$file_out" OR "$file_out2" FOR_THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$("FOUND "$file_out" FINISHED "$tool"");
  mes_out # ERROR OUTPUT IS THERE
fi
}
run_tools2i2o() {
if [[ ! -f "$file_out" && ! -f "$file_out2" ]]; # IF OUTPUT FILE IS NOT THERE
then
  if [[ -f "$file_in" && -f "$file_in2" ]]; # IF INPUT THERE
  then
    echo1=$("FOUND "$file_in" STARTING "$tool"");
    mes_out
    $tool # TOOL
  else
    echo1=$("CANNOT FIND "$file_in" OR "$file_in2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
  if [[ -f "$file_out" && -f "$file_out2" ]]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND "$file_out" AND "$file_out2" FINISHED "$tool"");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND "$file_out" OR "$file_out2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$(echo "FOUND "$file_out" OR "$file_out2" FINISHED "$tool"");
  mes_out # ERROR OUTPUT IS THERE
fi
}
run_tools2i() {
if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
then
  if [[ -f "$file_in" && -f "$file_in2" ]]; # IF INPUT THERE
  then
    echo1=$(echo "FOUND "$file_in" AND "$file_in2" STARTING "$tool"");
    mes_out
    $tool # TOOL
  else
    echo1=$(echo "CANNOT FIND "$file_in" OR "$file_in2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
  if [ -f "$file_out" ]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND "$file_out" FINISHED "$tool"");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND "$file_in" OR "$file_in2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$(echo "FOUND "$file_out" FINISHED "$tool"")
  mes_out # ERROR OUTPUT IS THERE
fi
}
download() {
runfoldernameup=${run:0:3}
runfoldername=$(echo "$runfoldernameup" | tr '[:upper:]' '[:lower:]')
runfolder=${run:0:6}
lastnum=${run:9:10}
countrun=$(echo -n "$run" | wc -c)
if [ "$countrun" == "11" ];
then
  finallastnum=$(echo ""$lastnum"")
else
  finallastnum=$(echo "0"$lastnum"")
fi
cd "$wd"/
wget -q --tries=5 ftp://ftp.sra.ebi.ac.uk/vol1/"$runfoldername"/"$runfolder"/0"$finallastnum"/"$run"
# wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"$runfoldername"/"$runfolder"/"$run"/"$run".sra # this was for ncbi but ebi works better
cd "$dir_path"/AIDD
#mv "$wd"/"$run" "$wd"/"$sample":"$run"
}
fastqdumppaired() { 
new_dir="$wd"/fastq
create_dir
fastq-dump "$file_in" -I --split-files --read-filter pass -O "$wd"/
mv "$wd"/"$file_name"_pass_1.fastq "$file_out" 
mv "$wd"/"$file_name"_pass_2.fastq "$file_out2"
 }

fastqdumpsingle() { 
new_dir="$wd"/fastq
create_dir
fastq-dump "$file_in" --read-filter pass -O "$wd"/
mv "$wd"/"$file_name"_pass.fastq "$file_out"
 }
movefastqpaired() {
new_dir="$wd"/fastq
create_dir
cp "$file_in" "$file_out"
cp "$file_in2" "$file_out2"
}
movefastqsingle() {
new_dir="$wd"/fastq
create_dir
cp "$file_in" "$file_out"
}
fastqcpaired() { 
cd "$dir_path"/AIDD
fastqc "$wd"/fastq/"$file_name"_1.fastq "$wd"/fastq/"$file_name"_2.fastq --outdir=$dirqc/fastqc
cd "$dir_path"/AIDD
}
fastqcsingle() { 
cd "$dir_path"/AIDD
fastqc "$wd"/fastq/"$file_name".fastq --outdir=$dirqc/fastqc
cd "$dir_path"/AIDD
}
setreadlength() {
start=12
end=400
}
trimpaired() {
new_dir="$wd"/trim
create_dir
fastx_trimmer -f "$start" -l "$end" -i "$file_in" -o "$file_out"
fastx_trimmer -f "$start" -l "$end" -i "$file_in2" -o "$file_out2"
cd $dirqc/fastqc
fastqc "$file_out" "$file_out2" --outdir=$dirqc/fastqc 
cd "$dir_path"/AIDD/ 
}
trimsingle() { 
new_dir="$wd"/trim
create_dir
fastx_trimmer -f "$start" -l "$end" -i "$file_in" -o "$file_out"
cd $dirqc/fastqc
fastqc "$file_out" --outdir=$dirqc/fastqc
cd "$dir_path"/AIDD/
}
HISAT2_paired() {  
new_dir="$wd"/sam
create_dir
hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -1 "$wd"/fastq/"$file_name"_1.fastq -2 "$wd"/fastq/"$file_name"_2.fastq -t --summary-file $dirqc/alignment_metrics/"$file_name".txt -S "$wd"/sam/"$file_name".sam
#mv "$wd"/"$file_name".sam "$wd"/sam/"$file_name".sam
}
HISAT2_single() { 
new_dir="$wd"/sam
create_dir
hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -U "$file_in" -t "$wd"/fastq/"$file_name".fastq --summary-file $dirqc/alignment_metrics/"$file_name".txt -S "$wd"/sam/"$file_name".sam
}
STAR_paired() { 
STAR --genomeDir "$home_dir"/AIDD/references/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn 1 "$wd"/fastq/"$file_name"_1.fastq -2 "$wd"/fastq/"$file_name"_2.fastq  --outFileNamePrefix ../results/STAR/Mov10_oe_1_ --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard 
} # 
 
STAR_single() { 
STAR --genomeDir "$home_dir"/AIDD/references/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn -"$wd"/fastq/"$file_name".fastq --outFileNamePrefix "$rdbam"/"$file_name".bam --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard 
} #
BOWTIE2_paired() { echo "BOWTIE2 some text line on how to run" ; }
BOWTIE2_single() { echo "BOWTIE2 some text line on how to run" ; }
samtobam() { 
java -Djava.io.tmpdir="$dir_path"/tmp -jar "$AIDDtool"/picard.jar SortSam INPUT="$file_in" OUTPUT="$file_out" SORT_ORDER=coordinate
}
assem_string() { 
stringtie "$file_in" -p3 -G "$ref_dir_path"/ref.gtf -A "$file_out" -l -B -b "$dir_path"/raw_data/ballgown_in/"$sample"/"$sample" -e -o "$file_out2"
}
basecounts() {
bash "$home_dir"/AIDD/AIDD/ExToolset/scripts/basecountsfrombam.sh "$home_dir" "$dir_path"
}
temp_dir() {
if [ -d "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ ]; # IF TEMP_DIR IN SAMPLE FOLDER
then
  echo "FOUND tempdir ALREADLY IN FOLDER"
  rm -f -R "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ #DELETE TMP_DIR
fi
}
create_filecheck() {
if [ -s "$type1" ];
then
  echo ""$run""$snptype"1,yes" >> "$filecheckVC"/filecheck"$snptype"1.csv
else
  echo ""$run""$snptype"1,no" >> "$filecheckVC"/filecheck"$snptype"1.csv
fi
if [ -s "$type2" ];
then
  echo ""$run""$snptype"2,yes" >> "$filecheckVC"/filecheck"$snptype"2.csv
else
  echo ""$run""$snptype"2,no" >> "$filecheckVC"/filecheck"$snptype"2.csv
fi
}
creatematrix() {
cd "$dir_path"/raw_data/
python "$ExToolset"/prepDE.py -g "$dirres"/gene_count_matrix.csv -t "$dirres"/transcript_count_matrix.csv
cd "$dir_path"/AIDD/
} # runs python script to summarize gtf files in count matrix

####################################################################################################################
####################################################################################################################
####################################################################################################################
#  DOWNLOADS ALL SAMPLES BEFORE STARTING AIDD
####################################################################################################################
####################################################################################################################
####################################################################################################################
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  source config.shlib; # load the config library functions
  dir_path="$(config_get dir_path)"; # main directory
  wd="$dir_path"/working_directory; # working directory
  home_dir="$(config_get home_dir)"; # home directory
  ref_dir_path="$home_dir"/AIDD/references
  dirqc="$dir_path"/quality_control; # qc directory
  AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
  javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
  fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
  sra="$(config_get sra)"; # downloading sra files or have your own 
####################################################################################################################
#  DOWNLOADS
####################################################################################################################
if [ "$sra" == "yes" ]; # IF DOWNLOAD SRA
then
  if [ ! -f "$wd"/"$run" ]; # IF OUTPUT FILE IS NOT THERE
  then
    echo1=$(echo "STARTING "$tool" FOR "$sample"");
    file_in=$(echo "downloading");
    mes_out
    download
  fi
  if [ -f "$wd"/"$run" ]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND $run FINISHED DOWNLOADING $sample")
    file_in=$(echo "downloading");
    mes_out # ERROR OUTPUT IS THERE
  else
    echo1=$(echo "STARTING "$tool" FOR "$sample"");
    file_in=$(echo "downloading_second_time");
    mes_out
    #download
    if [ ! -f "$wd"/"$run" ]; # IF OUT IS NOT THERE
    then
      echo1=$(echo "STARTING "$tool" FOR "$sample"");
      file_in=$(echo "downloading_third_time");
      mes_out
     # download
    else
      echo1=$(echo "CAN'T DOWNLOAD "$sample"")
      file_in=$(echo "DONE TRYING TO DOWNLOAD CANNOT DO IT AT THIS TIME")
      mes_out
      exit
    fi  
  fi
else
  next_samp
fi
done
step1=$(echo "INTERNET")
step2=$(echo "ALIGN_AND_ASSEMBLE")
steps
} < $INPUT
IFS=$OLDIFS
####################################################################################################################
# CONVERT SRA TO FASTQ
####################################################################################################################
cd "$dir_path"/AIDD
source config.shlib; # load the config library functions
sra="$(config_get sra)"
scRNA="$(config_get scRNA)"
miRNA="$(config_get miRNA)"
miRNAtype="$(config_get miRNAtype)"
library="$(config_get library)"
aligner="$(config_get aligner)"
assembler="$(config_get assembler)"
savesra="$(config_get savesra)"
savefastq="$(config_get savefastq)"
human="$(config_get human)"
dir_count="$wd"
for files in "$dir_count"/*
do
  if [ -d "$files" ]; then
    echo "$files is a directory"
  else
    name_files
    echo "$file_name"
    if [[ "$sra" == "yes" && "$library" == "paired" ]];
    then
      tool=fastqdumppaired
      file_in="$wd"/"$file_name"
      file_out="$wd"/fastq/"$file_name"_1.fastq
      file_out2="$wd"/fastq/"$file_name"_2.fastq
      run_tools2o
    fi
  fi
####################################################################################################################
#  CONVERT SRA TO FASTQ
####################################################################################################################
  if [[ "$sra" == "yes" && "$library" == "single" ]];
  then
    tool=fastqdumpsingle
    file_in="$wd"/$file_sra   
    file_out="$wd"/fastq/"$file_name".fastq
    run_tools
  fi 
done
####################################################################################################################
# MOVEFASTQPAIRED
####################################################################################################################
dir_count="$fastq_dir_path"
for files in "$dir_count"/* ;
do
  if [[ "$sra" == "no" && "$library" == "paired" ]];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      tool=movefastqpaired
      file_in=$fastq_dir_path/"$file_name"_1.fastq
      file_in2=$fastq_dir_path/"$file_name"_2.fastq
      file_out="$wd"/fastq/"$file_name"_1.fastq
      file_out2="$wd"/fastq/"$file_name"_2.fastq
      run_tools2i2o
    fi
  fi
####################################################################################################################
#  MOVEFASTQSINGLE
####################################################################################################################
  if [[ "$sra" == "no" && "$library" == "single" ]];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      tool=movefastqsingle
      file_in=$fastq_dir_path/"$file_name".fastq   
      file_out="$wd"/fastq/"$file_name".fastq
      run_tools
    fi
  fi 
done
step1=$(echo "INTERNET")
step2=$(echo "QUALITY CONTROL")
steps
####################################################################################################################
####################################################################################################################
####################################################################################################################
#NON-INTERNET PART OF THE PIPELINE
####################################################################################################################
####################################################################################################################
####################################################################################################################
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files 
####################################################################################################################
# PAIRED QUALITY CONTROL
####################################################################################################################
  if [ "$library" == "paired" ];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory" 
    else
      tool=fastqcpaired
      file_in="$wd"/fastq/"$file_name"_1.fastq
      file_in2="$wd"/fastq/"$file_name"_2.fastq
      file_out=$dirqc/fastqc/"$file_name"_1_fastqc.html
      file_out2=$dirqc/fastqc/"$file_name"_2_fastqc.html
      JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
      version=11
      setjavaversion
      run_tools2i2o
      version=8
      JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/ 
      setjavaversion
    fi
  fi
done
####################################################################################################################
#  SINGLE QUALITY CONTROL
####################################################################################################################
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files 
  if [ "$library" == "single" ];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory" 
    else
      tool=fastqcsingle
      file_in="$wd"/fastq/"$file_name".fastq    
      file_out=$dirqc/fastqc/"$file_name"_fastqc.html
      JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
      version=11
      setjavaversion
      run_tools
      JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/ 
      version=8
      setjavaversion
    fi
  fi 
done
####################################################################################################################
# PAIRED TRIMMING
####################################################################################################################
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files 
  if [ "$library" == "paired" ];
  then
    if [ -d "$files" ];
    then 
      echo ""$files" is a directory"
    else
      #check=$(echo ">>Per base sequence content")
      #pass=$(cat "$dirqc"/fastqc/"$file_name"_1_fastqc/fastqc_data.txt '{if (/'$check'/) print NR}');
      #missing=$(grep -o 'pass' "$pass" | wc -l)
      tool=trimpaired
      file_in="$wd"/fastq/"$file_name"_1.fastq
      file_in2="$wd"/fastq/"$file_name"_2.fastq
      file_out="$wd"/trim/"$file_name"trim_1.fastq 
      file_out2="$wd"/trim/"$file_name"trim_2.fastq
      if [ ! -f "$file_out" ];
      then
        JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
        version=11
        setjavaversion 
        setreadlength
        echo1=$(echo "RUNNING TRIMMER CUTTING "$start" OFF THE BEGINNING AND ENDING AT "$end"")
        mes_out 
        run_tools2i2o
        JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/
        version=8 
       setjavaversion
      else
        echo "Already trimmed "$file_name""
        rm -f "$file_in" 
        rm -f "$file_in2"
        mv "$file_out" "$file_in"
        mv "$file_out2" "$file_in2"
      fi
    fi
  fi
done
####################################################################################################################
# TRIMMING SINGLE
#################################################################################################################### 
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files 
  if [ "$library" == "single" ];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory" 
    else
      tool=trimsingle
      file_in="$wd"/fastq/"$file_name".fastq    
      file_out="$wd"/trim/"$file_name"trim.fastq
      if [ ! -f "$file_out" ];
      then
        JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
        version=11
        setjavaversion
        setreadlength
        echo1=$(echo "RUNNING TRIMMER CUTTING "$start" OFF THE BEGINNING AND "$end" OF THE END OF THE READS")
        mes_out 
        run_tools
        JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/ 
        version=8
        setjavaversion
      else
        echo "Already trimmed "$file_name""
        rm -f "$file_in"
        mv "$file_out" "$file_in" 
        mes_out
      fi
    fi
  fi
done 
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files
####################################################################################################################
# ALIGNMENT HISAT2 PAIRED
####################################################################################################################
  if [[ "$library" == "paired" && "$aligner" == "HISAT2" ]];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      tool=HISAT2_paired
      file_in="$wd"/fastq/"$file_name"_1.fastq
      file_in2="$wd"/fastq/"$file_name"_2.fastq    
      file_out="$wd"/sam/$file_name.sam
      if [ "$savesra" == "no" ];
      then
        rm -f "$wd"/"$file_name" ##add option here donot remove files
      else
        new_dir="$dir_path"/raw_data/sra_files
        create_dir
        mv "$wd"/"$file_name" "$dir_path"/raw_data/sra_files/"$file_name"
      fi
      run_tools2i
    fi
  fi
done
####################################################################################################################
# ALIGNMENT HISAT2 SINGLE
####################################################################################################################
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files 
  if [ "$library" == "single" ];
  then
    if [ -d "$files" ];
    then 
      echo ""$files" is a directory"
    else
      if [[ "$library" == "single" && "$aligner" == "HISAT2" ]];
      then
        if [ -d "$files" ];
        then
          echo ""$files" is a directory"
        else
          tool=HISAT2_single
          file_in="$wd"/fastq/"$file_name".fastq    
          file_out="$wd"/sam/"$file_name".sam
          file_out2=$dirqc/alignment_metrics/"$file_name".txt
          run_tools
        fi
      fi
    fi
  fi
####################################################################################################################
# ALIGNMENT STAR PAIRED
####################################################################################################################
  if [[ "$library" == "paired" && "$aligner" == "STAR" ]];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      tool=STAR_paired
      file_in="$wd"/fastq/"$file_name"_1.fastq    
      file_in2="$wd"/fastq/"$file_name"_2.fastq    
      file_out="$wd"/sam/"$file_name".sam
      run_tools2i
    fi
  fi
####################################################################################################################
# ALIGNMENT STAR SINGLE
####################################################################################################################
  if [[ "$library" == "single" && "$aligner" == "STAR" ]];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      tool=STAR_single
      file_in="$wd"/fastq/"$file_name".fastq    
      file_out="$wd"/sam/"$file_name".sam
      run_tools
    fi
  fi
####################################################################################################################
# ALIGNMENT BOWTIE2 PAIRED
####################################################################################################################
  if [[ "$library" == "paired" && "$aligner" == "STAR" ]];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      tool=BOWTIE2_paired
      file_in="$wd"/fastq/"$file_name"_1.fastq   
      file_in2="$wd"/fastq/"$file_name"_2.fastq    
      file_out="$wd"/sam/"$file_name".sam
      run_tools2i
    fi
  fi
####################################################################################################################
# ALIGNMENT BOWTIE2 SINGLE
####################################################################################################################
  if [[ "$library" == "single" && "$aligner" == "STAR" ]];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      tool=BOWTIE2_single
      file_in="$wd"/fastq/"$file_name".fastq    
      file_out="$wd"/sam/"$file_name".sam
      run_tools
    fi
  fi
done
####################################################################################################################
#  samtobam
####################################################################################################################
dir_count="$wd"/sam
for files in "$dir_count"/* ;
do
  if [ -d "$files" ];
  then
    echo ""$files" is a directory"
  else
    name_files
    tool=samtobam
    file_in="$wd"/sam/"$file_name".sam    
    file_out="$rdbam"/"$file_name".bam
    if [ "$savefastq" == "no" ];
    then
      rm -f "$wd"/fastq/"$file_name"*
      rm -f "$wd"/trim/"$file_name"*
    else
      new_dir="$dir_path"/raw_data/fastq_files
      create_dir
      mv "$wd"/fastq/*.fastq "$dir_path"/raw_data/fastq_files
    fi
    run_tools
  fi
done
####################################################################################################################
#  ASSEMBLY STRINGTIE
####################################################################################################################
count=1
dir_count="$rdbam"
for files in "$dir_count"/* ;
do
  if [ "$assembler" == "stringtie" ];
  then
    if [ -d "$files" ];
    then
      echo ""$files" is a directory"
    else
      name_files
      count=`expr $count + 1`
      sample="sample${count}"
      echo1=$(echo "FOUND "$file_name" NOW STARTING "$sample"");
      mes_out
      tool=assem_string
      file_in="$rdbam"/"$file_name".bam    
      file_out="$dir_path"/raw_data/counts/"$file_name".tab 
      file_out2="$dir_path"/raw_data/ballgown/"$sample"/"$sample".gtf
      run_tools2o
      rm -f "$wd"/sam/"$file_name".sam ##add option here donot remove files
    fi
  fi
####################################################################################################################
#  ASSEMBLY CUFFLINKS
####################################################################################################################
 if [ "$assembler" == "cufflinks" ];
 then
   if [ -d "$files" ];
   then
     echo ""$files" is a directory"
   else
     sample=$(echo "sample000")
     sam_num=${sample:7:8}
     new_sam=$(("$sam_num" + 1));
     next_sample=$(echo "sample"$new_sam"");
     tool=assem_cuff
     file_in="$rdbam"/"$file_name".bam
     file_out="$dir_path"/raw_data/counts/"$file_name".tab
     file_out2="$dir_path"/raw_data/ballgown/"$next_sample"/"$next_sample".gtf
     run_tools2o
     rm -f "$wd"/sam/"$file_name".sam
   fi
 fi
done
