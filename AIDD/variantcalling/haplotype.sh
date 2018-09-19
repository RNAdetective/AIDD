#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    echo "Starting haplotype calling this can take several hours for each sample depending on read depth"
    ##have to create bam index for each bam file
    java -jar /home/user/AIDD/AIDD_tools/picard.jar BuildBamIndex INPUT=/media/sf_AIDD/working_directory/"$run"_dedup_reads.bam
    ##starts haplotype caller with rna-seq common parameters
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp  -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T HaplotypeCaller -R /media/sf_AIDD/references/ref2.fa -I /media/sf_AIDD/working_directory/"$run"_dedup_reads.bam --dbsnp /media/sf_AIDD/references/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 -A BaseCounts --max_alternate_alleles 40 -o /media/sf_AIDD/working_directory/"$run"raw_variants.vcf
    ##this moves vcf files to raw data folder and cleans working directory
    mv /media/sf_AIDD/working_directory/"$run"raw_variants.vcf /media/sf_AIDD/raw_data/vcf_files/
    ##converts raw vcf files into table for easier use.
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp  -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantsToTable -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"raw_variants.vcf -F CHROM -F POS -F ID -F QUAL -F AC -F BaseCounts -o /media/sf_AIDD/raw_data/vcf_files/"$run"raw_variants.table
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/haplotype.log
