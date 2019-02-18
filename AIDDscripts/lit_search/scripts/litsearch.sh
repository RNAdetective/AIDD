#!/usr/bin/env bash
pubmed_search() {
file_outabs="$dir_path"/"$topic"abstracts.csv
file_outstats="$dir_path"/"$topic"stats.csv
file_outsum="$dir_path"/summary.txt
num_rec=10000
if [[ ! -s "$file_outabs" && ! -s "$file_outstats" ]]; then
  Rscript --vanilla "$main_dir"/scripts/pubmed.R $topic $file_outabs $file_outstats $num_rec $file_outsum
else
echo ""$file_outstats" and "$file_outabs" FOUND"
fi
}
create_dir() {
  dp="$main_dir"/"$topic"
  wkd="$dir_path"/final
  mwkd="$main_dir"/final
  wkd1="$dir_path"/stats
  mwkd1="$main_dir"/topic_stats
  mwkd2="$mwkd"/"$search_cat"
for i in "$dp" "$wkd" "$mwkd" "$wkd1" "$mwkd1" "$mwkd2" ;
do
  if [ ! -d "$i" ];
  then
  mkdir "$i"
  fi
done
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
cat "$file_in" | cut -d',' -f2 >> "$file_out2"
cat "$file_in" | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f$column_num | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed 's/"//g' | sed '1i freq,name' >> "$file_out"
}
Country() {
awk -F',' '{ if ( $1 <= 60 ) { print } }' "$file_out" >> "$file_out3"
awk -F',' '{ if ( $1 > 60 ) { print } }' "$file_out" >> "$file_out4"
}
Year() {
awk -F',' '{ if ( $2 != "NA" ) { print } }' "$file_out" >> "$file_out4"
}
piechart() {
Rscript --vanilla "$main_dir"/scripts/piechart.R $file_in $file_out $name
}
find_totals() {
if [ ! -s "$file_out" ]; then
  add_header
fi
echo ""$column1","$column2"" >> "$file_out"
}
find_totals2() {

echo ""$column1","$column2"" >> "$file_out"
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
cat "$wkd"/* | sort -u >> "$file_out"
}
search_term_matrix_main() {
cat "$mwkd"/* | sort -u >> "$file_out"
}
total_wabs() {
cat "$file_in" | sed 's/""/*NA*/g' | sed 's/"//g' | awk -F',' '{ if ( $4 != "*NA*" ) { print $2; } }' >> "$file_out"

}
filter_abs() {
find "$file_in" -type f | xargs grep -n "$search" >> "$file_out"
cat "$file_out" | cut -d',' -f2 >> "$file_out2"
rm "$file_out"
}
create_absearch() {
for search_file in "$search_terms" "$search_terms2" ;
do
  wkd="$dir_path"/final/"$search_cat"
  mkdir "$wkd"
  search_cat=$(awk -F',' 'NR == 1 {print $1}' "$search_file" | sed 's/,//g' ) # grep from search_file
done
}
################################################################################################################
#SEARCH FOR KEY TERM
################################################################################################################
maintopic1="$2"
maintopic2="$3"
maintopic3="$4"
for topic in "$maintopic1" "$maintopic2" "$maintopic3" ; do #enter search terms here
  main_dir="$1"
  dir_path="$main_dir"/"$topic"
  create_dir
  config_text
  config_defaults
  pubmed_search #finds all pubmed articles for topic
  file_in="$dir_path"/"$topic"stats.csv
  file_out="$dir_path"/"$topic"stat_names.csv
  tool=create_stat
  run_tools 
  file_in="$dir_path"/"$topic"abstracts.csv
  file_out="$dir_path"/"$topic"abPMID.csv
  tool=total_wabs
  run_tools
