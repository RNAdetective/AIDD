#!/usr/bin/env bash
####################################################################################################################
# this sets up variables for options
####################################################################################################################
echo "Please see the manual for set up and instructions to run AIDD.  Make sure before you start you have created the auto mount shared folder called AIDD on your host computer and completed the directions on the desktop. If not running defaults please follow the prompts to fill in the details for your experiment."
default="$1" # defaut is first space
home_dir="$2" # home directory is second space
dir_path="$3" # working directory is third space
LOG_LOCATION="$dir_path"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/AIDDpipeline.log)
exec 2>&1

echo "Log Location should be: [ $LOG_LOCATION ]"
if [ "$default" == "2" ]; #this allows for download of sequences or starting with your own .fastq files 
then
  echo "Are you running a batch instance? 1=(default)no 2=yes" # do you want to download your pheno_data file
  read pheno
  if [ "$pheno" == "2" ];
  then
    echo "How many samples do you want in each batch?"
    read splitnum
  fi
  echo "Are you downloading sequences from NCBI 1=(default)yes 2=no" # download sequences
  read sra
  if [ "$sra" == "2" ]; # if no downloads
  then
    echo "Are your files in the folder on the desktop? 1=(default)yes 2=no"
    read fastq
    if [ "$fastq" == "2" ];
    then
      echo "Are you downloading the sequences from a previously preparred file accroding to the directions outlined in the manual? 1=no they are located somewhere other then the folder on the desktop. 2=yes I need to download them"
      read fastqdown
      if [ "$fastqdown" == "1" ];
      then
        echo "Please enter the directory where the fastq files are located."
        read fastq_dir_path # where to find fastq files
      fi
      if [ "$fastqdown" == "2" ];
      then
        echo "Please enter the url to download the sequences."
        read fastq_url # where to find fastq files
      fi
    fi
  fi  
  echo "Do you have bulk RNAseq data? 1=(default)yes 2=no (single cell)" # do you have bulk or single reads
  read scRNA
  echo "Do you have standard mRNA library prep selecting for poly-A tails? 1=(default)yes 2=no (miRNA)" # mRNA or miRNA data
  read miRNA
  if [ "$miRNA" == "2" ];
  then
    echo "Would you like to align to whole transcriptome? 1=(default)yes 2=no(hairpin) 3=no(mature)"
    read miRNAtype
  fi
  echo "Please enter library layout type: 1=(default)paired or 2=single" # this allows for selection between paired and single end data
  read library
  echo "Which aligner would you like to use? 1=(default)HISAT2, 2=STAR, 3=BOWTIE2" # which alignment tool
  read aligner 
  echo "Which assembler would you like to use? 1=(default)stringtie, 2=cufflinks" # which assembly tool
  read assembler 
  echo "Would you like to do variant calling for RNAediting prediction at this time? 1=(default)yes 2=no" # run variant calling
  read variant
  echo "Do you want to start at the beginning or do you want to start with variant calling? 1=(default)beginning 2=variant calling I already have bam files present" # do you need to download bam files
  read bamfile
 ## if [ "$bamfile" == "2" ];
 ##   echo "Do you need to download bam files?"
  echo "Do you have references already downloaded? 1=(default)yes 2=no" # do you want to download references now
  read ref
  if [ "$ref" == 2 ];
  then
    echo "Do you have bulk human data? 1=(default)yes 2=no(mouse) 3=no(chimpanzee)" # human or mouse data
    read human
    if [ "$human" == "1" ];
    then
      echo "Please choose a build to download and prepare reference files for the whole pipeline. 1=GRCh37, 2=GRCh38, 3=hg19" # which build for ref
      read ref_set
    fi
  fi
else
  pheno=$"1";
  instancebatch=$"1";
  indexes=$"1";
  sra=$"1";
  scRNA=$"1";
  miRNA=$"1";
  miRNAtype=$"1";
  library=$"1";
  aligner=$"1";
  assembler=$"1";
  variant=$"1";
  bamfile=$"1";
  ref=$"1";
  human=$"1";
  ref_set=$"1";
