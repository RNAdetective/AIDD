#https://crashcourse.housegordon.org/split-fasta-files.html
mkdir /media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/directory
cd /media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/directory
csplit -s -z /media/sf_AIDD/Results/DESeq2/level/differential_expression/venndiagrams/directory.csv '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.csv" ; \
 done
cd /home/user/
