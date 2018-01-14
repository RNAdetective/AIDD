#!/usr/bin/env bash
## this allows user to access shared folders
sudo adduser user vboxsf
##this updates java for the picard tool
sudo apt-add-repository ppa:openjdk-r/ppa
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes install openjdk-8-jdk
sudo update-alternatives --config java
##this installs curl and other attachments for adding R packages later
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes upgrade
sudo apt-get --yes --force-yes install curl
sudo apt-get --yes --force-yes install php5-curl
sudo apt-get --yes --force-yes install aptitude
sudo apt-get --yes --force-yes install libcurl4-openssl-dev
sudo apt-get --yes --force-yes install libxml2-dev
sudo apt-get --yes --force-yes install libssl-dev
sudo apt-get --yes --force-yes install libgsl0ldbl
sudo apt-get --yes --force-yes install gsl-bin libgsl0-dev
sudo apt-get --yes --force-yes install gsl-bin libgsl2
sudo apt-get --yes --force-yes install libtiff-dev
sudo apt-get --yes --force-yes install build-essential python2.7-dev python-htseq
## this uninstalls old version of R that came with biolinux8
sudo apt-get --yes --force-yes remove r-base-core
## the following adds permission and downloads the newest version of R sets R up for R package downloads required for analysis.
sudo sh -c 'echo' "deb http://cran.rstudio.com/bin/linux/ubuntu precise/" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository ppa:marutter/rdev
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes upgrade
sudo apt-get --yes --force-yes install r-base
## this downloads the tool that allows R to find and downloads certain packages needed for analysis.
sudo apt-get --yes --force-yes install r-cran-rmysql
mkdir /home/user/Pipelines
mkdir /home/user/Pipelines/HISAT2_pipeline
mkdir /home/user/Pipelines/HISAT2_pipeline/bin
##sratoolkit
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz -O sratoolkit.tar.gz
tar -vxzf /home/user/sratoolkit.tar.gz
rm /home/user/sratoolkit.tar.gz
cp /home/user/sratoolkit.2.8.2-1-ubuntu64/bin/* /home/user/Pipelines/HISAT2_pipeline/bin
cd /home/user/
mv /home/user/sratoolkit.2.8.2-1-ubuntu64 /home/user/Pipelines/HISAT2_pipeline/
##samtools
wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 -O /home/user/samtools.tar.bz2
tar -xjvf samtools.tar.bz2
rm /home/user/samtools.tar.bz2
cd /home/user/samtools-1.3.1
make
sudo make prefix=/usr/local/bin install
cp /home/user/samtools-1.3.1/samtools /home/user/Pipelines/HISAT2_pipeline/bin
cd /home/user/
mv /home/user/samtools-1.3.1 /home/user/Pipelines/HISAT2_pipeline
##install HISAT2
wget ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-2.1.0-Linux_x86_64.zip
unzip /home/user/hisat2-2.1.0-Linux_x86_64.zip
rm /home/user/hisat2-2.1.0-Linux_x86_64.zip
cp /home/user/hisat2-2.1.0/* /home/user/Pipelines/HISAT2_pipeline/bin
mv /home/user/hisat2-2-1-0 /home/user/Pipelines/HISAT2_pipeline
## install stringtie
wget http://ccb.jhu.edu/software/stringtie/dl/stringtie-1.3.3b.tar.gz
tar -vxzf stringtie-1.3.3b.tar.gz
rm /home/user/stringtie-1.3.3b.tar.gz
cd /home/user/stringtie-1.3.3b
make release
cd /home/user/
mv /home/user/stringtie-1.3.3b /home/user/Pipelines/HISAT2_pipeline/bin
## wget http://ccb.jhu.edu/software/stringtie/dl/gffcompare-0.10.1.Linux_x86_64.tar.gz
## get bwa igv ??
##this installs cufflinks
wget http://cole-trapnell-lab.github.io/cufflinks/assets/downloads/cufflinks-2.2.1.Linux_x86_64.tar.gz
tar -vxzf cufflinks-2.2.1.Linux_x86_64.tar.gz
rm /home/user/cufflinks-2.2.1.Linux_x86_64.tar.gz
cp /home/user/cufflinks-2.2.1.Linux_x86_64/* /home/user/Pipelines/HISAT2_pipeline/bin
mv /home/user/cufflinks-2.2.1.Linux_x86_64 /home/user/Pipelines/HISAT2_pipeline
## this installs STAR
wget https://github.com/alexdobin/STAR/archive/2.5.3a.tar.gz
tar -xzf 2.5.3a.tar.gz
rm /home/user/2.5.3a.tar.gz
cp /home/user/STAR-2.5.3a/bin/Linux_x86_64/STAR /home/user/Pipelines/HISAT2_pipeline/bin
mv /home/user/STAR-2.5.3a /home/user/Pipelines/HISAT2_pipeline
##picard tool
wget https://github.com/broadinstitute/picard/archive/2.17.3.tar.gz
tar -vxzf 2.17.3.tar.gz
rm /home/user/2.17.3.tar.gz
wget https://github.com/broadinstitute/picard/releases/download/2.17.3/picard.jar
mv /home/user/picard.jar /home/user/Pipelines/HISAT2_pipeline/picard.jar
mv /home/user/picard-2.17.3 /home/user/Pipelines/HISAT2_pipeline
## this downloads GATK
wget https://github.com/broadinstitute/gatk/releases/download/4.0.0.0/gatk-4.0.0.0.zip
unzip gatk-4.0.0.0.zip
rm /home/user/gatk-4.0.0.0.zip
mv /home/user/gatk-4.0.0.0 /home/user/Pipelines/HISAT2_pipeline
## install snpEff
wget wget http://sourceforge.net/projects/snpeff/files/snpEff_latest_core.zip
unzip snpEff_latest_core.zip
rm /home/user/snpEff_latest_core.zip
cp /home/user/snpEff/snpEff.jar /home/user/Pipelines/HISAT2_pipeline/snpEff.jar
mv /home/user/snpEff /home/user/Pipelines/HISAT2_pipeline
mv /home/user/clinEff /home/user/Pipelines/HISAT2_pipeline
