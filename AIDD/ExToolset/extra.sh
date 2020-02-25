file_in=/media/sf_AIDD/MDD/Results/guttman/excitomefreq_count_matrixANOVAnew.csv
header=$(cat "$file_in" | head -n 1)
cat "$file_in" | sed 1d | nawk -F',' '{for(i=1;i<=NF;i++) $i=($i>0) ? 1 : $i}1' | sed 's/ /,/g' | sed 's/ /0/g' | sed '1i '$header'' >> /media/sf_AIDD/MDD/Results/guttman/guttediting_count_matrixANOVAnew.csv
