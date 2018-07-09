#!/usr/bin/env bash
main_function() {
##other python scripts
## this creates .gff input files from the count .gtf file from stringtie output using a python script for DEXseq exon counting analysis however these are not used in the default pipeline they are generated if more advanced user would like to run DEXseq.
##echo "Starting python script to find exon counts for DEXSeq2"
##for i in 0{1..9} {10..18}
##do
## python /home/user/AIDD/AIDD_tools/bin/dexseq_prepare_annotation.py $path/ballgown/${samp}.gtf $path/DEXSeq/${samp}.gff
##done
##echo "Starting python script to find exon counts for DEXSeq2"
##for i in 0{1..9} {10..18}
##do
 ##  python /home/user/AIDD/AIDD_tools/bin/dexseq_count.py $path/ballgown/${samp}.gff $path/${samp}/${samp}.sam $path/DEXSeq/${samp}
##done
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/pythonscripts.log
