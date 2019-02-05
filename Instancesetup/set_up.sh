#!/usr/bin/env bash
sudo apt-get --yes update
sudo apt-get --yes upgrade
sudo apt-get --yes install r-base-core
##this updates java for the picard tool
sudo apt install --yes default-jdk
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get install oracle-java8-installer 
##this insalls python
sudo apt-get --yes install python2.7
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
sudo apt-get --yes install build-essential python2.7-dev python-htseq
mkdir ~/AIDD
mkdir ~/AIDD/AIDD_tools
mkdir ~/AIDD/AIDD_tools/bin
mkdir ~/AIDD/AIDDtoolscompressed
cd ~/AIDD/AIDDtoolscompressed
##this option with download pre downloaded files for static tool versions
wget https://github.com/RNAdetective/AIDDinstance/raw/master/AIDDtoolscompressed/AIDDtools.tar.gz.{001..013}
cat ~/AIDD/AIDDtoolscompressed/* > AIDDtools.tar.gz
tar -zxf AIDDtools.tar.gz
rm AIDDtools.tar.gz*
mv ~/AIDD/AIDDtoolscompressed/AIDDtools/* ~/AIDD/AIDD_tools/
mv ~/AIDD/AIDDtoolscompressed/* ~/AIDD/AIDD_tools/
rm -R ~/AIDD/AIDDtoolscompressed/
cd ~/AIDD/AIDD_tools
##sratoolkit
tar -vxzf ~/sratoolkit.tar.gz
rm sratoolkit.tar.gz
cp ~/AIDD/AIDD_tools/sratoolkit.2.9.2-ubuntu64/bin/* ~/AIDD/AIDD_tools/bin
sudo apt --yes install sra-toolkit
##fastx-toolkit instalation
sudo apt --yes install fastx-toolkit
##samtools
tar -xjvf samtools.tar.bz2
rm samtools.tar.bz2
cd ~/AIDD/AIDD_tools/samtools-1.3.1
make
sudo make prefix=/usr/local/bin install
cp ~/samtools-1.3.1/samtools ~/AIDD/AIDD_tools/bin
cd ~/AIDD/AIDD_tools
sudo apt --yes install samtools
##install HISAT2
unzip hisat2-2.1.0-Linux_x86_64.zip
rm hisat2-2.1.0-Linux_x86_64.zip
cp ~/AIDD/AIDD_tools/hisat2-2.1.0/* ~/AIDD/AIDD_tools/bin
## install stringtie
tar -vxzf stringtie-1.3.3b.tar.gz
rm stringtie-1.3.3b.tar.gz
cd ~/AIDD/AIDD_tools/stringtie-1.3.3b
make release
cd ~/AIDD/AIDD_tools
cp ~/AIDD/AIDD_tools/stringtie-1.3.3b/stringtie ~/AIDD/AIDD_tools/bin
##picard tool
tar -vxzf 2.17.3.tar.gz
rm 2.17.3.tar.gz
## unzip genome
tar -xjvf GenomeAnalysisTK-3.8-1-0-gf15c1c3ef.tar.bz2
rm GenomeAnalysisTK-3.8-1-0-gf15c1c3ef.tar.bz2
## download fastqc
unzip fastqc_v0.11.7.zip
rm fastqc_v0.11.7.zip
cp ~/AIDD/AIDD_tools/FastQC/fastqc ~/AIDD/AIDD_tools/bin/
chmod 777 ~/AIDD/AIDD_tools/bin/fastqc
sudo apt-get --yes install fastqc
## install snpEff
unzip snpEff_latest_core.zip
rm snpEff_latest_core.zip
## install cufflinks
tar -vxzf cufflinks*
cp ~/AIDD/AIDD_tools/cufflinks-2.2.1.Linux_x86_64/* ~/AIDD/AIDD_tools/bin
rm cufflinks*
## install gffcompare
tar -vxzf gffcompare.tar.gz
rm gffcompare.tar.gz
cp ~/AIDD/AIDD_tools/gffcompare/gffcompare-0.10.1.Linux_x86_64/gffcompare ~/AIDD/AIDD_tools/bin
## install STAR
tar 2.5.3a.tar.gz
cp ~/AIDD/AIDD_tools/2.5.3a/STAR-2.5.3a/bin/Linux_x85_64/* ~/AIDD/AIDD_tools/bin
rm 2.5.3a.tar.gz
##this will get pipeline scripts
wget https://github.com/RNAdetective/AIDDinstance/raw/master/Instancescripts.tar.gz
tar -vxzf Instancescripts.tar.gz
rm Instancescripts.tar.gz
mkdir ~/AIDD/AIDD/
mv ~/AIDD/AIDD_tools/Instancescripts/* ~/AIDD/AIDD/
rm -d ~/AIDD/AIDD_tools/Instancescripts/