################################################################################################################
#CREATE PIECHART FOR EACH INDEX MEASURE IN STATS FROM PUBMED SEARCH
##NEED TO FILTER $namestats.csv LIKE YEAR REMOVE NA
################################################################################################################
  INPUT="$dir_path"/"$topic"stat_names.csv
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  while IFS=, read -r name num column
  do
    source /home/user/lit_search/scripts/config.shlib; # load the config library functions
    cd /home/user/lit_search/scripts
    topic="$(config_get topic)";
    main_dir="$(config_get main_dir)";
    dir_path="$main_dir"/"$topic";
    wkd="$dir_path"/stats/"$name";
    mkdir "$wkd"
    mwkd="$main_dir"/topic_stats;
    file_in="$dir_path"/"$topic"stats.csv;
    file_out="$wkd"/"$name".csv;
    file_out2="$mwkd"/"$topic"stats.csv;
    column_num="$column";
    tool=unique
    run_tools #will create unique list of files
    if [ "$name" == "Country" ];
    then
      mwkd="$main_dir"/topic_stats;
      file_out="$wkd"/"$name".csv;
      file_out3="$wkd"/"$name"lowcounts.csv;
      file_out4="$wkd"/"$name"new.csv;
      Country
      file_in="$wkd"/"$name"lowcounts.csv;
      file_out="$wkd"/"$name"new.csv;
      totals=$(cat "$file_in" | awk -F',' '{s+=$1} END {print s}') #sum of columns from file that contains freq 
      column1="$totals"
      column2=other
      find_totals
    fi
    if [[ "$name" == "YearA" || "$name" == "YearR" ]];
    then
      file_out="$wkd"/"$name".csv;
      file_out4="$wkd"/"$name"new.csv;
      Year
    fi 
    file_in="$wkd"/"$name"new.csv
    file_out="$wkd"/"$name".tiff
    tool=piechart
    run_tools # will create pie charts for each file
    cd
  done
  } < $INPUT
  IFS=$OLDIFS
################################################################################################################
#CREATES TOTAL NUMBER OF ARTICLES FOUND FOR EACH TOPIC 
################################################################################################################
  file_in="$dir_path"/"$topic"stats.csv
  file_out="$main_dir"/totals.csv
  if [ -s "$file_in" ]; then
    column1="$topic"
    totals=$(cat "$file_in" | wc -l)
    column2="$totals"
    find_totals # this will find how many articles were found
  fi
