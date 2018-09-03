#!/usr/bin/env bash
cell_linename1=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename2=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/cell_line.csv)
cell_linename3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/cell_line.csv)
##this does the same as above but it will combine gene with transcript to compare each cell line gene verse transcript lists to find unique only found in transcript analysis that would have been missed by gene level analysis.
for j in upreg downreg ; do
for k in vennall top100 ; do
for l in $cell_linename1 $cell_linename2 $cell_linename3 ; do
paste -d , /media/sf_AIDD/Results/DESeq2/gene/differential_expression/"$j"idGlist"$k""$l".csv /media/sf_AIDD/Results/DESeq2/transcript/differential_expression/"$j"idGlist"$k""$l".csv > /media/sf_AIDD/Results/DESeq2/gene/differential_expression/"$j"idGlist"$k""$l"added.csv
mv /media/sf_AIDD/Results/DESeq2/gene/differential_expression/"$j"idGlist"$k""$l"added.csv /media/sf_AIDD/Results/DESeq2/gene/differential_expression/venndiagrams/
done
done
done

