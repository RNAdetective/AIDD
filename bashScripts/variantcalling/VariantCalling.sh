#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
echo "which step would you like to start on? 1=beginning 2=markduplicates 3=haplotype 4=haplotype 5=filter 6=haplotype2 7=filter2 8=snpEff 9=bedtools 10=RscriptVC?"
read steps
if [ "$steps" == "1" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/prepbam.sh
bash /home/user/AIDD/bashScripts/variantcalling/markduplicates.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in haplotype filter haplotype2 filter2 snpEff bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "2" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/markduplicates.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in haplotype filter haplotype2 filter2 snpEff bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "3" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/haplotype.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in haplotype filter haplotype2 filter2 snpEff bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "4" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/filter.sh
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in filter haplotype2 filter2 snpEff bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "6" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/haplotype2.sh
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in haplotype2 filter2 snpEff bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "7" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/filter2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in filter2 snpEff bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "8" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/snpEff.sh
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in snpEff bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
if [ "$steps" == "9" ]; then
bash /home/user/AIDD/bashScripts/variantcalling/bedtools.sh
mv /media/sf_AIDD/working_directory/"$run".genes.txt /media/sf_AIDD/raw_data/snpEff/"$run"_gene.txt
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/*"$i"* /media/sf_AIDD/raw_data/vcf_files/"$i"/
done
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables2.sh
bash /home/user/AIDD/bashScripts/variantcalling/snpEfftables3.sh
for i in bedtools do 
sed -i 's/\-A BaseCounts //g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/\-F BaseCounts //g' /media/sf_AIDD/bashSCripts/variantcalling/$i.sh
sed -i 's/raw_variants/raw_variantsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snps/raw_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indels/raw_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snps/filtered_snpsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indels/filtered_indelsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_data/recal_dataNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_reads/recal_readsNoCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
bash /media/sf_AIDD/bashScripts/variantcalling/$i
sed -i 's/raw_variantsNoCounts/raw_variants/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/AC/ \-A BaseCounts/g' /media/sf_AIDD/bashScripts/variantcallings/$i.sh
sed -i 's/cigar/cigar \-F BaseCounts/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_snpsNoCounts/raw_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/raw_indelsNoCounts/raw_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_snpsNoCounts/filtered_snps/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/filtered_indelsNoCounts/filtered_indels/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_dataNoCounts/recal_data/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
sed -i 's/recal_readsNoCounts/recal_reads/g' /media/sf_AIDD/bashScripts/variantcalling/$i.sh
done
for i in raw final filtered; do
mv /media/sf_AIDD/raw_data/vcf_files/NoCounts/*"$i"* /media/sf_AIDD/raw_data/vcf_files/NoCounts/"$i"/
done
fi
}
main_function 2>&1 | tee -a /media/sf_AIDD/quality_control/logs/VariantCalling.log

