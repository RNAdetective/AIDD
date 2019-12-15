download() {
runfoldernameup=${run:0:3}
runfoldername=$(echo "$runfoldernameup" | tr '[:upper:]' '[:lower:]')
runfolder=${run:0:6}
lastnum=${run:9:10}
cd "$wd"/
wget ftp://ftp.sra.ebi.ac.uk/vol1/"$runfoldername"/"$runfolder"/00"$lastnum"/"$run"
# wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"$runfoldername"/"$runfolder"/"$run"/"$run".sra # this was for ncbi but ebi works better
cd "$dir_path"/AIDD
}
fastqdumppaired() { 
fastq-dump "$wd"/$file_sra -I --split-files --read-filter pass -O "$wd"/ 
mv "$wd"/$file_fastqpaired1pass "$wd"/$file_fastqpaired1 
mv "$wd"/$file_fastqpaired2pass "$wd"/$file_fastqpaired2
 }
fastqdumpsingle() { fastq-dump "$wd"/$file_sra --read-filter pass -O "$wd"/ ; }
movefastq() { mv $fastq_dir_path/$file_fastq "$wd"/ ; }
fastqcpaired() { cd "$dir_path"/AIDD ; fastqc "$wd"/$file_fastqpaired1 "$wd"/$file_fastqpaired2 --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD ; }
fastqcsingle() { cd $dirqc/fastqc/ ; fastqc "$wd"/$file_fastq ; cd "$dir_path"/AIDD ; }
trimpaired() { fastx_trimmer -f "$start" -l "$end" -i "$wd"/$file_fastqpaired1 -o "$wd"/$file_fastqpaired1trim ; fastx_trimmer -f "$start" -l "$end" -i "$wd"/$file_fastqpaired2 -o "$wd"/$file_fastqpaired2trim ; cd $dirqc/fastqc ; fastqc "$wd"/$file_fastqpaired1trim "$wd"/$file_fastqpaired2trim --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD/ ; rm -f  "$wd"/$file_fastqpaired1 ; rm -f "$wd"/$file_fastqpaired2 ; mv "$wd"/$file_fastqpaired1trim "$wd"/$file_fastqpaired1 ; mv "$wd"/$file_fastqpaired2trim "$wd"/$file_fastqpaired2 ; }
trimsingle() { fastx_trimmer -f start -l end -i "$wd"/$file_fastq -o "$wd"/"$run"_trim.fastq ; cd $dirqc/fastqc ; fastqc "$run"_trim.fastq --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD/ ; rm -f "$wd"/$file_fastq ; mv "$wd"/"$run"_trim.fastq "$wd"/$file_fastq ; }
HISAT2_paired() {  hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -1 "$wd"/"$file_fastqpaired1" -2 "$wd"/"$file_fastqpaired2" -t --summary-file $dirqc/alignment_metrics/"$run".txt -S "$wd"/"$file_sam" ; }
HISAT2_single() { hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -U "$wd"/"$file_fastq" -t --summary-file "$dir_path"/raw_data/counts/"$run".txt -S "$wd"/"$file_sam" ; }
STAR_paired() { echo "STAR some text line on how to run" ; }
STAR_single() { echo "STAR some text line on how to run" ; }
samtobam() { java -Djava.io.tmpdir="$dir_path"/tmp -jar "$AIDDtool"/picard.jar SortSam INPUT="$wd"/"$file_sam" OUTPUT="$rdbam"/$file_bam SORT_ORDER=coordinate ; }
assem_string() { stringtie "$rdbam"/"$file_bam" -p3 -G "$ref_dir_path"/ref.gtf -A "$dir_path"/raw_data/counts/"$file_tab" -l -B -b "$dir_path"/raw_data/ballgown_in/"$sample"/"$run" -e -o "$dir_path"/raw_data/ballgown/"$sample"/"$file_name_gtf" ; }
prep_bam_2() {
java $javaset -jar $AIDDtool/picard.jar AddOrReplaceReadGroups I="$rdbam"/$file_bam O="$wd"/$file_bam_2 RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 ##this will set up filtering guidelines in bam files 
}
prep_bam_3() { 
  java $javaset -jar $AIDDtool/picard.jar ReorderSam I="$wd"/$file_bam_2 O="$wd"/$file_bam_3 R="$ref_dir_path"/ref2.fa CREATE_INDEX=TRUE
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
#samtools depth "$wd"/$file_bam_3 > "$wd"/"$run"depth_out.txt
mv "$wd"/"$run"_alignment_metrics.txt $dirqc/alignment_metrics/
mv "$wd"/"$run"_insert_metrics.txt $dirqc/insert_metrics/
mv "$wd"/"$run"_insert_size_histogram.pdf $dirqc/insert_metrics/
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
move_vcf() {
mv "$wd"/$file_vcf_raw "$rdvcf"/
mv "$wd"/"$run"filtered_snps.vcf "$rdvcf"/
mv "$wd"/"$run"recal_data.table $dirqc/recalibration_plots/
mv "$wd"/"$run"raw_snps.vcf "$rdvcf"/
rm "$wd"/"$run"raw_indels.vcf
rm "$wd"/"$run"filtered_indels.vcf
if [ -f "$wd"/"$run"recalibration_plots.pdf ];
then
  rm "$wd"/"$run"recal_data.table
  rm "$wd"/"$run"post_recal_data.table
fi
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
move_vcf2() {
mv "$wd"/"$file_vcf_raw_recal" "$rdvcf"/
mv "$wd"/"$file_vcf_recal" "$rdvcf"/
mv "$wd"/"$file_vcf_finalAll" "$rdvcf"/
}
excitome_vcf() { 
## filter out everything that is not ADAR mediated editing
awk -F "\t" '/^#/' "$rdvcf"/"$run"filtered_snps_finalAll.vcf > "$rdvcf"/"$run"filtered_snps_finalinfo.vcf #
awk -F "\t" ' { if (($4 == "A") && ($5 == "G")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalAG.vcf
awk -F "\t" '{ if (($4 == "T") && ($5 == "C")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalTC.vcf
cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalAG.vcf "$rdvcf"/"$run"filtered_snps_finalTC.vcf > "$rdvcf"/"$file_vcf_finalADAR"
awk -F "\t" ' { if (($4 == "C") && ($5 == "T")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalCT.vcf
awk -F "\t" '{ if (($4 == "G") && ($5 == "A")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalGA.vcf
cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalCT.vcf "$rdvcf"/"$run"filtered_snps_finalGA.vcf > "$rdvcf"/"$file_vcf_finalAPOBEC"
}
move_vcf3() {
for i in raw final filtered; do
  new_dir=$dir_path/raw_data/vcf_files/"$i"/
  create_dir
  mv $dir_path/raw_data/vcf_files/*"$i"* $dir_path/raw_data/vcf_files/"$i"/
done
}
snpEff() {
java $javaset -jar $AIDDtool/snpEff.jar -v GRCh37.75 "$rdvcf"/"$file_vcf_final""$snptype".vcf -stats "$dir_path"/raw_data/snpEff/"$snp_stats""$snptype" -csvStats "$dir_path"/raw_data/snpEff/"$snp_csv""$snptype".csv > "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf     ##converts final annotationed vcf to table for easier processing
java "$javaset"  -jar "$AIDDtool"/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F AC -F ANN -o "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".table
}
AllsnpEff() {
  for snptype in All ADARediting APOBECediting AG GA CT TC ; # DO ALL VARIANTS, ADAR VARIANTS, AND APOBEC VARIANTS
  do
    snpEff #runs snp effect prediction
    echo ""$run" is done." 
  done
}
combine_file() {
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" >> "$file_out"
}
Rbar() {
Rscript "$sim_scripts"/barchart.R "$file_in" "$file_out" "$bartype"
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
mes_out() {
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
}
dir_path="$1"
echo "Which step would you like to start with?
Please choose one of the following:
fastqdumpsingle, fastqdumppaired trimsingle, trimpaired, alignsingle, alignpaired, alignsingleSTAR, alignpairedSTAR, alignsingleBOWTIE2, alignpairedBOWTIE2, samtobam, assemble, prep_bam, haplotype1, haplotype2, excitomevcf, excitomesnpEff"
read AIDDstep
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS  
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  dir_path="$1"
  rdvcf="$dir_path"/raw_data/vcf_files
  rdsnp="$dir_path"/raw_data/snpEff
  rdbam="$dir_path"/raw_data/bam_files # directory for bam files
  dirqc="$dir_path"/quality_control
  wd="$dir_path"/working_directory
  javaset=$(echo "-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"); # sets java tools
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
  file_sra="$run";
  file_fastq="$run".fastq;
  file_fastq="$run".fastq;
  file_fastqpaired1="$run"_1.fastq;
  file_fastqpaired2="$run"_2.fastq;
  file_fastqpaired1pass="$run"_pass_1.fastq;
  file_fastqpaired2pass="$run"_pass_2.fastq;
  file_fastqpaired1trim="$run"_trim_1.fastq;
  file_fastqpaired2trim="$run"_trim_2.fastq;
  file_sam="$run".sam;
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
  file_tab="$run".tab;
  file_name_gtf="$sample".gtf;
  export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
  if [ "$AIDDstep" == "fastqdumpsingle" ];
  then
    fastqdumpsingle
    movefastq
    fastqcsingle
    trimsingle
    HISAT2_single
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "fastqdumppaired" ];
  then
    fastqdumppaired
    movefastq
    fastqcpaired
    trimpaired
    HISAT2_paired
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "trimsingle" ];
  then
    trimsingle
    HISAT2_single
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "trimpaired" ];
  then
    trimpaired
    HISAT2_paired
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "alignsingle" ];
  then
    HISAT2_single
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "alignpaired" ];
  then
    HISAT2_paired
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "alignsingleSTAR" ];
  then
    HISAT2_single
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "alignpairedSTAR" ];
  then
    HISAT2_paired
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "alignsingleBOWTIE2" ];
  then
    HISAT2_single
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "alignpairedBOWTIE2" ];
  then
    HISAT2_paired
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "samtobam" ];
  then
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "assemble" ];
  then
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "prep_bam" ];
  then
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "haplotype1" ];
  then
    haplotype1 #first variant calling step
    filter1 #first round of filtering after variant calling
    move_vcf
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "haplotype2" ];
  then
    haplotype2 #second variant calling step
    filter2 #second and final round of filtering 
    move_vcf2
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "excitomevcf" ];
  then
    excitome_vcf
    AllsnpEff
  fi
  if [ "$AIDDstep" == "excitomesnpEff" ];
  then
    AllsnpEff
  fi    
done
} < $INPUT
IFS=$OLDIFS
#dirqc="$dir_path"/quality_control
#filecheckVC="$dirqc"/filecheckVC
#snptype=AG
#check=$(cat "$filecheckVC"/filecheck"$snptype"2.csv | cut -d',' -f2 | grep -o 'yes' | wc -l)
#if [ "$check" == "0" ];
#then
#  echo "done"
#fi
