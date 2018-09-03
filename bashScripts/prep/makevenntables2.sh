#!/usr/bin/env bash
##this is the output file regulationregidGlistclasscell_line.csv
##this will combine all 3 cell types into one table for gene level and transcript level and well as for up and down regulated and all genes/transcripts or just the top 100 genes/transcripts into a csv ready for venn diagrams comparing all three cell lines that are up reg or down reg in either gene or transcript level. 
for i in gene transcript ; do
for j in upreg downreg ; do
for k in vennall top100 ; do
paste -d , /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"idGlist"$k"*.csv > /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"idGlist"$k".csv
mv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/"$j"idGlist"$k".csv /media/sf_AIDD/Results/DESeq2/"$i"/differential_expression/venndiagrams/
done
done
done
