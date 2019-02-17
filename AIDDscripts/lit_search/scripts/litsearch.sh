#!/usr/bin/env bash
pubmed_search() {
file_outabs="$dir_path"/abstracts.csv
file_outstats="$dir_path"/stats.csv
file_outsum="$dir_path"/summary.txt
num_rec=10000
if [[ ! -s "$file_outabs" && ! -s "$file_outstats" ]]; then
  Rscript --vanilla "$main_dir"/scripts/pubmed.R $topic $file_outabs $file_outstats $num_rec $file_outsum
else
echo ""$file_outstats" and "$file_outabs" FOUND"
fi
}
config_text() {
file_out="$main_dir"/scripts/config.cfg
if [ -s "$file_out" ]; then
rm "$file_out"
fi
    echo "topic=$topic
main_dir=$main_dir
" >> "$file_out"
}
config_defaults() {
file_out="$main_dir"/scripts/config.cfg.defaults
if [ -s "$file_out" ]; then
rm "$file_out"
fi
echo "topic=Default Value
main_dir=Default Value" >> "$file_out"
}
create_stat() {
cat "$file_in" | cut -d',' -f3,4,5,6,7 | sed -n '1p' | sed "s/,/\n/g" | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' | sed 's/"//g' >> "$file_out"
}
unique() {
cat "$file_in" | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f$column_num | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed 's/"//g' | sed '1i freq,name' > "$file_out"
}
piechart() {
Rscript --vanilla "$main_dir"/scripts/piechart.R $file_in $file_out $name
}
find_totals() {
if [ ! -s "$file_out" ]; then
  add_header
fi
echo ""$topic","$totals"" >> "$file_out"
}
find_totals2() {
echo ""$name","$totals2"" >> "$file_out"
}
add_header() {
echo "name,freq" >> "$file_out"
}
run_tools() {
if [ ! -s "$file_out" ]; then
  if [ -s "$file_in" ]; then
    "$tool"
  else 
    echo ""$file_in" missing"
  fi
else
echo ""$file_out" FOUND"
fi
}
search_term_matrix() {
cat "$dir_path"/final/* | sort -u >> "$file_out"
}
filter_abs() {
find "$file_in" -type f | xargs grep -n "$search" >> "$file_out"
cat "$file_out" | cut -d',' -f2 >> "$file_out2"
}
################################################################################################################
#SEARCH FOR KEY TERM
################################################################################################################
for topic in ZIKV DENV WNV ; do #enter search terms here
  main_dir=~/lit_search
  dir_path="$main_dir"/"$topic"
  mkdir "$dir_path"
  mkdir "$dir_path"/final
  config_text
  config_defaults
  pubmed_search
  file_in="$dir_path"/stats.csv
  file_out="$dir_path"/stat_names.csv
  tool=create_stat
  run_tools
################################################################################################################
#CREATE UNIQUE CSV FOR EACH INDEX
################################################################################################################
  INPUT="$file_out"
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  while IFS=, read -r name num column
  do
    source /home/user/lit_search/scripts/config.shlib; # load the config library functions
    cd /home/user/lit_search/scripts
    topic="$(config_get topic)";
    main_dir="$(config_get main_dir)";
    dir_path="$main_dir"/"$topic";
    file_in="$dir_path"/stats.csv;
    file_out="$dir_path"/"$name".csv;
    column_num="$column";
    tool=unique
    run_tools #will create unique list of files
    file_in="$dir_path"/"$name".csv
    file_out="$dir_path"/"$name".tiff
    tool=piechart
    run_tools # will create pie charts for each file
    cd
  done
  } < $INPUT
  IFS=$OLDIFS
  file_in="$dir_path"/stats.csv
  file_out="$main_dir"/totals.csv
  totals=$(cat "$file_in" | wc -l)
  if [ -s "$file_in" ]; then
    find_totals # this will find how many articles were found
  fi
  CNS1=CNS
  CNS2=brain
  CNS3=nerve
  CNS4=spinal
  sym1=microcephaly
  sym2=hydrocephalus
  sym3=ventriculomegaly
  sym4=lissencephaly
  for search in "$CNS1" "$CNS2" "$CNS3" "$CNS4" "$sym1" "$sym2" "$sym3" "$sym4" ; do
      file_in="$dir_path"/abstracts.csv
      file_out="$dir_path"/"$search".csv
      file_out2="$dir_path"/final/"$search"ID.csv
      tool=filter_abs
      run_tools # this will filter abstracts by search term
      file_in="$dir_path"/"$search".csv
      file_in2="$dir_path"/stats.csv
      file_out="$dir_path"/"$search"totals.csv
      name="$topic"
      topic="$search"
      totals=$(cat "$file_in" | wc -l)
      g_tot=$(cat "$file_in2" | wc -l)
      totals2=$(expr "$g_tot" - "$totals")
      if [ -s "$file_in" ]; then
        find_totals # this will create totals file for all search terms
        find_totals2 # adds totals to file
        file_in="$dir_path"/"$search"totals.csv
        file_out="$dir_path"/"$search"totals.tiff
        tool=piechart
        run_tools # will create pie charts for viruses
      fi
  done
  file_out="$dir_path"/final/totalneuro.csv
  search_term_matrix
  topic="$name"
  totals=$(cat "$file_in" | wc -l)
  file_in="$dir_path"/final/totalneuro.csv
  file_in2="$dir_path"/stats.csv
  file_out="$dir_path"/final/counttotalneuro.csv
  totals=$(cat "$file_in" | wc -l)
  g_tot=$(cat "$file_in2" | wc -l)
  totals2=$(expr "$g_tot" - "$totals")
  find_totals # this will create totals file for all search terms
  find_totals2
  file_in="$dir_path"/final/counttotalneuro.csv
  file_out="$dir_path"/totalneuro.tiff
  tool=piechart
  run_tools # will create pie charts for viruses
done
file_in="$main_dir"/totals.csv
file_out="$main_dir"/virus.tiff
name=virus
tool=piechart
run_tools # will create pie charts for viruses
file_in="$main_dir"/totals.csv
file_out="$main_dir"/virus.tiff
name=virus
tool=piechart
run_tools # will create pie charts for viruses

