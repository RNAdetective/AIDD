cd /media/sf_AIDD/Results/regions
mainfile=/media/sf_AIDD/Results/All/guttediting_count_matrixbatchesAll.csv
awk -F ',' 'NR==1{h=$0; next};!seen[$5]++{f=$5".csv"; print h > f};{f=$5".csv"; print >> f; close(f)}' "$mainfile"
for files in /media/sf_AIDD/Results/regions/* ;
do
  awk -F ',' 'NR==1{h=$0; next};!seen[$3]++{f=$3$5".csv"; print h > f};{f=$3$5".csv"; print >> f; close(f)}' "$files"
done

