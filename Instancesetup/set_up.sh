#!/usr/bin/env bash
home_dir="$1"
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
}
install_tool() {
sudo apt-get --yes install "$intool"
}
untar_tool() {
tar -vxzf "$tool".tar.gz
rm "$tool".tar.gz
}
copy_tool() {
cp "$tool_dir"/"$tool"/* "$tool_dir_bin"
}
toolz() {
unzip "$tool".zip
rm "$tool".zip
}
sudo apt-get --yes update
sudo apt-get --yes upgrade
##this updates java for the picard tool
sudo apt install --yes default-jdk
sudo apt-add-repository ppa:webupd8team/java
sudo apt-get install oracle-java8-installer 
##this insalls python
sudo apt-get --yes install python2.7
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
sudo apt-get --yes install build-essential python2.7-dev python-htseq
sudo apt-get install python-pip
pip install biopython --upgrade
for tool in sra-toolkit fastx-toolkit samtools fastqc csvtools r-base-core gdebi-core  libcurl4-openssl-dev libxml2-dev libssl-dev r-cran-rmysql libmysql++-dev ;
do
  intool="$tool"
  install_tool # installs tools
done
sudo apt-add-repository ppa:webupd8team/java #this updates java for the picard tool  
sudo update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1 # this insalls both versions of python
sudo apt-get --yes install build-essential python2.7-dev python-htseq
wget https://s3.amazonaws.com/rstudio-dailybuilds/rstudio-xenial-1.1.463-amd64.deb
sudo gdebi rstudio-xenial-1.1.463-amd64.deb
rm rstudio-xenial-1.1.463-amd64.deb
new_dir="$home_dir"/AIDD
create_dir
AIDDs="$home_dir"/AIDD/AIDD/
new_dir="$AIDDs"
create_dir
tool_dir="$home_dir"/AIDD/AIDD_tools
new_dir="$tool_dir"
create_dir
tool_dir_bin="$home_dir"/AIDD/AIDD_tools/bin
new_dir="$tool_dir_bin"
create_dir
AIDD_tools="$home_dir"/AIDD/AIDDtoolscompressed
new_dir="$AIDD_tools"
create_dir
cd
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDscripts.tar.gz #this will get pipeline scripts
tar -vxzf AIDDscripts.tar.gz
rm AIDDscripts.tar.gz
cp -r "$home_dir"/AIDDscripts/* "$AIDDs"
wget https://github.com/RNAdetective/AIDD/raw/master/Desktop.tar.gz #this will get desktop folder
tar -vxzf Desktop.tar.gz
rm Desktop.tar.gz
cd "$AIDD_tools"
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDtoolscompressed/AIDDtools.tar.gz.{001..014} # gets static versions of tools used in AIDD pipeline
cat "$AIDD_tools"/* > AIDDtools.tar.gz
tar -zxf AIDDtools.tar.gz
rm AIDDtools.tar.gz*
mv "$AIDD_tools"/AIDDtools/* "$tool_dir"
rm -R "$AIDD_tools"
cd "$tool_dir"
tool=stringtie-1.3.5.Linux_x86_64 #install stringtie
untar_tool
copy_tool
tool=2.17.3 #picard tool
untar_tool
tool=cufflinks-2.2.1.Linux_x86_64 #install cufflinks
untar_tool
copy_tool
tool=gffcompare #install gffcompare
untar_tool
cp "$tool_dir"/"$tool"-0.10.1.Linux_x86_64/* "$tool_dir_bin"
tool=2.5.3a #install STAR
untar_tool
cp "$tool_dir"/STAR-"$tool"/bin/Linux_x86_64/* "$tool_dir_bin"
tool=salmon-0.12.0_linux_x86_64 #install salmon
untar_tool
cp "$tool_dir"/"$tool"/bin/* "$tool_dir_bin"
tool=kallisto_linux-v0.45.0 #install kallisto
untar_tool
cp "$tool_dir"/"$tool"/* "$tool_dir_bin"
tool=GenomeAnalysisTK-3.8-1-0-gf15c1c3ef #unzip genome
tar -xjf "$tool".tar.bz2
rm "$tool".tar.bz2
tool=bowtie2-2.3.4.3-linux-x86_64 #install bowtie
toolz
cp "$tool_dir"/"$tool"/* "$tool_dir_bin"
tool=snpEff_latest_core #install snpEff
toolz
tool=hisat2-2.1.0-Linux_x86_64 #install HISAT2
toolz
cp "$tool_dir"/hisat2-2.1.0/* "$tool_dir_bin"
gsettings set org.gnome.desktop.background picture-uri "file://"$AIDDs"/AIDDlogo.jpg"
rm -r "$home_dir"/AIDDscripts
cd