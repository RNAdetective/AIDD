mv /home/user/AIDD/AIDD_tools/snpEff/snpEff.jar /home/user/AIDD/AIDD_tools/snpEff.jar
rm -r /home/user/AIDD/AIDD
wget https://github.com/RNAdetective/AIDD/raw/master/AIDDscripts.tar.gz #this will get pipeline scripts
tar -vxzf AIDDscripts.tar.gz #uncompress them
rm AIDDscripts.tar.gz #remove compressed file
cp -r /home/user/AIDDscripts/* /home/user/AIDD/AIDD/ #moves all the updated scripts to the correct directory

