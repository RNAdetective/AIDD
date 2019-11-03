#!/usr/bin/env bash
home_dir="$1"
echo "Do you want to update AIDD scripts? yes or no"
read answer
if [ "$answer" == "yes" ];
then
  echo "Now updating AIDD scripts"
  rm -r "$home_dir"/AIDD/AIDD
  wget https://github.com/RNAdetective/AIDD/raw/master/AIDDscripts.tar.gz #this will get pipeline scripts
  tar -vxzf AIDDscripts.tar.gz #uncompress them
  rm AIDDscripts.tar.gz #remove compressed file
  mkdir "$home_dir"/AIDD/AIDD
  cp -r "$home_dir"/AIDDscripts/* /home/user/AIDD/AIDD/ #moves all the updated scripts to the correct directory
  AIDDs="$home_dir"/AIDD
  gsettings set org.gnome.desktop.background picture-uri "file://"$AIDDs"/AIDDlogo.jpg"
  rm -r "$home_dir"/AIDDscripts
else
  echo "Not updating AIDD scripts and leaving current AIDD scripts as is."
fi
