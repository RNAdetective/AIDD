#!/usr/bin/env bash
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
ExToolsetix=/home/user/AIDD/AIDD/ExToolset/indexes/human
dir_path=/media/sf_AIDD/all_excitomefreq
INPUT="$ExToolsetix"/"$human"/excitome_loc.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r excitome_gene gene_id snp_database chrome coord strand annotation AAsubstitution AAposition exon codon_position express_value edit_value
do
  for type in Cause_of_death phenotype ;
  do
    echo "Starting "$excitome_gene"
___________________________________
___________________________________"
    ExToolset=/home/user/AIDD/AIDD/ExToolset/scripts
    dir_path=/media/sf_AIDD/all_excitomefreq
    new_dir="$dir_path"/"$type"
    create_dir
    file_in="$dir_path"/MDDfreqall2gather.csv
    file_out="$dir_path"/"$type"/MDDfreqall2"$excitome_gene".tiff
    file_out2="$dir_path"/"$type"/"$excitome_gene"ANOVA.txt
    cat "$ExToolset"/excitomegraphs.R | sed 's/e2_gene/'$excitome_gene'/g' | sed 's/COD/'$type'/g' >> "$dir_path"/temp.R
    Rscript "$dir_path"/temp.R "$file_in" "$file_out" "$file_out2"
    rm "$dir_path"/temp.R
  done
done
} < $INPUT
IFS=$OLDIFS
