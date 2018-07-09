#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/working_directory/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do  ##I would like to try to combine then first and then do these steps so it is all in one count table.
    vcftools --vcf /media/sf_AIDD/vcf_files/$runfiltered_snps_final.vcf --freq --out /media/sf_AIDD/Results/variant_calling/freq/$runfreq.vcf
    vcftools --vcf /media/sf_AIDD/vcf_files ##add more command besides freq, also look up nt subs and codon sub matric creation too.
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/VCfreq.log
