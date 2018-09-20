#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    ##creates fitered variants
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_variants.vcf -selectType SNP -o /media/sf_AIDD/working_directory/"$run"raw_snps.vcf
    ##moves files
    mv /media/sf_AIDD/working_directory/"$run"raw_snps.vcf /media/sf_AIDD/raw_data/vcf_files/
    ##runs variants to table for easier viewing of vcf files
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp  -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantsToTable -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -F BaseCounts -o /media/sf_AIDD/raw_data/vcf_files/"$run"raw_snps.table
    ##select more variants for filtering
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_variants.vcf -selectType INDEL -o /media/sf_AIDD/working_directory/"$run"raw_indels.vcf
    ##starting filtering steps
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_snps.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o /media/sf_AIDD/working_directory/"$run"filtered_snps.vcf
    ##moves and converts vcf filtered snp file into table
    mv /media/sf_AIDD/working_directory/"$run"filtered_snps.vcf /media/sf_AIDD/raw_data/vcf_files/
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp  -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantsToTable -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"filtered_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -F BaseCounts -o /media/sf_AIDD/raw_data/vcf_files/"$run"filtered_snps.table
    ##more filtering
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_indels.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o /media/sf_AIDD/working_directory/"$run"filtered_indels.vcf
    ##rns base recalibrator to create new bam files with filtering taken into account
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T BaseRecalibrator -R /media/sf_AIDD/references/ref2.fa -I /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam -knownSites /media/sf_AIDD/working_directory/"$run"filtered_snps.vcf -knownSites /media/sf_AIDD/working_directory/"$run"filtered_indels.vcf --filter_reads_with_N_cigar -o /media/sf_AIDD/working_directory/"$run"recal_data.table
    ##moves and converts vcf files
    mv /media/sf_AIDD/working_directory/"$run"recal_data.table /media/sf_AIDD/quality_control/recalibration_plots/
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T BaseRecalibrator -R /media/sf_AIDD/references/ref2.fa -I /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam -knownSites /media/sf_AIDD/working_directory/"$run"filtered_snps.vcf -knownSites /media/sf_AIDD/working_directory/"$run"filtered_indels.vcf -BQSR /media/sf_AIDD/working_directory/"$run"recal_data.table --filter_reads_with_N_cigar -o /media/sf_AIDD/working_directory/"$run"post_recal_data.table
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T AnalyzeCovariates -R /media/sf_AIDD/references/ref2.fa -before /media/sf_AIDD/working_directory/"$run"recal_data.table -after /media/sf_AIDD/working_directory/"$run"post_recal_data.table -plots /media/sf_AIDD/working_directory/"$run"recalibration_plots.pdf
    ##creates new bam file containing filtering data.
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T PrintReads -R /media/sf_AIDD/references/ref2.fa -I /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam -BQSR /media/sf_AIDD/working_directory/"$run"recal_data.table --filter_reads_with_N_cigar -o /media/sf_AIDD/working_directory/"$run"recal_reads.bam
    rm /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam
    ##moves recalibration plots to quality control directories for later user evaluation
    mv /media/sf_AIDD/working_directory/"$run"post_recal_data.table /media/sf_AIDD/quality_control/recalibration_plots/
    mv /media/sf_AIDD/working_directory/"$run"recalibration_plots.pdf /media/sf_AIDD/quality_control/recalibration_plots/
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/filter.log