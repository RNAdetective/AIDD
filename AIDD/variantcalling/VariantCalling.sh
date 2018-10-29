#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "which step would you like to start on? 1=beginning 2=markduplicates 3=haplotype 4=haplotype 5=filter 6=haplotype2 7=filter2 8=snpEff?"
read steps
if [ "$steps" == "1" ]; then
echo "Starting with preping bam files for variant calling"
bash /home/user/AIDD/AIDD/variantcalling/prepbam.sh
echo "Marking duplicates getting ready for variant calling"
bash /home/user/AIDD/AIDD/variantcalling/markduplicates.sh
echo "Running haplotype caller for the first time"
bash /home/user/AIDD/AIDD/variantcalling/haplotype.sh
echo "Filtering raw variants"
bash /home/user/AIDD/AIDD/variantcalling/filter.sh
echo "Running haplotype two on filtered files"
bash /home/user/AIDD/AIDD/variantcalling/haplotype2.sh
echo "Running second filtering round to create final vcf files"
bash /home/user/AIDD/AIDD/variantcalling/filter2.sh
echo "Running snpEff to predict variants effect on protein structure and functions"
bash /home/user/AIDD/AIDD/variantcalling/snpEff.sh
echo "Using bed tools to create a visual file of variants"
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run".gene.txt
echo "Reorganizing final vcf files in proper directories"
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
rm /media/sf_AIDD/working_directory/*.vcf
for i in haplotype filter haplotype2 filter2 snpEff ; do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
bash /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
done
mv /media/sf_AIDD/raw_data/vcf_files/*"NoCounts"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "2" ]; then
bash /home/user/AIDD/AIDD/variantcalling/markduplicates.sh
bash /home/user/AIDD/AIDD/variantcalling/haplotype.sh
bash /home/user/AIDD/AIDD/variantcalling/filter.sh
bash /home/user/AIDD/AIDD/variantcalling/haplotype2.sh
bash /home/user/AIDD/AIDD/variantcalling/filter2.sh
bash /home/user/AIDD/AIDD/variantcalling/snpEff.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
for i in haplotype filter haplotype2 filter2 snpEff ; do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
bash /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "3" ]; then
bash /home/user/AIDD/AIDD/variantcalling/haplotype.sh
bash /home/user/AIDD/AIDD/variantcalling/filter.sh
bash /home/user/AIDD/AIDD/variantcalling/haplotype2.sh
bash /home/user/AIDD/AIDD/variantcalling/filter2.sh
bash /home/user/AIDD/AIDD/variantcalling/snpEff.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
for i in haplotype filter haplotype2 filter2 snpEff ; do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
bash /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "4" ]; then
bash /home/user/AIDD/AIDD/variantcalling/filter.sh
bash /home/user/AIDD/AIDD/variantcalling/haplotype2.sh
bash /home/user/AIDD/AIDD/variantcalling/filter2.sh
bash /home/user/AIDD/AIDD/variantcalling/snpEff.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
for i in filter haplotype2 filter2 snpEff ; do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
bash /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "6" ]; then
bash /home/user/AIDD/AIDD/variantcalling/haplotype2.sh
bash /home/user/AIDD/AIDD/variantcalling/filter2.sh
bash /home/user/AIDD/AIDD/variantcalling/snpEff.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
for i in haplotype2 filter2 snpEff ; do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
bash /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "7" ]; then
bash /home/user/AIDD/AIDD/variantcalling/filter2.sh
bash /home/user/AIDD/AIDD/variantcalling/snpEff.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
for i in filter2 snpEff ; do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
bash /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "8" ]; then
bash /home/user/AIDD/AIDD/variantcalling/snpEff.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
for i in snpEff ; do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
bash /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/AIDD/variantcalling/"$i".sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/VariantCalling.log

