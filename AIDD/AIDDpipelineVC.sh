#!/usr/bin/env bash
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
TIME_HOUR=$(date +%H)
TIME_MIN=$(date +%M)
TIME_SEC=$(date +%S)
home_dir="$1" # home_dir="$home_dir"
dir_path="$2" # dir_path="$home_dir"/testAIDD 
ref_dir_path="$home_dir"/AIDD/references  # this is where references are stored
ExToolset="$dir_path"/AIDD/ExToolset/scripts
ExToolsetix="$home_dir"/AIDD/AIDD/ExToolset/indexes
AIDDtool="$home_dir"/AIDD/AIDD_tools
wd="$dir_path"/working_directory
dirres="$dir_path"/Results; #
dirraw="$dir_path"/raw_data;
rdbam="$dirraw"/bam_files
rdvcf="$dirraw"/vcf_files
rdvcf_final="$dirraw"/vcf_files/final
rdsnp="$dirraw"/snpEff
source config.shlib; # load the config library functions
export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
qc_dir="$dir_path"/quality_control
LOG_LOCATION="$qc_dir"/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/AIDDpipelineVC.log)
exec 2>&1
echo "Log Location will be: [ $LOG_LOCATION ]"
####################################################################################################################
####################################################################################################################
####################################################################################################################
#defines the functions
####################################################################################################################
####################################################################################################################
####################################################################################################################
create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
mes_out() {
dirqc="$dir_path"/quality_control
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$file_name","$file_in","$tool"" >> "$dirqc"/time_check/"$file_name"time_check.csv
file_size
echo "'$DATE_WITH_TIME' $echo1 $file_name $file_ext $file_size_kb
___________________________________________________________________________"
}
file_size() {
file_size_kb=`du -k "$file_in" | cut -f1`
#dir_name=$(echo "$file_in" | sed 's/\//./g' | cut -f 6 -d '.')
#file_name=$(echo "$dir_name" | cut -f 1 -d '.')
#file_ext=$(echo "$file_in" | sed 's/\//./g' | cut -f 7 -d '.')
new_dir="$dirqc"/file_size
create_dir
sizefile="$dirqc"/file_size/sizefile.csv
if [ ! -f "$sizefile" ];
then
  echo "run,file" >> "$sizefile"
fi
echo ""$file_name","$file_size_kb","$file_in"" >> "$sizefile"
}
next_samp() {
sam_num=${sample:7:8}
new_sam=$(("$sam_num" + 1));
next_sample=$(echo "sample"$new_sam"");
echo1=$(echo "FOUND "$sample" NOW STARTING "$next_sample"");
mes_out
}

steps() {
echo1=$(echo "DONE WITH "$step1" NOW STARTING "$step2"");
file_in="$step2"
tool="$step1"
mes_out
}
setjavaversion() {
   
JDK8="$AIDDtool"/jdk-8u221-linux-x64/jdk1.8.0_221/  
JDK11=/usr/lib/jvm/java-11-openjdk-amd64/                                                                                              
case $version in
  8)
     export JAVA_HOME="$JDK8"
     export PATH=$JAVA_HOME/bin:$PATH     ;
  ;;
  11)
     export JAVA_HOME="$JDK11"
     export PATH=$JAVA_HOME/bin:$PATH     ;
  ;;
  *)
     error java version can only be 1.8 or 1.11
  ;;
