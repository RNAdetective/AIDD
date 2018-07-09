#!/usr/bin/env bash
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "Please see the manual for set up and instructions to run AIDD.  Make sure before you start you have created the auto mount shared folder called AIDD on your host computer.  Please follow the prompts to fill in the details for your experiment."
## this runs script to create folder system and sets up references and scripts for analysis.
bash /home/user/AIDD/bashScripts/prep/foldersystem.sh
echo "would you like to run with defaults? 1=yes, 2=no"
read default
if [ "$default" == "2" ]; then
##this allows for download of sequences or starting with your own .fastq files
echo "Are you downloading sequences from NCBI 1=(default)yes 2=no"
read sra
## this allows for selection between paired and single end data
echo "Please enter library layout type: 1=(default)paired or 2=single"
read library
## this allows for alternative aligners to be used
echo "Which aligner would you like to use? 1=(default)HISAT2, 2=STAR 3=salmon"
read aligner 
## this allows for choice of running variant calling now or later
echo "Would you like to do variant calling at this time? 1=(default)yes 2=no"
read variant
## this allows for bivariate data or multivariate experimental set-up
echo "Choose a set up for your experiment.  1=(default)2 conditions 2 groups, 2=2 taking into account an interaction term"
read design
else
sra="1"
library="1"
aligner="1"
variant="1"
design="1"
fi
##this will edit Rscripts for downstream analysis
bash /media/sf_AIDD/bashScripts/prep/Rscript_edits.sh
#this downloads and creates all necessary reference files and sra files if needed.
bash /media/sf_AIDD/bashScripts/prep/downloads.sh
##this will convert .sra depending on library layout and if you want to download sra files 
if  [ "$sra" == "1" ]; then
echo "Starting SRA downloads"
if  [ "$library" == "1" ]; then
bash /media/sf_AIDD/bashScripts/prep/downloads_sra.sh
else 
bash /media/sf_AIDD/bashScripts/prep/downloads_sraSingle.sh
fi
fi
if [ "$sra" == "2" ]; then
echo "Starting moving fastq files"
if [ "$library" == "1" ]; then
bash /media/sf_AIDD/bashScripts/prep/move.sh
else
bash /media/sf_AIDD/bashScripts/prep/moveSingle.sh
fi
fi
## this will trim sequences if they need to be trimmed.
echo "Please evaluate your fastqc results and find out if you need to trim your fastq files. Do you need to trim 1=yes, 2=no."
read trim
if [ "$trim" == "1" ]; then
echo "Please enter which nucleotide to start new trimmed reads at. Please enter a number."
read start
echo "Please enter which nucleotide to end the new trimmed reads at. Please enter a number."
read end
sed -i "s/"start"/"$start"/g" /media/sf_AIDD/bashScripts/prep/trim.sh
sed -i "s/"start"/"$start"/g" /media/sf_AIDD/bashScripts/prep/trimSingle.sh
sed -i "s/"end"/"$end"/g" /media/sf_AIDD/bashScripts/prep/trim.sh
sed -i "s/"end"/"$end"/g" /media/sf_AIDD/bashScripts/prep/trimSingle.sh
if [ "$library" == "1" ]; then
echo "Starting trimming fastq files"
bash /media/sf_AIDD/bashScripts/prep/trim.sh
else
bash /media/sf_AIDD/bashScripts/prep/trimSingle.sh
fi
fi
## this will run HISAT2
if [ "$aligner" == "1" ]; then
echo "Starting alignment fastq files"
if [ "$library" == "1" ]; then
bash /media/sf_AIDD/bashScripts/align_assemble/HISAT2.sh
else
bash /media/sf_AIDD/bashScripts/align_assemble/HISAT2Single.sh
fi
fi
## this will convert sam to bam and then run stringtie
bash /media/sf_AIDD/bashScripts/align_assemble/assembly.sh
##this is the python script to transform all gtf count files into one matrix file for usage in R analysis.
echo "Starting python script to find gene and transcript counts"
cd /media/sf_AIDD/raw_data/
python /home/user/AIDD/AIDD_tools/bin/prepDE.py -g /media/sf_AIDD/Results/DESeq2/gene/counts/gene_count_matrix.csv -t /media/sf_AIDD/Results/DESeq2/transcript/counts/transcript_count_matrix.csv
cd "/home/user/"
Rscript /media/sf_AIDD/Rscripts/matrixedit.R

if  [ "$design" == "1" ]; then
bash /media/sf_AIDD/bashScripts/Rscripts/Rscripts.sh
fi
if  [ "$design" == "2" ]; then
bash /media/sf_AIDD/bashScripts/Rscripts/Rscripts2.sh
fi
if [ "$variant" == "1" ]; then
bash /media/sf_AIDD/bashScripts/variantcalling/VariantCalling.sh
fi
if [ "$variant" == "2" ]; then
echo "You can run variant calling at a later date by typing bash /media/sf_AIDD/VariantCalling.sh and following the onscreen prompts.  Your logs of this session are stored in the logs folder.  To start another experiment please move all files out of the main sf_AIDD."