fi
####################################################################################################################
#THIS DEFINES FUNCTIONS 
####################################################################################################################
mes_out() {
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
}
run_tools() {
    if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
    then
      if [ -f "$file_in" ]; # IF INPUT THERE
      then
        echo1=$(echo "FOUND "$file_in" STARTING "$tool"")
        mes_out
        $tool # TOOL
      else
        echo1=$(echo "CANT FIND "$file_in" FOR_THIS "$sample"")
        mes_out # ERROR INPUT NOT THERE
      fi
      if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
      then
        echo1=$(echo "FOUND "$file_out" FINISHED "$tool"")
        mes_out # ERROR OUTPUT IS THERE
      else 
        echo1=$(echo "CANT FIND "$file_out" FOR THIS "$sample"")
        mes_out # ERROR INPUT NOT THERE
      fi
  else
        echo1=FOUND_"$file_out"_FINISHED_"$tool"
        mes_out # ERROR OUTPUT IS THERE
  fi
}
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
assembly_dir_create() {
INPUT="$dir_path"/PHENO_DATA.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run codition sample condition2 condition3
do
  new_dir="$dir_path"/raw_data/$ball/$sample/
  create_dir
done
rm -rf "$dir_path"/raw_data/$ball/sample/
} < $INPUT
IFS=$OLDIFS
}
temp_file() {
if [ -s "$dir_path"/temp.csv ];
then
  rm "$file_in"
  mv "$dir_path"/temp.csv "$file_in"
fi
}
remove_stuff() {
if [ -f "$path" ];
then
 rm -f "$path"
fi
} # this removes $path
get_file() {
if [ -s "$to_move" ];
then
  cp "$to_move" "$file_move"
else
  echo1=$(echo "CANT FIND "$to_move" STARTING PROCESS TO CREATE IT")
  mes_out
fi
} # gets to_move file and move to file_move
cond_file() {
cat "$dir_path"/PHENO_DATA.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f"$coln" | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed '1i freq,name' >> "$dir_path"/"$nam".csv
file_in="$dir_path"/"$nam".csv
file_out="$dir_path"/"$nam".tiff
bartype=cond
tool=Rbar
run_tools
} # creates condition file
make_cdef2() {
echo "con_name1=$con_name1
con_name2=$con_name2
con_name3=$con_name3" >> "$dir_path"/AIDD/config.cfg.defaults
} # adds conditions to config files
split_PHENO() {
mkdir "$dir_path"/splitfile/
PHENO="$dir_path"/PHENO_DATAwhole.csv
csvheader=`head -n 1 "$PHENO"`
split -d -l"$splitnum" "$PHENO" "$dir_path"/splitfile/PHENO_DATAbatch
for f in "$dir_path"/splitfile/* ;
do
  cat $f | sed 1i"$csvheader" >> $f.csv
  rm -f $f
done
sed -i '1d' "$dir_path"/splitfile/PHENO_DATAbatch00.csv
mv $dir_path/splitfile/PHENO_DATA"$batch".csv "$dir_path"/PHENO_DATA.csv
} # to be used for spliting PHENO DATA into batch files to save space for processing hundreds of samples
copy_file() {
cp "$home_dir"/Desktop/"$j"/* "$dir_path"/indexes/"$i"_list/"$dp"/ # moves experimental gene/transcript list from the desktop to the correct index folder to be used for building own on the fly indexes for GEX and TEX tools
}
moveindexes() {
for i in gene transcript ; 
do
  for j in insert_"$i"_of_interest insert_"$i"_lists_for_pathways ;
  do
    file_dir=$(ls -A "$home_dir"/Desktop/$j/)
    if [ ! -z "$file_dir" ];
    then
      if [ "$j" == insert_"$i"_of_interest ];
      then
        dp=DESeq2
        copy_file
      else
        dp=pathway
        copy_file
      fi
    else
      echo "No indexes to move"
    fi
  done
done
}

config_text() {
echo "home_dir=$home_dir
dir_path=$dir_path
ref_dir_path=$ref_dir_path
pheno=$pheno
pheno_url=$pheno_url
instancebatch=$batch
batch=$batchnumber
indexes=$indexes
indexes_url=$indexes_url
sra=$sra
fastq_dir_path=$fastq_dir_path
scRNA=$scRNA
miRNA=$miRNA
miRNAtype=$miRNAtype
library=$library
aligner=$aligner
assembler=$assembler
variant=$variant
bamfile=$bamfile
ref=$ref
human=$human
ref_set=$ref_set
ExToolset="$ExToolset"
dirqc="$dirqc"
dirqcalign="$dirqcalign"
dirres="$dirres"
dirraw="$dirraw"
dirVC="$dirVC"
dirVCsubs="$dirVCsubs"
ExToolsetix="$ExToolsetix"
summaryfile="$summaryfile"
matrix_file="$matrix_file" 
matrix_file2="$matrix_file2"
matrix_fileedit="$matrix_fileedit"
matrix_fileedit2="$matrix_fileedit2"
matrix_file3a="$matrix_file3a"
matrix_file3b="$matrix_file3b"
matrix_file3="$matrix_file3"
matrix_file4="$matrix_file4"
matrix_file5="$matrix_file5"
matrix_file6="$matrix_file6"
matrix_file7="$matrix_file7"
matrix_file8="$matrix_file8"
matrix_file9="$matrix_file9"
matrix_file10="$matrix_file10"
matrix_file11="$matrix_file11"
matrix_filefinal="$matrix_filefinal"
raw_input1="$raw_input1"
raw_input2="$raw_input2"
raw_input3="$raw_input3"
raw_input4="$raw_input4"
DATE_WITH_TIME="$DATE_WITH_TIME"
TIME_HOUR="$TIME_HOUR"
TIME_MIN="$TIME_MIN"
TIME_SEC="$TIME_SEC"
data_summary_file1="$data_summary_file1"
data_summary_file2="$data_summary_file2"
data_summary_file3="$data_summary_file3"
data_summary_file3a="$data_summary_file3a"
data_summary_file4="$data_summary_file4"
data_summary_file5="$data_summary_file5"
data_summary_file6="$data_summary_file6"
data_summary_file6a="$data_summary_file6a"
data_summary_filefinal="$data_summary_filefinal"" >> "$dir_path"/AIDD/config.cfg
}
config_defaults() {
echo "home_dir=Default Value
dir_path=Default Value
ref_dir_path=Default Value
pheno=Default Value
instancebatch=Default Value
batch=Default Value
indexes=Default Value
indexes_url=Default Value
sra=Default Value
fastq_dir_path=Default Value
scRNA=Default Value
miRNA=Default Value
miRNAtype=Default Value
library=Default Value
aligner=Default Value
assembler=Default Value
variant=Default Value 
bamfile=Default Value
ref=Default Value
human=Default Value
ref_set=Default Value
ExToolset=Default Value
dirqc=Default Value 
dirqcalign=Default Value
dirres=Default Value
dirraw=Default Value
dirVC=Default Value
dirVCsubs=Default Value
ExToolsetix=Default Value
summaryfile=Default Value
matrix_file=Default Value
matrix_file2=Default Value
matrix_fileedit=Default Value
matrix_fileedit2=Default Value
matrix_file3a=Default Value
matrix_file3b=Default Value
matrix_file3=Default Value
matrix_file4=Default Value
matrix_file5=Default Value
matrix_file6=Default Value
matrix_file7=Default Value
matrix_file8=Default Value
matrix_file9=Default Value
matrix_file10=Default Value
matrix_file11=Default Value
matrix_filefinal=Default Value
raw_input1=Default Value
raw_input2=Default Value
raw_input3=Default Value
raw_input4=Default Value
DATE_WITH_TIME=Default Value
TIME_HOUR=Default Value
TIME_MIN=Default Value
TIME_SEC==Default Value
data_summary_file1=Default Value
data_summary_file2=Default Value
data_summary_file3=Default Value
data_summary_file3a=Default Value
data_summary_file4=Default Value
data_summary_file5=Default Value
data_summary_file6=Default Value
data_summary_file6a=Default Value
data_summary_filefinal=Default Value" >> "$dir_path"/AIDD/config.cfg.defaults
} 
get_fastq() {
cp "$fastq_dir_path"/* "$dir_path"/working_directory
}

downloaded_ref() {
wget "$ftpsite" -O "$ref_name".gz
gunzip "$ref_name".gz
if [ -s "$ref_dir_path"/"$ref_name" ] ;
then
  rm "$ref_name".gz
else
  echo "_________________________________________________________
Can't find "$ref_name" file"
fi
}
organize_ref() {
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar "$home_dir"/AIDD/AIDD_tools/picard.jar CreateSequenceDictionary REFERENCE="$ref_dir_path"/ref2.fa OUTPUT="$ref_dir_path"/ref2.dict
samtools faidx "$ref_dir_path"/ref2.fa
}
HISAT_ref(){
wget "$ftpsite"
tar -vxzf "$set_ref".tar.gz
for i in {1..8} ; do
  mv "$ref_dir_path"/"$set_ref"/genome*."$i".ht2 "$ref_dir_path"/genome."$i".ht2
done
if [ -s "$ref_dir_path" ];
then
  rm "$set_ref".tar.gz
else
  echo "_________________________________________________________
Can't find unziped HISAT2 file"
fi
}

####################################################################################################################
# SET UP PARENT DIRECTORIES, PHENO_DATA, AND SET-UP CONFIG FILES AND LIST OF CONDITIONS
####################################################################################################################
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
TIME_HOUR=$(date +%H)
TIME_MIN=$(date +%M)
TIME_SEC=$(date +%S)
default="$1"
home_dir="$2" # home_dir=/home/user
dir_path="$3" # dir_path=/home/user/testAIDD 
ref_dir_path="$home_dir"/AIDD/references  # this is where references are stored
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
dirqc="$dir_path"/quality_control; # qc directory 
dirqcalign="$dirqc"/alignment_metrics
dirres="$dir_path"/Results; #
dirraw="$dir_path"/raw_data;
dirVC="$dirres"/variant_calling;
dirVCsubs="$dirVC"/substitutions;
summaryfile="$dir_path"/quality_control/alignment_metrics/all_summaryPF_READS_ALIGNED.csv
matrix_file="$dirres"/gene_count_matrix.csv; 
matrix_file2="$dirres"/transcript_count_matrix.csv; 
matrix_fileedit="$dirres"/gene_count_matrixedited.csv;
matrix_fileedit2="$dirres"/transcript_count_matrixedited.csv;
matrix_file3="$dirres"/"$level"ofinterest_count_matrix.csv;
matrix_file3a="$dirres"/geneofinterest_count_matrix.csv;
matrix_file3b="$dirres"/transcriptofinterest_count_matrix.csv;
matrix_file4="$dirres"/excitome_count_matrix.csv;
matrix_file5="$dirres"/genetrans_count_matrix.csv;
matrix_file6="$dirres"/GTEX_count_matrix.csv;
matrix_file7="$dirres"/nucleotide_count_matrix.csv; 
matrix_file8="$dirres"/amino_acid_count_matrix.csv;
matrix_file9="$dirres"/subs_count_matrix.csv;
matrix_file10="$dirres"/impact_count_matrix.csv;
matrix_file11="$dirres"/VEX_count_matrix.csv;
matrix_filefinal="$dirres"/all_count_matrix.csv;
data_summary_file1="$dirres"/geneofinterest/geneofinterestallsummaries.csv;
data_summary_file2="$dirres"/transcriptofinterest/transcriptofinterest.csv;
data_summary_file3="$dirres"/excitome/excitomeallsummaries.csv;
data_summary_file3a="$dirres"/GTEXallsummaries.csv;
data_summary_file4="$dirres"/nucleotide/nucleotideallsummaries.csv;
data_summary_file5="$dirres"/amino_acid/amino_acidallsummaries.csv;
data_summary_file6="$dirres"/impact/impactallsummaries.csv;
data_summary_file6a="$dirres"/VEXallsummaries.csv;
data_summary_filefinal="$dirres"/allsummaries.csv;
###############################################################################################################################################################
# CREATE DIRECTORIES                                                                                                                           *TESTED
###############################################################################################################################################################
echo1=$(echo "CREATING DIRECTORIES")
mes_out
new_dir="$dir_path"
create_dir # creates new directory to store results
if [ "$pheno" == "1" ];
then
  to_move="$home_dir"/Desktop/PHENO_DATA.csv
  file_move="$dir_path"/PHENO_DATA.csv
  get_file
  #sed -i 's/\r//g' "$dir_path"/PHENO_DATA.csv
fi
#if [[ "$pheno" == "2" && "$batchinstance" == "1" ]];
#then
#  get_PHENO
#fi
#if [[ "$pheno" == "2" && "$batchinstance" == "2" ]];
#then
#  get_PHENO
#  split_PHENO
#fi
for ndir in quality_control raw_data Results temp tmp working_directory ;
do
  new_dir="$dir_path"/"$ndir"
  create_dir # creates Results directory
done
new_dir="$dir_path"/quality_control # creates directories for quality control
create_dir
for ndir1 in alignment_metrics fastqc recalibration_plots insert_metrics logs filecheck filecheckVC ; 
do
  new_dir="$dir_path"/quality_control/"$ndir1" # creates directories for quality control
  create_dir
done
for ndir2 in ballgown ballgown_in bam_files counts snpEff vcf_files;
do
  new_dir="$dir_path"/raw_data/"$ndir2"
  create_dir
  if [[ "$ndir2" == ballgown || "$ndir2" == ballgown_in ]];
  then
    ball="$ndir2"
    assembly_dir_create
  fi
  if [ "$nd3" == vcf_files ];
  then
    for nd3 in final filtered raw ; 
    do
      new_dir="$dir_path"/raw_data/vcf_files/"$nd3"
      create_dir        
    done
  fi
done
new_dir="$dir_path"/AIDD # creates directory for scripts and config files
create_dir
if [ -d "$home_dir"/AIDD/AIDD ];
then
  cp -r "$home_dir"/AIDD/AIDD/* "$dir_path"/AIDD # get AIDD scripts with ExToolset
else
  new_dir="$dir_path"/AIDD/ExToolset
  create_dir
  cp -r "$home_dir"/ExToolset/* "$dir_path"/AIDD/ExToolset # get ExToolset scripts
fi
if [ "$index" == "1" ];
then
moveindexes  # MOVE AIDD INDEXES TO EXPERIMENT DIRECTORY
fi
###############################################################################################################################################################
# CREATE CONFIG FILES AND ADD CONDITION VARIABLES                                                                                              *TESTED
###############################################################################################################################################################
echo1=$(echo "CREATING CONFIG FILES")
mes_out
for config in config.cfg config.cfg.defaults config.R listofconditions.csv ;
do
  path="$dir_path"/AIDD/"$config"
  remove_stuff # get rid of existing config files
done
config_text # MAKES CONFIG TEXT
config_defaults # MAKE CONFIG DEFAULTS TEXT
file_in="$dir_path"/PHENO_DATA.csv
cat "$file_in" | sed 's/ //g' | sed '/^$/d' >> "$dir_path"/temp.csv
temp_file
cat "$dir_path"/PHENO_DATA.csv | awk 'NR==1' | sed 's/,/ /g' | sed "s/ /\n/g" | sed '1d' | sed '1d' | sed '2d' | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' | sed '/,$/{N;s/\n/ /}' >> "$dir_path"/AIDD/listofconditions.csv # creates list of conditions file 
cd "$dir_path"/AIDD
cat "$dir_path"/PHENO_DATA.csv | sed 's/_[0-9]*//g' >> "$dir_path"/PHENO_DATAtemp.csv
allcon=$(awk -F, 'NR==1{print $1}' "$dir_path"/PHENO_DATAtemp.csv)
nam="$allcon"
cat "$dir_path"/PHENO_DATAtemp.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f1 | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed '1i freq,name' >> "$dir_path"/"$nam".csv
file_in="$dir_path"/"$nam".csv
file_out="$dir_path"/"$nam".tiff
bartype=cond
tool=Rbar
run_tools
con_name1=$(awk -F, 'NR==1{print $3}' "$dir_path"/PHENO_DATA.csv)
coln=3
nam="$con_name1"
cond_file
con_name2=$(awk -F, 'NR==1{print $5}' "$dir_path"/PHENO_DATA.csv)
coln=5
nam="$con_name2"
cond_file
con_name3=$(awk -F, 'NR==1{print $6}' "$dir_path"/PHENO_DATA.csv)
coln=6
nam="$con_name3"
cond_file
make_cdef2
####################################################################################################################
#  GET FASTQ IF NOT DOWNLOADING FROM NCBI
####################################################################################################################
if [ "$sra" == 2 ]; # using local fastq files
then
  echo "dir_path="$home_dir"/$batch
fastq_dir_path="$home_dir"" >> "$dir_path"/AIDD/config.cfg # add special directory path to config file
  get_fastq
fi
####################################################################################################################
#  DOWNLOAD REFERENCES
####################################################################################################################
if [ "$ref" = 2 ];
then
  new_dir="$ref_dir_path"
  create_dir
  ref_files="$(ls -1 "$ref_dir_path" | wc -l)"
  if [ ! "$ref_files" == 0 ];
  then
    mv "$ref_dir_path" "$ref_dir_path"_old # THIS WILL STORY ANY OLD REFERENCES FOR LATER USE
    mkdir "$ref_dir_path"
  fi
  cd "$ref_dir_path"
####################################################################################################################
#  GRCh37.75
####################################################################################################################
  if  [ "$ref_set" == "1" ]; 
  then
    if [ "$aligner" == "1" ];
    then
      ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37_snp_tran.tar.gz
      set_ref=grch37_snp_tran
      HISAT_ref
    fi
    ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz # ref.fa
    ref_name=ref.fa
    downloaded_ref
    if [ "$miRNA" == "1" ];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz # ref.gtf
      ref_name=ref.gtf
      downloaded_ref
    fi
    if [ "$miRNA" == "2" ];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/genomes/hsa.gff3 # ref.gtf
      ref_name=ref.gtf
      downloaded_ref
    fi
    if [ "$miRNA" == "1" ];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "2" && "$miRNAtype" == "1" ]];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "2" && "$miRNAtype" == "2" ]];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "2" && "$miRNAtype" == "3" ]];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/mature.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
    ref_name=dbsnp.vcf
    downloaded_ref
    wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh37.75.zip/download
    gunzip download
    organize_ref
  fi
