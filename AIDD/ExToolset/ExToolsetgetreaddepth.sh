dir=/media/sf_AIDD/COVID19/raw_data/counts
for files in "$dir"/* ;
do
  dir=/media/sf_AIDD/COVID19/raw_data/counts
  dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 7 -d '.')
  file_name=$(echo "$dir_name" | cut -f 1 -d '.')
  exten=$(echo "${files##*.}")
  if [ "$exten" == "txt" ] ;
  then
    declare -i percent
    percent=$(cat "$files" | tail -n 1 | sed 's/ /,/g' | cut -d',' -f1 | sed 's/%//g' | awk '{print int($1)}')
    declare -i depth
    depth=$(cat "$files" | head -n 1 | sed 's/ /,/g' | cut -d',' -f1)
    if [ "$percent" -ge 70 ] ;
    then
      check=$(echo "keep")
    else
      check=$(echo "removed")
    fi
    file_out=/media/sf_AIDD/COVIDreaddepth.csv
    if [ ! -s "$file_out" ] ;
    then
      echo "file_name,depth,percent_align,check" >> "$file_out"
    fi
    echo ""$file_name","$depth","$percent","$check"" >> "$file_out"
  fi
done

