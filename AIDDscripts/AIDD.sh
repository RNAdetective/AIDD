####################################################################################################################
####################################################################################################################
####################################################################################################################
# this sets up variables for options
####################################################################################################################
####################################################################################################################
####################################################################################################################
echo "Please see the manual for set up and instructions to run AIDD.  Make sure before you start you have created the auto mount shared folder called AIDD on your host computer and completed the directions on the desktop. Please follow the prompts to fill in the details for your experiment."
echo "would you like to run with defaults?  This includes downloading files from sra, paired end read datasets, HISAT2 aligner and running with variant calling on a computer with shared folder set up and not downloading the references file if you would like to run defaults type 1=yes, or 2=no if you need to change any of these settings"
read default
if [ "$default" == 2 ]; #this allows for download of sequences or starting with your own .fastq files 
then
  echo "What is your working directory?"
  read sup_dir
  echo "What is your home directory?"
  read home_dir
  echo "Are you downloading sequences from NCBI 1=(default)yes 2=no" # download sequences
  read sra
  if [ "$sra" == 2 ]; # if no downloads
  then
    echo "Please enter the directory where the fastq files are located. For example /media/sf_files/ if you have shared the folder from your main computer or if you are on an instance "$home_dir"/folderwithfiles/"
    read fastq_dir_path # where to find fastq files
  fi
  echo "Are you using a shared folder? 1=(default)yes 2=no(instance)" # shared folder or folder AIDD on the main users home directory.
  read instance
  echo "Do you need to run AIDD once? 1=(default)yes 2=no(batch instance)" # do you need to download a pheno_data file
  read instancebatch
  if [ "$instancebatch" == "2" ];
  then
    echo "Which batch are you using?"
    read batch #which batch are you running
  fi
  echo "Do you have references already downloaded? 1=(default)yes 2=no" # do you want to download references now
  read ref
  if [ "$ref" == 2 ];
  then
    echo "Do you have bulk human data? 1=(default)yes 2=no(mouse)" # human or mouse data
    read human
    echo "Please choose a build to download and prepare reference files for the whole pipeline. 1=GRCh37, 2=GRCh38, none=if you already have references saved from previous experiment" # which build for ref
    read ref_set
  fi
  echo "Do you have bulk RNAseq data? 1=(default)yes 2=no (single cell)" # do you have bulk or single reads
  read scRNA
  echo "Do you have mRNA data? 1=(default)yes 2=no (miRNA)" # mRNA or miRNA data
  read miRNA
  echo "Please enter library layout type: 1=(default)paired or 2=single" # this allows for selection between paired and single end data
  read library
  echo "Which aligner would you like to use? 1=(default)HISAT2, 2=STAR, 3=BOWTIE2" # which alignment tool
  read aligner 
  echo "Which aligner would you like to use? 1=(default)stringtie, 2=cufflinks" # which assembly tool
  read assembler 
  echo "Would you like to do variant calling for RNAediting prediction at this time? 1=(default)yes 2=no" # run variant calling
  read variant
  echo "Do you have your PHENO_DATA already downloaded? 1=(default)yes 2=no" # do you want to download your pheno_data file
  read pheno
  echo "Do you want to start at the beginning or do you want to start with variant calling? 1=(default)beginning 2=variant calling I already have bam files present" # do you need to download bam files
  read bamfile
