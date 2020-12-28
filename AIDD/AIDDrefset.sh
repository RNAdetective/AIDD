#!/usr/bin/env bash
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
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
ensembl_refset() {
ftpsite=ftp://ftp.ensembl.org/pub/release-${ENSEMBL_RELEASE}/fasta/${ENSEMBL_ORGANISM}/cdna/${ENSEMBL_ORG_FILE_NAME}.cdna.all.fa.gz # ref.fa
ref_name=ref.fa
downloaded_ref
ftpsite=ftp://ftp.ensembl.org/pub/release-${ENSEMBL_RELEASE}/gtf/${ENSEMBL_ORGANISM}/${ENSEMBL_ORG_FILE_NAME}.${ENSEMBL_RELEASE}.gtf.gz # ref.gtf
ref_name=ref.gtf
downloaded_ref 
ftpsite=ftp://ftp.ensembl.org/pub/release-${ENSEMBL_RELEASE}/fasta/${ENSEMBL_ORGANISM}/dna/${ENSEMBL_ORG_FILE_NAME}.dna.primary_assembly.fa.gz # ref1.fa
ref_name=ref1.fa
downloaded_ref
}
home_dir="$1"
dir_path="$2"
new_dir="$dir_path"
create_dir
LOG_LOCATION="$dir_path"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/AIDDRefSet.log)
exec 2>&1

echo "Log Location will be: [ $LOG_LOCATION ]"
ref_dir_path="$home_dir"/AIDD/references
ref_dir_old="$dir_path"/oldreferences
echo "Would you like to download references at this time? Please respond yes or no" # do you want to download references now
read ref
echo "Which aligner will you be using? Please select one of the following: (HISAT2 is recommended option)"
echo "HISAT2, STAR or BOWTIE"
read aligner
echo "Do you have poly-A tail prepped mRNA or are you using miRNA? Please choose one of the following:"
echo "mRNA or miRNA"
read miRNA
if [ "$miRNA" == "miRNA" ];
then
  echo "Which reference set would you like to align your miRNA whole=entire genome hairpin=just miRNA hairpin loops or mature=only mature miRNA sequences? Please choose one of the following:" 
  echo "whole, hairpin or mature"
  read miRNAtype
fi
if [ "$ref" == "yes" ];
then
  echo "Which organism would you like to use? Please respond with one of the following choices:"
  echo "human, mouse, rat, worm, fly or yeast" # human or mouse data
  read organism
  if [ "$organism" == "human" ];
  then
    echo "Please choose a build to download and prepare reference files for the whole pipeline. Please respond with one of the following:"
echo "GRCh37 or GRCh38" # which build for ref
    read ref_set
  fi
fi
####################################################################################################################
#  MOVES CURRENT REFERENCES TO A NEW FOLDER TO GET READY TO DOWNLOAD NEW ONES
####################################################################################################################
if [ "$ref" == "yes" ];
then
  new_dir="$ref_dir_path"
  create_dir
  new_dir="$ref_dir_old"
  create_dir
  ref_files="$(ls -1 "$ref_dir_path" | wc -l)"
  if [ ! "$ref_files" == "0" ];
  then
    echo "Now copying old references to a new directory in your shared folder to save them for later use"
    cp -r "$ref_dir_path" "$ref_dir_old" # THIS WILL STORY ANY OLD REFERENCES FOR LATER USE
  fi
  oldref_files="$(ls -1 "$ref_dir_old" | wc -l)"
  if [ ! "$oldref_files" == "0" ];
  then
    rm -r "$ref_dir_path"
    new_dir="$ref_dir_path"
    create_dir
  fi
  cd "$ref_dir_path"
