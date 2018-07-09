#!/usr/bin/env bash
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/home/user/AIDD/extra/split.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  batch rows
do
sed -i "s/chunk_column/"$batch"/g" /home/user/AIDD/extra/split.R
sed -i "s/rows_column/"$rows"/g" /home/user/AIDD/extra/split.R
Rscript /home/user/AIDD/extra/split.R
sed -i "s/"$batch"/chunk_column/g" /home/user/AIDD/extra/split.R
sed -i "s/"$rows"/rows_column/g" /home/user/AIDD/extra/split.R
done < $INPUT
IFS=$OLDIFS


