#!/usr/bin/env bash
echo "What is your home directory?"
read home_dir
tool_dir="$home_dir"/AIDD/AIDD_tools/bin
AIDD_tools="$home_dir"/AIDD/AIDDtoolscompressed
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
mkdir "$tool_dir"
mkdir "$AIDD_tools"
cd "$AIDD_tools"
##this option with download pre downloaded files for static tool versions
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDtoolscompressed/AIDDtools.tar.gz.{001..014}
cat "$AIDD_tools"/* > AIDDtools.tar.gz
tar -zxf AIDDtools.tar.gz
rm AIDDtools.tar.gz*
mv "$AIDD_tools"/AIDDtools/* "$home_dir"/AIDD/AIDD_tools/
mv "$AIDD_tools"/* "$home_dir"/AIDD/AIDD_tools/
rm -R "$AIDD_tools"/
cd "$home_dir"/AIDD/AIDD_tools
##install tools
for tool in sra-toolkit fastx-toolkit samtools fastqc ;
do
  sudo apt --yes install "$tool"
done
##install HISAT2
tool=hisat2-2.1.0-Linux_x86_64.zip
unzip "$tool"
rm "$tool"
cp "$home_dir"/AIDD/AIDD_tools/hisat2-2.1.0/* "$tool_dir"
## install stringtie
tool=stringtie-1.3.5.Linux_x86_64
tar -vxzf "$tool".tar.gz
rm "$tool".tar.gz
cp "$home_dir"/AIDD/AIDD_tools/"$tool"/stringtie "$tool_dir"
##picard tool
tool=2.17.3
tar -vxzf "$tool".tar.gz
rm "$tool".tar.gz
## unzip genome
tool=GenomeAnalysisTK-3.8-1-0-gf15c1c3ef
tar -xjvf "$tool".tar.bz2
rm "$tool".tar.bz2
## install snpEff
unzip snpEff_latest_core.zip
rm snpEff_latest_core.zip
## install cufflinks
tar -vxzf cufflinks*
cp "$home_dir"/AIDD/AIDD_tools/cufflinks-2.2.1.Linux_x86_64/* "$tool_dir"
rm cufflinks*
## install gffcompare
tar -vxzf gffcompare.tar.gz
rm gffcompare.tar.gz
cp "$home_dir"/AIDD/AIDD_tools/gffcompare/gffcompare-0.10.1.Linux_x86_64/gffcompare "$tool_dir"
## install STAR
tar 2.5.3a.tar.gz
cp "$home_dir"/AIDD/AIDD_tools/2.5.3a/STAR-2.5.3a/bin/Linux_x85_64/* "$tool_dir"
rm 2.5.3a.tar.gz
## install salmon
tar salmon-0.12.0_linux_x86_64.tar.gz
cp "$home_dir"/AIDD/AIDD_tools/salmon-0.12.0_linux-x86_64/bin/* "$tool_dir"
rm salmon-0.12.0_linux_x86_64.tar.gz
## install kallisto
tar kallisto_linux-v0.45.0.tar.gz
cp "$home_dir"/AIDD/AIDD_tools/kallisto_linux-v0.45.0/kallisto "$tool_dir"
rm kallisto_linux-v0.45.0.tar.gz
## install bowtie2
tar bowtie2-2.3.4.3-linux-x86
##this will get pipeline scripts
cd
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDscripts.tar.gz
tar -vxzf AIDDscripts.tar.gz
rm AIDDscripts.tar.gz
mkdir "$home_dir"/AIDD/AIDD/
cp -r "$home_dir"/AIDDscripts/* "$home_dir"/AIDD/AIDD
##this will get desktop folder
cd
wget https://github.com/RNAdetective/AIDD/raw/master/Desktop.tar.gz
tar -vxzf Desktop.tar.gz
## this will change background picture 
gsettings set org.gnome.desktop.background picture-uri "file://"$home_dir"/AIDD/AIDD/AIDDlogo.jpg"
