#https://crashcourse.housegordon.org/split-fasta-files.html
mkdir /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/directory/
cd /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/directory/
csplit -s -z /media/sf_AIDD/Results/variant_calling/level/protein_effect_impact/final/directory.csv '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.csv" ; \
 done
