#https://crashcourse.housegordon.org/split-fasta-files.html
cd /home/user/sim/genome_references
csplit -s -z /home/user/AIDD/references/ref.fa '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1d ; 1q' "$i") ; \
  mv "$i" "$n.fa" ; \
 done
