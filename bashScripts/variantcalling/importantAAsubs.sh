#!/bin/bash
for F in /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/globalrun_namesubs.txt
do
    {
        read QtoR
        read RtoG
        read ItoV
    } < $F
    echo "$QtoR,$RtoG,$ItoV" >> /media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/run_nameAAsubs.csv
done
