#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do

    rm /media/sf_AIDD/working_directory/"$run"_alignment_metrics.txt
    rm /media/sf_AIDD/working_directory/"$run"_insert_metrics.txt
    rm /media/sf_AIDD/working_directory/"$run"_insert_size_histogram.pdf
    rm /media/sf_AIDD/working_directory/"$run"depth_out.txt
    rm /media/sf_AIDD/working_directory/"$run"raw_variants.vcf
    rm /media/sf_AIDD/working_directory/"$run"recalibration_plots.pdf
    rm /media/sf_AIDD/working_directory/"$run"post_recal_data.table
    rm /media/sf_AIDD/working_directory/"$run"recal_data.table 
    rm /media/sf_AIDD/working_directory/"$run"filtered_indels.vcf
    rm /media/sf_AIDD/working_directory/"$run"filtered_snps.vcf
    rm /media/sf_AIDD/working_directory/"$run"raw_indels.vcf
    rm /media/sf_AIDD/working_directory/"$run"raw_snps.vcf
    rm /media/sf_AIDD/working_directory/"$run"raw_variants_recal.vcf
    rm /media/sf_AIDD/working_directory/"$run"raw_snps_recal.vcf
    rm /media/sf_AIDD/working_directory/"$run"raw_indels_recal.vcf
    rm /media/sf_AIDD/working_directory/"$run"filtered_snps_final.vcf
    rm /media/sf_AIDD/working_directory/"$run"filtered_indels_recal.vcf
    rm /media/sf_AIDD/working_directory/"$run"filtered_indels.vdix
    rm /media/sf_AIDD/working_directory/"$run"filtered_snps.vdix
    rm /media/sf_AIDD/working_directory/"$run"raw_indels.vdix
    rm /media/sf_AIDD/working_directory/"$run"raw_snps.vdix
    rm /media/sf_AIDD/working_directory/"$run"raw_variants_recal.vdix
    rm /media/sf_AIDD/working_directory/"$run"raw_snps_recal.vdix
    rm /media/sf_AIDD/working_directory/"$run"raw_indels_recal.vdix
    rm /media/sf_AIDD/working_directory/"$run"filtered_snps_final.vdix
    rm /media/sf_AIDD/working_directory/"$run"filtered_indels_recal.vdix
    rm /media/sf_AIDD/working_directory/"$run"_3.bam
    rm /media/sf_AIDD/working_directory/"$run"_3.bai
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/removefiles.log

