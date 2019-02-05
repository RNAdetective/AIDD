#!/usr/bin/env bash
echo "What is your home directory?"
read $home_dir
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
mkdir "$home_dir"/AIDD
mkdir "$home_dir"/AIDD/AIDD_tools
mkdir "$home_dir"/AIDD/AIDD_tools/bin
mkdir "$home_dir"/AIDD/AIDDtoolscompressed
cd "$home_dir"/AIDD/AIDDtoolscompressed
##this option with download pre downloaded files for static tool versions
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDtoolscompressed/AIDDtools.tar.gz.{001..013}
cat "$home_dir"/AIDD/AIDDtoolscompressed/* > AIDDtools.tar.gz
tar -zxf AIDDtools.tar.gz
rm AIDDtools.tar.gz*
mv "$home_dir"/AIDD/AIDDtoolscompressed/AIDDtools/* "$home_dir"/AIDD/AIDD_tools/
mv "$home_dir"/AIDD/AIDDtoolscompressed/* "$home_dir"/AIDD/AIDD_tools/
rm -R "$home_dir"/AIDD/AIDDtoolscompressed/
cd "$home_dir"/AIDD/AIDD_tools
##sratoolkit
tar -vxzf "$home_dir"/sratoolkit.tar.gz
rm sratoolkit.tar.gz
cp "$home_dir"/AIDD/AIDD_tools/sratoolkit.2.9.2-ubuntu64/bin/* "$home_dir"/AIDD/AIDD_tools/bin
sudo apt --yes install sra-toolkit
##fastx-toolkit instalation
sudo apt --yes install fastx-toolkit
##samtools
tar -xjvf samtools.tar.bz2
rm samtools.tar.bz2
cd "$home_dir"/AIDD/AIDD_tools/samtools-1.3.1
make
sudo make prefix=/usr/local/bin install
cp "$home_dir"/samtools-1.3.1/samtools "$home_dir"/AIDD/AIDD_tools/bin
cd "$home_dir"/AIDD/AIDD_tools
sudo apt --yes install samtools
##install HISAT2
unzip hisat2-2.1.0-Linux_x86_64.zip
rm hisat2-2.1.0-Linux_x86_64.zip
cp "$home_dir"/AIDD/AIDD_tools/hisat2-2.1.0/* "$home_dir"/AIDD/AIDD_tools/bin
## install stringtie
tar -vxzf stringtie-1.3.3b.tar.gz
rm stringtie-1.3.3b.tar.gz
cd "$home_dir"/AIDD/AIDD_tools/stringtie-1.3.3b
make release
cd "$home_dir"/AIDD/AIDD_tools
cp "$home_dir"/AIDD/AIDD_tools/stringtie-1.3.3b/stringtie "$home_dir"/AIDD/AIDD_tools/bin
##picard tool
tar -vxzf 2.17.3.tar.gz
rm 2.17.3.tar.gz
## unzip genome
tar -xjvf GenomeAnalysisTK-3.8-1-0-gf15c1c3ef.tar.bz2
rm GenomeAnalysisTK-3.8-1-0-gf15c1c3ef.tar.bz2
## download fastqc
unzip fastqc_v0.11.7.zip
rm fastqc_v0.11.7.zip
cp "$home_dir"/AIDD/AIDD_tools/FastQC/fastqc "$home_dir"/AIDD/AIDD_tools/bin/
chmod 777 "$home_dir"/AIDD/AIDD_tools/bin/fastqc
sudo apt-get --yes install fastqc
## install snpEff
unzip snpEff_latest_core.zip
rm snpEff_latest_core.zip
## install cufflinks
tar -vxzf cufflinks*
cp "$home_dir"/AIDD/AIDD_tools/cufflinks-2.2.1.Linux_x86_64/* "$home_dir"/AIDD/AIDD_tools/bin
rm cufflinks*
## install gffcompare
tar -vxzf gffcompare.tar.gz
rm gffcompare.tar.gz
cp "$home_dir"/AIDD/AIDD_tools/gffcompare/gffcompare-0.10.1.Linux_x86_64/gffcompare "$home_dir"/AIDD/AIDD_tools/bin
## install STAR
tar 2.5.3a.tar.gz
cp "$home_dir"/AIDD/AIDD_tools/2.5.3a/STAR-2.5.3a/bin/Linux_x85_64/* "$home_dir"/AIDD/AIDD_tools/bin
rm 2.5.3a.tar.gz
##this will get pipeline scripts
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDscripts.tar.gz
tar -vxzf AIDDscripts.tar.gz
rm AIDDscripts.tar.gz
mkdir "$home_dir"/AIDD/AIDD/
mv "$home_dir"/AIDD/AIDD_tools/AIDD/* "$home_dir"/AIDD/AIDD/
rm -d "$home_dir"/AIDD/AIDD_tools/AIDD/
##this will get desktop folder
wget https://github.com/RNAdetective/AIDD/raw/master/Desktop.tar.gz
tar -vxzf Desktop.tar.gz
## this will change background picture 
gsettings set org.gnome.desktop.background picture-uri "file://"$home_dir"/AIDD/AIDD/AIDDlogo.jpg"
