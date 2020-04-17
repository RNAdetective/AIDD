#!/usr/bin/env bash
home_dir=/home/user
dir_path=/media/sf_AIDD/AIDD_data
ExToolset="$home_dir"/AIDD/AIDD/ExToolset
echo "Which tool from ExToolset would you like to run? Please choose one of the following:ANOVA will run ANOVA on all columns in your matrix and then summarize need to have phenodata file merged with your matrix. DESeq2 will run differential analysis on user supplied matrix. Corr will run correlations for ADAR genes and editing frequencies in the csv in the index file in the AIDD folder. GEApanther takes output from panther see manual for format and produces bargraphs. Guttman runs guttman scale on user supplied matrix with one condition in the first column. Frequency needs bam files see manual for more information. It will create frequency count matrix for the entire excitome from bam files.
ANOVA, DESeq2, corr, GEApanther, Guttman, Frequency or split"
read Tool
if [[ "$Tool" == "ANOVA" || "$Tool" == "DESeq2" ]];
then
  echo "What is the name of your input matrix that is located in the desktop folder called put count here?"
  read userinput
fi
echo "Do you need to set up AIDD directories? Please choose one of the following:
yes or no"
read directories
if [ "$directories" == yes ];
then
  bash "$ExToolset"/AIDD.sh "$home_dir" "$dir_path"
fi
inputdir=/home/user/put_counts_here
cp "$inputdir"/"$userinput" "$dir_path"/Results
if [ "$Tool" == "ANOVA" ];
then
  bash "$ExToolset"/ExToolset"$Tool".sh "$userinput"
fi
if [ "$Tool" == "DESeq2" ];
then
  bash "$ExToolset"/ExToolset"$Tool".sh "$userinput"
fi
if [ "$Tool" == "correlation" ];
then
  echo "bash "$ExToolset"/ExToolsetcorr.sh"
fi
if [ "$Tool" == "GEApanther" ];
then
  echo "This feature will be added in AIDDv2.0"
fi
if [ "$Tool" == "Guttman" ];
then
  echo "automated Guttman scale matrix can be created by running Frequency from the first prompt. However visualization is not automated at this time."
fi
if [ "$Tool" == "Frequency" ];
then
  echo "Do you need to move bam files to AIDD directories? Please choose one of the following:
yes or no"
  read movebam
  if [ "$movebam" == "yes" ];
  then
    echo "Where are your bam files located?"
    read bamdir
    cp "$bamdir"/* "$dir_path"/raw_data/bam_files
  fi
  cd "$dir_path"/AIDD
  bash "$ExToolset"/ExToolset"$Tool".sh "$dir_path"/AIDD_data
fi
if [ "$Tool" == "split" ];
then
  echo "This feature to split you pheno_data file into condition will be available in AIDDv2.0"
fi


