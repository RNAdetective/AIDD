#!/usr/bin/env bash
echo "To run the pipeline simply answer the following few prompts and then the pipeline could take days to weeks to run depending on size and number of files used in experiment.  Please read the manual on the desktop of this virtual machine for more instructions, options, or detailed explanation on the steps involved in the pipeline. Please make sure you have filled out your experimental data in the /home/user/AIDD/index/PHENO_DATA.csv.  Simply go to the path and open  the file in the LibreOffice Calc or text and change the small scale AML tutorial example to your own data files.  Also remember this is the same order you must enter in the following prompts when it asks you for file names.  Make sure you also have your hard drive or shared folder set up prior to running the script.  See the manual for instructions how to set this up.  When this file is saved and all other optional changes have been made from the manual." 

export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin

echo "Please enter the path to working directory (please see manual for instructions on creating your working directory) this working directory is recommended to be at least 500G for optiminal performance.  The small scale AML study tutorial used /media/sf_tutorial/tutorial."
read path
mkdir $path
cd $path
##example shared folder option path /media/"name of your drive"/"name of your file"

echo "Would you like to download sequences from NCBI with SRA number? enter yes to download or no if you would like to run your own data? yes or no."
read data
## answer yes or no

if  [ "$data" == "yes" ]; then
echo "Please enter up to 18 sra file numbers seperated by a space with no punctuation for example in the small scale AML tutorial we use SRR3895734 SRR3895735 SRR1575102 SRR1575103"
read varname1 varname2 varname3 varname4 varname5 varname6 varname7 varname8 varname9 varname10 varname11 varname12 varname13 varname14 varname15 varname16 varname17 varname18
##example for small scale AML study SRR3895734 SRR3895735 SRR1575102 SRR1575103
fi

if  [ "$data" == "no" ]; then
echo "Please make sure your files (up to 18) are in fastq format in the /home/user/Downloads path and make sure if you have paired end reads they should be in this format NAME_1.fastq NAME_2.fastq but only enter NAME in the following list and list all your file names. example NAME1 NAME2 NAME3 where NAME is the name of your files."
read file1 file2 file3 file4 file5 file6 file7 file8 file9 file10 file11 file12 file13 file14 file15 file16 file17 file18
fi
##this is where you will enter your own data's file names.  If you have single end reads just put the file name without the extension (.fastq) and your files must be in fastq form not fastq.gz you must uncompress them first.  If you have paired end reads they must also be in .fastq format and to distinguish the pairs it should be in XXXXX_1.fastq XXXXX_2.fastq where XXXXX is your file name.  Then simply enter the list XXXXX XXXXX XXXXXX with a space inbetween the name of each file.  Remember it is also important to enter them in the same order as you entered them in the PHENO_DATA index file.
##this will edit Rscripts for your experiment
echo "Please enter how many samples you have in your experiment.  Enter a number 4-18."
read sample

echo "What is the name of condition 1"
read con1
echo "what is the name of condition 2"
read con2

##this changes PHENO_DATA file for individual experiment
sed -i "s/condition_1/$con1/g" /home/user/AIDD/index/PHENO_DATA.csv
sed -i "s/condition_2/$con2/g" /home/user/AIDD/index/PHENO_DATA.csv


##this changes R script for sample count
for i in GLDE.R TLDE.R GOF.R heatmaps.R POItables.R TOF.R topGO.R ; do
if  [ "$sample" == "6" ]; then 
sed -i 's/2:5/2:7/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1:4/1:6/g' /home/user/AIDD/Rscripts/$i
sed -i 's/4:7/4:9/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 9, 10, 11, 12, 13, 14/g' /home/user/AIDD/Rscripts/$i
sed -i "s/condition_1/$con1/g" /home/user/AIDD/Rscripts/$i
sed -i "s/condition_2/$con2/g" /home/user/AIDD/Rscripts/$i
fi

