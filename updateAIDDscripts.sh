mv /home/user/AIDD/AIDD_tools/snpEff/snpEff.jar /home/user/AIDD/AIDD_tools/snpEff.jar
mv /home/user/AIDD/AIDD_tools/snpEff/snpEff.jar /home/user/AIDD/AIDD_tools/snpEff.config
rm -r /home/user/AIDD/AIDD
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDscripts.tar.gz #this will get pipeline scripts
tar -vxzf AIDDscripts.tar.gz #uncompress them
rm AIDDscripts.tar.gz #remove compressed file
mkdir /home/user/AIDD/AIDD
cp -r /home/user/AIDDscripts/* /home/user/AIDD/AIDD/ #moves all the updated scripts to the correct directory
AIDDs=/home/user/AIDD/AIDD
gsettings set org.gnome.desktop.background picture-uri "file://"$AIDDs"/AIDDlogo.jpg"
rm -r /home/user/AIDDscripts
