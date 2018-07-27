#!/usr/bin/env bash

export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/home/user/Downloads/sequenceofinterest.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x sequencename
do
    grep '[^[:blank:]]' < "$sequencename"clean.fa > "$sequencename"cleaner.fa
done < $INPUT
IFS=$OLDIFS