if  [ "$sample" == "8" ]; then 
sed -i 's/2:5/2:9/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1:4/1:8/g' /home/user/AIDD/Rscripts/$i
sed -i 's/4:7/4:11/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 11, 12, 13, 14, 15, 16/g' /home/user/AIDD/Rscripts/$i
sed -i "s/condition_1/$con1/g" /home/user/AIDD/Rscripts/$i
sed -i "s/condition_2/$con2/g" /home/user/AIDD/Rscripts/$i
fi

if  [ "$sample" == "12" ]; then 
sed -i 's/2:5/2:13/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1:4/1:12/g' /home/user/AIDD/Rscripts/$i
sed -i 's/4:7/4:15/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 15, 16, 17, 18, 19, 20/g' /home/user/AIDD/Rscripts/$i
sed -i "s/condition_1/$con1/g" /home/user/AIDD/Rscripts/$i
sed -i "s/condition_2/$con2/g" /home/user/AIDD/Rscripts/$i
fi

if  [ "$sample" == "16" ]; then 
sed -i 's/2:5/2:17/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1:4/1:16/g' /home/user/AIDD/Rscripts/$i
sed -i 's/4:7/4:19/g' /home/user/AIDD/Rscripts/$i
sed -i 's/1, 2, 7, 8, 9, 10, 11, 12/1, 2, 19, 20, 21, 22, 23, 24/g' /home/user/AIDD/Rscripts/$i
sed -i "s/condition_1/$con1/g" /home/user/AIDD/Rscripts/$i
sed -i "s/condition_2/$con2/g" /home/user/AIDD/Rscripts/$i
fi
done

##This will select which genes you would like to investigate
echo "Do you have genes of interest besides ADAR and VEGF?  Please respond yes or no."
read gof

if [ "$gof" == "yes" ] ; then
echo "How many genes do you have in you list?  At this time AIDD can handle 10 of your own genes of interest at one time Please enter a number 1-5."
read num_gof
fi

##this process starts moving index files and creating the Results directory
echo "moving index files for R analysis and setting up directory system for Results from transcriptome assembly"
## this creates directories to store results from stringtie and further downstream analysis
for i in Counts ballgown_in ballgown ballgown2 Results; do
    mkdir $path/$i/
done
## this creates subdirectories in results
for i in DESeq2_gene DESeq2_transcript topGO_gene GenePathway topGO_trans ; do
    mkdir $path/Results/$i/
done
cp -a /home/user/AIDD/index/. $path/Results/DESeq2_gene/
cp -a /home/user/AIDD/index/. $path/Results/DESeq2_transcript/
cp -a /home/user/AIDD/gene_list/. $path/Results/DESeq2_gene/
cp -a /home/user/AIDD/gene_list/. $path/Results/DESeq2_transcript/

cp /home/user/Downloads/PRJNA339538/gene_count_matrix.csv $path/Results/DESeq2_gene/gene_count_matrix.csv
cp /home/user/Downloads/PRJNA339538/transcript_count_matrix.csv $path/Results/DESeq2_transcript/transcript_count_matrix.csv
cp /home/user/Downloads/PRJNA339538/PHENO_DATA.csv $path/Results/DESeq2_gene/PHENO_DATA.csv
cp /home/user/Downloads/PRJNA339538/PHENO_DATA.csv $path/Results/DESeq2_transcript/PHENO_DATA.csv

cd "$path/Results/DESeq2_gene"
echo "Running DESeq2 package for gene level analysis"
## this is the command to run the gene level differential analysis in R using DESeq2 as the main package for analysis
Rscript /home/user/AIDD/Rscripts/GLDE.R
ls $path/Results/DESeq2_gene

##this runs the bargraphs for gene counts
echo "Running R to explore gene of interest including ADAR, VEGF, and your genes"
Rscript /home/user/AIDD/Rscripts/GOF.R

sed -i 's/6:8/9:11/g' /home/user/AIDD/Rscripts/GOF.R
sed -i 's/ADARGene/VEGFGene/g' /home/user/AIDD/Rscripts/GOF.R
Rscript /home/user/AIDD/Rscripts/GOF.R

