#!/usr/bin/env bash
main_function() {
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

##echo "Please enter how many samples you have in your experiment.  Enter a number 4-18."
##read sample
##for i in {5..18}
##if  [ "$sample" == "$i" ]; then 
##sed -i 's/2:5/2:17/g' /home/user/AIDD/Rscripts/GLDE.R
##sed -i 's/1:4/1:16/g' /home/user/AIDD/Rscripts/GLDE.R
##sed -i 's/1, 1+$i, 7, 8, 9, 10, 11/1, 18, 19, 20, 21, 22, 23/g' /home/user/AIDD/Rscripts/GLDE.R
##sed -i 's/2:5/2:17/g' /home/user/AIDD/Rscripts/TLDE.R
##sed -i 's/1:4/1:16/g' /home/user/AIDD/Rscripts/TLDE.R
##sed -i 's/1, 6, 7, 8, 9, 10, 11/1, 18, 19, 20, 21, 22, 23/g' /home/user/AIDD/Rscripts/TLDE.R
##fi

echo "Please enter how many samples you have in your experiment.  Enter a number 4-18."
read sample
 for i in GLDE.R TLDE.R ; do
if  [ "$sample" == "16" ]; then 
sed -i 's/2:5/2:17/g' /home/user/AIDD/Rscripts/GLDE.R
sed -i 's/1:4/1:16/g' /home/user/AIDD/Rscripts/GLDE.R
sed -i 's/1, 6, 7, 8, 9, 10, 11/1, 18, 19, 20, 21, 22, 23/g' /home/user/AIDD/Rscripts/GLDE.R
sed -i 's/2:5/2:17/g' /home/user/AIDD/Rscripts/TLDE.R
sed -i 's/1:4/1:16/g' /home/user/AIDD/Rscripts/TLDE.R
sed -i 's/1, 6, 7, 8, 9, 10, 11/1, 18, 19, 20, 21, 22, 23/g' /home/user/AIDD/Rscripts/TLDE.R
fi
done

##this process starts moving index files and creating the Results directory
echo "moving index files for R analysis and setting up directory system for Results from transcriptome assembly"
## this creates directories to store results from stringtie and further downstream analysis
for i in Counts ballgown_in ballgown ballgown2 Results; do
    mkdir $path/$i/
done
## this creates subdirectories in results
for i in DESeq2_gene DESeq2_pathway DESeq2_transcript ; do
    mkdir $path/Results/$i/
done
cp -a /home/user/AIDD/index/. $path/Results/DESeq2_gene/
cp -a /home/user/AIDD/index/. $path/Results/DESeq2_transcript/
cp -a /home/user/AIDD/gene_list/. $path/Results/DESeq2_gene/
cp -a /home/user/AIDD/gene_list/. $path/Results/DESeq2_transcript/
cp /home/user/Downloads/gene_count_matrix.csv $path/Results/DESeq2_gene/gene_count_matrix.csv
cp /home/user/Downloads/transcript_count_matrix.csv $path/Results/DESeq2_transcript/transcript_count_matrix.csv
echo "Starting Rscript for Gene Level Differential expression analysis"
cd "$path/Results/DESeq2_gene"
## this is the command to run the gene level differential analysis in R using DESeq2 as the main package for analysis
Rscript /home/user/AIDD/Rscripts/GLDE.R
##now the transcript level R script will run after changing working directories to transcript folders
cd "$path/Results/DESeq2_transcript"
Rscript /home/user/AIDD/Rscripts/TLDE.R
##this moves index files for topGO_gene and moves the input files into working directory for R
mkdir $path/Results/topGO_gene
cp "/home/user/AIDD/index/annotations2.csv" "$path/Results/topGO_gene/annotations2.csv"
cp "$path/Results/DESeq2_gene/Upreg.csv" "$path/Results/topGO_gene/Upreg.csv"
cp "$path/Results/DESeq2_gene/Downreg.csv" "$path/Results/topGO_gene/Downreg.csv"
cd "$path/Results/topGO_gene"
Rscript /home/user/AIDD/Rscripts/topGO.R
echo "contents of $path"
ls $path
echo "contents of $path/Results"
ls $path/Results
echo "contents of $path/Results/DESeq2_gene"
ls $path/Results/DESeq2_gene
echo "contents of $path/Results/DESeq2_transcript"
ls $path/Results/DESeq2_transcript
echo "contents of $path/Results/topGO_gene"
ls $path/Results/topGO_gene
}
main_function 2>&1 | tee -a AIDDrun.log


##echo "Please enter how many samples you have in your experiment.  Enter a number 4-18."
##read sample
##echo "Please enter the name of your first condition."
##read con1
##echo "Please enter the name of your second condition."
##read con2
## for i in GLDE.R TLDE.R topGO.R variantcalling.R ; do
##sed -i 's/A1/$con1/g' $i
##sed -i 's/B1/$con2/g' $i
##if  [ "$sample" == "16" ]; then 
##sed -i 's/2:5/2:17/g' GLDE.R
##sed -i 's/1:4/1:16/g' GLDE.R
##sed -i 's/1, 6, 7, 8, 9, 10, 11/1, 18, 19, 20, 21, 22, 23/g' GLDE.R
##sed -i 's/2:5/2:17/g' TLDE.R
##sed -i 's/1:4/1:16/g' TLDE.R
##sed -i 's/1, 6, 7, 8, 9, 10, 11/1, 18, 19, 20, 21, 22, 23/g' TLDE.R
##fi
##done
