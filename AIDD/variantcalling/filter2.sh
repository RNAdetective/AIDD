#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ##second round of filtering same steps as first roung
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_variants_recal.vcf -selectType SNP -o /media/sf_AIDD/working_directory/"$run"raw_snps_recal.vcf
    mv /media/sf_AIDD/working_directory/"$run"raw_snps_recal.vcf /media/sf_AIDD/raw_data/vcf_files/
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp  -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantsToTable -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_snps_recal.vcf -F CHROM -F POS -F ID -F QUAL -F AC -F BaseCounts -o /media/sf_AIDD/raw_data/vcf_files/"$run"raw_snps_recal.table
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_variants_recal.vcf -selectType INDEL -o /media/sf_AIDD/working_directory/"$run"raw_indels_recal.vcf
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_snps_recal.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o /media/sf_AIDD/working_directory/"$run"filtered_snps_final.vcf
    mv /media/sf_AIDD/working_directory/"$run"filtered_snps_final.vcf /media/sf_AIDD/raw_data/vcf_files/
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp  -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantsToTable -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"filtered_snps_final.vcf -F CHROM -F POS -F ID -F QUAL -F AC -F BaseCounts -o /media/sf_AIDD/raw_data/vcf_files/"$run"filtered_snps_final.table
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_indels_recal.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o /media/sf_AIDD/working_directory/"$run"filtered_indels_recal.vcf
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/filter2.log