esac
}
name_files() {
  temp=$(echo "$dir_count" | sed 's/\//,/g')
  dirnum=$(echo "$temp" | grep -o "," | wc -l)
  filenum=$(expr "$dirnum" + 2)
  extnum=$(expr "$dirnum" + 3) 
  dir_name=$(echo "$files" | sed 's/\//./g' | cut -f "$filenum" -d '.')
  res="${dir_name//[^_]}"
  if [ "$res" == "" ];
  then
    file_name=$(echo "$dir_name" | cut -f 1 -d '.') 
    #sample=$(echo "$file_name" | cut -f 1 -d ':')
  else
    file_name=$(echo "$dir_name" | cut -f 1 -d '.' | cut -f 1-"${#res}" -d '_' )
    #sample=$(echo "$file_name" | cut -f 1 -d ':')
  fi
  file_ext=$(echo "$files" | sed 's/\//./g' | cut -f "$extnum" -d '.') 
}
run_tools() {
if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
then
  if [ -f "$file_in" ]; # IF INPUT THERE
  then
    echo1=$(echo "FOUND $file_in STARTING $tool");
    mes_out
    $tool # TOOL
  else
    echo1=$(echo "CANNOT FIND "$file_in" FOR "$sample"");
  fi
  if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND $file_out FINISHED $tool");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND $file_out FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$(echo "FOUND $file_out FINISHED $tool")
  mes_out # ERROR OUTPUT IS THERE
fi
}
run_tools2o() {
if [[ ! -f "$file_out" && ! -f "$file_out2" ]]; # IF OUTPUT FILE IS NOT THERE
then
  if [ -f "$file_in" ]; # IF INPUT THERE
  then
    echo1=$(echo "FOUND "$file_in" STARTING "$tool"");
    mes_out
    $tool # TOOL
  else
    echo1=$(echo "CANNOT FIND $file_in FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
  if [[ -f "$file_out" && -f "$file_out2" ]]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND $file_out FINISHED $tool");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND "$file_out" OR "$file_out2" FOR_THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$("FOUND "$file_out" FINISHED "$tool"");
  mes_out # ERROR OUTPUT IS THERE
fi
}
run_tools2i2o() {
if [[ ! -f "$file_out" && ! -f "$file_out2" ]]; # IF OUTPUT FILE IS NOT THERE
then
  if [[ -f "$file_in" && -f "$file_in2" ]]; # IF INPUT THERE
  then
    echo1=$("FOUND "$file_in" STARTING "$tool"");
    mes_out
    $tool # TOOL
  else
    echo1=$("CANNOT FIND "$file_in" OR "$file_in2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
  if [[ -f "$file_out" && -f "$file_out2" ]]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND "$file_out" AND "$file_out2" FINISHED "$tool"");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND "$file_out" OR "$file_out2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$(echo "FOUND "$file_out" OR "$file_out2" FINISHED "$tool"");
  mes_out # ERROR OUTPUT IS THERE
fi
}
run_tools2i() {
if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
then
  if [[ -f "$file_in" && -f "$file_in2" ]]; # IF INPUT THERE
  then
    echo1=$(echo "FOUND "$file_in" AND "$file_in2" STARTING "$tool"");
    mes_out
    $tool # TOOL
  else
    echo1=$(echo "CANNOT FIND "$file_in" OR "$file_in2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
  if [ -f "$file_out" ]; # IF OUTPUT IS THERE
  then
    echo1=$(echo "FOUND "$file_out" FINISHED "$tool"");
    mes_out # ERROR OUTPUT IS THERE
  else 
    echo1=$(echo "CANNOT FIND "$file_in" OR "$file_in2" FOR THIS "$sample"");
    mes_out # ERROR INPUT NOT THERE
  fi
else
  echo1=$(echo "FOUND "$file_out" FINISHED "$tool"")
  mes_out # ERROR OUTPUT IS THERE
fi
}
prep_bam_2() {
java $javaset -jar $AIDDtool/picard.jar AddOrReplaceReadGroups I="$file_in" O="$file_out" RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 ##this will set up filtering guidelines in bam files 
}
prep_bam_3() { 
java $javaset -jar $AIDDtool/picard.jar ReorderSam I="$file_in" O="$file_out" R="$ref_dir_path"/ref2.fa CREATE_INDEX=TRUE
}
prep_align_sum() {
java -jar $AIDDtool/picard.jar CollectAlignmentSummaryMetrics R="$ref_dir_path"/ref2.fa I="$file_in" O="$file_out" 
}
prep_align_sum2() {
java -jar $AIDDtool/picard.jar CollectInsertSizeMetrics INPUT="$file_in" OUTPUT=$file_out HISTOGRAM_FILE=$dirqc/insert_metrics/"$file_name"_insert_size_histogram.pdf ##this collect alignment metrics and piut them in quality control for user to look at for accuracy
}
prep_align_sum3() {
samtools depth "$file_in" > "$file_out" ##creates depth file for quality control on variant calling.
}
combine_file() {
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" | sed '/^$/d' | awk -F',' '!x[$1]++' >> "$file_out"
} # cuts each column out of matrix and makes its own file
summary_split() {
subname=$(cat "$dir_path"/PHENO_DATA.csv | awk -F',' '$2 == '$file_name' { print $1 }')
echo "$subname"
  cat "$dirqcalign"/"$file_name"_alignment_metrics.txt | sed '/^#/d' | sed 's/PAIR/'$file_name'/g' | sed 's/UN//g' | sed 's/ED//g' | sed '/^FIR/d' | sed '/^SEC/d' | sed 's/\t/,/g' | sed '1d' >> "$dirqcalign"/"$file_name"_alignment_metrics.csv
} #creates alignment matrix from txt file
sum_combine() {
cat "$dirqcalign"/*.csv | sed '/^$/d' | awk -F',' '!x[$1]++' >> "$dirqcalign"/all_summary.csv
file_in="$dirqcalign"/all_summary.csv
cat "$file_in" | sed '1!{/^CAT/d;}' >> "$dir_path"/temp.csv 
temp_file
file_in="$dirqcalign"/all_summary.csv
file_out="$dirqcalign"/all_summaryfilter.csv
col_num=$(echo "1,6,7,13,18,20,21,22,23")
tool=combine_file
run_tools
file_in="$dirqcalign"/all_summary.csv
file_out="$dirqcalign"/all_summarynorm.csv
col_num=$(echo "1,2")
tool=combine_file
run_tools
file_in="$dirqcalign"/all_summarynorm.csv
file_out="$dirqcalign"/all_summarynorm.tiff
bartype=$(echo "depth")
tool=Rbar
run_tools
} # makes big summary file matrix with all columns and creates bar graph
sum_divid() {
for colnum in 2 3 4 5 6 7 8 9 ; do
colname=$(awk -F, 'NR==1{print $'$colnum'}' "$dirqcalign"/all_summaryfilter.csv);
file_in="$dirqcalign"/all_summaryfilter.csv
file_out="$dirqcalign"/all_summary"$colname".csv
col_num=$(echo "1,"$colnum"")
tool=combine_file
run_tools
file_in="$dirqcalign"/all_summary"$colname".csv
cat "$file_in" | sed '1d' | sed '1i name,freq' >> "$dir_path"/temp.csv
temp_file
file_out="$dirqcalign"/all_summary"$colname".tiff
bartype=$(echo "depth")
tool=Rbar
run_tools
done
} # separates big summary into each category and creates bar graph
markduplicates(){
java $javaset -jar $AIDDtool/picard.jar MarkDuplicates INPUT="$file_in" OUTPUT="$file_out" METRICS_FILE="$wd"/"$run"metrics.txt
}
haplotype1() {
java -jar $AIDDtool/picard.jar BuildBamIndex INPUT="$file_in"
}
haplotype1B() {
AIDDtool="$home_dir"/AIDD/AIDD_tools
version=8
setjavaversion
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$file_in" --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$file_out"
}
haplotype1C() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$file_in" -F CHROM -F POS -F ID -F QUAL -F AC -o "$file_out"
}
filter1() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$file_in" -selectType SNP -o "$file_out"
}
filter1B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$file_in" -F CHROM -F POS -F ID -F QUAL -F AC -o "$file_out" ##select more variants for filtering
}
filter1C() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$file_in" -selectType INDEL -o "$file_out" ##starting filtering steps
}
filter1D() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$file_in" --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$file_out" ##moves and converts vcf filtered snp file into table
}
filter1E() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$file_in" -F CHROM -F POS -F ID -F QUAL -F AC -o "$file_out" ##more filtering
}
filter1F() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$file_in" --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$file_out" ##rns base recalibrator to create new bam files with filtering taken into account
}
filter1G() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$file_in" -knownSites "$wd"/"$file_name"filtered_snps.vcf -knownSites "$wd"/"$file_name"filtered_indels.vcf --filter_reads_with_N_cigar -o "$file_out" ##moves and converts vcf files
}
filter1H() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$file_in" -knownSites "$wd"/"$file_name"filtered_snps.vcf -knownSites "$wd"/"$file_name"filtered_indels.vcf -BQSR "$wd"/"$file_name"recal_data.table --filter_reads_with_N_cigar -o "$file_out"
}
filter1I() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T AnalyzeCovariates -R "$ref_dir_path"/ref2.fa -before "$wd"/"$file_name"recal_data.table -after "$wd"/"$file_name"post_recal_data.table -plots "$wd"/"$file_name"recalibration_plots.pdf ##creates new bam file containing filtering data.
}
filter1J() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T PrintReads -R "$ref_dir_path"/ref2.fa -I "$file_in" -BQSR "$wd"/"$file_name"recal_data.table --filter_reads_with_N_cigar -o "$file_out"
}
haplotype2() {
AIDDtool="$home_dir"/AIDD/AIDD_tools
version=8
setjavaversion
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$file_in" --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$file_out"
}
haplotype2B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$file_in" -F CHROM -F POS -F ID -F QUAL -F AC -o "$file_out"   
}
filter2() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$file_in" -selectType SNP -o "$file_out"
}
filter2B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$file_in" -F CHROM -F POS -F ID -F QUAL -F AC -o "$file_out"
}
filter2C() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$file_in" -selectType INDEL -o "$file_out"
}
filter2D() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$file_in" --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$file_out"
}
filter2E() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$file_in" -F CHROM -F POS -F ID -F QUAL -F AC -o "$file_out"
}
filter2F() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$file_in" --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$file_out"
}
move_vcf() {
mv "$wd"/"$file_name"raw_variants.vcf "$rdvcf"/
mv "$wd"/"$file_name"filtered_snps.vcf "$rdvcf"/
mv "$wd"/"$file_name"recal_data.table $dirqc/recalibration_plots/
mv "$wd"/"$file_name"raw_snps.vcf "$rdvcf"/
rm "$wd"/"$file_name"raw_indels.vcf
rm "$wd"/"$file_name"filtered_indels.vcf
if [ -f "$wd"/"$file_name"recalibration_plots.pdf ];
then
  rm "$wd"/"$file_name"recal_data.table
  rm "$wd"/"$file_name"post_recal_data.table
fi
}
move_vcf2() {
mv "$wd"/"$file_name"raw_variants_recal.vcf "$rdvcf"/
mv "$wd"/"$file_name"raw_snps_recal.vcf "$rdvcf"/
mv "$wd"/"$file_name"filtered_snps_finalAll.vcf "$rdvcf"/
}
move_vcf3() {
for i in raw final filtered ;
do
  new_dir=$dir_path/raw_data/vcf_files/"$i"/
  create_dir
  mv $dir_path/raw_data/vcf_files/*"$i"* $dir_path/raw_data/vcf_files/"$i"/
done
}
excitome_vcf() { 
## filter out everything that is not ADAR mediated editing
awk -F "\t" '/^#/' "$rdvcf_final"/"$file_name"filtered_snps_finalAll.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalinfo.vcf #
cat "$rdvcf_final"/"$file_name"filtered_snps_finalAll.vcf | awk -F "\t" ' { if ($3 == ".") { print } }' > "$rdvcf_final"/"$file_name"filtered_snps_finalAllNoSnpsediting.vcf
awk -F "\t" ' { if (($4 == "A") && ($5 == "G") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAllNoSnpsediting.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalAG.vcf
awk -F "\t" '{ if (($4 == "T") && ($5 == "C") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAllNoSnpsediting.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalTC.vcf
cat "$rdvcf_final"/"$file_name"filtered_snps_finalinfo.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalAG.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalTC.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalADARediting.vcf
awk -F "\t" ' { if (($4 == "C") && ($5 == "T") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAllNoSnpsediting.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalCT.vcf
awk -F "\t" '{ if (($4 == "G") && ($5 == "A") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAllNoSnpsediting.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalGA.vcf
cat "$rdvcf_final"/"$file_name"filtered_snps_finalinfo.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalCT.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalGA.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalAPOBECediting.vcf
}
snpEff() {
snpEff_out="$file_name"filtered_snps_finalAnn;
java $javaset -jar $AIDDtool/snpEff.jar -v GRCh37.75 "$rdvcf_final"/"$file_name"filtered_snps_final"$snptype".vcf -stats "$rdsnp"/"$file_name""$snptype" -csvStats "$rdsnp"/snpEff"$file_name""$snptype".csv > "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf     ##converts final annotationed vcf to table for easier processing
java "$javaset"  -jar "$AIDDtool"/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$rdsnp"/"$snpEff_out""$snptype".vcf -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F AC -F ANN -o "$rdsnp"/"$snpEff_out""$snptype".table
}
AllsnpEff() {
  for snptype in All AllNoSnpsediting ADARediting APOBECediting AG GA CT TC ; # DO ALL VARIANTS, ADAR VARIANTS, AND APOBEC VARIANTS
  do
    snpEff #runs snp effect prediction
    echo ""$file_name" is done." 
  done
}
basecounts() {
bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolsetbasecountsfrombam.sh "$home_dir" $dir_path/frequencies
}
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING STEP1 PREP BAM FILES
####################################################################################################################
####################################################################################################################
####################################################################################################################
dir_count="$rdbam"
for files in "$dir_count"/* ;
do
  if [ -d "$files" ];
  then
    echo ""$files" is a directory"
  else
    name_files
####################################################################################################################
#  prep_bam_2
####################################################################################################################
    tool=prep_bam_2
    file_in="$rdbam"/$file_name.bam    
    file_out="$wd"/"$file_name"_2.bam
    run_tools
####################################################################################################################
#  prep_bam_3
####################################################################################################################
    tool=prep_bam_3    
    file_in="$wd"/"$file_name"_2.bam
    file_out="$wd"/"$file_name"_3.bam
    run_tools
####################################################################################################################
#  prep_align_sum
####################################################################################################################
    tool=prep_align_sum
    file_in="$wd"/"$file_name"_3.bam   
    file_out="$dirqc"/alignment_metrics/"$file_name"_alignment_metrics.txt
    run_tools
    tool=prep_align_sum2
    file_in="$wd"/"$file_name"_3.bam
    file_out=$dirqc/insert_metrics/"$file_name"_insert_metrics.txt
    run_tools
    tool=prep_align_sum3
    file_in="$wd"/"$file_name"_3.bam
    file_out="$wd"/"$file_name"depth_out.txt
    rm -f "$wd"/"$file_name"_2.bam ##add option here donot remove files
    run_tools
####################################################################################################################
#  markduplicates
####################################################################################################################
    tool=markduplicates
    file_in="$wd"/"$file_name"_3.bam    
    file_out="$wd"/"$file_name"_dedup_reads.bam
    run_tools
  fi
####################################################################################################################
#  DISPLAY MESSAGES
####################################################################################################################
done
step1=$(echo "VARIANT_CALLING_1_PREP_BAM_FILE")
step2=$(echo "VARIANT_CALLING_2_FIRST_VARIANT_CALLING")
steps
####################################################################################################################
#  haplotype1
####################################################################################################################
dir_count="$rdbam"
for files in "$dir_count"/* ;
do
  if [ -d "$files" ];
  then
    echo ""$files" is a directory"
  else
    name_files 
    tool=haplotype1
    file_in="$wd"/"$file_name"_dedup_reads.bam    
    file_out="$wd"/"$file_name"_dedup_read.bai
    rm -f "$wd"/"$file_name"_3.bam ##add option here donot remove files
    run_tools
    tool=haplotype1B
    file_in="$wd"/"$file_name"_dedup_reads.bam    
    file_out="$wd"/"$file_name"raw_variants.vcf
    run_tools
    tool=haplotype1C
    file_in="$wd"/"$file_name"raw_variants.vcf   
    file_out="$rdvcf"/"$file_name"raw_variants.table
    run_tools
####################################################################################################################
#  filter1
####################################################################################################################
    tool=filter1
    file_in="$wd"/"$file_name"raw_variants.vcf   
    file_out="$wd"/"$file_name"raw_snps.vcf
    run_tools
    tool=filter1B
    file_in="$wd"/"$file_name"raw_snps.vcf    
    file_out="$rdvcf"/"$file_name"raw_snps.table
    #run_tools
    tool=filter1C
    file_in="$wd"/"$file_name"raw_variants.vcf 
    file_out="$wd"/"$file_name"raw_indels.vcf
    run_tools
    tool=filter1D
    file_in="$wd"/"$file_name"raw_snps.vcf
    file_out="$wd"/"$file_name"filtered_snps.vcf
    run_tools
    tool=filter1E
    file_in="$wd"/"$file_name"filtered_snps.vcf
    file_out="$rdvcf"/"$file_name"filtered_snps.table
    #run_tools
    tool=filter1F
    file_in="$wd"/"$file_name"raw_indels.vcf
    file_out="$wd"/"$file_name"filtered_indels.vcf
    run_tools
    tool=filter1G
    file_in="$wd"/"$file_name"_dedup_reads.bam
    file_out="$wd"/"$file_name"recal_data.table
    run_tools
    tool=filter1H
    file_in="$wd"/"$file_name"_dedup_reads.bam
    file_out="$wd"/"$file_name"post_recal_data.table
    run_tools
    tool=filter1I
    file_in="$wd"/"$file_name"recal_data.table
    file_in2="$wd"/"$file_name"post_recal_data.table
    file_out="$wd"/"$file_name"recalibration_plots.pdf
    run_tools2i
    tool=filter1J
    file_in="$wd"/"$file_name"_dedup_reads.bam
    file_out="$wd"/"$file_name"recal_reads.bam
    run_tools
    move_vcf
  fi
done
####################################################################################################################
#  haplotype2
####################################################################################################################
dir_count="$rdbam"
for files in "$dir_count"/* ;
do
  if [ -d "$files" ];
  then
    echo ""$files" is a directory"
  else
    name_files
    tool=haplotype2
    file_in="$wd"/"$file_name"recal_reads.bam    
    file_out="$wd"/"$file_name"raw_variants_recal.vcf
   # rm -f "$wd"/"$file_name"_dedup_reads.bam
    run_tools
    tool=haplotype2B
    file_in="$wd"/"$file_name"raw_variants_recal.vcf
    file_out="$rdvcf"/"$file_name"raw_variants_recal.table
    run_tools
####################################################################################################################
#  filter2
####################################################################################################################
    tool=filter2
    file_in="$wd"/"$file_name"raw_variants_recal.vcf    
    file_out="$wd"/"$file_name"raw_snps_recal.vcf
    run_tools
    tool=filter2B
    file_in="$wd"/"$file_name"raw_snps_recal.vcf
    file_out="$rdvcf"/"$file_name"raw_snps_recal.table
    run_tools
    tool=filter2C
    file_in="$wd"/"$file_name"raw_variants_recal.vcf
    file_out="$wd"/"$file_name"raw_indels_recal.vcf
    run_tools
    tool=filter2D
    file_in="$wd"/"$file_name"raw_snps_recal.vcf
    file_out="$wd"/"$file_name"filtered_snps_finalAll.vcf
    run_tools
    tool=filter2E
    file_in="$wd"/"$file_name"filtered_snps_finalAll.vcf
    file_out="$rdvcf"/"$file_name"filtered_snps_finalAll.table
    run_tools
    tool=filter2F
    file_in="$wd"/"$file_name"raw_indels_recal.vcf
    file_out="$wd"/"$file_name"filtered_indels_recal.vcf
    run_tools
    move_vcf
    move_vcf2
    move_vcf3
  fi
done
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
next_samp
step1=$(echo "VARIANT_CALLING")
step2=$(echo "VARIANT_CALLING_IMPACT_PREDICTION")
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING IMPACT PREDICTION
####################################################################################################################
####################################################################################################################
####################################################################################################################
dir_count="$rdbam"
for files in "$dir_count"/* ;
do
  if [ -d "$files" ];
  then
    echo ""$files" is a directory"
  else
    name_files
####################################################################################################################
#  EXCITOME FILTERING
####################################################################################################################
    tool=excitome_vcf
    file_in="$rdvcf_final"/"$file_name"filtered_snps_finalAll.vcf
    file_out="$rdvcf_final"/*ADARediting.vcf
    run_tools
####################################################################################################################
#  IMPACT PREDICTION
####################################################################################################################
    tool=AllsnpEff
    file_in="$rdvcf_final"/"$file_name"filtered_snps_finalAllNoSnpsediting.vcf    
    file_out="$rdsnp"/"$file_name"Ann.vcf
    run_tools  
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    next_samp
  fi
done
step1=$(echo "VARIANT_CALLING_4_IMPACT_PREDICTION")
step2=$(echo "RUNNING_BASECOUNTS_EDITING_SITES")
steps
####################################################################################################################
# RUN EXTOOLSET
####################################################################################################################
bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolset.sh 2 "$home_dir" "$dir_path" "$human"
####################################################################################################################
# CLEANING UP AND COMPRESSING FILES AFTER VARIANT CALLING
####################################################################################################################
step1=$(echo "RUNNING_EXTOOLSET")
step2=$(echo "CLEANING_UP_FILES")
steps
compress_AIDD
step1=$(echo "CLEANING_UP_FILES")
step2=$(echo "NOW_DONE_WITH_AIDD_PLEASE_CHECK_AND_CLEAN_OUT_sf_media_BEFORE_YOU_CAN_RUN_AIDD_AGAIN")
steps

