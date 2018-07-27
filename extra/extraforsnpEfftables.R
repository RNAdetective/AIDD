for i in gene transcript ; do
for j in high moderate ; do
awk  '{print $2, $5}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run"high.txt
awk  '{print $3, $5}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run"high.txt
awk  '{print $2, $7}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run"moderate.txt
awk  '{print $3, $7}' /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | column -t > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run"moderate.txt
sort /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$j".txt | uniq -u > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$j"Unique.txt
sed 's/ \+/,/g' /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$j".txt > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$j".csv
grep -v -e "^0$" /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$j".csv > /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/"$j"_impact/"$run""$condition""$j"Final.csv
done
done


cat /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | cut -f 2,5 > /media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/"$run""$condition"high.csv
cat /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | cut -f 3,5 > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/high_impact/"$run""$condition"high.csv
cat /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | cut -f 2,7 > /media/sf_AIDD/Results/variant_calling/haplotype/gene/moderate_impact/"$run""$condition"moderate.csv
cat /media/sf_AIDD/raw_data/snpEff/"$run"genes.csv | cut -f 3,7 > /media/sf_AIDD/Results/variant_calling/haplotype/transcript/moderate_impact/"$run""$condition"moderate.csv

multmerge = function(path){
  filenames=list.files(path=path, full.names=TRUE)
  df2 <- subset(df1, select = c(1, 2, 5))
  rbindlist(lapply(filenames, fread))
}
path <- "/media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/mock"
DF <- multmerge(path)
write.csv(DF, "/media/sf_AIDD/Results/variant_calling/haplotype/gene/high_impact/mockhighFinal.csv", row.names=FALSE)

print(paste("The year is", 2010))
print(paste("The year is", 2011))
print(paste("The year is", 2012))
print(paste("The year is", 2013))
print(paste("The year is", 2014))
print(paste("The year is", 2015))

for (year in c(2010,2011,2012,2013,2014,2015)){
  print(paste("The year is", year))
}