excitome_vcf() { 
## filter out everything that is not ADAR mediated editing
awk -F "\t" '/^#/' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalinfo.vcf #
awk -F "\t" ' { if (($4 == "A") && ($5 == "G")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalAG.vcf
awk -F "\t" '{ if (($4 == "T") && ($5 == "C")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalTC.vcf
cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalAG.vcf "$rdvcf"/"$run"filtered_snps_finalTC.vcf > "$rdvcf"/"$file_vcf_finalADAR"
awk -F "\t" ' { if (($4 == "C") && ($5 == "T")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalCT.vcf
awk -F "\t" '{ if (($4 == "G") && ($5 == "A")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalGA.vcf
cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalCT.vcf "$rdvcf"/"$run"filtered_snps_finalGA.vcf > "$rdvcf"/"$file_vcf_finalAPOBEC"
}
snpEff() {
    java $javaset -jar $AIDDtool/snpEff.jar -v GRCh37.75 "$rdvcf"/"$file_vcf_final""$snptype".vcf -stats "$rdsnp"/"$snp_stats""$snptype" -csvStats "$rdsnp"/"$snp_csv""$snptype".csv > "$rdsnp"/"$snpEff_out""$snptype".vcf
    ##converts final annotationed vcf to table for easier processing
    #java "$javaset"  -jar "$AIDDtool"/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F AC -F ANN -o "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".table
}
prep_bam_2() {
java $javaset -jar $AIDDtool/picard.jar AddOrReplaceReadGroups I="$rdbam"/$file_bam O="$wd"/$file_bam_2 RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 ##this will set up filtering guidelines in bam files 
}
prep_bam_3() { 
  java -jar $AIDDtool/picard.jar ReorderSam I="$wd"/$file_bam_2 O="$wd"/$file_bam_3 R="$ref_dir_path"/ref2.fa CREATE_INDEX=TRUE
}
prep_align_sum() {
##this collect alignment metrics and piut them in quality control for user to look at for accuracy
java -jar $AIDDtool/picard.jar CollectAlignmentSummaryMetrics R="$ref_dir_path"/ref2.fa I="$wd"/$file_bam_3 O="$wd"/"$run"_alignment_metrics.txt
java -jar $AIDDtool/picard.jar CollectInsertSizeMetrics INPUT="$wd"/$file_bam_3 OUTPUT="$wd"/"$run"_insert_metrics.txt HISTOGRAM_FILE="$wd"/"$run"_insert_size_histogram.pdf
##creates depth file for quality control on variant calling.
echo1=STARTING
echo2=SAMTOOLS
echo3=TO_CHECK
echo4=READ_DEPTH
mes_out
samtools depth "$wd"/$file_bam_3 > "$wd"/"$run"depth_out.txt
mv "$wd"/"$run"_alignment_metrics.txt $dirqc/alignment_metrics/
mv "$wd"/"$run"_insert_metrics.txt $dirqc/insert_metrics/
mv "$wd"/"$run"_insert_size_histogram.pdf $dirqc/insert_metrics/
}
combine_file() {
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" >> "$file_out"
}
Rbar() {
Rscript "$sim_scripts"/barchart.R "$file_in" "$file_out" "$bartype"
}
summary_split() {
INPUT="$dir_path"/PHENO_DATA2.csv
OLDIFS=$IFS  
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read samp_name run condition sample condition2 condition3 
do
  wkd="$dirqc"/alignment_metrics
  cat "$wkd"/"$run"_alignment_metrics.txt | sed '/^#/d' | sed 's/PAIR/'$run'/g' | sed '/^FIR/d' | sed '/^SEC/d' | sed 's/\t/,/g' | sed '1d' >> "$wkd"/"$run"_alignment_metrics.csv
done
} < $INPUT
IFS=$OLDIFS
}
sum_combine() {
wkd="$dirqc"/alignment_metrics
cat "$wkd"/*.csv | sed '/^$/d' >> "$wkd"/all_summary.csv
sed -i '1!{/^CAT/d;}' "$wkd"/all_summary.csv
file_in="$wkd"/all_summary.csv
file_out="$wkd"/all_summaryfilter.csv
col_num=$(echo "1,6,7,13,18,20,21,22,23")
tool=combine_file
run_tools
file_in="$wkd"/all_summary.csv
file_out="$wkd"/all_summarynorm.csv
col_num=$(echo "1,2")
tool=combine_file
run_tools
file_in="$wkd"/all_summarynorm.csv
file_out="$wkd"/all_summarynorm.tiff
bartype=$(echo "single")
tool=Rbar
run_tools
}
sum_divid() {
for colnum in 2 3 4 5 6 7 8 9 ; do
colname=$(awk -F, 'NR==1{print $'$colnum'}' "$wkd"/all_summaryfilter.csv);
file_in="$wkd"/all_summaryfilter.csv
file_out="$wkd"/all_summary"$colname".csv
col_num=$(echo "1,"$colnum"")
tool=combine_file
run_tools
file_in="$wkd"/all_summary"$colname".csv
file_out="$wkd"/all_summary"$colname".tiff
bartype=$(echo "single")
tool=Rbar
run_tools
done
}
run_tools() {
    if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
    then
      if [ -f "$file_in" ]; # IF INPUT THERE
      then
        echo1=FOUND
        echo2=$file_in
        echo3=STARTING
        echo4=$tool
        mes_out
        $tool # TOOL
      else
        echo1=CANT_FIND
        echo2=$file_in
        echo3=FOR_THIS
        echo4="$sample"
        mes_out # ERROR INPUT NOT THERE
      fi
      if [[ -f "$file_out" ]]; # IF OUTPUT IS THERE
      then
        echo1=FOUND
        echo2=$file_out
        echo3=FINISHED
        echo4=$tool
        mes_out # ERROR OUTPUT IS THERE
      else 
        echo1=CANT_FIND
        echo2=$file_in
        echo3=FOR_THIS
        echo4="$sample"
        mes_out # ERROR INPUT NOT THERE
      fi
  else
        echo1=FOUND
        echo2=$file_out
        echo3=FINISHED
        echo4=$tool
        mes_out # ERROR OUTPUT IS THERE
  fi
}
markduplicates(){
    java $javaset -jar $AIDDtool/picard.jar MarkDuplicates INPUT="$wd"/$file_bam_3 OUTPUT="$wd"/$file_bam_dup METRICS_FILE="$wd"/"$run"metrics.txt
}
haplotype1() {
    java -jar $AIDDtool/picard.jar BuildBamIndex INPUT="$wd"/$file_bam_dup
    java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$wd"/$file_vcf_raw
    java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_raw -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_variants.table
}
filter1() {
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_raw -selectType SNP -o "$wd"/"$run"raw_snps.vcf
    cp "$wd"/"$run"raw_snps.vcf "$rdvcf"/
    ##runs variants to table for easier viewing of vcf files
    java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_snps.table
    ##select more variants for filtering
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_raw -selectType INDEL -o "$wd"/"$run"raw_indels.vcf
    ##starting filtering steps
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_snps.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$wd"/"$run"filtered_snps.vcf
    ##moves and converts vcf filtered snp file into table
    cp "$wd"/"$run"filtered_snps.vcf "$rdvcf"/
    java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"filtered_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"filtered_snps.table
    ##more filtering
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_indels.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$wd"/"$run"filtered_indels.vcf
    ##rns base recalibrator to create new bam files with filtering taken into account
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup -knownSites "$wd"/"$run"filtered_snps.vcf -knownSites "$wd"/"$run"filtered_indels.vcf --filter_reads_with_N_cigar -o "$wd"/"$run"recal_data.table
    ##moves and converts vcf files
    cp "$wd"/"$run"recal_data.table $dirqc/recalibration_plots/
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup -knownSites "$wd"/"$run"filtered_snps.vcf -knownSites "$wd"/"$run"filtered_indels.vcf -BQSR "$wd"/"$run"recal_data.table --filter_reads_with_N_cigar -o "$wd"/"$run"post_recal_data.table
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T AnalyzeCovariates -R "$ref_dir_path"/ref2.fa -before "$wd"/"$run"recal_data.table -after "$wd"/"$run"post_recal_data.table -plots "$wd"/"$run"recalibration_plots.pdf
    ##creates new bam file containing filtering data.
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T PrintReads -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup -BQSR "$wd"/"$run"recal_data.table --filter_reads_with_N_cigar -o "$wd"/$file_bam_recal
}
haplotype2() {
  java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_recal --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$wd"/"$file_vcf_raw_recal"
  java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_variants_recal.table   
}
filter2() {
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -selectType SNP -o "$wd"/"$file_vcf_recal"
    cp "$wd"/"$file_vcf_recal" "$rdvcf"/
    java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_recal -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_snps_recal.table
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -selectType INDEL -o "$wd"/"$run"raw_indels_recal.vcf
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_recal" --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$wd"/"$file_vcf_finalAll"
    cp "$wd"/"$file_vcf_finalAll" "$rdvcf"/
    java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_finalAll" -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"filtered_snps_finalAll.table
    ##this finishes filtering indels
    java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_indels_recal.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$wd"/"$run"filtered_indels_recal.vcf
}
dir_path=/home/user/AIDDtest2
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS  
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  rdvcf=/home/user/AIDDtest2/raw_data/vcf_files/final
  rdsnp=/home/user/AIDDtest2/raw_data/snpEff
  rdbam=/home/user/AIDDtest2/raw_data/bam_files # directory for bam files
  dirqc=/home/user/AIDDtest2/quality_control
  wd=/home/user/AIDDtest2/working_directory
  javaset=$(echo "-Xmx30G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"); # sets java tools
  AIDDtool=/home/user/AIDD/AIDD_tools; # AIDD tool directory
  file_vcf_final="$run"filtered_snps_final;
  file_vcf_finalAll="$run"filtered_snps_finalAll.vcf
  file_vcf_finalADAR="$run"filtered_snps_finalADARediting.vcf
  file_vcf_finalAPOBEC="$run"filtered_snps_finalAPOBECediting.vcf
  file_vcf_finalAll="$run"filtered_snps_finalAll.vcf;
  snpEff_out="$run"filtered_snps_finalAnn;
  snp_csv=snpEff"$run";
  snp_stats="$run";
  snpEff_in="$run"filtered_snps_final;
  ref_dir_path=/home/user/AIDD/references;
  file_bam="$run".bam;
  file_bam_2="$run"_2.bam;
  file_bam_3="$run"_3.bam;
  file_pdf="$run"_insert_size_histogram.pdf;
  file_bam_dup="$run"_dedup_reads.bam;
  file_bam_recal="$run"recal_reads.bam;
  file_vcf_raw="$run"raw_variants.vcf;
  file_vcf_raw_recal="$run"raw_variants_recal.vcf;
  file_vcf_recal="$run"raw_snps_recal.vcf;
  file_vcf_finalAll="$run"filtered_snps_finalAll.vcf;
  file_vcf_finalADAR="$run"filtered_snps_finalADARediting.vcf;
  file_vcf_finalAPOBEC="$run"filtered_snps_finalAPOBECediting.vcf;
  sum_file="$dirqc"/alignment_metrics/"$run".txt 
  fastq_dir_path=/home/user; # directory for local fastq files
  prep_bam_2
  prep_bam_3
  prep_align_sum
  markduplicates
  haplotype1
  filter1
  haplotype2
  filter2
  excitome_vcf
  for snptype in All AG ADARediting APOBECediting TC CT GA ; # DO ALL VARIANTS, ADAR VARIANTS, AND APOBEC VARIANTS
  do
    snpEff
#    filecheckVC="$dirqc"/filecheckVC
#    type1="$rdsnp"/snpEff"$run""$snptype".csv
#    type2="$rdsnp"/snpEff"$run""$snptype".genes.txt
#    if [ -s "$type1" ];
#    then
#      echo ""$run""$snptype"1,yes" >> "$filecheckVC"/filecheck"$snptype"1.csv
#    else
#      echo ""$run""$snptype"1,no" >> "$filecheckVC"/filecheck"$snptype"1.csv
#    fi
#    if [ -s "$type2" ];
#    then
#      echo ""$run""$snptype"2,yes" >> "$filecheckVC"/filecheck"$snptype"2.csv
#    else
#      echo ""$run""$snptype"2,no" >> "$filecheckVC"/filecheck"$snptype"2.csv
#    fi 
  done
done
} < $INPUT
IFS=$OLDIFS
#dirqc=/home/user/AIDDtest2/quality_control
#filecheckVC="$dirqc"/filecheckVC
#snptype=AG
#check=$(cat "$filecheckVC"/filecheck"$snptype"2.csv | cut -d',' -f2 | grep -o 'yes' | wc -l)
#if [ "$check" == "0" ];
#then
#  echo "done"
#fi
