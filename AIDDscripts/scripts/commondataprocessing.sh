##############################################################################################
#TRANSPOSE A FILE IN BASH
##############################################################################################
dir_path=/media/sf_AIDD/McGrath
file_name=PHENO_DATA
cat "$dir_path"/"$file_name".csv | 
awk -F',' '{for(i=1;i<=NF;i++){A[NR,i]=$i};if(NF>n){n=NF}}
END{for(i=1;i<=n;i++){
for(j=1;j<=NR;j++){
s=s?s","A[j,i]:A[j,i]}
print s;s=""}}' >> "$dir_path"/"$file_name"trans.csv

##############################################################################################
#CHECK FOR COMMA SEPARATE WITH CORRECT NUMBER OF COLUMNS
##############################################################################################
dir_path=/media/sf_AIDD/McGrath
file_name=PHENO_DATA
pheno_file="$dir_path"/"$file_name".csv
numberOFcolumns="6"
phenocheck=`awk 'BEGIN{FS=","}END{print NF}' "$pheno_file"`
tab_check=`awk -F "\t" 'NF != '$numberOFcolumns'' "$pheno_file"`
tab_count=$(echo "$tab_check" | wc -l)
window_check=$(grep "\r" "$pheno_file")
if [ "$window_check" != "" ];
then
  sed -i 's/\r//g' "$pheno_file"
fi
if [ "$phenocheck" != ""$numberOFcolumns"" ] ; 
then
  echo "PHENO_DATA FILE DOES NOT HAVE CORRECT NUMBER OF COLUMNS: MAKE SURE IT IS IN THIS FORMAT sampname,run,condition,sample,condition2,condition3. If your experiment does not have 3 condition just put in NA in the unused columns"
  if [ "$tab_count" != "0" ];
  then
    sed -i 's/\t/,/g' "$pheno_file"
  fi
else
  echo "PHENO_DATA FILE IS READY"
fi

##############################################################################################
#CHECK FOR COMMA SEPARATE WITH CORRECT NUMBER OF COLUMNS
##############################################################################################
dir_path=/media/sf_AIDD/McGrath
file_name=PHENO_DATA
final_file="$dir_path"/"$file_name".csv
header=$(cat "$final_file" | head -n 1 | sed 's/,/ /g')
echo "$header"
INPUT="$pheno_file"
OLDIFS=$IFS
{
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while read $header
do
  echo "$sampname"
done
} < $INPUT
IFS=$OLDIFS # creates count matrix


