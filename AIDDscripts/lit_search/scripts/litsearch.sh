#!/usr/bin/env bash
create_dir() {
  dp="$main_dir"/"$topic"; #set up directories
  wkd="$dir_path"/final;
  mwkd="$main_dir"/final;
  wkd1="$dir_path"/stats;
  mwkd1="$main_dir"/topic_stats;
for i in "$dp" "$wkd" "$mwkd" "$wkd1" "$mwkd1" ;
do
  if [ ! -d "$i" ];
  then
  mkdir "$i"
  fi
done
}
config_text() {
file_out="$main_dir"/scripts/config.cfg;
if [ -s "$file_out" ]; then
rm "$file_out"
fi
echo "topic=$topic
main_dir=$main_dir
" >> "$file_out"
}
config_defaults() {
file_out="$main_dir"/scripts/config.cfg.defaults;
if [ -s "$file_out" ]; then
rm "$file_out"
fi
echo "topic=Default Value
main_dir=Default Value" >> "$file_out"
}
pubmed_search() {
file_outabs="$dir_path"/"$topic"abstracts.csv; #names of pubmed search out put files
file_outstats="$dir_path"/"$topic"stats.csv;
file_outsum="$dir_path"/summary.txt;
num_rec=100000; #max number of records to return from pubmed
if [[ ! -s "$file_outabs" && ! -s "$file_outstats" ]]; then
  Rscript --vanilla "$main_dir"/scripts/pubmed.R $topic $file_outabs $file_outstats $num_rec $file_outsum #runs the Rscript to use RISmed to search pubmed database
else
  echo ""$file_outstats" and "$file_outabs" FOUND"
fi
}
create_stat() { 
cat "$file_in" | cut -d',' -f3,4,5,6,7 | sed -n '1p' | sed "s/,/\n/g" | awk '{$2=NR}1' | awk '{$3=$2+2}1' | sed 's/ /,/g' | sed 's/"//g' >> "$file_out" #makes a metadata names file for analysis
}
total_wabs() {
cat "$file_in" | sed 's/""/*NA*/g' | sed 's/"//g' | awk -F',' '{ if ( $4 != "*NA*" ) { print $2; } }' >> "$file_out" #removes all articles without an abstract and creates a list of PMID that contained abstracts
}
unique() {
cat "$file_in" | cut -d',' -f2 >> "$file_out2" #takes article list downloaded from pubmed and creates a PMIDlist
cat "$file_in" | sed -e 1d | sed -e 's/ /_/g' | cut -d',' -f$column_num | sort | uniq -ci | sed 's/ \+/,/g' | sed 's/^.//g' | sed 's/"//g' | sed '1i freq,name' >> "$file_out" #counts number of unique PMID in article list for each of the metadata terms searched for and creates a file with columns frequencies and metadata variable names for example countrys would have USA, UK, Canada ect. 
}
Country() {
awk -F',' '{ if ( $1 <= 60 ) { print } }' "$file_out" >> "$file_out3" #prints file with countries that have less then 60 articles
awk -F',' '{ if ( $1 > 60 ) { print } }' "$file_out" >> "$file_out4" #makes a new file with the collapsed other value added
}
Year() {
awk -F',' '{ if ( $2 != "NA" ) { print } }' "$file_out" >> "$file_out4" #filters any article that does not have a date record in the metadata
}
chart() {
Rscript --vanilla "$main_dir"/scripts/charts.R $Rtools $file_in $file_out $name #creates a piechart from a file with frequency in column 1 and names in column2
}
barchart() {
Rscript --vanilla "$main_dir"/scripts/barchart.R $file_in $file_out #creates bar charts
}
find_totals() {
if [[ ! -s "$file_out" && "$header" == "no" ]]; then
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
    echo "Running "$tool""
    "$tool"
  else 
    echo ""$file_in" MISSING"
  fi
else
echo ""$file_out" already FOUND"
fi
}
search_term_matrix() {
cat "$wkd"/* | sed '1d' | sort -u | sed '1i name,freq' >> "$file_out"
}
search_term_matrix_main() {
cat "$mwkd"/* | sort -u | sed '1i PMID' >> "$file_out"
}
rmlast() {
cat "$file_in" | head -n -1 > temp.csv ; mv temp.csv "$file_in"
}
filter_abs() {
find "$file_in" -type f | xargs grep -n "$search" >> "$file_out"
cat "$file_out" | cut -d',' -f2 >> "$file_out2"
rm "$file_out"
}
create_absearch() {
  wkd="$dir_path"/final/"$search_cat";
  dtm="$wkd"
  createdir
  for i in final totals charts ; do
    wkd="$dir_path"/final/"$search_cat";
    dtm="$wkd"/"$i"
    createdir
  done
}
fix_header() {
cat "$file_in" | awk -F',' '{ if ( $1 != "name" ) { print $1,$2; } }' | sed '1i name,freq' >> temp.csv
rm "$file_in"
mv temp.csv "$file_in"
sed -i 's/ /,/g' "$file_in"
}
createdir() {
if [ ! -d "$dtm" ];
then
  mkdir "$dtm"
fi
}
makedir() {
        for i in final totals charts ;
        do
        if [ ! -d "$wkd"/"$i" ];
        then
          mkdir "$wkd"/"$i"
        fi
        done
}
set_cat_var() {

      cat "$config" | sed '/^'$phrase'/ d' >> temp.txt
      rm "$config" 
      mv temp.txt "$config"
      echo ""$phrase2"" >> /home/user/lit_search/scripts/config.cfg.defaults
} 

run_ind_st() {
            wkd="$dir_path"/final/"$search_cat";
            topic="$(config_get topic)";
            main_dir="$(config_get main_dir)";
            dir_path="$main_dir"/"$topic";
            file_in="$dir_path"/"$topic"abstracts.csv;
            file_out="$dir_path"/"$search".csv;
            file_out2="$wkd"/final/"$search"ID.csv;
            tool=filter_abs;
            run_tools #takes search term and finds PMID for abstracts containing that word
            file_in="$wkd"/final/"$search"ID.csv;
            file_out="$wkd"/totals/"$search"totals.csv;
            if [ -s "$file_in" ]; then
              totals=$(cat "$file_in" | wc -l); #count how many articles for search term
              column1="$search"; # labels file with search term,
              column2="$totals"; # writes the count for the search term
              header=no
              find_totals
              file_in2="$dir_path"/"$topic"abPMID.csv;
              g_tot=$(cat "$file_in2" | wc -l);
              totals2=$(expr "$g_tot" - "$totals");
              column1=$(echo ""$search"other"); # labels with others
              column2="$totals2" # total number of articles with abstracts 
              find_totals2 # adds totals to file
              file_in="$wkd"/totals/"$search"totals.csv;
              file_out="$wkd"/charts/"$search"totals.tiff;
              Rtools=piechart
              tool=chart;
              name=totals;
              run_tools # will create pie charts for search term against not search term
            fi
} 
total_cat_terms() {
      wkd="$dir_path"/final/"$search_cat"/totals; #collection of PMID files for each search term
      mwkd="$dir_path"/final;
      file_out="$mwkd"/"$topic"total"$search_cat".csv; 
      search_term_matrix #totals of articles for each search term
      sed -i '/other/d' "$file_out"
} 
searchterm_bargraph() {
      dir_path="$main_dir"/"$topic"
      mwkd="$dir_path"/final;
      mmwkd="$main_dir"/final;
      file_in="$mwkd"/"$topic"total"$search_cat".csv; #freq,search_cat
      fix_header
      file_in="$mwkd"/"$topic"total"$search_cat".csv; #freq,search_cat
      file_out="$mwkd"/"$topic"total"$search_cat".tiff;
      Rtools=barchart
      tool=barchart;
      name=empty;
      run_tools #creates number of articles for each search term grouped by category
}  
catgor_piechart() {
      wkd="$mwkd"/"$search_cat"/final
      mwkd="$dir_path"/final;
      file_out="$mwkd"/"$topic"total"$search_cat"counts.csv;
      search_term_matrix #total number of articles for each category
      file_in="$mwkd"/"$topic"total"$search_cat"counts.csv;
      file_out="$mwkd"/"$topic"total"$search_cat"abs.csv;
      totals=$(cat "$file_in" | wc -l); #count how many articles for search term
      column1="$search_cat"; # labels file with search term,
      column2="$totals"; # writes the count for the search term
      header=no
      find_totals
      file_in2="$dir_path"/"$topic"abPMID.csv;
      file_out="$mwkd"/"$topic"total"$search_cat"abs.csv;
      file_in="$mwkd"/"$topic"total"$search_cat"counts.csv;
      totals=$(cat "$file_in" | wc -l); #count how many articles for search term
      g_tot=$(cat "$file_in2" | wc -l);
      totals2=$(expr "$g_tot" - "$totals"); 
      column1="other then "$search_cat""; # labels file with search term,
      column2="$totals2"; # writes the count for the search term 
      find_totals2
      file_in="$mwkd"/"$topic"total"$search_cat"abs.csv; #freq,search_cat
      file_out="$mwkd"/"$topic"total"$search_cat"abs.tiff;
      Rtools=piechart
      tool=chart;
      name=empty;
      run_tools #pie chart for all search terms at least once in a category against none found
} 
 
topic_bar_prep() {
      file_in="$mwkd"/"$topic"total"$search_cat"counts.csv;
      file_out="$mwkd"/"$topic"totalcatwtot.csv;
      totals=$(cat "$file_in" | wc -l); #count how many articles for search term
      column1="$search_cat"
      column2="$totals"
      header=yes
      find_totals #adds a row with search 
} 
topic_bar() {
      #file_in="$dir_path"/"$topic"abPMID.csv;
      #file_out="$dir_path"/final/"$topic"totalcatwtot.csv;
      #totals=$(cat "$file_in" | wc -l); #count how many articles for search term
      #column1=Total
      #column2="$totals"
      #header=yes
      #find_totals
      sed -i '1i name,freq' "$file_out"
      file_in="$dir_path"/final/"$topic"totalcatwtot.csv;
      file_out="$dir_path"/final/"$topic"totalwtot.tiff
      Rtools=barchart
      tool=barchart;
      name=total;
      run_tools # bar chart for each topic with categories showing how many found.
}

    
################################################################################################################
#SEARCH FOR KEY TERMS ***
################################################################################################################
maintopic1="$2" # uses defined main topics 1-6
maintopic2="$3"
maintopic3="$4"
maintopic4="$5"
maintopic5="$6"
maintopic6="$7"
for topic in "$maintopic1" "$maintopic2" "$maintopic3" "$maintopic4" "$maintopic5" "$main_topic6" ; do #enter search terms here
  main_dir="$1"; # user defined main directory
  dir_path="$main_dir"/"$topic";
  create_dir #creates directories for results
  config_text #creates config file to store variables
  config_defaults #creates more config files for variables
  pubmed_search #finds all pubmed articles for topic
  file_in="$dir_path"/"$topic"stats.csv
  file_out="$dir_path"/"$topic"stat_names.csv
  tool=create_stat #gets article metadata ready for analysis
  run_tools 
  file_in="$dir_path"/"$topic"abstracts.csv
  file_out="$dir_path"/"$topic"abPMID.csv
  tool=total_wabs #gets article abstract file ready for analysis
  run_tools
################################################################################################################
#CREATE PIECHART FOR EACH INDEX MEASURE IN STATS FROM PUBMED SEARCH ***
################################################################################################################
  INPUT="$dir_path"/"$topic"stat_names.csv
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
  while IFS=, read -r name num column
  do
    source "$1"/scripts/config.shlib; # load the directory variables
    cd "$1"/scripts # change directory to those files
    topic="$(config_get topic)";
    main_dir="$(config_get main_dir)";
    dir_path="$main_dir"/"$topic";
    wkd="$dir_path"/stats/"$name";
    dtm="$wkd"
    createdir
    mwkd="$main_dir"/topic_stats;
    file_in="$dir_path"/"$topic"stats.csv;
    file_out="$wkd"/"$name".csv;
    file_out2="$mwkd"/"$topic"stats.csv;
    column_num="$column";
    tool=unique;
    run_tools #will create unique list of files
    if [ "$name" == "Country" ];
    then
      mwkd="$main_dir"/topic_stats;
      file_out="$wkd"/"$name".csv;
      file_out3="$wkd"/"$name"lowcounts.csv;
      file_out4="$wkd"/"$name"new.csv;
      Country #preps metadata category countries to make pie charts
      file_in="$wkd"/"$name"lowcounts.csv;
      file_out="$wkd"/"$name"new.csv;
      totals=$(cat "$file_in" | awk -F',' '{s+=$1} END {print s}') 
      column1="$totals";
      column2=other;
      header=yes
      find_totals #sum of columns from file that contains low frequency to collapse all countries with less then 60 articles into an other category the countries included in other can be seen in the Countrylowcounts.csv file
    fi
    if [[ "$name" == "YearA" || "$name" == "YearR" ]];
    then
      file_out="$wkd"/"$name".csv;
      file_out4="$wkd"/"$name"new.csv;
      Year #will get rid of articles that do not have a year in there metadata.
    fi 
    file_in="$wkd"/"$name"new.csv;
    file_out="$wkd"/"$name".tiff;
    Rtools=piechart
    tool=chart;
    run_tools # will create pie charts for each file
    cd
  done
  } < $INPUT
  IFS=$OLDIFS
################################################################################################################
#CREATES TOTAL NUMBER OF ARTICLES FOUND FOR EACH TOPIC ***
################################################################################################################
  file_in="$dir_path"/"$topic"stats.csv;
  file_out="$main_dir"/totals.csv;
  if [ -s "$file_in" ]; then
    column1="$topic";
    totals=$(cat "$file_in" | wc -l);
    column2="$totals";
    header=yes
    find_totals # this will find how many articles were found with metadata
  fi
  if [ -s "$file_in" ]; then
  file_in="$dir_path"/"$topic"abPMID.csv
  file_out="$main_dir"/abstotal.csv
    column1="$topic";
    totals=$(cat "$file_in" | wc -l);
    column2="$totals";
    header=yes
    find_totals # this will find how many articles were found with an abstract
  fi
################################################################################################################
#SEARCH THE ABSTRACTS FOR EACH **TERM** IN A CATAGORY AND MAKE GRAPHS ***
################################################################################################################
  search_file="$main_dir"/scripts/search_terms.csv
  for number in {1..2} ;
  do 
    search_cat=$(awk -F, 'NR==1{print $'$number'}' "$search_file"); #grep header name from search_terms file those are search term catagories
    if [ "$search_cat" != "" ]; then
      create_absearch
      config=/home/user/lit_search/scripts/config.cfg.defaults
      phrase=$(echo "search_cat=")
      phrase2=$(echo "search_cat="$search_cat"")
      set_cat_var
      config=/home/user/lit_search/scripts/config.cfg.defaults
      phrase=$(echo "catnum=")
      phrase2=$(echo "catnum="$number"")
      set_cat_var
      config=/home/user/lit_search/scripts/config.cfg.defaults
      phrase=$(echo "search=")
      phrase2=$(echo "search=catgor"$catnum"")
      set_cat_var
      if [ "$number" == "1" ];
      then
        INPUT="$search_file"
        {
        [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
        read
        while IFS=, read -r catgor1 catgor2
        do
          source /home/user/lit_search/scripts/config.shlib; # load the config library functions
          cd /home/user/lit_search/scripts #cd directory to where config files are stored
          catnum="$(config_get catnum)";
          search_cat="$(config_get search_cat)";  
          search="$catgor1";
          run_ind_st # will create pie charts for search term against not search term
        done
        } < $INPUT
        IFS=$OLDIFS
        total_cat_terms #PIECHARTS FOR EACH **CATEGORY BROKEN DOWN BY TERMS SEARCH_TERMS.CSV ***
        searchterm_bargraph #CHARTS FOR EACH TOPIC BROKEN DOWN BY CATEGORIES *(wont print bar) creates number of articles for each search term grouped by category
        catgor_piechart #CHARTS COMPARING categories *** pie chart for all search terms at least once in a category against none found
        topic_bar_prep #CHARTS COMPARING categories * bar chart for each topic with categories showing how many found.
      fi
      if [ "$number" == "2" ];
      then
        INPUT="$search_file"
        {
        [ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
        read
        while IFS=, read -r catgor1 catgor2
        do
          source /home/user/lit_search/scripts/config.shlib; # load the config library functions
          cd /home/user/lit_search/scripts #cd directory to where config files are stored
          catnum="$(config_get catnum)";
          search_cat="$(config_get search_cat)";  
          search="$catgor2";
          run_ind_st
        done
        } < $INPUT
        IFS=$OLDIFS
        total_cat_terms # set up for charts later ***
        searchterm_bargraph #x=terms in category y=how many articles for each term *(wont print bar)
        catgor_piechart # pie chart for all search terms at least once in a category. *** 
        topic_bar_prep # prep file for each category total to but in bar graph for each topic.
      fi        
    fi
  done
  topic_bar #x=categories in topic y=how many articles contain at least one search term from each cat.
done
################################################################################################################
#CHARTS COMPARING TOPICS * bar chart for total number of articles for each topic with or wout abstracts
################################################################################################################
mwkd="$main_dir"/topic_stats;
file_out="$main_dir"/totals_list.csv;
search_term_matrix_main #makes a unique list of all main topics articles to find percentage of articles with each main topic
file_in="$main_dir"/abstotal.csv;
file_out="$main_dir"/abstotal.tiff;
name=empty;
tool=barchart;
Rtools=barchart
run_tools # will create bar chart for total number of articles with abstracts for each topic
file_in="$main_dir"/totals.csv;
file_out="$main_dir"/totals.tiff;
name=empty;
tool=barchart;
Rtools=barchart
run_tools # will create bar chart for total number of articles for each topic with or wout abstracts
