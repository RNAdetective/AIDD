#https://crashcourse.housegordon.org/split-fasta-files.html
mkdir /media/sf_AIDD/Results/variant_calling/substitutions/raw/file_name/
cd /media/sf_AIDD/Results/variant_calling/substitutions/raw/file_name/
csplit -s -z /media/sf_AIDD/Results/variant_calling/substitutions/file_name.csv '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.csv" ; \
  sed -i '1d' "$n.csv"
 done
