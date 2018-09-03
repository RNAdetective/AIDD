conditionname1=$(awk -F, 'NR==3{print $2}' /media/sf_AIDD/condition.csv)
conditionname2=$(awk -F, 'NR==2{print $2}' /media/sf_AIDD/condition.csv)
conditionname3=$(awk -F, 'NR==4{print $2}' /media/sf_AIDD/condition.csv)
conditionname4=$(awk -F, 'NR==5{print $2}' /media/sf_AIDD/condition.csv)
conditionname5=$(awk -F, 'NR==6{print $2}' /media/sf_AIDD/condition.csv)
condition1=$(awk -F, 'NR==3{print $1}' /media/sf_AIDD/condition.csv)
condition2=$(awk -F, 'NR==2{print $1}' /media/sf_AIDD/condition.csv)
condition3=$(awk -F, 'NR==4{print $1}' /media/sf_AIDD/condition.csv)
condition4=$(awk -F, 'NR==5{print $1}' /media/sf_AIDD/condition.csv)
condition5=$(awk -F, 'NR==6{print $1}' /media/sf_AIDD/condition.csv)
##this loop creates the tables from snpEff output to create amino acid sub and nucleotide sub tables and moves thes to new folders for downstream R.
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  sed 's/#/>/g' /media/sf_AIDD/raw_data/snpEff/snpEff"$run".csv > /media/sf_AIDD/raw_data/snpEff/global"$x".csv
  sed -i 's/ //g' /media/sf_AIDD/raw_data/snpEff/global"$x".csv
  sed -i 's/:/_/g' /media/sf_AIDD/raw_data/snpEff/global"$x".csv
  sed -i 's/\//_/g' /media/sf_AIDD/raw_data/snpEff/global"$x".csv
  sed -i 's/:/_/g' /media/sf_AIDD/raw_data/snpEff/global"$x".csv
  sed -i '/^\s*$/d' /media/sf_AIDD/raw_data/snpEff/global"$x".csv
  sed -i 's/run_name/'$x'/g' /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom2.sh
  bash /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom2.sh
  sed -i 's/'$x'/run_name/g' /media/sf_AIDD/bashScripts/variantcalling/splitfastachrom2.sh
  sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$x"/Aminoacidchangetable.csv
  sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$X"/Basechanges.csv
