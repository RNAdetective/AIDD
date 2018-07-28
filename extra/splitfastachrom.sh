#https://crashcourse.housegordon.org/split-fasta-files.html
mkdir GRCh37
cd GRCh37
csplit -s -z /media/sf_sim/GRCh37.fa '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.fa" ; \
 done