####################################################################################################################
#  GRCh38.92
####################################################################################################################
  if  [ "$ref_set" == "2" ]; then
    if [ "$aligner" == "1" ]; then
    ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38_snp_tran.tar.gz
    set_ref=grch38_snp_tran
    HISAT_ref
    fi
    ftpsite=ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz # ref.fa
    ref_name=ref.fa
    downloaded_ref
    ftpsite=ftp://ftp.ensembl.org/pub/release-84/gtf/homo_sapiens/Homo_sapiens.GRCh38.84.gtf.gz # ref.gtf
    ref_name=ref.gtf
    downloaded_ref 
    ftpsite=ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # ref1.fa
    ref_name=ref1.fa
    downloaded_ref
    ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
    ref_name=dbsnp.vcf
    downloaded_ref
    wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip
    gunzip download
    organize_ref
  fi
####################################################################################################################
#  hg19 FILL THESE IN
####################################################################################################################
  if  [ "$ref_set" == "3" ]; then
    ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/hg19.tar.gz
    set_ref=hg19
    HISAT_ref
    ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz # ref.fa
    ref_name=ref.fa
    downloaded_ref
    ftpsite=ftp://ftp.ensembl.org/pub/release-92/gtf/homo_sapiens/Homo_sapiens.GRCh38.92.gtf.gz # ref.gtf
    ref_name=ref.gtf
    downloaded_ref 
    ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # ref1.fa
    ref_name=ref1.fa
    downloaded_ref
    ftpsite=https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
    ref_name=
    downloaded_ref
    ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
    ref_name=dbsnp.vcf
    downloaded_ref
    organize_ref
  fi
