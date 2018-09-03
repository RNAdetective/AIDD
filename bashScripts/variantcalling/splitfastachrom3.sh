mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/ModerateVenn/
cd /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/ModerateVenn/
csplit -s -z /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/genelistVennDiagram.txt '/>/' '{*}'
for i in xx* ; do \
  n=$(sed 's/>// ; s/ .*// ; 1q' "$i") ; \
  mv "$i" "$n.txt" ; \
 done
cd /home/user/