## this function takes only Q toR R to G and I to V substitutions.  Maybe add NtoS substitutions to this as well.
  main_function() {
    QtoR=$(awk -F, 'NR==17{print $18}' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$x"/Aminoacidchangetable.csv)
    RtoG=$(awk -F, 'NR==18{print $9}' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$x"/Aminoacidchangetable.csv)
    ItoV=$(awk -F, 'NR==11{print $21}' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$x"/Aminoacidchangetable.csv)
    echo "$x,$QtoR,$RtoG,$ItoV"
  }
  main_function 2>&1 | tee -a /media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/global"$x"subs.csv 
##this R script will transpose the tables to find averages
   sed -i "1i\run,QtoR,RtoG,ItoV" /media/sf_AIDD/Results/variant_calling/haplotype/gene/amino_acid/global"$x"subs.csv 
   sed -i 's/run_name/'$x'/g' /media/sf_AIDD/Rscripts/transpose.R 
   Rscript /media/sf_AIDD/Rscripts/transpose.R
   sed -i 's/'$x'/run_name/g' /media/sf_AIDD/Rscripts/transpose.R

done < $INPUT
IFS=$OLDIFS
## this will make new folder called final for the amino acid subs file to be place to combine them into one.
for i in gene transcript ; do
mkdir /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/amino_acid/final/
mv /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/amino_acid/*final* /media/sf_AIDD/Results/variant_calling/haplotype/"$i"/amino_acid/final/
done
## this will merge all AA sub files into one table for making bar graphs.
Rscript /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
##this script runs and makes aerage and sd table then creates a bar graph with those averages.
for m in ItoV QtoR RtoG ; do
sed -i 's/set_barcolors/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/set_x/x=condition/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/file_name/'$m'/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/Rscripts/variantbartables.R
Rscript /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/x=condition/set_x/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/'$m'/file_name/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/Rscripts/variantbartables.R
done
## this will make all aasubs and ntsubs tables
for m in amino_acid nucleotide ; do
mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/"$m"/allfinal/
done
## this will run bargraphs for all subs
sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$X"/Basechanges.csv
sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$x"/Aminoacidchangetable.
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample cell
do
    sed -i 's/cell_line/'$x'/g' /media/sf_AIDD/Rscripts/variantsubsallmerge.R
    Rscript /media/sf_AIDD/Rscripts/variantsubsallmerge.R
    sed -i "s/"$x"/cell_line/g" /media/sf_AIDD/Rscripts/variantsubsallmerge.R
done < $INPUT
IFS=$OLDIFS
Rscript /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
for m in ItoV QtoR RtoG ; do
sed -i 's/set_barcolors/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/set_x/x=condition/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/file_name/'$m'/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/set_fill/fill=condition/g' /media/sf_AIDD/Rscripts/variantbartables.R
Rscript /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/"#FF6666", "#FFFF99", "#66FF66", "#6633FF", "#CC66FF"/set_barcolors/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/x=condition/set_x/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/'$m'/file_name/g' /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/fill=condition/set_fill/g' /media/sf_AIDD/Rscripts/variantbartables.R
done
##this will make vectors of each cell line
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  sed -i '1d' /media/sf_AIDD/Results/variant_calling/haplotype/gene/vcf_tables/global"$x"/Basechanges.csv
done < $INPUT
##create all variant files
IFS=$OLDIFS
INPUT=/media/sf_AIDD/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample cell
do
    sed -i 's/cell_line/'$x'/g' /media/sf_AIDD/Rscripts/variantsubsallmerge.R
    Rscript /media/sf_AIDD/Rscripts/variantsubsallmerge.R
    sed -i "s/"$x"/cell_line/g" /media/sf_AIDD/Rscripts/variantsubsallmerge.R
done < $INPUT
IFS=$OLDIFS
sed -i 's/final/allfinal/g' /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
Rscript /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
sed -i 's/amino_acid/nucleotide/g' /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
Rscript /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
sed -i 's/nucleotide/amino_acid/g' /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
sed -i 's/allfinal/final/g' /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
##still need to add a script to get rid of rows with letters and first column
for m in AtoA CtoA GtoA TtoA AtoC CtoC GtoC TtoC AtoG CtoG GtoG TtoG AtoT CtoT GtoT TtoT ; do
sed -i 's/file_name/'$m'/g' /media/sf_AIDD/Rscripts/variantbartables.R
Rscript /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/'$m'/file_name/g' /media/sf_AIDD/Rscripts/variantbartables.R
done
##combine average and sd files
mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/merged/
for m in AtoA CtoA GtoA TtoA AtoC CtoC GtoC TtoC AtoG CtoG GtoG TtoG AtoT CtoT GtoT TtoT ; do
mv /media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/*confinal"$m".csv /media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/merged/
done
##run R merge
Rscript /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R
##still need to run amino acids



##still need to add a script to get rid of rows with letters and first column
for m in AtoA CtoA GtoA TtoA AtoC CtoC GtoC TtoC AtoG CtoG GtoG TtoG AtoT CtoT GtoT TtoT ; do
sed -i 's/file_name/'$m'/g' /media/sf_AIDD/Rscripts/variantbartables.R
Rscript /media/sf_AIDD/Rscripts/variantbartables.R
sed -i 's/'$m'/file_name/g' /media/sf_AIDD/Rscripts/variantbartables.R
done
##combine average and sd files
mkdir /media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/merged/
for m in  CtoA GtoA TtoA AtoC CtoC GtoC TtoC AtoG CtoG GtoG TtoG AtoT CtoT GtoT TtoT ; do
mv /media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/*confinal"$m".csv /media/sf_AIDD/Results/variant_calling/haplotype/gene/nucleotide/allfinal/merged/
done

##run R merge
Rscript /media/sf_AIDD/Rscripts/variantsubsfinalmerge.R