####################################################################################################################
#  Mouse
####################################################################################################################
  if  [ "$human" == "2" ]; then
  ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grcm38_snp_tran.tar.gz
  set_ref=grcm38_snp_tran
  HISAT_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/mus_musculus/cdna/Mus_musculus.GRCm38.cdna.all.fa.gz # ref.fa
  ref_name=ref.fa
  downloaded_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/gtf/homo_sapiens/Homo_sapiens.GRCh38.92.gtf.gz # ref.gtf
  com_ref=Homo_sapiens.GRCh38.92.gtf
  ref_name=ref.gtf
  downloaded_ref 
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz # ref1.fa
  ref_name=ref1.fa
  downloaded_ref
  ftpsite=https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  com_ref=download
  downloaded_ref
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  com_ref=dbsnp_138.hg38.vcf
  downloaded_ref
  organize_ref
  fi
####################################################################################################################
#  Rat
####################################################################################################################
  if  [ "$human" == "3" ]; then
  ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/rn6.tar.gz
  set_ref=rn6
  HISAT_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/rattus_norvegicus/cdna/Rattus_norvegicus.Rnor_6.0.cdna.all.fa.gz # ref.fa
  ref_name=ref.fa
  downloaded_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/gtf/mus_musculus/Mus_musculus.GRCm38.92.gtf.gz # ref.gtf
  ref_name=ref.gtf
  downloaded_ref 
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz # ref1.fa
  ref_name=ref1.fa
  downloaded_ref
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  downloaded_ref
  wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  gunzip download
  organize_ref
  fi
####################################################################################################################
#  STAR References
####################################################################################################################
  if [ "$aligner" == "2" ];
  then
    star --runMode genomeGenerate --genomeDir "$ref_dir_path"/ --genomeFastaFiles "$ref_dir_path"/ref1.fa --sjdbGTFfile "$ref_dir_path"/ref.gtf
  fi
####################################################################################################################
#  Bowtie2 Build References
####################################################################################################################
  if [ "$aligner" == "3" ];
  then
    bowtie2-build [options]* "$ref_dir_path"/ref1.fa "$ref_dir_path"/genome
  fi
fi
####################################################################################################################
#  Run AIDD
####################################################################################################################
cd "$dir_path"/AIDD
bash "$dir_path"/AIDD/AIDDpipeline.sh # runs AIDD pipeline
  