if [ "$num_gof" == "1" ]; then
sed -i 's/9:11/6/g' /home/user/AIDD/Rscripts/GOF.R
sed -i 's/VEGFGene/Zgenes/g' /home/user/AIDD/Rscripts/GOF.R
Rscript /home/user/AIDD/Rscripts/GOF.R
fi
if [ "$num_gof" == "2" ]; then
sed -i 's/9:11/12:13/g' /home/user/AIDD/Rscripts/GOF.R
sed -i 's/VEGFGene/Zgenes/g' /home/user/AIDD/Rscripts/GOF.R
Rscript /home/user/AIDD/Rscripts/GOF.R
fi
if [ "$num_gof" == "3" ]; then
sed -i 's/9:11/12:14/g' /home/user/AIDD/Rscripts/GOF.R
sed -i 's/VEGFGene/Zgenes/g' /home/user/AIDD/Rscripts/GOF.R
Rscript /home/user/AIDD/Rscripts/GOF.R
fi
if [ "$num_gof" == "4" ]; then
sed -i 's/9:11/12:15/g' /home/user/AIDD/Rscripts/GOF.R
sed -i 's/VEGFGene/Zgenes/g' /home/user/AIDD/Rscripts/GOF.R
Rscript /home/user/AIDD/Rscripts/GOF.R
fi
if [ "$num_gof" == "5" ]; then
sed -i 's/9:11/12:16/g' /home/user/AIDD/Rscripts/GOF.R
sed -i 's/VEGFGene/Zgenes/g' /home/user/AIDD/Rscripts/GOF.R
Rscript /home/user/AIDD/Rscripts/GOF.R
fi
ls $path/Results/DESeq2_gene

##get heatmaps table ready
echo "Running R to make tables for pathways with results"
mkdir /home/user/temp
for i in resultsall.csv PHENO_DATA.csv gene_count_matrixedited.csv ; do
cp $path/Results/DESeq2_gene/$i /home/user/temp/$i
cp $path/Results/DESeq2_gene/$i $path/Results/GenePathway/$i
done

cd /home/user/temp
Rscript /home/user/AIDD/Rscripts/POItables.R

cp -a /home/user/temp/. $path/Results/GenePathway/

ls $path/Results/GenePathway

##this makes heatmaps for tables previously made
cd $path/Results/GenePathway
Rscript /home/user/AIDD/Rscripts/heatmaps.R
##this removes no longer needed temp files
for files in /home/user/temp/ ; do
 rm $files
done
ls $path/Results/GenePathway
## this does topGO
cp $path/Results/DESeq2_gene/Upreg.csv $path/Results/topGO_gene/
cp $path/Results/DESeq2_gene/Downreg.csv $path/Results/topGO_gene/
cp /home/user/AIDD/index/annotations2.csv $path/Results/topGO_gene/
cd $path/Results/topGO_gene
Rscript /home/user/AIDD/Rscripts/GtopGO.R
## this does transcript level
cd $path/Results/DESeq2_transcript
Rscript /home/user/AIDD/Rscripts/TLDE.R
##this runs the bargraphs for gene counts
echo "Running R to explore gene of interest including ADAR, VEGF, and your genes"
Rscript /home/user/AIDD/Rscripts/TOF.R

cd $path/Results/topGO_trans
for i in Upregtrans.csv Downregtrans.csv PHENO_DATA.csv annotations2.csv ; do
cp $path/Results/DESeq2_transcript/$i $path/Results/topGO_trans
done
echo "Running R to run gene enrichment with topGO"
Rscript /home/user/AIDD/Rscripts/TtopGO.R

cp -a /home/user/AIDDScripts/Rscripts/. /home/user/AIDD/Rscripts/
cp -a /home/user/AIDDScripts/index/. /home/user/AIDD/index/
cp -a /home/user/AIDDScripts/gene_list/. /home/user/AIDD/gene_list/