####################################################################################################################
#  GRCh37.75
####################################################################################################################
  if [[ "$organism" == "human" && "$ref_set" == "GRCh37" ]]; 
  then
    if [ "$aligner" == "HISAT2" ];
    then
      ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37_snp_tran.tar.gz
      set_ref=grch37_snp_tran
      HISAT_ref
    fi
    ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz # ref.fa
    ref_name=ref.fa
    downloaded_ref
    if [ "$miRNA" == "mRNA" ];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz # ref.gtf
      ref_name=ref.gtf
      downloaded_ref
    fi
    if [ "$miRNA" == "miRNA" ];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/genomes/hsa.gff3 # ref.gtf
      ref_name=ref.gtf
      downloaded_ref
    fi
    if [ "$miRNA" == "mRNA" ];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "miRNA" && "$miRNAtype" == "whole" ]];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "miRNA" && "$miRNAtype" == "hairpin" ]];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "miRNA" && "$miRNAtype" == "mature" ]];
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
  if [[ "$organism" == "human" && "$ref_set" == "GRCh38" ]]; 
  then
    if [ "$aligner" == "1" ]; then
    ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38_snp_tran.tar.gz
    set_ref=grch38_snp_tran
    HISAT_ref
    fi
    ftpsite=ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz # ref.fa
    ref_name=ref.fa
    downloaded_ref
    if [ "$miRNA" == "mRNA" ];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-84/gtf/homo_sapiens/Homo_sapiens.GRCh38.84.gtf.gz # ref.gtf
      ref_name=ref.gtf
      downloaded_ref
    fi
    if [ "$miRNA" == "miRNA" ];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/genomes/hsa.gff3 # ref.gtf
      ref_name=ref.gtf
      downloaded_ref
    fi
    if [ "$miRNA" == "mRNA" ];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "miRNA" && "$miRNAtype" == "whole" ]];
    then
      ftpsite=ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "miRNA" && "$miRNAtype" == "hairpin" ]];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/hairpin.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    if [[ "$miRNA" == "miRNA" && "$miRNAtype" == "mature" ]];
    then
      ftpsite=ftp://mirbase.org/pub/mirbase/CURRENT/mature.fa.gz # ref1.fa
      ref_name=ref1.fa
      downloaded_ref
    fi
    ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
    ref_name=dbsnp.vcf
    downloaded_ref
    wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip/download
    gunzip download
    organize_ref
  fi
####################################################################################################################
#  Mouse
####################################################################################################################
  if  [ "$organism" == "mouse" ];
  then
    if [ "$aligner" == "HISAT2" ];
    then
      ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grcm38_snp_tran.tar.gz
      set_ref=grcm38_snp_tran
      HISAT_ref
    fi
    ENSEMBL_RELEASE=82
    ENSEMBL_ORGANISM=mus_musculus
    ENSEMBL_ORG_FILE_NAME=Mus_musculus.GRCm38
    ensembl_refset
    organize_ref
    ftpsite=https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCm38.82.zip/download # snpEff
    com_ref=download
    downloaded_ref
    ftpsite=ftp://ftp-mouse.sanger.ac.uk/current_snps/mgp.v5.merged.snps_all.dbSNP142.vcf.gz # dpsnp.vcf
    com_ref=dbsnp.vcf
    downloaded_ref
    organize_ref
  fi
####################################################################################################################
#  Rat
####################################################################################################################
  if  [ "$organism" == "rat" ];
  then
  if [ "$aligner" == "HISAT2" ];
  then
    ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/rnor6.tar.gz
    set_ref=rnor6
    HISAT_ref
  fi
  ENSEMBL_RELEASE=84
  ENSEMBL_ORGANISM=rattus_norvegicus
  ENSEMBL_ORG_FILE_NAME=Rattus_norvegicus.Rnor_6.0
  ensembl_refset
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  downloaded_ref
  wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  gunzip download
  organize_ref
  fi
####################################################################################################################
#  C. elegans
####################################################################################################################
  if  [ "$organism" == "worm" ];
  then
  if [ "$aligner" == "HISAT2" ];
  then
    ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/wbcel235_tran.tar.gz
    set_ref=wbcel235_tran
    HISAT_ref
  fi
  ENSEMBL_RELEASE=84
  ENSEMBL_ORGANISM=caenorhabditis_elegans
  ENSEMBL_ORG_FILE_NAME=Caenorhabditis_elegans.WBcel235
  ensembl_refset
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  downloaded_ref
  wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  gunzip download
  organize_ref
  fi
####################################################################################################################
#  D. melanogaster
####################################################################################################################
  if  [ "$organism" == "fly" ];
  then
  if [ "$aligner" == "HISAT2" ];
  then
    ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/bdgp6_tran.tar.gz
    set_ref=bdgp6
    HISAT_ref
  fi
  ENSEMBL_RELEASE=84
  ENSEMBL_ORGANISM=drosophila_melanogaster
  ENSEMBL_ORG_FILE_NAME=Drosophila_melanogaster.BDGP6
  ensembl_refset
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  downloaded_ref
  wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  gunzip download
  organize_ref
  fi
####################################################################################################################
#  S. cerevisiae
####################################################################################################################
  if  [ "$organism" == "yeast" ];
  then
  if [ "$aligner" == "HISAT2" ];
  then
    ftpsite=ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/r64_tran.tar.gz
    set_ref=r64
    HISAT_ref
  fi
  ENSEMBL_RELEASE=84
  ENSEMBL_ORGANISM=saccharomyces_cerevisiae
  ENSEMBL_ORG_FILE_NAME=Saccharomyces_cerevisiae.R64-1-1
  ensembl_refset
  ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.hg38.vcf.gz # dpsnp.vcf
  ref_name=dbsnp.vcf
  downloaded_ref
  wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip # snpEff
  gunzip download
  organize_ref
  fi
####################################################################################################################
#  HISAT2 build References
####################################################################################################################

####################################################################################################################
#  STAR build References
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
