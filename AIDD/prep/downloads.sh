#!/usr/bin/env bash
main_function() {
##this is the function to download all necessary reference files
echo "Please choose a build to download and prepare reference files for the whole pipeline. 1=GRCh38, 2=GRCh37, none=if you already have references saved from previous experiment"
read variable 
cd "/media/sf_AIDD/references"
if  [ "$variable" == "1" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget -q ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch38_snp_tran.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch38_snp_tran.tar.gz
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.1.ht2 /media/sf_AIDD/references/genome.1.ht2
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.2.ht2 /media/sf_AIDD/references/genome.2.ht2
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.3.ht2 /media/sf_AIDD/references/genome.3.ht2
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.4.ht2 /media/sf_AIDD/references/genome.4.ht2
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.5.ht2 /media/sf_AIDD/references/genome.5.ht2
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.6.ht2 /media/sf_AIDD/references/genome.6.ht2
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.7.ht2 /media/sf_AIDD/references/genome.7.ht2
mv /media/sf_AIDD/references/grch38_snp_tran/genome_snp_tran.8.ht2 /media/sf_AIDD/references/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh38.cdna.all.fa.gz
mv /media/sf_AIDD/references/Homo_sapiens.GRCh38.cdna.all.fa /media/sf_AIDD/references/ref.fa
rm Homo_sapiens.GRCh38.cdna.all.fa.gz
wget ftp://ftp.ensembl.org/pub/release-92/gtf/homo_sapiens/Homo_sapiens.GRCh38.92.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh38.92.gtf.gz
mv /media/sf_AIDD/references/Homo_sapiens.GRCh38.92.gtf /media/sf_AIDD/references/ref.gtf
wget ftp://ftp.ensembl.org/pub/release-92/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
mv /media/sf_AIDD/references/*.primary_assembly.fa /media/sf_AIDD/references/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL* $d/KI*`' > ref2.fa
java -jar /home/user/AIDD/AIDD_tools/picard.jar CreateSequenceDictionary REFERENCE=/media/sf_AIDD/references/ref2.fa OUTPUT=/media/sf_AIDD/references/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx /media/sf_AIDD/references/ref2.fa
wget -q https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh38.92.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh38.92.zip
rm snpEff_v4_3_GRCh38.92.zip
wget ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/hg38/dbsnp_138.hg38.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.hg38.vcf.gz
mv dbsnp_138.hg38.vcf dbsnp.vcf
fi

if  [ "$variable" == "2" ]; then
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/data/grch37_snp_tran.tar.gz
echo "Uncompressing and moving genome reference for alignment step"
tar xzvf grch37_snp_tran.tar.gz
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.1.ht2 /media/sf_AIDD/references/genome.1.ht2
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.2.ht2 /media/sf_AIDD/references/genome.2.ht2
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.3.ht2 /media/sf_AIDD/references/genome.3.ht2
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.4.ht2 /media/sf_AIDD/references/genome.4.ht2
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.5.ht2 /media/sf_AIDD/references/genome.5.ht2
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.6.ht2 /media/sf_AIDD/references/genome.6.ht2
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.7.ht2 /media/sf_AIDD/references/genome.7.ht2
mv /media/sf_AIDD/references/grch37_snp_tran/genome_snp_tran.8.ht2 /media/sf_AIDD/references/genome.8.ht2
wget ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh37.75.cdna.all.fa.gz
echo "Uncompressing and moving genome fasta cdna file for trancriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.cdna.all.fa.gz
mv /media/sf_AIDD/references/*.fa /media/sf_AIDD/references/ref.fa
wget ftp://ftp.ensembl.org/pub/release-75/gtf/homo_sapiens/Homo_sapiens.GRCh37.75.gtf.gz
echo "Uncompressing and moving gtf file for transcriptome assembly step"
gunzip Homo_sapiens.GRCh37.75.gtf.gz
mv /media/sf_AIDD/references/*.gtf /media/sf_AIDD/references/ref.gtf
wget -q ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
echo "Uncompressing and moving primary assembly dna file for variant calling steps also running a python script to reorder the fasta sequences within the file so the chromosomes are in the right order for variant calling steps."
gunzip Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz
mv /media/sf_AIDD/references/*.primary_assembly.fa /media/sf_AIDD/references/ref1.fa
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar /home/user/AIDD/AIDD_tools/picard.jar CreateSequenceDictionary REFERENCE=/media/sf_AIDD/references/ref2.fa OUTPUT=/media/sf_AIDD/references/ref2.dict
echo "using samtools to create an index file of the previously designed references"
samtools faidx /media/sf_AIDD/references/ref2.fa
wget https://sourceforge.net/projects/snpeff/files/databases/v4_3/snpEff_v4_3_GRCh37.75.zip
echo "uncompressing and moving snpEff databases for protein structure and function prediction from snps found in variant calling."
unzip snpEff_v4_3_GRCh37.75.zip
wget -q ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
echo "uncompressing and moving snp databases for variant calling"
gunzip dbsnp_138.b37.vcf.gz
mv dbsnp_138.b37.vcf dbsnp.vcf
fi

}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/downloads.log
