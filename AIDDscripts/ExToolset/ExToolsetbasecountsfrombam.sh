##INSTRUCTIONS FOR USE
#This script requires a bam file and a vcf file created by that bam file
#it will take the vcf file and extract read counts and nucleotide counts for the sites contained in the vcf file.
#it is setup to use with AIDD more specifically it is setup to use AIDD directories
#put all bam files in /media/sf_AIDD/bamfiles
#put coordinate list in /media/sf_AIDD/vcffiles
#run bash /path/to/basecountsfrombam.sh
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this function creates directories $new_dir
remove() {
if [ -d "$file_in" ];
then
  echo ""$file_in" already found"
  rm -r "$file_in"
fi
} #this function removes files and directories
get_tool() {
git clone https://github.com/genome/bam-readcount.git #gets bam-readcount tool
}
index() {
java -jar $AIDDtool/picard.jar BuildBamIndex INPUT="$files" 
} #function to create bam index file
find_freq() {
"$tool" -w 0 -l "$coord" -f "$ref" "$files" | awk '$4 != 0' | cut -d" " -f5 --complement >> "$file_out" # runs bam-readcount with coordinate file and corresponding bam file along with references used for variant calling to create vcf files
} # function for running bam-readcount with coordinate file and corresponding bam file along with references used for variant calling to create vcf files
edit_freq() {
if [ ! -s "$file_out" ];
then
  echo "chromosome,coordinate,reference,stackdepth,A,C,G,T" >> "$file_out"
fi
cat "$file_in" | sed 's/=//g' | sed 's/:/,/g' | awk ' { print $1"," $2"," $3","$4","$5","$6","$7","$8","$9 } ' | cut -d',' -f 1,2,3,4,20,34,48,62 | awk -F ',' '{if ($4 >= '100') {print}}' | sed 's/ /,/g' >> "$file_out"
}
create_coord() {
cat "$vcf_file"  | sed '/^#/d' | awk '{print $1,$2,$2}' >> "$coord"
} # function for creating coordinate list from each individual vcf file for the corresponding
main_dir="$1" #this is the /home/user directory in AIDD
ref_dir="$main_dir"/AIDD/references # this is the directory in AIDD to find reference files used to create vcf files 
out_dir="$2" # this is the directory to write the files to and were bam and vcf folder should be located
vcf_dir="$out_dir"/raw_data/vcf_files/final #defining where vcf files are located
coor_dir="$vcf_dir"/coordinatelists
new_dir="$coor_dir"
create_dir #creates a folder to put coordinate txt files in for finding variants
bam_dir="$out_dir"/raw_data/bam_files #defining where bam files are located
AIDDtool="$main_dir"/AIDD/AIDD_tools
count_tool="$AIDDtool"/bam-readcount #define where bam-readcount folder is located 
tool="$count_tool"/bin/bam-readcount
download="$main_dir"/Downloads
LOG_LOCATION="$out_dir"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/ExToolsetBaseCounts.log)
exec 2>&1

echo "Log Location will be: [ $LOG_LOCATION ]"
if [ ! -f "$tool" ]; # if you don't have bam-readcounts tool installed
then
  file_in="$download"/bam-readcount
  remove
  file_in="$count_tool"
  remove
  cd "$download" #change to directory where bam-readcounts was downloaded (with AIDD this is /home/user/Downloads)
  get_tool
  new_dir="$count_tool" 
  create_dir #creates the directory where the tool is to be installed
  cd "$new_dir"
  cmake "$download"/bam-readcount #moves tools from downloads to tool directory
  cd "$new_dir"
  make #installs tool
  cd
fi
output="$out_dir"/frequency_counts #this is where output text files from bam-readcounts will be created
new_dir="$output"
create_dir #makes the output directory exists
for files in "$bam_dir"/* ; # takes each bam file in the /bamfile directory
do
  find "$bam_dir" -maxdepth 1 -type d | sed 's/\//,/g' >> "$out_dir"/temp.csv
  dirnum=$(head -n 1 "$out_dir"/temp.csv | grep -o "," | wc -l)
  filenum=$(expr "$dirnum" + 2)
  extnum=$(expr "$dirnum" + 3)
  echo "$filenum,$extnum" 
  dir_name=$(echo "$files" | sed 's/\//./g' | cut -f "$filenum" -d '.') 
  file_name=$(echo "$dir_name" | cut -f 1 -d '.')
  echo "Now starting base counts for "$file_name""
  file_ext=$(echo "$files" | sed 's/\//./g' | cut -f "$extnum" -d '.')
  bambai="$bam_dir"/"$file_name".bai
  bambai2="$bam_dir"/"$file_name".bam.bai
  if [ "$files" != "$bambai2" ]; # if bam index file does not exist 
  then
    if [ ! -f "$bambai2" ];
    then
      index
      mv "$bambai" "$bambai2"
    else
      echo "Already have index file for "$file_name""
    fi
  fi
  vcf_file="$vcf_dir"/"$file_name"filtered_snps_finalAllNoSnpsediting.vcf #name of vcf_file based on identifier (run #) bam file and vcf file have to have same identifie
  echo "$vcf_file"
  coord="$coor_dir"/"$file_name"coordinatelist.txt #coordinate list 
  if [ -s "$vcf_file" ];
  then
    create_coord # creates coordinate file
  else
    echo "Can't find vcf_file"
  fi
  file_out="$output"/"$file_name"All.txt
  ref="$ref_dir"/ref2.fa
  if [ ! -s "$file_out" ];
  then
    if [ -s "$ref_dir" ];
    then
      if [ -s "$coord" ];
      then
        find_freq
        file_in="$file_out"
        file_out=""$output"/"$file_name"All.csv"
        if [ -s "$file_in" ];
        then
          edit_freq
        else
          echo "Can't find "$file_in""
        fi
      else
        echo "Can't find coordinate list check you vcffile directory to see if coordinate list is missing" # if can't find 
      fi
    else
      echo "Can't find reference .fa file in /home/user/AIDD/references"; exit # stop script if you don't have reference file
    fi
  else
    echo ""$file_name" results already found" #if you already have results for that sample it will tell you and move on
  fi
done