################################################################################################################
#SEARCH THE ABSTRACTS FOR SEARCH TERMS IN CATEGORIES AND CREATE EACH INDIVIDUAL SEARCH TERM PIE CHART
#NOT WORKING
################################################################################################################
  search_terms="$main_dir"/scripts/search_terms.csv
  search_terms2="$main_dir"/scripts/search_terms2.csv
  create_absearch
  for search_file in "$search_terms" "$search_terms2" ;
  do
    echo "search_file="$search_file"" >> /home/user/lit_search/scripts/config.cfg.defaults
    INPUT="$search_file"
    {
    [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
    while IFS=, read -r search
    do
      source /home/user/lit_search/scripts/config.shlib; # load the config library functions
      cd /home/user/lit_search/scripts
      search_cat=$(awk 'NR == 1 {print $1}' "$search_file") #grep header name from search_terms file
      wkd="$dir_path"/final/"$search_cat"
      source /home/user/lit_search/scripts/config.shlib; # load the config library functions
      cd /home/user/lit_search/scripts
      wkd="$dir_path"/final/"$search_cat"
      mkdir "$wkd"
      mkdir "$wkd"/final
      topic="$(config_get topic)";
      main_dir="$(config_get main_dir)";
      dir_path="$main_dir"/"$topic";
      file_in="$dir_path"/"$topic"abstracts.csv
      file_out="$dir_path"/"$search".csv
      file_out2="$wkd"/final/"$search"ID.csv
      tool=filter_abs
      run_tools #takes search term and finds PMID for abstracts containing that word
      file_in="$wkd"/final/"$search"ID.csv
      file_in2="$dir_path"/"$topic"abPMID.csv
      file_out="$wkd"/"$search"totals.csv
      if [ -s "$file_in" ]; then
        totals=$(cat "$file_in" | wc -l) #count how many articles for search term
        column1="$search" # labels file with search term,
        column2="$totals" # writes the count for the search term
        find_totals 
        totals=$(cat "$file_in" | wc -l)
        g_tot=$(cat "$file_in2" | wc -l)
        totals2=$(expr "$g_tot" - "$totals") 
        column1=$(echo ""$search"other") # labels with others
        column2="$totals2" # total number of articles with abstracts 
        find_totals2 # adds totals to file
        file_in="$wkd"/"$search"totals.csv
        file_out="$wkd"/"$search"totals.tiff
        tool=piechart
        run_tools # will create pie charts for search term against not search term
      fi
    done
    } < $INPUT
    IFS=$OLDIFS
################################################################################################################
#ADD UP ALL INDIVIDUAL SEARCH TERMS FOR EACH CATEGORY IN SEARCH_TERMS.CSV
################################################################################################################
    search_cat=$(awk -F',' 'NR == 1 {print $1}' "$search_file" | sed 's/,//g' ) # grep from search_file
    wkd="$dir_path"/final/"$search_cat"/final
    mwkd="$main_dir"/final/"$search_cat"
      mkdir "$wkd"
      mkdir "$mwkd"
    file_out="$dir_path"/final/"$search_cat"/final/"$topic"total"$search_cat".csv
    search_term_matrix
    file_in="$wkd"/"$topic"total"$search_cat".csv
    file_in2="$dir_path"/"$topic"abPMID.csv
    file_out="$mwkd"/"$topic"counttotal"$search_cat".csv
    totals=$(cat "$file_in" | wc -l)
    column1="$search_cat"
    column2="$totals"
    find_totals # this will create totals file for all search terms
    totals=$(cat "$file_in" | wc -l)
    g_tot=$(cat "$file_in2" | wc -l)
    totals2=$(expr "$g_tot" - "$totals")
    column1=$(echo ""$search_cat"other")
    column2="$totals2"
    find_totals2 # adds totals to file
    file_in="$mwkd"/"$topic"counttotal"$search_cat".csv
    file_out="$wkd"/"$topic"total"$search_cat".tiff
    tool=piechart
    name="$search_cat"
    run_tools # will create pie charts for total neuro terms
    file_in="$mwkd"/"$topic"counttotal"$search_cat".csv
    file_out="$mwkd"/"$topic""$search_cat".csv
    tool=search_term_matrix_main
    run_tools # will create file to combine terms
  done
done
################################################################################################################
#CREATES TOTAL NUMBER OF ARTICLES FOUND FOR EACH TOPIC  THIS IS NOT WORKING FIX COLUMN1 and 2 numbers are wrong
################################################################################################################
mwkd="$main_dir"/topic_stats
file_out="$main_dir"/totals_list.csv
search_term_matrix_main #makes a unique list of all main topics articles to find percentage of articles with each main topic
for topic in "$maintopic1" "$maintopic2" "$maintopic3" ; 
do
  file_in="$dir_path"/"$topic"stats.csv
  file_out="$mwkd"/topic_counts.csv
  totals=$(cat "$file_in" | wc -l)
  column1="$topic"
  column2="$totals"
  find_totals # this will create totals file for all search terms
done
file_in="$main_dir"/totals_list.csv
file_out="$mwkd"/topic_counts.csv
totals=$(cat "$file_in" | wc -l)
column1=total
column2="$totals"
find_totals # this will add a row at the bottom with the total of unique articles found
file_in="$mwkd"/topic_counts.csv
file_out="$mwkd"/topic.tiff
name=topic
tool=piechart
run_tools # will create pie charts for viruses
rm "$dir_path"/"$topic"stat_names.csv
