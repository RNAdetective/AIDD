#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "which step would you like to start on? 1=beginning 2=markduplicates 3=haplotype 4=haplotype 5=filter 6=haplotype2 7=filter2 8=snpEff 9=bedtools 10=RscriptVC 11=mutech2?" ##add in the mutech2
read steps
if [ "$steps" == "1" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/prepbam.sh
bash /home/user/AIDD/bashScripts/variantcalling/markduplicates.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/raw_variantsNoounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recalNoounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recal/raw_snps_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recal/raw_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recal/filtered_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recalNoCounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recalNoCounts/raw_snps_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recalNoCounts/raw_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recalNoCounts/filtered_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "2" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/markduplicates.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/raw_variantsNoounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recalNoounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recal/raw_snps_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recal/raw_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recal/filtered_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recalNoCounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recalNoCounts/raw_snps_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recalNoCounts/raw_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recalNoCounts/filtered_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "3" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/raw_variantsNoounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recalNoounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recal/raw_snps_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recal/raw_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recal/filtered_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recalNoCounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recalNoCounts/raw_snps_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recalNoCounts/raw_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recalNoCounts/filtered_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "4" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recalNoounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recal/raw_snps_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recal/raw_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recal/filtered_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recalNoCounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recalNoCounts/raw_snps_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recalNoCounts/raw_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recalNoCounts/filtered_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "5" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0 -A BaseCounts/20.0/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/20.0/20.0 -A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/raw_variants_recalNoounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recal/raw_snps_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recal/raw_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recal/filtered_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recalNoCounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recalNoCounts/raw_snps_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recalNoCounts/raw_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recalNoCounts/filtered_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "6" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recal/raw_variants_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recal/raw_snps_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recal/raw_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recal/filtered_indels_recalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_variants_recalNoCounts/raw_variants_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_snps_recalNoCounts/raw_snps_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/raw_indels_recalNoCounts/raw_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/filtered_indels_recalNoCounts/filtered_indels_recal/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "7" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_final/filtered_snps_finalNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC -F BaseCounts/AC/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEFF.sh
sed -i 's/filtered_snps_finalNoCounts/filtered_snps_final/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
sed -i 's/AC/AC -F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "8" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecov/genomecovNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
sed -i 's/genomecovNoCounts/genomecov/g' /media/sf_AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "9" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/RscriptVC.sh
fi
if [ "$steps" == "10" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/mutech2.sh
fi
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/VariantCalling.log

