#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp -jar /home/user/AIDD/AIDD_tools/snpEff.jar -v GRCh37.75 /media/sf_AIDD/working_directory/"$run"filtered_snps_final.vcf -stats /media/sf_AIDD/raw_data/snpEff/"$run" -csvStats /media/sf_AIDD/raw_data/snpEff"$run".csv > /media/sf_AIDD/raw_data/snpEff/"$run"filtered_snps_final.ann.vcf
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/tmp  -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantsToTable -R /media/sf_AIDD/references/ref2.fa -V /media/sf_AIDD/working_directory/"$run"filtered_snps_final.ann.vcf -F CHROM -F POS -F ID -F QUAL -F AC -F BaseCounts -o /media/sf_AIDD/raw_data/vcf_files/"$run"filtered_snps_final.ann.table
    mv /media/sf_AIDD/raw_data/*.csv /media/sf_AIDD/raw_data/snpEff/
    mv /media/sf_AIDD/raw_data/*.txt /media/sf_AIDD/raw_data/snpEff/
    sed 's/ \+/,/g' /media/sf_AIDD/raw_data/snpEff/snpEff"$run".genes.txt > /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv
done < $INPUT
IFS=$OLDIFS
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/snpEff.log