else
sra=$"1";
library=$"1";
aligner=$"1";
assembler=$"1";
variant=$"1";
instance=$"1";
instancebatch=$"1";
ref=$"1";
pheno=$"1";
bamfile=$"1";
human=$"1";
ref_set=$"1";
scRNA=$"1";
miRNA=$"1";
dir_path=/media/sf_AIDD;
home_dir=/home/user;
fi
####################################################################################################################
####################################################################################################################
####################################################################################################################
#THIS DEFINES FUNCTIONS 
####################################################################################################################
####################################################################################################################
####################################################################################################################
move_PHENO() { 
cp "$home_dir"/Desktop/PHENO_DATA.csv "$dir_path"/PHENO_DATA.csv 
}
get_PHENO() { 
cd "$dir_path"
wget https://github.com/RNAdetective/AIDD/raw/master/batches/PHENO_DATAwhole.csv
cd "$home_dir"/AIDD/AIDD 
}
create_pd() {
for i in raw_data Results quality_control working_directory AIDD tmp temp ; 
do
  mkdir "$dir_path"/$i/ # makes directories
done
}
moveAIDD() { 
  cp -r "$home_dir"/AIDD/AIDD/* "$dir_path"/AIDD/
}
moveindexes() {
for i in gene transcript ; 
do
  for j in insert_"$i"_of_interest insert_"$i"_lists_for_pathways ;
  do
    if [ ! "$(ls -A )" "$home_dir"/Desktop/$empty_dir/* ];
    then
      if [ "$j" == insert_"$i"_of_interest ];
      then
        cp "$home_dir"/Desktop/"$j"/* "$dir_path"/indexes/"$i"_list/DESeq2/ # moves experimental gene/transcript list from the desktop to the correct index folder to be used for building own on the fly indexes for GEX and TEX tools
      else
        cp "$home_dir"/Desktop/"$j"/* "$dir_path"/indexes/"$i"_list/pathway/
      fi
    else
      echo "No indexes to move"
    fi
  done
done
}
downloadindex() {
for i in gene transcript ; 
  do
    cd "$dir_path"/indexes/"$i"_list/DESeq2/ # moves experimental gene/transcript list from the desktop to the correct index folder to be used for building own on the fly indexes for GEX and TEX tools
    wget https:/github.com/RNAdetective/AIDD/raw/master/insert_"$i"_of_interest/*
    cd "$dir_path"/indexes/"$i"_list/pathway/
    wget https:/github.com/RNAdetective/AIDD/raw/master/insert_"$i"_lists_for_pathways/*
  done
  wget https://github.com/RNAdetective/AIDDinstance/raw/master/batches/PHENO_DATA"$batch".csv
  cp "$home_dir"/PHENO_DATA"$batch".csv "$dir_path"/PHENO_DATA.csv
}
remove_file() {
  if [ -f $dir_to_remove ]; # CONFIG.CFG IF IT IS THERE
    then
      rm $dir_to_remove # DELETE
  fi
}
config_text() {
    echo "sra=$sra
library=$library
aligner=$aligner
assembler=$assembler
variant=$variant
instance=$instance
instancebatch=$batch
batch=$batchnumber
ref=$ref
pheno=$pheno
bamfile=$bamfile
human=$human
ref_set=$ref_set
scRNA=$scRNA
miRNA=$miRNA
dir_path=$dir_path
" >> "$home_dir"/AIDD/AIDD/config.cfg
}
config_R() {
echo "batch <- "$batch"
miRNA <- "$miRNA"
scRNA <- "$scRNA"
dir_path <- "$dir_path"
" >> "$home_dir"/AIDD/AIDD/config.R
}
config_text_dir() {
if [ "$instance" == 1 ]; then
echo "ref_dir_path="$dir_path"/references" >> "$home_dir"/AIDD/AIDD/config.cfg
fi
if [ "$instance" == 2 ]; then
echo "ref_dir_path=$ref_dir_path
home_dir=$home_dir
sup_dir=$sup_dir" >> "$home_dir"/AIDD/AIDD/config.cfg
fi
}
config_defaults() {
echo "sra=Default Value
library=Default Value
aligner=Default Value
assembler=Default Value
variant=Default Value
instance=Default Value
ref=Default Value
pheno=Default Value 
bamfile=Default Value
scRNA=Default Value
human=Default Value
miRNA=Default Value
ref_dir_path=Default Value
dir_path=Default Value
fastq_dir_path=Default Value" >> "$home_dir"/AIDD/AIDD/config.cfg.defaults
}
listcon() {
cat "$dir_path"/PHENO_DATA.csv | awk 'NR==1' | sed 's/,/ /g' | sed "s/ /\n/g" | sed '1d' | sed '1d' | sed '2d' | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' >> "$home_dir"/AIDD/AIDD/listofconditions.csv # this will create
}
makeconfig() {
  INPUT="$home_dir"/AIDD/AIDD/listofconditions.csv
  OLDIFS=$IFS
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  while IFS=, read condition number column 
  do
  echo "con_name$number=$condition" >> "$home_dir"/AIDD/AIDD/config.cfg.defaults
  echo "con_name$number -> $condition" >> "$home_dir"/AIDD/AIDD/config.R
  done
  } < $INPUT
  IFS=$OLDIFS #This will add directory specific information to config files 
}
checkconfig() {
file1=config.cfg
for config in config.cfg config.cfg.defaults config.R listofconditions.csv ;
do
  path_to1="$home_dir"/AIDD/AIDD
  path_to2="$dir_path"/AIDD
  path_to3="$dir_path"
  for path_to in $path_to1 $path_to2 $path_to3 ;
  do
    if [ -f "$path_to"/"$config" ];
    then
      rm -f "$path_to"/"$config"
    fi
  done
done 
}
con_file_create() {
cat "$dir_path"/PHENO_DATA.csv | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f$column_num | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' > $dir_to_condition
}
add_var_list() { 
echo "con_name"$con_number"="$con_name1"AND"$con_name2""  >> "$dir_path"/AIDD/config.cfg.defaults
}
add_var_list2() { 
echo "con_name"$con_number"="$con_name1"AND"$con_name3""  >> "$dir_path"/AIDD/config.cfg.defaults
}
add_var_list3() { 
echo "con_name"$con_number"="$con_name2"AND"$con_name3""  >> "$dir_path"/AIDD/config.cfg.defaults
}
add_con_list1() { 
echo "$con_name1"AND"$con_name2"",3,0"  >> "$dir_path"/listofconditions.csv
}
add_con_list2() { 
echo "$con_name1"AND"$con_name3"",4,0"  >> "$dir_path"/listofconditions.csv
}
add_con_list3() { 
echo "$con_name2"AND"$con_name3"",5,0"  >> "$dir_path"/listofconditions.csv
}
onesub_dir_create() { 
    sub_directory=$i
    mkdir "$dir_path"/$parent_directory/$sub_directory/
}
assembly_dir_create() {
INPUT="$dir_path"/PHENO_DATA.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run codition sample condition2 condition3
do
    mkdir "$dir_path"/raw_data/$ball/$sample/
done
rm -rf "$dir_path"/raw_data/$ball/sample/
} < $INPUT
IFS=$OLDIFS
}
twosub_dir_create() { 
    sub_directory=$i
    mkdir "$dir_path"/$parent_directory/$sub_directory/$sub_directory2/
}
threesub_dir_create() {
  sub_directory="$i"
  sub_directory3="$j"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/
}
foursub_dir_create() {
  sub_directory="$i"
  sub_directory3="$j"
  sub_directory4="$k"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/"$sub_directory4"/
}
fivesub_dir_create() {
    sub_directory="$i"
    sub_directory3="$j"
    sub_directory4="$k"
    sub_directory5="$l"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/"$sub_directory4"/"$sub_directory5"/
}
sixsub_dir_create() {
  sub_directory="$i"
  sub_directory3="$j"
  sub_directory4="$k"
  sub_directory5="$l"
  sub_directory6="$m"
  mkdir ""$dir_path""/"$parent_directory"/"$sub_directory"/"$sub_directory2"/"$sub_directory3"/"$sub_directory4"/"$sub_directory5"/"$sub_directory6"/
}
split_PHENO() {
mkdir "$dir_path"/splitfile/
PHENO="$dir_path"/PHENO_DATAwhole.csv
csvheader=`head -n 1 "$PHENO"`
split -d -l4 "$PHENO" "$dir_path"/splitfile/PHENO_DATAbatch
for f in "$dir_path"/splitfile/* ;
do
  cat $f | sed 1i"$csvheader" >> $f.csv
  rm -f $f
done
sed -i '1d' "$dir_path"/splitfile/PHENO_DATAbatch00.csv
mv $dir_path/splitfile/PHENO_DATA"$batch".csv "$dir_path"/PHENO_DATA.csv
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
    java -jar /home/user/AIDD/AIDD_tools/picard.jar CreateSequenceDictionary REFERENCE="$ref_dir_path"/ref2.fa OUTPUT="$ref_dir_path"/ref2.dict
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
####################################################################################################################
####################################################################################################################
# SET UP VARIABLE LIBRARY
####################################################################################################################
####################################################################################################################
####################################################################################################################
if [ "$instance" == 1 ] ; # SHARED FOLDER
then
  dir_path=/media/sf_AIDD
  home_dir=/home/user
    create_pd
    move_PHENO
    moveAIDD
    checkconfig
  if [ ! "$(ls -A )" ];
  then
    moveindexes  # MOVE AIDD INDEXES TO EXPERIMENT DIRECTORY
  else
      echo "NO INDEX FILES TO MOVE"
  fi
fi
if [ "$instance" == 2 ] ; # HOME DIRECTORY FOLDER
then
  dir_path="$sup_dir"/"$batch"
  home_dir="$home_dir"
  ref_dir_path="$home_dir"/AIDD/references
  mkdir "$ref_dir_path"
  mkdir "$dir_path"
  create_pd
  get_PHENO
  split_PHENO
  moveAIDD # MOVE AIDD SCRIPTS TO EXPERIMENT DIRECTORY
  checkconfig
  if [ "$indexes" == 2 ]; # HOME DIRECTORY FOLDER ADD IN OPTION IN BEG #######indexes 1=yes 2=no (means download them) FOR DOWNLOAD INDEXES
  then
    downloadindex
  fi 
fi
config_text # MAKES CONFIG TEXT
config_R # MAKES R CONIG FILE
config_text_dir # ADD DIRECTORY TO CONFIG
config_defaults # MAKE CONFIG DEFAULTS TEXT
listcon # MAKES LISTS OF CONDITIONS FILE
makeconfig # MAKES CONFIG FILES
cp "$home_dir"/AIDD/AIDD/config.cfg ""$dir_path""/AIDD/
cp "$home_dir"/AIDD/AIDD/config.cfg.defaults ""$dir_path""/AIDD/
cp "$home_dir"/AIDD/AIDD/listofconditions.csv ""$dir_path""/
cp "$home_dir"/AIDD/AIDD/config.R ""$dir_path""/
############################################################################
####################################################################################################################
##############################Need to add option to move fastq files add fastq_dir_path#############################
####################################################################################################################
####################################################################################################################
#  if [ "$sra" == 2 ]; # using local fastq files
#  then
#    echo "dir_path="$home_dir"/$batch
#fastq_dir_path="$home_dir"" >> "$dir_path"/AIDD/config.cfg # add special directory path to config file
#  fi
####################################################################################################################
####################################################################################################################
####################################################################################################################
####################################################################################################################
####################################################################################################################
cd "$home_dir"/AIDD/AIDD
source config.shlib; # load the config library functions
INPUT="$dir_path"/listofconditions.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while IFS=, read condition number column
do
  con_name1=$(awk -F, 'NR==1{print $3}' "$dir_path"/PHENO_DATA.csv)
  con_name2=$(awk -F, 'NR==1{print $5}' "$dir_path"/PHENO_DATA.csv)
  con_name3=$(awk -F, 'NR==1{print $6}' "$dir_path"/PHENO_DATA.csv)
  con_name4=$(awk -F, 'NR==1{print $7}' "$dir_path"/PHENO_DATA.csv)
  column_num="$column"
  if [ "$column" == 3 ];
  then
    dir_to_condition="$dir_path"/$condition.csv
    column_num="$column"
    con_file_create
  fi
  if [ "$column" == 4 ];
  then
    dir_to_condition="$dir_path"/$condition.csv
    con_file_create
    dir_to_condition="$dir_path"/"$con_name1"AND"$con_name2"
    column_num=3,4
    con_number="$column"
    con_file_create
    add_var_list
    add_con_list1
  fi
  if [ "$column" == 5 ];
  then
    dir_to_condition="$dir_path"/$condition.csv
    con_file_create
    dir_to_condition="$dir_path"/"$con_name1"AND"$con_name3"
    column_num=3,5
    con_number="$column"
    con_file_create
    add_var_list2
    add_var_list3
    add_con_list2
    add_con_list3
  fi
done
} < $INPUT
IFS=$OLDIFS
####################################################################################################################
####################################################################################################################
####################################################################################################################
# CREATES SUB DIRECTORIES TO AIDD PARENT DIRECTORIES ALREADY CREATED
####################################################################################################################
####################################################################################################################
####################################################################################################################
condition=condition # THIS WILL BE FROM PHENO_DATA FILE
if [ ! -d "$dir_path"/Results/variant_calling/$condition/gene/impact/high_impact/ ];
then
  for pd in raw_data quality_control Results ;
  do
    parent_directory=$pd
    if [ "$pd" == raw_data ];
    then
      for i in counts ballgown ballgown_in bam_files snpEff vcf_files ; 
      do
        onesub_dir_create
        ball="$i"
        if [[ "$i" == ballgown || "$i" == ballgown_in ]];
        then
          assembly_dir_create
        fi
        if [ "$i" == vcf_files ];
        then
          for k in final filtered raw ; 
          do
            sub_directory2="$k"
            twosub_dir_create
          done
        fi
      done
    fi
    if [ "$pd" == quality_control ];
    then
      for i in alignment_metrics fastqc recalibration_plots insert_metrics logs filecheck filecheckVC ; 
      do
       onesub_dir_create
      done
    fi
    if [ "$pd" == Results ];
    then
      for i in DESeq2 topGO pathway variant_calling ; 
      do
        onesub_dir_create
        INPUT="$dir_path"/listofconditions.csv
        IFS=$OLDIFS
        {
        [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
        while IFS=, read condition number column
        do
          sub_directory2="$condition"
          twosub_dir_create
          for j in gene transcript ;
          do
            threesub_dir_create
            if [ "$i" = DESeq2 ]; 
            then
              for k in calibration counts differential_expression PCA ;
              do
                foursub_dir_create
                if [ "$k" == differential_expression ];
                then
                  for l in excitome geneofinterest venndiagram ;
                  do
                    fivesub_dir_create
                  done
                fi
              done
            fi
            if [ "$i" = pathway ]; 
            then
              for k in heatmaps tables volcano ;
              do
                foursub_dir_create
              done
            fi
            if [ "$i" = variant_calling ]; 
            then
              for k in amino_acid impact nucleotide substitutions ;
              do
                foursub_dir_create
                if [ "$k" == impact ];
                then
                  for l in high_impact moderate_impact ;
                  do 
                    fivesub_dir_create
                    for m in con_var1 con_var2  ;
                    do
                      sixsub_dir_create
                    done
                  done
                fi
              done
            fi
          done
        done
        } < $INPUT
        IFS=$OLDIFS
      done
    fi
  done
fi
####################################################################################################################
#  DOWNLOAD REFERENCES
####################################################################################################################
if [ "$ref" = 2 ];
then
  ref_files="$(ls -1 "$ref_dir_path" | wc -l)"
  if [ ! "$ref_files" == 0 ];
  then
    mv "$ref_dir_path" "$ref_dir_path"_old
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
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "2" && "$miRNAtype" == "2" ]];
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
  ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38_snp_tran.tar.gz
  set_ref=grch38_snp_tran
  HISAT_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz # ref.fa
  ref_name=ref.fa
  download_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/gtf/homo_sapiens/Homo_sapiens.GRCh38.92.gtf.gz # ref.gtf
  ref_name=ref.gtf
  download_ref 
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # ref1.fa
  ref_name=ref1.fa
  download_ref
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  download_ref
  wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip
 # snpEff
  gunzip download
  organize_ref
  fi
####################################################################################################################
#  hg19 FILL THESE IN
####################################################################################################################
  if  [ "$ref_set" == "2" ]; then
  ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/hg19.tar.gz
  set_ref=hg19
  HISAT_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz # ref.fa
  ref_name=ref.fa
  download_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/gtf/homo_sapiens/Homo_sapiens.GRCh38.92.gtf.gz # ref.gtf
  ref_name=ref.gtf
  download_ref 
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # ref1.fa
  ref_name=ref1.fa
  download_ref
  ftpsite=https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  ref_name=
  download_ref
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  download_ref
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
  download_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/gtf/homo_sapiens/Homo_sapiens.GRCh38.92.gtf.gz # ref.gtf
  com_ref=Homo_sapiens.GRCh38.92.gtf
  ref_name=ref.gtf
  download_ref 
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz # ref1.fa
  ref_name=ref1.fa
  download_ref
  ftpsite=https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  com_ref=download
  download_ref
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  com_ref=dbsnp_138.hg38.vcf
  download_ref
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
  download_ref
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/gtf/mus_musculus/Mus_musculus.GRCm38.92.gtf.gz # ref.gtf
  ref_name=ref.gtf
  download_ref 
  ftpsite=ftp://ftp.ensembl.org/pub/release-92/fasta/rattus_norvegicus/dna/Rattus_norvegicus.Rnor_6.0.dna.toplevel.fa.gz # ref1.fa
  ref_name=ref1.fa
  download_ref
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  download_ref
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
fi
####################################################################################################################
#  Run AIDD
####################################################################################################################
if [ "$instance" == 1 ];
then
  dir_path="$dir_path"
  cd "$home_dir"/AIDD/AIDD
  bash "$dir_path"/AIDD/scripts/AIDDpipeline.sh # runs AIDD pipeline
fi
if [ "$instance" == 2 ];
then
  dir_path="$dir_path"
  cd "$home_dir"/AIDD/AIDD
  bash "$dir_path"/AIDD/scripts/AIDDpipeline.sh
fi
  
