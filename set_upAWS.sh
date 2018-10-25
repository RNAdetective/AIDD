#!/usr/bin/env bash
## this uninstalls old version of R that came with biolinux8
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes upgrade
sudo apt-get --yes --force-yes remove r-base-core
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes upgrade
sudo add-apt-repository ppa:marutter/rdev
sudo cp /etc/bash_completion.d/R /usr/share/bash-completion/completions/R
sudo apt-get --yes --force-yes install r-base-core 
## this downloads the tool that allows R to find and downloads certain packages needed for analysis.
sudo apt-get --yes --force-yes install r-cran-rmysql
sudo apt-get --yes --force-yes install ipvsadm
sudo apt-get --yes --force-yes install dkms
##this updates java for the picard tool
sudo apt-add-repository ppa:openjdk-r/ppa
sudo apt-get --yes --force-yes update
sudo apt-get --yes --force-yes upgrade
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
sudo apt-get --yes --force-yes install gsl-bin libgsl2
sudo apt-get --yes --force-yes install libtiff-dev
sudo apt-get --yes --force-yes install build-essential python2.7-dev python-htseq
##download Rstudio
sudo apt-key adv –keyserver keyserver.ubuntu.com –recv-keys E084DAB9
# Basic format of next line deb https://<my.favorite.cran.mirror>/bin/linux/ubuntu <enter your ubuntu version>/
sudo add-apt-repository 'deb https://ftp.ussg.iu.edu/CRAN/bin/linux/ubuntu trusty/'
sudo apt-get install gdebi-core
wget https://download1.rstudio.org/rstudio-1.0.44-amd64.deb
sudo gdebi rstudio-1.0.44-amd64.deb
rm rstudio-1.0.44-amd64.deb
mkdir /home/ubuntu/AIDD
mkdir /home/ubuntu/AIDD/AIDD_tools
mkdir /home/ubuntu/AIDD/AIDD_tools/bin
##this will download AWStools
wget https://drive.google.com/open?id=1zleX3g2eg4o_yyFYYzH2RqliZmopDzTx
tar -vxzf AIDD_AWStools.tar.gz
mv /home/ubuntu/AIDD_AWStools/* /home/ubuntu/AIDD/AIDD_tools/
rm /home/ubuntu/AIDD_AWStools.tar.gz
##this will get pipeline scripts
wget https://github.com/RNAdetective/AIDD/raw/master/AIDD_AWSscripts.tar.gz
tar -vxzf AIDD_AWSscripts.tar.gz
mv /home/ubuntu/AIDD_AWSscripts/* /home/ubuntu/AIDD/
rm /home/ubuntu/AIDD_AWSscripts.tar.gz
##this is the function to download all necessary reference files
mkdir /home/ubuntu/AIDD/references
cd "/home/ubuntu/AIDD/references"
echo "Bulk downloading, extracting, and moving all needed reference and index files"
wget https://drive.google.com/open?id=1A0ItKKoiA6MxCh9QdZBoScgxN_uEtzbN
mv /home/ubuntu/GRCh37.tar.gz /home/ubuntu/AIDD/references/
tar -vxzf /home/ubuntu/AIDD/references/GRCh37.tar.gz
rm /home/ubuntu/AIDD/references/GRCh37.tar.gz

mv /home/ubuntu/AIDD/references/


