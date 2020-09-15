file_in="/media/sf_AIDD/frequency_counts/SRR5489208.txt"
file_out="/media/sf_AIDD/frequency_counts/SRR5489208CtoT.csv"
header=$(echo "chromosome,coordinate,reference,stackdepth,A,C,G,T,percentA,percentC,percentG,percentT")
if [ ! -s "$file_out" ];
then
  echo "$header" >> "$file_out"
fi
cat "$file_in" | sed 's/=//g' | sed 's/:/,/g' | awk ' { print $1"," $2"," $3"," $4","$5","$6","$7","$8","$9 } ' | cut -d',' -f 1,2,3,4,20,34,48,62 | awk -F ',' '{if ($4 >= '100') {print}}' | sed 's/ /,/g'
g

{i=2; total=0; while (i <= NF) {total = total + $i; i++;}print $0,$6/$4;}

while
