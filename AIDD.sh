#!/usr/bin/env bash
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "Please see the manual for set up and instructions to run AIDD.  Make sure before you start you have created the auto mount shared folder called AIDD on your host computer and completed the directions on the desktop. Please follow the prompts to fill in the details for your experiment."
echo "would you like to run with defaults?  This includes downloading files from sra, paired end read datasets, HISAT2 aligner and running with variant calling if you would like to run defaults type 1=yes, or 2=no"
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
echo "Choose a set up for your experiment.  1=(default)comparing 2 conditions with no other groupings, or 2=comparing 2 conditions with 2 or more conditions or 3=no conditions just testing variation in the system within three of more groups"
read design
else
sra="1"
library="1"
aligner="1"
variant="1"
design="1"
fi
## this runs script to create folder system and sets up references and scripts for analysis.
bash /home/user/AIDD/AIDD/prep/directories.sh
#this downloads and creates all necessary reference files and sra files if needed.
bash /media/sf_AIDD/AIDD/prep/downloads.sh
##this will convert .sra depending on library layout and if you want to download sra files 
if  [ "$sra" == "1" ]; then
echo "Starting SRA downloads"
if  [ "$library" == "1" ]; then
echo "Please stay connected to the internet for the next few hours while downloading samples from ncbi.  If you loose internet connect and the program fails to download sequences you will have to make sure all corupt files are deleted from /home/user/ncbi/public/sra.  Then try to run the pipeline again once the internet issues have been resolved.  IF you have more issue check the quality_control/log folder for details and error report to fix problem."
bash /media/sf_AIDD/AIDD/prep/downloads_sra.sh
else 
bash /media/sf_AIDD/AIDD/prep/downloads_sraSingle.sh
fi
fi
if [ "$sra" == "2" ]; then
echo "Starting moving fastq files from desktop directory"
if [ "$library" == "1" ]; then
bash /media/sf_AIDD/AIDD/prep/move.sh
else
bash /media/sf_AIDD/AIDD/prep/moveSingle.sh
fi
fi
## this will trim sequences if they need to be trimmed and recheck quality control.  Need to set start and end points before you can run.
echo "Please evaluate your fastqc results that are located in media/sf_AIDD/quality_control/fastqc and find out if you need to trim your fastq files. Do you need to trim 1=yes, 2=no."
read trim
if [ "$trim" == "1" ]; then
echo "Please enter which nucleotide to start new trimmed reads at. Please enter a number."
read start
echo "Please enter which nucleotide to end the new trimmed reads at. Please enter a number."
read end
sed -i "s/"start"/"$start"/g" /media/sf_AIDD/AIDD/prep/trim.sh
sed -i "s/"start"/"$start"/g" /media/sf_AIDD/AIDD/prep/trimSingle.sh
sed -i "s/"end"/"$end"/g" /media/sf_AIDD/AIDD/prep/trim.sh
sed -i "s/"end"/"$end"/g" /media/sf_AIDD/AIDD/prep/trimSingle.sh
if [ "$trim" == "1" ]; then
echo "Starting trimming fastq files"
bash /media/sf_AIDD/AIDD/prep/trim.sh
else
bash /media/sf_AIDD/AIDD/prep/trimSingle.sh
fi
fi
## this will run HISAT2
if [ "$aligner" == "1" ]; then
echo "Starting alignment fastq files"
if [ "$library" == "1" ]; then
bash /media/sf_AIDD/AIDD/align_assemble/HISAT2.sh
else
bash /media/sf_AIDD/AIDD/align_assemble/HISAT2Single.sh
fi
fi
## this will convert sam to bam and then run stringtie
bash /media/sf_AIDD/AIDD/align_assemble/assembly.sh
##this is the python script to transform all gtf count files into one matrix file for usage in R analysis.
echo "Starting python script to find gene and transcript counts"
cd /media/sf_AIDD/raw_data/
python /home/user/AIDD/AIDD_tools/bin/prepDE.py -g /media/sf_AIDD/Results/DESeq2/gene/counts/gene_count_matrix.csv -t /media/sf_AIDD/Results/DESeq2/transcript/counts/transcript_count_matrix.csv
cd "/home/user/"
echo "Starting AIDDExtoolset these next steps with run GEX, TEX, and PEX tools"
if [ "$design" == "1" ]; then
bash /media/sf_AIDD/ExToolset/GEX_TEX.sh
bash /media/sf_AIDD/ExToolset/PEX.sh
fi
if [ "$design" == "2" ]; then
bash /media/sf_AIDD/ExToolset/GEX_TEXcell_line.sh
fi
if [ "$design" == "3" ]; then
bash /media/sf_AIDD/ExToolset/GEX_TEXvariance.sh
fi
##this will run variant calling
if [ "$variant" == "1" ]; then
bash /media/sf_AIDD/AIDD/variantcalling/VariantCalling.sh
if [ "$design" == "1" ]; then
bash /media/sf_AIDD/ExToolset/G_VEX.sh
bash /media/sf_AIDD/ExToolset/I_VEX.sh
##bash /media/sf_AIDD/ExToolset/C_VEX.sh
fi
if [ "$design" == "2" ]; then
bash /media/sf_AIDD/ExToolset/G_VEXcell_line.sh
bash /media/sf_AIDD/ExToolset/I_VEXcell_line.sh
bash /media/sf_AIDD/ExToolset/C_VEXcell_line.sh
fi
if [ "$design" == "2" ]; then
bash /media/sf_AIDD/ExToolset/G_VEXvariance.sh
bash /media/sf_AIDD/ExToolset/I_VEXvariance.sh
bash /media/sf_AIDD/ExToolset/C_VEXvariance.sh
fi
else
echo "You can run variant calling at a later date by typing bash /media/sf_AIDD/VariantCalling.sh and following the onscreen prompts.  Your logs of this session are stored in the logs folder.  To start another experiment please move all files out of the main sf_AIDD"
fi
