#https://crashcourse.housegordon.org/split-fasta-files.html
mkdir directory
cd directory
csplit -s -z /media/sf_sim/directory.txt '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/$// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.txt" ; \
 done
