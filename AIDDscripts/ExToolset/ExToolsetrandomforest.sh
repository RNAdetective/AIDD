create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
for type in tissue gender phenotype COD CODgender CODgenderphenotypetissue genderphenotype CODgendertissue genderphenotypetissue ;
do
  dir_path=/media/sf_AIDD/all_guttman
  new_dir="$dir_path"/RF"$type"
  create_dir
  file_in="$dir_path"/guttman_count_matrix"$type".csv
  file_out="$new_dir"/guttman_count_matrix_"$type".txt
  i1="$new_dir"/guttman_count_matrix2_1.tiff
  i2="$new_dir"/guttman_count_matrix2_2.tiff
  i3="$new_dir"/guttman_count_matrix2_3.tiff
  i4="$new_dir"/guttman_count_matrix2_4.tiff
  i5="$new_dir"/guttman_count_matrix2_5.tiff
  i6="$new_dir"/guttman_count_matrix2_6.tiff
  i7="$new_dir"/guttman_count_matrix2_7.tiff
  i8="$new_dir"/guttman_count_matrix2_8.tiff
  i9="$new_dir"/guttman_count_matrix2_9.tiff
  cat /home/user/AIDD/AIDD/ExToolset/scripts/randomforest.R | sed 's/type_1/'$type'/g' >> "$dir_path"/randomforest_temp.R  
  Rscript "$dir_path"/randomforest_temp.R "$file_in" "$i1" "$i2" "$i3" "$i4" "$i5" "$i6" "$i7" "$i8" "$i9" "$file_out"
  rm "$dir_path"/randomforest_temp.R
done
