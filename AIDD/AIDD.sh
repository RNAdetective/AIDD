#!/usr/bin/env bash
####################################################################################################################
# this sets up variables for options
####################################################################################################################
home_dir="$1" # home directory is second space
dir_path="$2" # working directory is third space
echo "Please see the manual for set up and instructions to run AIDD.  Make sure before you start you have created the auto mount shared folder called AIDD on your host computer and completed the directions on the desktop. Would you like to run AIDD with defaults? Please select from the following: (note default = runs AIDD with all default setting from start to finish; options = prompts user to select from various tool and dataset options; diretories = to run just the AIDD file setup and not run the rest of AIDD at this time; AIDDparts to run AIDD from a certain part of the pipeline."
echo "default, options, directories or AIDDparts"
read AIDD
if [ "$AIDD" != "default" ]; #this allows for download of sequences or starting with your own .fastq files 
then
  echo "Do you need to download sequences from NCBI? Please choose from the following:"
  echo "yes or no" # download sequences
  read sra
  if [ "$sra" == "no" ]; # if no downloads
  then
    echo "Please enter the directory where the fastq files are located. Please make sure these are files have the correct naming format SRRXXXXXXX_1.fastq more details can be found in the manual"
    read fastq_dir_path # where to find fastq files
  fi  
  echo "Would you like to save intermediate sra files? Please choose from the following:"
  echo "yes or no" # save sra files
  read savesra
  echo "Would you like to save intermediate fastq files? Please choose from the following:"
  echo "yes or no" # save fastq files
  read savefastq
  #echo "Do you have bulk RNAseq data or single cell RNAseq data? Please choose from the following:"
  #echo "bulk single" # do you have bulk or single reads
  #read scRNA 
  #echo "Do you have standard mRNA library prep selecting for poly-A tails (mRNA) or microRNA library prep (miRNA)? Please choose one of the following:"
  #echo "mRNA or miRNA" # mRNA or miRNA data
  #read miRNA
  if [ "$miRNA" == "miRNA" ];
  then
    echo "Would you like to align to whole genome, just hairpin miRNA or just the mature miRNA? Please choose one of the following:"
echo "whole, hairpin or mature"
    read miRNAtype
  fi
  echo "Please enter library layout type. Please choose one of the following:"
  echo "paired or single" # this allows for selection between paired and single end data
  read library
  echo "Which aligner would you like to use? Please choose one of the following: (note that if you are using STAR or BOWTIE2 you need to make sure you download the correct reference sets before you run AIDD by double clicking on the AIDDrefset icon on the desktop."
echo "HISAT2, STAR or BOWTIE2" # which alignment tool
  read aligner 
  echo "Which assembler would you like to use? Please choose one of the following: (note that if you are using HISAT2 stringtie is suggested and with STAR and BOWTIE2 cufflinks is recommended)"
  echo "stringtie or cufflinks" # which assembly tool
  read assembler 
  echo "Which organism are you using?"
  read human
else
  sra=$"yes";
  scRNA=$"bulk";
  miRNA=$"mRNA";
  miRNAtype=$"whole";
  library=$"paired";
  aligner=$"HISAT2";
  assembler=$"stringtie";
  savesra=$"no";
  savefastq=$"no";
  bamvcf=$"yes";
  human=$"human";
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
con_name3=$con_name3
con_name4="$con_name4"" >> "$dir_path"/AIDD/config.cfg.defaults
} # adds conditions to config files
copy_file() {
cp "$home_dir"/Desktop/"$j"/* "$dir_path"/indexes/"$i"_list/"$dp"/ # moves experimental gene/transcript list from the desktop to the correct index folder to be used for building own on the fly indexes for GEX and TEX tools
}
config_text() {
echo "home_dir=$home_dir
dir_path=$dir_path
sra="$sra"
scRNA="$scRNA"
miRNA="$mRNA"
miRNAtype="$miRNAtype"
library="$library"
aligner="$aligner"
assembler="$stringtie"
savesra="$savesra"
savefastq="$savefastq"
human="$human"
bamvcf="$bamvcf"
DATE_WITH_TIME="$DATE_WITH_TIME"
TIME_HOUR="$TIME_HOUR"
TIME_MIN="$TIME_MIN"
TIME_SEC="$TIME_SEC"" >> "$dir_path"/AIDD/config.cfg
}
config_defaults() {
echo "home_dir=Default Value
dir_path=Default Value
sra=Default Value;
scRNA=Default Value;
miRNA=Default Value;
miRNAtype=Default Value;
library=Default Value;
aligner=Default Value;
assembler=Default Value;
savesra=Default Value;
savefastq=Default Value;
human=Default Value;
bamvcf=Default Value" >> "$dir_path"/AIDD/config.cfg.defaults
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
home_dir="$1" # home_dir=/home/user
dir_path="$2" # dir_path=/home/user/testAIDD 
ref_dir_path="$home_dir"/AIDD/references  # this is where references are stored
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
dirres="$dir_path"/Results; #
dirraw="$dir_path"/raw_data;
dirVC="$dirres"/variant_calling;
dirVCsubs="$dirVC"/substitutions;
new_dir="$dir_path"
create_dir
qc_dir="$dir_path"/quality_control
new_dir="$qc_dir"
create_dir
LOG_LOCATION="$dir_path"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/AIDDpipeline.log)
exec 2>&1

echo "Log Location will be: [ $LOG_LOCATION ]"
###############################################################################################################################################################
# CREATE DIRECTORIES                                                                                                                           *TESTED
###############################################################################################################################################################
echo1=$(echo "CREATING DIRECTORIES")
mes_out
new_dir="$dir_path"
create_dir # creates new directory to store results
if [ ! -f "$dir_path"/PHENO_DATA.csv ];
then
  to_move="$home_dir"/Desktop/PHENO_DATA.csv
  file_move="$dir_path"/PHENO_DATA.csv
  get_file
  #sed -i 's/\r//g' "$dir_path"/PHENO_DATA.csv
fi
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
  #if [[ "$ndir2" == ballgown || "$ndir2" == ballgown_in ]];
  #then
  #  ball="$ndir2"
  #  assembly_dir_create
  #fi
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
cond_file
make_cdef2
####################################################################################################################
#  Run AIDD
####################################################################################################################
if [[ "$AIDD" != "directories" || "$AIDD" != "AIDDparts" ]];
then
  cd "$dir_path"/AIDD
  bash "$dir_path"/AIDD/AIDDpipeline.sh # runs AIDD pipeline
fi  
if [ "$AIDD" == "AIDDparts" ];
then
  bash "$home_dir"/AIDD/AIDD/AIDDparts.sh
fi
