#!/usr/bin/env bash
conditionname1=$(awk -F, 'NR==2{print $2}' "$dir_path"/condition.csv)
conditionname2=$(awk -F, 'NR==3{print $2}' "$dir_path"/condition.csv)
dir_path="$(config_get dir_path)"; # main directory
wd="$dir_path"/working_directory; # working directory
ref_dir_path="$dir_path"/references; # reference directory
dirqc="$dir_path"/quality_control; # qc directory
AIDDtool=~/AIDD/AIDD_tools; # AIDD tool directory
rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
rdbam="$dir_path"/raw_data/bam_files # directory for bam files
javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
sra="$(config_get sra)"; # downloading sra files or have your own
library="$(config_get library)"; # paired or single
aligner="$(config_get aligner)"; # HISAT2 or STAR
assembler="$(config_get assembler)"; # Strintie or cufflinks
variant="$(config_get variant)"; # variant calling
instance="$(config_get instance)"; # instance or computer
instancebatch="$(config_get instancebatch)"; # are you running a batch number
batch="$(config_get batch)"; # which batch number
ref="$(config_get ref)"; # do you want to download your references
pheno="$(config_get pheno)"; # is your pheno data local or do you need to download it
bamfile="$(config_get bamfile)"; # do you already have bam files
scRNA="$(config_get scRNA)"; # bulk or single cell
human="$(config_get human)"; # human or mouse
ref_set="$(config_get ref_set)"; # GRCh37 or GRCH38
miRNA="$(config_get miRNA)"; # mRNA or miRNA
start=12;
end=97;
Gmatrix_name=gene_count_matrix.csv; 
Tmatrix_name=transcript_count_matrix.csv;
file_sra="$run".sra;
file_fastq="$run".fastq;
file_fastqpaired1="$run"_1.fastq;
file_fastqpaired2="$run"_2.fastq;
file_fastqpaired1pass="$run"_pass_1.fastq;
file_fastqpaired2pass="$run"_pass_2.fastq;
file_fastqpaired1trim="$run"_trim_1.fastq;
file_fastqpaired2trim="$run"_trim_2.fastq;
file_sam="$run".sam;
file_bam="$run".bam;
file_tab="$run".tab;
file_name_gtf="$sample".gtf;
file_bam_2="$run"_2.bam;
file_bam_3="$run"_3.bam;
file_pdf="$run"_insert_size_histogram.pdf;
file_bam_dup="$run"_dedup_reads.bam;
file_bam_recal="$run"recal_reads.bam;
file_vcf_raw="$run"raw_variants.vcf;
file_vcf_recal="$run"raw_snps_recal.vcf;
file_vcf_final="$run"filtered_snps_final;
snpEff_out="$run"filtered_snps_finalAnn;
snp_csv=snpEff"$run";
snp_stats="$run";
snpEff_in="$run"filtered_snps_final;
wd="$dir_path"/working_directory;
raw_impact="$dir_path"/raw_data/snpEff/snpEff"$run".genes.txt;
##move impact files to working directory and converting from txt to csv
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  sed '1,2d' $raw_impact | sed 's/ \+/,/g' >> "$dir_path"/Results/variant_calling/impact/"$x"genes.csv
  rm "$dir_path"/Results/variant_calling/impact/"$x"genes.txt
