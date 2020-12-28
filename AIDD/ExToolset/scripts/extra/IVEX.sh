create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
for batch in MDDbatch01_07 MDDbatch08 MDDbatch09 MDDbatch10 MDDbatch11 MDDbatch12 MDDbatch13 MDDbatch14 MDDbatch15 MDDbatch16 MDDbatch17 MDDbatch18 MDDbatch19 MDDbatch20 MDDbatch21 MDDbatch22 MDDbatch23 MDDbatch24 MDDbatch25 MDDbatch26 MDDbatch27 ;
do
  for files in "$dir_path"/* ;
  do
    if [ ! -d "$files" ];
    then
      dir_path=/media/sf_AIDD/"$batch"/Results/variant_calling/impact/transcript/high_impact/ADARediting
          dir_name=$(echo "$files" | sed 's/\//./g' | cut -f 11 -d '.')
          file_name=$(echo "$dir_name" | cut -f 1 -d '.')
          samp_name=$(echo "$dir_name" | cut -f 1 -d '_' | sed 's/ADAReditingalcool//g')
          echo "$samp_name"
          total=$(awk -F"," '{ sum += $2; }END { print sum; }' "$files")
          echo "$total"
          new_dir=/media/sf_AIDD/mergeIVEX
          create_dir
          file_out=/media/sf_AIDD/transcript_high_IVEX_count_matrix5.csv
          if [ ! -f "$file_out" ];
          then
            echo "run,total" >> "$file_out"
          fi
          echo ""$samp_name","$total"" >> "$file_out"
        fi
  done
done



