#https://crashcourse.housegordon.org/split-fasta-files.html
mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/globalrun_name/
cd /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/globalrun_name/
csplit -s -z /media/sf_AIDD/raw_data/snpEff/globalrun_name.csv '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.csv" ; \
 done
cd /home/user/