done < $INPUT
IFS=$OLDIFS
##seperate impact files to look at just moderate impact and high impact variants only as well as seperating by condition
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
  awk '{print $2, $5}' "$dir_path"/Results/variant_calling/impact/"$x"genes.csv | column -t > "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high3.txt | column -t > "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high2.txt
   awk '!x[$1]++ { print $1}' "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high2.txt | column -t > "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high.txt 
   sed 's/ \+/,/g' "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high.txt > "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high.csv
     sed -i "1i\ $condition" "$dir_path"/Results/variant_calling/gene/high_impact/"$x""$condition"high.csv
      rm "$dir_path"/Results/variant_calling/gene/high_impact/*.txt

  awk '{print $2, $7}' "$dir_path"/Results/variant_calling/impact/"$x"genes.csv | column -t > "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate3.txt| column -t > "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate2.txt
   awk '!x[$1]++ { print $1 }' "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate2.txt| column -t > "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.txt
   sed 's/ \+/,/g' "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.txt > "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.csv
     sed -i "1i\ $condition" "$dir_path"/Results/variant_calling/gene/moderate_impact/"$x""$condition"moderate.csv 
      rm "$dir_path"/Results/variant_calling/gene/moderate_impact/*.txt

  awk '{print $3, $5}' "$dir_path"/Results/variant_calling/impact/"$x"genes.csv | column -t > "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high3.txt > "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high2.txt
   awk '!x[$1]++ { print $1 }' "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high2.txt > "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high.txt
   sed 's/ \+/,/g' "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high.txt > "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high.csv
     sed -i "1i\ $condition" "$dir_path"/Results/variant_calling/transcript/high_impact/"$x""$condition"high.csv
      rm "$dir_path"/Results/variant_calling/transcript/high_impact/*.txt

  awk '{print $3, $7}' "$dir_path"/Results/variant_calling/impact/"$x"genes.csv | column -t > "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate3.txt
   awk '{ if($2 >= 1) { print $1, $2}}' "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate3.txt > "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate2.txt
   awk '!x[$1]++ { print $1 }' "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate2.txt > "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.txt
   sed 's/ \+/,/g' "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.txt > "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.csv
     sed -i "1i\ $condition" "$dir_path"/Results/variant_calling/transcript/moderate_impact/"$x""$condition"moderate.csv
      rm "$dir_path"/Results/variant_calling/transcript/moderate_impact/*.txt
done < $INPUT
IFS=$OLDIFS
##divid files by condition to combine into gene list for venndiagrams.
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read  x run condition sample t_name2
do
for i in gene transcript ; do
for j in high moderate ; do
  mv "$dir_path"/Results/variant_calling/"$i"/"$j"_impact/*$condition* "$dir_path"/Results/variant_calling/"$i"/"$j"_impact/"$condition"/
done
done
done < $INPUT
IFS=$OLDIFS
## this will clean directories to get ready for analysis
for i in gene transcript ; do
for j in moderate high ; do
  rm "$dir_path"/Results/variant_calling/$i/"$j"_impact/*condition*
done
done
## clean directories to get ready for analysis
for i in gene transcript ; do
for j in moderate high ; do
for l in $conditionname1 $conditionname2 ; do
  sed -i 's/level/'$i'/g' "$dir_path"/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/protein_effect/'$j'/g' "$dir_path"/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/condition/'$l'/g' "$dir_path"/ExToolset/I_VEX/multimergeimpact.R 
  Rscript  "$dir_path"/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/'$i'/level/g' "$dir_path"/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/'$j'/protein_effect/g' "$dir_path"/ExToolset/I_VEX/multimergeimpact.R
  sed -i 's/'$l'/condition/g' "$dir_path"/ExToolset/I_VEX/multimergeimpact.R
done
done
done
## this will remove duplicates from final
for i in gene transcript ; do
for j in moderate high ; do
for l in $conditionname1 $conditionname2 ; do
   awk -F"," '!x[$1]++ { print $1 }' "$dir_path"/Results/variant_calling/"$i"/"$j"_impact/final/"$l""$i""$j"final2.csv | column -t > "$dir_path"/Results/variant_calling/"$i"/"$j"_impact/final/"$l""$i""$j"final.csv
   rm "$dir_path"/Results/variant_calling/"$i"/"$j"_impact/final/"$l""$i""$j"final2.csv
done
done
done
##this combines gene lists
for i in gene transcript ; do
for j in moderate high ; do
paste -d , "$dir_path"/Results/variant_calling/$i/"$j"_impact/final/* > "$dir_path"/Results/variant_calling/"$i"/"$j"_impact/final/"$i""$j"final.csv
done
done
##to create venndiagrams
sed -i 's/DESeq2\/level\/differential_expression\/venndiagrams\/file_name/variant_calling\/level\/protein_effect_impact\/final\/levelprotein_effectfinal/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
for i in gene transcript ; do
for j in moderate high ; do
sed -i 's/level/'$i'/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/protein_effect/'$j'/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/set_column_name/"'$conditionname1'","'$conditionname2'"/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R 
sed -i 's/set_colors/"red","blue"/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/set_alpha/0.5,0.5/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
Rscript "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/"'$conditionname1'","'$conditionname2'"/set_column_name/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/"red","blue"/set_colors/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/0.5,0.5/set_alpha/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/'$i'/level/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
sed -i 's/'$j'/protein_effect/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
done
done
sed -i 's/variant_calling\/level\/protein_effect_impact\/final\/levelprotein_effectfinal/DESeq2\/level\/differential_expression\/venndiagrams\/file_name/g' "$dir_path"/ExToolset/I_VEX/Gvenn.R
##to create unique gene lists
sed -i 's/file_name/levelprotein_effectfinal/g' "$dir_path"/ExToolset/I_VEX/venntexttogenelistimpact.sh
for i in gene transcript ; do
for j in moderate high ; do
sed -i 's/level/'$i'/g' "$dir_path"/ExToolset/I_VEX/venntexttogenelistimpact.sh
sed -i 's/protein_effect/'$j'/g' "$dir_path"/ExToolset/I_VEX/venntexttogenelistimpact.sh
bash "$dir_path"/ExToolset/I_VEX/venntexttogenelistimpact.sh
sed -i 's/'$i'/level/g' "$dir_path"/ExToolset/I_VEX/venntexttogenelistimpact.sh
sed -i 's/'$j'/protein_effect/g' "$dir_path"/ExToolset/I_VEX/venntexttogenelistimpact.sh
done
done
sed -i 's/levelprotein_effectfinal/file_name/g' "$dir_path"/ExToolset/I_VEX/venntexttogenelistimpact.sh

