Place you matrix files here.

Step 1: Place all folders and files into the folder on the desktop called put_counts_here

You need to have the alignment_metrics summary folder with all samples listed in PHENO_DATA file having a csv derived from variant calling part of AIDD or instead you can put the all read depth summary matrix file

You need to have the ballgown folder from raw_data from AIDD results or alternatively both gene_count_matrix.csv and transcript_matrix.csv if those were created already

You need to have the snpEff folder from raw_data from AIDD results including all output for all samples in PHENO_DATA file

Step 2: copy and paste the following command into the command prompt

bash /home/user/AIDD/ExToolset.sh 2 /home/user /media/sf_AIDD
/media/sf_AIDD can be changed to whatever directory you would like to save the results too

