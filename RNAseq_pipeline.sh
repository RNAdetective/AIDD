#!/usr/bin/env bash
main_function() {
echo "To run the pipeline simply answer the following few prompts and then the pipeline could take days to weeks to run depending on size and number of files used in experiment.  Please read the manual on the desktop of this virtual machine for more instructions, options, or detailed explanation on the steps involved in the pipeline. Please make sure you have filled out your experimental data in the /home/user/Pipelines/index/PHENO_DATA.csv.  Simply go to the path and open  the file in the LibreOffice Calc or text and change the small scale AML tutorial example to your own data files.  Also remember this is the same order you must enter in the following prompts when it asks you for file names.  When this file is saved and all other optional changes have been made from the manual." 

export PATH=$PATH:/home/user/Pipelines/HISAT2_pipeline/bin

echo "Please enter the path to working directory (please see manual for instructions on creating your working directory) this working directory is recommended to be at least 500G for optiminal performance.  The small scale AML study tutorial used /media/sf_tutorial/tutorial."
read path
mkdir $path
cd $path
##example shared folder option path /media/"name of your drive"/"name of your file"

echo "Would you like to download sequences from NCBI with SRA number? enter yes to download or no if you would like to run your own data? yes or no."
read data
## answer yes or no

if  [ "$data" == "yes" ]; then
echo "Please enter up to 18 sra file numbers seperated by a space with no punctuation for example in the small scale AML tutorial we use SRR3895734 SRR3895735 SRR1575102 SRR1575103"
read varname1 varname2 varname3 varname4 varname5 varname6 varname7 varname8 varname9 varname10 varname11 varname12 varname13 varname14 varname15 varname16 varname17 varname18
##example for small scale AML study SRR3895734 SRR3895735 SRR1575102 SRR1575103
fi

if  [ "$data" == "no" ]; then
echo "Please make sure your files (up to 18) are in fastq format in the /home/user/Downloads path and make sure if you have paired end reads they should be in this format NAME_1.fastq NAME_2.fastq but only enter NAME in the following list and list all your file names. example NAME1 NAME2 NAME3 where NAME is the name of your files."
read file1 file2 file3 file4 file5 file6 file7 file8 file9 file10 file11 file12 file13 file14 file15 file16 file17 file18
fi
##this is where you will enter your own data's file names.  If you have single end reads just put the file name without the extension (.fastq) and your files must be in fastq form not fastq.gz you must uncompress them first.  If you have paired end reads they must also be in .fastq format and to distinguish the pairs it should be in XXXXX_1.fastq XXXXX_2.fastq where XXXXX is your file name.  Then simply enter the list XXXXX XXXXX XXXXXX with a space inbetween the name of each file.  Remember it is also important to enter them in the same order as you entered them in the PHENO_DATA index file.

echo "Please enter HISAT2 index file choice from one of the following options: GRCh37, GRCh37_snp, GRCh37_tran, GRCh37_snp_tran, GRCh38, GRCh38_snp, GRCh38_tran, GRCh38_snp_tran.  For the tutorial with the small AML set we use GRCh37_snp_tran as the default setting. If you have mouse data you can enter one of the following   For more information on these chooses see the www.ensembl.org for more information."
read variable 

echo "Please enter library layout type: single or paired"
read library

echo "Please enter the aligner you would like to use HISAT2, STAR, or Salmon.  WARNING: STAR can only be used if you virtualbox has at least 30G of RAM assigned to it from the host machine.  Although it runs much faster only use Salmon with paired end reads and when not performing variant calling.  Otherwise use HISAT2 that is the default that was used in the small scale AML example data set.)"
read aligner 

echo "Choose one of the following DESeq2 design set-ups for more information on experimental design see DESeq2 manual at https://bioconductor.org/packages/release/bioc/html/DESeq2.html. 1.) if your PHENO_DATA index file you have created in previous set-up contains just one condition column enter (1) for example this set up is used in the small scale AML tutorial.  2.) if you PHENO table contains two conditions both condition1 and condition2 columns are present in the table then enter (2).  For example if you data set contains disease and normal and then three different cell lines this would be a two condition set up. Please enter 1 or 2"
read design

echo "Would you like to do variant calling at the same time as the gene and transcript level expression analysis? (the other option would be to run it at a later time with the command bash /home/user/Pipelines/VariantCalling.sh instructions for this can also be found in the manual at a later time)  Please enter yes or no.  Please keep in mind only paired end reads are able to be used for variant calling analysis with the default code due to the high error rate of single end reads in variant calling for RNA editing."
read variant

if  [ "$data" == "yes" ]; then
echo "Now Downloading sra files and moving them to $path.  Depending on your file size this could take awhile.  If you recieve an error message during this step you will need to start the pipeline over and check the internet connection.  Make sure before you start this you will have continuous access to the internet for at least the next 2 hours.  If there is an error you will see a file appear in your working directory called ncbi_error" 
prefetch $varname1 $varname2 $varname3 $varname4 $varname5 $varname6 $varname7 $varname8 $varname9 $varname10 $varname11 $varname12 $varname13 $varname14 $varname15 $varname16 $varname17 $varname18
fi

if  [ "$data" == "yes" ]; then
for file in /home/user/ncbi/public/sra/*sra
do
    name="$(basename "$file" .sra)"
    echo "Moving $name"

    mkdir -p "$name"

    mv "$file" "$name"
done
fi

if  [ "$variable" == "GRCh38" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch38_snp_tran.tar.gz
mv $path/grch38/genome.1.ht2 $path/genome.1.ht2
mv $path/grch38/genome.2.ht2 $path/genome.2.ht2
mv $path/grch38/genome.3.ht2 $path/genome.3.ht2
mv $path/grch38/genome.4.ht2 $path/genome.4.ht2
mv $path/grch38/genome.5.ht2 $path/genome.5.ht2
mv $path/grch38/genome.6.ht2 $path/genome.6.ht2
mv $path/grch38/genome.7.ht2 $path/genome.7.ht2
mv $path/grch38/genome.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.89.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-89/gtf/homo_sapiens/Homo_sapiens.GRCh38.89.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.89.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh38.89.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b38/dbsnp_138.b38.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b38.vcf.gz
mv dbsnp_138.b38.vcf dbsnp.vcf
fi

if  [ "$variable" == "GRCh38_snp" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38_snp.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch38_snp.tar.gz
mv $path/grch38_snp/genome_snp.1.ht2 $path/genome.1.ht2
mv $path/grch38_snp/genome_snp.2.ht2 $path/genome.2.ht2
mv $path/grch38_snp/genome_snp.3.ht2 $path/genome.3.ht2
mv $path/grch38_snp/genome_snp.4.ht2 $path/genome.4.ht2
mv $path/grch38_snp/genome_snp.5.ht2 $path/genome.5.ht2
mv $path/grch38_snp/genome_snp.6.ht2 $path/genome.6.ht2
mv $path/grch38_snp/genome_snp.7.ht2 $path/genome.7.ht2
mv $path/grch38_snp/genome_snp.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.89.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-89/gtf/homo_sapiens/Homo_sapiens.GRCh38.89.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.89.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh38.89.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b38/dbsnp_138.b38.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b38.vcf.gz
mv dbsnp_138.b38.vcf dbsnp.vcf
fi

if  [ "$variable" == "GRCh38_tran" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38_tran.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch38_snp.tar.gz
mv $path/grch38_tran/genome_tran.1.ht2 $path/genome.1.ht2
mv $path/grch38_tran/genome_tran.2.ht2 $path/genome.2.ht2
mv $path/grch38_tran/genome_tran.3.ht2 $path/genome.3.ht2
mv $path/grch38_tran/genome_tran.4.ht2 $path/genome.4.ht2
mv $path/grch38_tran/genome_tran.5.ht2 $path/genome.5.ht2
mv $path/grch38_tran/genome_tran.6.ht2 $path/genome.6.ht2
mv $path/grch38_tran/genome_tran.7.ht2 $path/genome.7.ht2
mv $path/grch38_tran/genome_tran.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.89.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-89/gtf/homo_sapiens/Homo_sapiens.GRCh38.89.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.89.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh38.89.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b38/dbsnp_138.b38.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b38.vcf.gz
mv dbsnp_138.b38.vcf dbsnp.vcf
fi

if  [ "$variable" == "GRCh38_snp_tran" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38_snp_tran.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch38_snp_tran.tar.gz
mv $path/grch38_snp_tran/genome_snp_tran.1.ht2 $path/genome.1.ht2
mv $path/grch38_snp_tran/genome_snp_tran.2.ht2 $path/genome.2.ht2
mv $path/grch38_snp_tran/genome_snp_tran.3.ht2 $path/genome.3.ht2
mv $path/grch38_snp_tran/genome_snp_tran.4.ht2 $path/genome.4.ht2
mv $path/grch38_snp_tran/genome_snp_tran.5.ht2 $path/genome.5.ht2
mv $path/grch38_snp_tran/genome_snp_tran.6.ht2 $path/genome.6.ht2
mv $path/grch38_snp_tran/genome_snp_tran.7.ht2 $path/genome.7.ht2
mv $path/grch38_snp_tran/genome_snp_tran.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.89.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-89/gtf/homo_sapiens/Homo_sapiens.GRCh38.89.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh38.89.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-89/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh38.89.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.89.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh38.89.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b38/dbsnp_138.b38.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b38.vcf.gz
mv dbsnp_138.b38.vcf dbsnp.vcf
fi

if  [ "$variable" == "GRCh37" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch37.tar.gz
mv $path/grch37/genome.1.ht2 $path/genome.1.ht2
mv $path/grch37/genome.2.ht2 $path/genome.2.ht2
mv $path/grch37/genome.3.ht2 $path/genome.3.ht2
mv $path/grch37/genome.4.ht2 $path/genome.4.ht2
mv $path/grch37/genome.5.ht2 $path/genome.5.ht2
mv $path/grch37/genome.6.ht2 $path/genome.6.ht2
mv $path/grch37/genome.7.ht2 $path/genome.7.ht2
mv $path/grch37/genome.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh37.75.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh37.75.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b37.vcf.gz
mv dbsnp_138.b37.vcf dbsnp.vcf
fi
if  [ "$variable" == "GRCh37_tran" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37_tran.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch37_tran.tar.gz
mv $path/grch37_tran/genome_tran.1.ht2 $path/genome.1.ht2
mv $path/grch37_tran/genome_tran.2.ht2 $path/genome.2.ht2
mv $path/grch37_tran/genome_tran.3.ht2 $path/genome.3.ht2
mv $path/grch37_tran/genome_tran.4.ht2 $path/genome.4.ht2
mv $path/grch37_tran/genome_tran.5.ht2 $path/genome.5.ht2
mv $path/grch37_tran/genome_tran.6.ht2 $path/genome.6.ht2
mv $path/grch37_tran/genome_tran.7.ht2 $path/genome.7.ht2
mv $path/grch37_tran/genome_tran.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh37.75.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh37.75.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b37.vcf.gz
mv dbsnp_138.b37.vcf dbsnp.vcf
fi

if  [ "$variable" == "GRCh37_snp" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37_snp.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch37_snp.tar.gz
mv $path/grch37_snp/genome_snp.1.ht2 $path/genome.1.ht2
mv $path/grch37_snp/genome_snp.2.ht2 $path/genome.2.ht2
mv $path/grch37_snp/genome_snp.3.ht2 $path/genome.3.ht2
mv $path/grch37_snp/genome_snp.4.ht2 $path/genome.4.ht2
mv $path/grch37_snp/genome_snp.5.ht2 $path/genome.5.ht2
mv $path/grch37_snp/genome_snp.6.ht2 $path/genome.6.ht2
mv $path/grch37_snp/genome_snp.7.ht2 $path/genome.7.ht2
mv $path/grch37_snp/genome_snp.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh37.75.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh37.75.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b37.vcf.gz
mv dbsnp_138.b37.vcf dbsnp.vcf
fi

if  [ "$variable" == "GRCh37_snp_tran" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37_snp_tran.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch37_snp_tran.tar.gz
mv $path/grch37_snp_tran/genome_snp_tran.1.ht2 $path/genome.1.ht2
mv $path/grch37_snp_tran/genome_snp_tran.2.ht2 $path/genome.2.ht2
mv $path/grch37_snp_tran/genome_snp_tran.3.ht2 $path/genome.3.ht2
mv $path/grch37_snp_tran/genome_snp_tran.4.ht2 $path/genome.4.ht2
mv $path/grch37_snp_tran/genome_snp_tran.5.ht2 $path/genome.5.ht2
mv $path/grch37_snp_tran/genome_snp_tran.6.ht2 $path/genome.6.ht2
mv $path/grch37_snp_tran/genome_snp_tran.7.ht2 $path/genome.7.ht2
mv $path/grch37_snp_tran/genome_snp_tran.8.ht2 $path/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.cdna.all.fa.gz
mv $path/*.fa $path/ref.fa
wget ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.gtf.gz
mv $path/*.gtf $path/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
mv $path/*.primary_assembly.fa $path/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CreateSequenceDictionary REFERENCE=$path/ref2.fa OUTPUT=$path/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx $path/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh37.75.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh37.75.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b37.vcf.gz
mv dbsnp_138.b37.vcf dbsnp.vcf
fi

if  [ "$aligner" == "HISAT2" ]; then
echo "Starting HISAT2 for alignment"
if  [ "$library" == "single" ]; then
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    
    echo "Running fastq-dump to convert .sra to .fastq ${samp}"

    fastq-dump ${fn}/${samp}.sra \
      -O $path/${samp}
done


for fn in $varname{1..18};
do

samp=`basename ${fn}`
echo "Running HISAT2 alignment for single layout and with previously downloaded reference sequences for ${samp}"

hisat2 -q -x $path/genome -p3 --dta-cufflinks \
         -U ${fn}/${samp}.fastq \
         -t --summary-file $path/${samp}/${samp}.txt -S $path/${samp}/${samp}.sam

done
fi
fi
if  [ "$aligner" == "HISAT2" ]; then
echo "starting HISAT2 aligner for paired reads"
if  [ "$library" == "paired" ]; then
for fn in $varname{1..18};
do

samp=`basename ${fn}`
echo "Running fastq dump to convert .sra file to 2 mate .fastq files for ${samp}"

fastq-dump ${fn}/${samp}.sra \
      -I --split-files \
      -O $path/${samp}
done


for fn in $varname{1..18};
do

samp=`basename ${fn}`
echo "Running HISAT2 alignment for paired layout with preiously downloaded reference sequences for ${samp}"

hisat2 -q -x $path/genome -p3 --dta-cufflinks \
         -1 ${fn}/${samp}_1.fastq \
         -2 ${fn}/${samp}_2.fastq \
         -t --summary-file $path/${samp}/${samp}.txt -S $path/${samp}/${samp}.sam

done
fi
fi
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting sorting with picard tool to convert .sam to .bam for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar SortSam INPUT=$path/${samp}/${samp}.sam OUTPUT=$path/${samp}/${samp}.bam SORT_ORDER=coordinate
    
done
##this process starts moving index files and creating the Results directory
echo "moving index files for R analysis and setting up directory system for Results from transcriptome assembly"
## this creates directories to store results from stringtie and further downstream analysis
for i in Counts ballgown_in ballgown ballgown2 Results; do
    mkdir $path/$i/
done
## this creates subdirectories in results
for i in DESeq2_gene DESeq2_pathway DESeq2_transcript ; do
    mkdir $path/Results/$i/
done
cp -a /home/user/Pipelines/index/. $path/Results/DESeq2_gene/
cp -a /home/user/Pipelines/index/. $path/Results/DESeq2_transcript/
cp -a /home/user/Pipelines/gene_list/. $path/Results/DESeq2_gene/
cp -a /home/user/Pipelines/gene_list/. $path/Results/DESeq2_transcript/
## this next step runs stringtie for transcriptome assembly
for fn in $path/$varname{1..18};
do
samp=`basename ${fn}`
echo "Starting stringtie to  to create count files to be used in downstream differential expression analysis for ${samp}"
stringtie ${samp}/${samp}.bam \
         -p3 -G $path/ref.gtf -A $path/Counts/${samp}.tab -l -B -b $path/ballgown_in/${samp} -e -o $path/ballgown/${samp}.gtf
done
## this creates directories to store results
for i in 0{1..9} {10..18}
do
    mkdir $path/ballgown/"sample$i"/
done
## this creates directories to store results
for i in 0{1..9} {10..18}
do
    mkdir $path/ballgown_in/"sample$i"/
done
## this creates .gff input files from the count .gtf file from stringtie output using a python script for DEXseq exon counting analysis however these are not used in the default pipeline they are generated if more advanced user would like to run DEXseq.
##echo "Starting python script to find exon counts for DEXSeq2"
##for i in 0{1..9} {10..18}
##do
  ## python /home/user/Pipelines/HISAT2_pipeline/bin/dexseq_prepare_annotation.py $path/ballgown/${samp}.gtf $path/DEXSeq/${samp}.gff
##done
##echo "Starting python script to find exon counts for DEXSeq2"
##for i in 0{1..9} {10..18}
##do
 ##  python /home/user/Pipelines/HISAT2_pipeline/bin/dexseq_count.py $path/ballgown/${samp}.gff $path/${samp}/${samp}.sam $path/DEXSeq/${samp}
##done
mv $path/ballgown_in/$varname1 $path/ballgown2/sample01/
mv $path/ballgown_in/$varname2 $path/ballgown2/sample02/
mv $path/ballgown_in/$varname3 $path/ballgown2/sample03/
mv $path/ballgown_in/$varname4 $path/ballgown2/sample04/
mv $path/ballgown_in/$varname5 $path/ballgown2/sample05/
mv $path/ballgown_in/$varname6 $path/ballgown2/sample06/
mv $path/ballgown_in/$varname7 $path/ballgown2/sample07/
mv $path/ballgown_in/$varname8 $path/ballgown2/sample08/
mv $path/ballgown_in/$varname9 $path/ballgown2/sample09/
mv $path/ballgown_in/$varname10 $path/ballgown2/sample10/
mv $path/ballgown_in/$varname11 $path/ballgown2/sample11/
mv $path/ballgown_in/$varname12 $path/ballgown2/sample12/
mv $path/ballgown_in/$varname13 $path/ballgown2/sample13/
mv $path/ballgown_in/$varname14 $path/ballgown2/sample14/
mv $path/ballgown_in/$varname15 $path/ballgown2/sample15/
mv $path/ballgown_in/$varname16 $path/ballgown2/sample16/
mv $path/ballgown_in/$varname17 $path/ballgown2/sample17/
mv $path/ballgown_in/$varname18 $path/ballgown2/sample18/

mv $path/ballgown/$varname1.gtf $path/ballgown/sample01/sample01.gtf
mv $path/ballgown/$varname2.gtf $path/ballgown/sample02/sample02.gtf
mv $path/ballgown/$varname3.gtf $path/ballgown/sample03/sample03.gtf
mv $path/ballgown/$varname4.gtf $path/ballgown/sample04/sample04.gtf
mv $path/ballgown/$varname5.gtf $path/ballgown/sample05/sample05.gtf
mv $path/ballgown/$varname6.gtf $path/ballgown/sample06/sample06.gtf
mv $path/ballgown/$varname7.gtf $path/ballgown/sample07/sample07.gtf
mv $path/ballgown/$varname8.gtf $path/ballgown/sample08/sample08.gtf
mv $path/ballgown/$varname9.gtf $path/ballgown/sample09/sample09.gtf
mv $path/ballgown/$varname10.gtf $path/ballgown/sample10/sample10.gtf
mv $path/ballgown/$varname11.gtf $path/ballgown/sample11/sample11.gtf
mv $path/ballgown/$varname12.gtf $path/ballgown/sample12/sample12.gtf
mv $path/ballgown/$varname13.gtf $path/ballgown/sample13/sample13.gtf
mv $path/ballgown/$varname14.gtf $path/ballgown/sample14/sample14.gtf
mv $path/ballgown/$varname15.gtf $path/ballgown/sample15/sample15.gtf
mv $path/ballgown/$varname16.gtf $path/ballgown/sample16/sample16.gtf
mv $path/ballgown/$varname17.gtf $path/ballgown/sample17/sample17.gtf
mv $path/ballgown/$varname18.gtf $path/ballgown/sample18/sample18.gtf
find . -empty -type d -delete

##this is the python script to transform all gtf count files into one matrix file for usage in R analysis.
echo "Starting python script to find gene and transcript counts"
python /home/user/Pipelines/HISAT2_pipeline/bin/prepDE.py -g $path/Results/DESeq2_gene/gene_count_matrix.csv -t $path/Results/DESeq2_transcript/transcript_count_matrix.csv

##this says if you picked design with one condition it will move all index files were they need to be to conduct R analysis and then the Rscript with start
if  [ "$design" == "1" ]; then
echo "Starting Rscript for Gene Level Differential expression analysis"
cd "$path/Results/DESeq2_gene"
## this is the command to run the gene level differential analysis in R using DESeq2 as the main package for analysis
Rscript /home/user/Pipelines/Rscripts/GLDE.R
##now the transcript level R script will run after changing working directories to transcript folders
cd "$path/Results/DESeq2_transcript"
Rscript /home/user/Pipelines/Rscripts/TLDE.R
##this moves index files for topGO_gene and moves the input files into working directory for R
mkdir $path/Results/topGO_gene
cp "/home/user/Pipelines/index/annotations2.csv" "$path/Results/topGO_gene/annotations2.csv"
cp "$path/Results/DESeq2_gene/Upreg.csv" "$path/Results/topGO_gene/Upreg.csv"
cp "$path/Results/DESeq2_gene/Downreg.csv" "$path/Results/topGO_gene/Downreg.csv"
cd "$path/Results/topGO_gene"
Rscript /home/user/Pipelines/Rscripts/topGO.R
fi
##this says if you picked design with two seperate conditions it will move all index files were they need to be to conduct R analysis and then the Rscript with start still working on the index files for this.
if  [ "$design" == "2" ]; then
echo "moving index files for R analysis"
## this is the command to run the gene level differential analysis in R using DESeq2 as the main package for analysis
Rscript /home/user/Pipelines/Rscripts/GLDE_k3.R
##now the transcript level R script will run after changing working directories to transcript folders
cd "$path/Results/DESeq2_transcript"
Rscript /home/user/Pipelines/Rscripts/TLDE_k3.R
##this moves index files for topGO_gene and moves the input files into working directory for R
cp "/home/user/Pipelines/index/annotations2.csv" "$path/Results/topGO_gene/annotations2.csv"
cp "$path/Results/DESeq2_gene/Upreg.csv" "$path/Results/topGO_gene/Upreg.csv"
cp "$path/Results/DESeq2_gene/Downreg.csv" "$path/Results/topGO_gene/Downreg.csv"
cd "$path/Results/topGO_gene"
Rscript /home/user/Pipelines/Rscripts/topGO.R
fi
##this is the variant calling steps to follow if the answer yes run variant calling is selected in the beginning.
## this removes all index files and other unused files from results folders leaving only useable files to sort through at the gene level.
##for i in g_names.csv PHENO_DATA.csv bargraphindex.csv brain_deve_genes.csv cns_deve_genes.csv pns_deve_genes.csv neuro_deve_genes.csv neuro_genes.csv VEGFpathway_genes.csv ADARgene.csv VEGFgene.csv 5.csv 6.csv ; do
##rm "$path/Results/DESeq2_gene/$i"
##done
## this removes all index files and other unused files from results folders leaving only useable files to sort through at the transcript level.
##for i in t_names.csv PHENO_DATA.csv bargraphindex.csv ADAR1transcript.csv ADARB1transcript.csv ADARB2transcript.csv VEGFAtranscript.csv VEGFBtranscript.csv importantADARt.csv ; do
##rm "$path/Results/DESeq2_gene/$i"
##done
##this will change to the topGO results directory and starts the Rscript to do topGO analysis
if [ "$variant" == "yes" ]; then
##these next 4 commands all label and sort the bam files to the right order and labeling for Genome analysis tool kit.   AddorReplace read groups.  Takes all read groups and names them the same which is required for GATK (options are RGID is read group ID, RGLB read group library, RGPL read group platform, rgpu read group platform unit, RGSM read group sample name).
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard AddorReplaceReadGroups with RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar AddOrReplaceReadGroups I=$path/${samp}/${samp}.bam O=$path/${samp}/${samp}2.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
    
done
##the part reorders the reads to match the reference file provided which is in the correct chromosomal order for GATK haplotype caller.  It converts it to karyotypic order because the reference file was reordered this way with the python script during the bulk download step.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard ReorderSam and creating an index for the new order for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar ReorderSam I=$path/${samp}/${samp}2.bam O=$path/${samp}/${samp}3.bam R=$path/ref2.fa CREATE_INDEX=TRUE
    
done
##This step is again specific to illumina data and creates a detailed text file about alignment quality and threshold filters.  This is used by GATK when variant calling.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard CollectAlignmentSummaryMetrics to create text file for downstream variant calling for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CollectAlignmentSummaryMetrics R=$path/ref2.fa I=$path/${samp}/${samp}3.bam O=$path/${samp}/${samp}_alignment_metrics.txt

done
##This step creates another text file used by GATK which validates the library construction insert distribution and more.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard CollectInsertSizeMetrics to creat both a text file and pdf file summarizing insert size for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CollectInsertSizeMetrics INPUT=$path/${samp}/${samp}3.bam OUTPUT=$path/${samp}/${samp}_insert_metrics.txt HISTOGRAM_FILE=$path/${samp}/${samp}_insert_size_histogram.pdf

done
##Samtools is used to filter out short or cutoff reads in the bam file to insure accuracy in GATK variant calling and adding headers necessary for GATK.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running samtools to filter short or cutoff reads for more accurate variant calling for ${samp}"
    samtools view -b -f2 $path/${samp}/${samp}3.bam > $path/${samp}/${samp}4.bam 

done 
##creates a text file containing the computed depth at each position.  This is used by GATK to assure accurate varaint calling.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running samtools depth to create depth text for downstream variant calling for ${samp}"
    samtools depth $path/${samp}/${samp}4.bam > $path/${samp}/${samp}depth_out.txt 

done
## this elimantes PCR duplicate artifacts or other duplicate reads within the bam file.  The first options here are adjusting the resource allocated to java to perform the mark duplicates task which is one of the most memory intensive steps.  The step creates a marked bam file with a metrics text file listing any duplicate flags found.  This step is required by GATK.  
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "java picard MarkDuplicates to annotate PCR duplicates for more accurate variant calling in RNA editing experiments for ${samp}"
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=$path/tmp -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar MarkDuplicates INPUT=$path/${samp}/${samp}4.bam OUTPUT=$path/${samp}/${samp}dedup_reads.bam METRICS_FILE=$path/${samp}/${samp}metrics.txt TMP_DIR=$path/tmp

done
##this creates an index of your bam file for faster look up during GATK haplotype calling.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard to build Bam index for downstream variant calling for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar BuildBamIndex INPUT=$path/${samp}/${samp}dedup_reads.bam
    
done
##this minimizes the number of artifical mismatches created by the the presence of indels in an individuals genome compared to the reference genome by locally realignment.  This is used here with haplocaller because we are trying to detect RNA editing which requires even more accuracy during alignment to show true editing events.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting realigners using java GATK with reference sequences previously downloads for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $path/ref2.fa --filter_reads_with_N_cigar -I $path/${samp}/${samp}dedup_reads.bam -o $path/${samp}/${samp}realignment_targets.list
    
done
##this is another step of the local realignment to reduce false positives.  Again this is being done with Haplotype caller to imporve accuracy during RAN editing events.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Re aligning indels with java GATK with same reference sequences as previous step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T IndelRealigner -R $path/ref2.fa --filter_reads_with_N_cigar -I $path/${samp}/${samp}dedup_reads.bam -targetIntervals $path/${samp}/${samp}realignment_targets.list -o $path/${samp}/${samp}realigned_reads.bam
    
done
##HaplotypeCaller is used because it is a more sensitive and accurate tool and is more suited to detect RNA editing in RNAseq data.  When encountering highly variable regions it re-maps the region denovo allowing for more accuracy then position based callers.  This also allows for proper handling of splice junctions which is critical for proper RNA editing detection.  Also annotating with a known snp database will reduce the number of false positives allows for those variants to be discarded later as genomic and not part of RNA editing.  For more information on how Haplotype caller works see https://software.broadinstitute.org/gatk/documentation/tooldocs/current/org_broadinstitute_gatk_tools_walkers_haplotypecaller_HaplotypeCaller.php . stand_call_conf is the minimum phred-scaled confidence threshold at which variants should be called with the default of 10 we set it a 20 a more strict threshold lower number of false positives.   
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting GATK HaplotypeCaller using reference sequences from the previous step and known snp sites with special options for RNA editing detection for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T HaplotypeCaller -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam --dbsnp $path/dbsnp.vcf -dontUseSoftClippedBases -stand_call_conf 20.0 -o $path/${samp}/${samp}raw_variants.vcf
    
done
##this next two step select for a type of variant the first snp and second indel.  Both these files are needed even if only snp are used for RNA editing for base recalibration step.  
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK Select Variants to create vcf file of raw snps for filtering for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants.vcf -selectType SNP -o $path/${samp}/${samp}raw_snps.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK Select Variants to create vcf file of raw indels for filtering for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants.vcf -selectType INDEL -o $path/${samp}/${samp}raw_indels.vcf
    
done
##These next two steps are filtering steps for the variants.  this is where thresholds are set for the FILTER field and are need to PASS these inorder to be listed in the output vcf file.  QualByDepth is QD and standard is < 2.0.  FisherStrand is FS greater then 60 which is a standard value.  This is a measure of strand bias and 60 is used because it doesn't sacrafice losing true positives while still maintaining a lower number of false positives.  MQ is RMSMappingQuality this is square root of mapping quality at any given site and 40 is standard recommendation to increase true positives. MQRankSum compares mapping qualities of reads supporting reference allele and alternate allele.  Positive values are those matching alternative allele.  MQRankSum is -12.5 as the recommended hard filter.  ReadPosRankSum this is rank sum test for site position within reads.  Which is found at ends of reads with same positive and neg as with MQRankSum -8.0 is recommended hard filter.  SOR is StrandOddsRatio this is another measure of strand bias that takes into account reads at ends of exons which tend to be only covered in one direction.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting first filtering step for raw snps using GATK for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_snps.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 4.0' --filterName "basic_snp_filter" -o $path/${samp}/${samp}filtered_snps.vcf
    
done
## this is the same as for the previous step but for indels instead of snp.  All of the parameters selected are the recommended hard filters for more details about these filterExpression options see https://software.broadinstitute.org/gatk/documentation/article?id=6925 
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting second filtering step for raw indels using GATK for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_indels.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || SOR > 10.0' --filterName "basic_indel_filter" -o $path/${samp}/${samp}filtered_indels.vcf
    
done
##BQSR is base quality score recalibration apply machine learning to model errors and adjust score accordingly to reduce systematic technical error during variant calling algorithms quality scoring.  Builds a model of covariation based on known data then adjusts based on that model.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK baseRecalibrator to incorporate snp and indels from first variant calling step into a table to use for second variant calling for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -knownSites $path/${samp}/${samp}filtered_snps.vcf -knownSites $path/${samp}/${samp}filtered_indels.vcf -o $path/${samp}/${samp}recal_data.table
    
done
##base recalibration is ran a second time taking into account the first run to determine more accurate results.  Then creates a table for use in downstream steps.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Rerunniing GATK basRecalibrator as in the previous step but with BQSR option for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -knownSites $path/${samp}/${samp}filtered_snps.vcf -knownSites $path/${samp}/${samp}filtered_indels.vcf -BQSR $path/${samp}/${samp}recal_data.table -o $path/${samp}/${samp}post_recal_data.table
    
done
##this creates a plot to visualize base recalibration results.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK AnalyzeCovariates to visulaize base recalibration results ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T AnalyzeCovariates -R $path/ref2.fa -before $path/${samp}/${samp}recal_data.table -after $path/${samp}/${samp}post_recal_data.table -plots $path/${samp}/${samp}recalibration_plots.pdf
    
done
##This is the last part of the base quality recalibration where the reads are printed in a new bam file where the new covariates table is used to score the base quality.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK printreads to collect the previous filtering and annotations into the new .bam file for the last variant calling step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T PrintReads -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -BQSR $path/${samp}/${samp}recal_data.table -o $path/${samp}/${samp}recal_reads.bam
    
done
##This is the second round of variant calling using same commands and options as before but this time taking into account the first round of variant calling and new base calibration covariation tables.  
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK HaplotypeCaller for a second time with previous discovered variants already annotated in the starting bam file for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T HaplotypeCaller -R $path/ref2.fa --dbsnp $path/dbsnp.vcf -dontUseSoftClippedBases -stand_call_conf 20.0 -I $path/${samp}/${samp}recal_reads.bam -o $path/${samp}/${samp}raw_variants_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Using GATK to select snps for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants_recal.vcf -selectType SNP -o $path/${samp}/${samp}raw_snps_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Using GATK to select indels for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants_recal.vcf -selectType INDEL -o $path/${samp}/${samp}raw_indels_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Filtering raw snp from the second variant calling step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_snps_recal.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 4.0' --filterName "basic_snp_filter" -o $path/${samp}/${samp}filtered_snps_final.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Filtering raw indels from the second variant calling step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_indels_recal.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || SOR > 10.0' --filterName "basic_indel_filter" -o $path/${samp}/${samp}filtered_indels_recal.vcf
    
done
## This step runs snpEff to predict protein function and structure predictions 
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running snpEff to predict effects of RNA editing events found in the variant calling on the protein stucture and function for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/snpEff.jar -v GRCh37.75 $path/${samp}/${samp}filtered_snps_final.vcf > $path/${samp}/${samp}filtered_snps_final.ann.vcf
    mv $path/snpEff_* $path/${samp}
    
done
##this step creates a bedgraph file for visualization of the sequences using bedtools.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running bedtools on the bam file generated with the first haplotype variant calling annotated to create a bedgraph file for ${samp}"
    bedtools genomecov -bga -ibam $path/${samp}/${samp}recal_reads.bam > $path/${samp}/${samp}genomecov.bedgraph
    
done
mkdir "$path/Results/RNAediting"
mv "$path/Results/*.genes.txt" "$path/Results/RNAediting/*.genes.txt"
cd "$path/Results/RNAediting"
Rscript /home/user/Pipelines/Rscripts/variantcalling.R
rm "$path/Results/RNAediting/final.csv"
fi
cd "$path"
echo "contents of $path"
ls
cd "$path/Results"
echo "contents of $path/Results"
ls
cd "$path/Results/DESeq2_gene"
echo "contents of $path/Results/DESeq2_gene"
ls
cd"$path/Results/DESeq2_transcript"
echo "contents of $path/Results/DESeq2_transcript"
ls
cd"$path/Results/topGO_gene"
echo "contents of $path/Results/topGO_gene"
ls
}
main_function 2>&1 | tee -a RNAseq.log