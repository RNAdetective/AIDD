create_dir() {
if [ ! -d "$new_dir" ];
then
  mkdir "$new_dir"
fi
} # this creates directories $new_dir
Rbar() {
Rscript "$ExToolset"/barchart.R "$file_in" "$file_out" "$bartype" "$pheno" "$freq" "$sum_file" "$sampname" "$file_out2" "$sum_file2"
} # runs bargraph R script
mes_out() {
dirqc="$dir_path"/quality_control
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1
___________________________________________________________________________"
new_dir="$dirqc"/time_check
create_dir
echo "'$DATE_WITH_TIME',"$run","$file_in","$tool"" >> "$dirqc"/time_check/"$run"time_check.csv
}
download() {
runfoldernameup=${run:0:3}
runfoldername=$(echo "$runfoldernameup" | tr '[:upper:]' '[:lower:]')
runfolder=${run:0:6}
lastnum=${run:9:10}
countrun=$(echo -n "$run" | wc -c)
if [ "$countrun" == "11" ];
then
  finallastnum=$(echo ""$lastnum"")
else
  finallastnum=$(echo "0"$lastnum"")
fi
cd "$wd"/
wget -q --tries=5 ftp://ftp.sra.ebi.ac.uk/vol1/"$runfoldername"/"$runfolder"/0"$finallastnum"/"$run"
# wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"$runfoldername"/"$runfolder"/"$run"/"$run".sra # this was for ncbi but ebi works better
cd "$dir_path"/AIDD
}
fastqdumppaired() { 
fastq-dump "$wd"/$file_sra -I --split-files --read-filter pass -O "$wd"/fastq
mv "$wd"/fastq/$file_fastqpaired1pass "$wd"/fastq/$file_fastqpaired1 
mv "$wd"/fastq/$file_fastqpaired2pass "$wd"/fastq/$file_fastqpaired2
 }
fastqdumpsingle() { fastq-dump "$wd"/$file_sra --read-filter pass -O "$wd"/fastq
mv "$wd"/fastq/$file_fastqpass "$wd"/fastq/$file_fastq
 }
movefastq() { mv $fastq_dir_path/fastq/$file_fastq "$wd"/fastq ; }
fastqcpaired() { cd "$dir_path"/AIDD ; fastqc "$wd"/fastq/$file_fastqpaired1 "$wd"/fastq/$file_fastqpaired2 --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD ; }
fastqcsingle() { cd "$dir_path"/AIDD ; fastqc "$wd"/fastq/$file_fastq --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD ; }
setreadlength() {
#length=$(echo "Sequence length");
#seq_length=$(cat "$dirqc"/fastqc/"$run"_1_fastqc/fastqc_data.txt | awk -v search="sequence length" '$0~search{print $0; exit}');
#seq_length_final=${seq_length[3-1]}
#seq_length_final=$(expr "$seq_length_final" - "3");
start=12
end=400
}
trimpaired() { fastx_trimmer -f "$start" -l "$end" -i "$wd"/fastq/$file_fastqpaired1 -o "$wd"/trim/$file_fastqpaired1trim ; fastx_trimmer -f "$start" -l "$end" -i "$wd"/fastq/$file_fastqpaired2 -o "$wd"/trim/$file_fastqpaired2trim ; cd $dirqc/fastqc ; fastqc "$wd"/fastq/$file_fastqpaired1trim "$wd"/fastq/$file_fastqpaired2trim --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD/ ; rm -f  "$wd"/fastq/$file_fastqpaired1 ; rm -f "$wd"/fastq/$file_fastqpaired2 ; mv "$wd"/trim/$file_fastqpaired1trim "$wd"/fastq/$file_fastqpaired1 ; mv "$wd"/trim/$file_fastqpaired2trim "$wd"/fastq/$file_fastqpaired2 ; }
trimsingle() { fastx_trimmer -f "$start" -l "$end" -i "$wd"/fastq/$file_fastq -o "$wd"/trim/"$run"_trim.fastq ; cd $dirqc/fastqc ; fastqc "$run"_trim.fastq --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD/ ; rm -f "$wd"/fastq/$file_fastq ; mv "$wd"/trim/"$run"_trim.fastq "$wd"/fastq/$file_fastq ; }
HISAT2_paired() {  hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -1 "$wd"/fastq/"$file_fastqpaired1" -2 "$wd"/fastq/"$file_fastqpaired2" -t --summary-file $dirqc/alignment_metrics/"$run".txt -S "$wd"/sam/"$file_sam" ; }
HISAT2_single() { hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -U "$wd"/"$file_fastq" -t --summary-file "$dir_path"/raw_data/counts/"$run".txt -S "$wd"/"$file_sam" ; }
STAR_paired() { echo "STAR some text line on how to run" ; } #STAR --genomeDir /n/groups/hbctraining/intro_rnaseq_hpc/reference_data_ensembl38/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn Mov10_oe_1.subset.fq --outFileNamePrefix ../results/STAR/Mov10_oe_1_ --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard 
 
STAR_single() { echo "STAR some text line on how to run" ; } #STAR --genomeDir /n/groups/hbctraining/intro_rnaseq_hpc/reference_data_ensembl38/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn Mov10_oe_1.subset.fq --outFileNamePrefix ../results/STAR/Mov10_oe_1_ --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard
BOWTIE2_paired() { echo "BOWTIE2 some text line on how to run" ; }
BOWTIE2_single() { echo "BOWTIE2 some text line on how to run" ; }
samtobam() { java -Djava.io.tmpdir="$dir_path"/tmp -jar "$AIDDtool"/picard.jar SortSam INPUT="$wd"/sam/"$file_sam" OUTPUT="$rdbam"/$file_bam SORT_ORDER=coordinate ; }
assem_string() { stringtie "$rdbam"/"$file_bam" -p3 -G "$ref_dir_path"/ref.gtf -A "$dir_path"/raw_data/counts/"$file_tab" -l -B -b "$dir_path"/raw_data/ballgown_in/"$sample"/"$run" -e -o "$dir_path"/raw_data/ballgown/"$sample"/"$file_name_gtf" ; }
temp_dir() {
if [ -d "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ ]; # IF TEMP_DIR IN SAMPLE FOLDER
then
  echo "FOUND tempdir ALREADLY IN FOLDER"
  rm -f -R "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ #DELETE TMP_DIR
fi
}
create_filecheck() {
if [ -s "$type1" ];
then
  echo ""$run""$snptype"1,yes" >> "$filecheckVC"/filecheck"$snptype"1.csv
else
  echo ""$run""$snptype"1,no" >> "$filecheckVC"/filecheck"$snptype"1.csv
fi
if [ -s "$type2" ];
then
  echo ""$run""$snptype"2,yes" >> "$filecheckVC"/filecheck"$snptype"2.csv
else
  echo ""$run""$snptype"2,no" >> "$filecheckVC"/filecheck"$snptype"2.csv
fi
}
creatematrix() {
dir_path=$dir_path
cd "$dir_path"/raw_data/
python $AIDDtool/prepDE.py -g "$dir_path"/Results/$Gmatrix_name -t "$dir_path"/Results/$Tmatrix_name # CREATE MATRIX FILES
cd "$dir_path"/AIDD/
for level in gene transcript ;
do
  file_in_dir="$dir_path"/Results
  index_file="$home_dir"/AIDD/EXToolkit/indexes/index/"$level"_name
  Rtool=GTEX
  matrixeditor
done
}
matrixeditor() {
pheno_file="$dir_path"/PHENO_DATA
Rscript "$home_dir"/AIDD/ExToolset/scripts/matrix.R "$dir_path" "$file_in_dir" "$index_file" "$pheno_file" "$Rtool" # creates matrix counts with names instead of ids and checks to make sure they are there
}
prep_bam_2() {
AIDDtool=/home/user/AIDD/AIDD_tools
version=8
setjavaversion
java $javaset -jar $AIDDtool/picard.jar AddOrReplaceReadGroups I="$rdbam"/$file_bam O="$wd"/$file_bam_2 RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 ##this will set up filtering guidelines in bam files 
}
prep_bam_3() { 
java $javaset -jar $AIDDtool/picard.jar ReorderSam I="$wd"/$file_bam_2 O="$wd"/$file_bam_3 R="$ref_dir_path"/ref2.fa CREATE_INDEX=TRUE
}
prep_align_sum() {
java -jar $AIDDtool/picard.jar CollectAlignmentSummaryMetrics R="$ref_dir_path"/ref2.fa I="$wd"/$file_bam_3 O="$dirqc"/alignment_metrics/"$run"_alignment_metrics.txt 
}
prep_align_sum2() {
java -jar $AIDDtool/picard.jar CollectInsertSizeMetrics INPUT="$wd"/$file_bam_3 OUTPUT=$dirqc/insert_metrics/"$run"_insert_metrics.txt HISTOGRAM_FILE=$dirqc/insert_metrics/"$run"_insert_size_histogram.pdf ##this collect alignment metrics and piut them in quality control for user to look at for accuracy
}
prep_align_sum3() {
samtools depth "$wd"/$file_bam_3 > "$wd"/"$run"depth_out.txt ##creates depth file for quality control on variant calling.
}
combine_file() {
cat "$file_in" | sed '1!{/^CAT/d;}' | cut -d',' -f"$col_num" >> "$file_out"
}
Rbar() {
Rscript "$sim_scripts"/barchart.R "$file_in" "$file_out" "$bartype"
}
summary_split() {
INPUT="$dir_path"/PHENO_DATA.csv
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
compress_AIDD() {
for unwanted in "$wd" "$dir_path"/tmp "$dir_path"/temp ;
do 
  rm -f -r "$unwanted" # REMOVE UNNEEDED DIRECTORIES
done
AIDD=AIDD_data
tar -cvzf "$dir_path"/"$AIDD".tar.gz "$dir_path"
split -d -b 8G "$dir_path"/"$AIDD".tar.gz """$dir_path""/"$AIDD".tar.gz." # REMOVE UNNEEDED DIRECTORIES
##add gdrive command here to upload bam files
}
haplotype1() {
AIDDtool=/home/user/AIDD/AIDD_tools
version=8
setjavaversion
java -jar $AIDDtool/picard.jar BuildBamIndex INPUT="$wd"/$file_bam_dup
}
haplotype1B() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$wd"/$file_vcf_raw
}
haplotype1C() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_raw -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_variants.table
}
filter1() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_raw -selectType SNP -o "$wd"/"$run"raw_snps.vcf
}
filter1B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_snps.table ##select more variants for filtering
}
filter1C() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_raw -selectType INDEL -o "$wd"/"$run"raw_indels.vcf ##starting filtering steps
}
filter1D() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_snps.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$wd"/"$run"filtered_snps.vcf ##moves and converts vcf filtered snp file into table
}
filter1E() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"filtered_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"filtered_snps.table ##more filtering
}
filter1F() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_indels.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$wd"/"$run"filtered_indels.vcf ##rns base recalibrator to create new bam files with filtering taken into account
}
filter1G() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup -knownSites "$wd"/"$run"filtered_snps.vcf -knownSites "$wd"/"$run"filtered_indels.vcf --filter_reads_with_N_cigar -o "$wd"/"$run"recal_data.table ##moves and converts vcf files
}
filter1H() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup -knownSites "$wd"/"$run"filtered_snps.vcf -knownSites "$wd"/"$run"filtered_indels.vcf -BQSR "$wd"/"$run"recal_data.table --filter_reads_with_N_cigar -o "$wd"/"$run"post_recal_data.table
}
filter1I() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T AnalyzeCovariates -R "$ref_dir_path"/ref2.fa -before "$wd"/"$run"recal_data.table -after "$wd"/"$run"post_recal_data.table -plots "$wd"/"$run"recalibration_plots.pdf ##creates new bam file containing filtering data.
}
filter1J() {
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
haplotype2() {
AIDDtool=/home/user/AIDD/AIDD_tools
version=8
setjavaversion
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_recal --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$wd"/"$file_vcf_raw_recal"
}
haplotype2B() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_variants_recal.table   
}
filter2() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -selectType SNP -o "$wd"/"$file_vcf_recal"
}
filter2B() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_recal -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_snps_recal.table
}
filter2C() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -selectType INDEL -o "$wd"/"$run"raw_indels_recal.vcf
}
filter2D() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_recal" --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$wd"/"$file_vcf_finalAll"
}
filter2E() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_finalAll" -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"filtered_snps_finalAll.table
}
filter2F() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_indels_recal.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$wd"/"$run"filtered_indels_recal.vcf
}
move_vcf2() {
mv "$wd"/"$file_vcf_raw_recal" "$rdvcf"/
mv "$wd"/"$file_vcf_recal" "$rdvcf"/
mv "$wd"/"$file_vcf_finalAll" "$rdvcf"/
}
excitome_vcf() { 
## filter out everything that is not ADAR mediated editing
awk -F "\t" '/^#/' "$rdvcf_final"/"$run"filtered_snps_finalAll.vcf > "$rdvcf_final"/"$run"filtered_snps_finalinfo.vcf #
cat "$rdvcf_final"/"$run"filtered_snps_finalAll.vcf | awk -F "\t" ' { if ($3 == ".") { print } }' > "$rdvcf_final"/"$run"filtered_snps_finalAllNoSnpsediting.vcf
awk -F "\t" ' { if (($4 == "A") && ($5 == "G") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_vcf_finalAll" > "$rdvcf_final"/"$run"filtered_snps_finalAG.vcf
awk -F "\t" '{ if (($4 == "T") && ($5 == "C") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_vcf_finalAll" > "$rdvcf_final"/"$run"filtered_snps_finalTC.vcf
cat "$rdvcf_final"/"$run"filtered_snps_finalinfo.vcf "$rdvcf_final"/"$run"filtered_snps_finalAG.vcf "$rdvcf_final"/"$run"filtered_snps_finalTC.vcf > "$rdvcf_final"/"$file_vcf_finalADAR"
awk -F "\t" ' { if (($4 == "C") && ($5 == "T") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_vcf_finalAll" > "$rdvcf_final"/"$run"filtered_snps_finalCT.vcf
awk -F "\t" '{ if (($4 == "G") && ($5 == "A") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_vcf_finalAll" > "$rdvcf_final"/"$run"filtered_snps_finalGA.vcf
cat "$rdvcf_final"/"$run"filtered_snps_finalinfo.vcf "$rdvcf_final"/"$run"filtered_snps_finalCT.vcf "$rdvcf_final"/"$run"filtered_snps_finalGA.vcf > "$rdvcf_final"/"$file_vcf_finalAPOBEC"
}
move_vcf3() {
for i in raw final filtered; do
  new_dir=$dir_path/raw_data/vcf_files/"$i"/
  create_dir
  mv $dir_path/raw_data/vcf_files/*"$i"* $dir_path/raw_data/vcf_files/"$i"/
done
}
snpEff() {
java $javaset -jar $AIDDtool/snpEff.jar -v GRCh37.75 "$rdvcf"/final/"$file_vcf_final""$snptype".vcf -stats "$dir_path"/raw_data/snpEff/"$snp_stats""$snptype" -csvStats "$dir_path"/raw_data/snpEff/"$snp_csv""$snptype".csv > "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf     ##converts final annotationed vcf to table for easier processing
#java -jar "$AIDDtool"/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F AC -F ANN -o "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".table
}
AllsnpEff() {
  for snptype in All AllNoSnpsediting ADARediting APOBECediting AG GA CT TC ; # DO ALL VARIANTS, ADAR VARIANTS, AND APOBEC VARIANTS
  do
    snpEff #runs snp effect prediction
    echo ""$run" is done." 
  done
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
dir_path="$1"
echo "Which step would you like to start with?
Please choose one of the following:
fastqdumpsingle, fastqdumppaired trimsingle, trimpaired, alignsingle, alignpaired, alignsingleSTAR, alignpairedSTAR, alignsingleBOWTIE2, alignpairedBOWTIE2, samtobam, assemble, prep_bam, haplotype1, haplotype2, excitomevcf, excitomesnpEff"
read AIDDstep
LOG_LOCATION="$dir_path"/quality_control/logs
new_dir="$LOG_LOCATION"
create_dir
exec > >(tee -i $LOG_LOCATION/AIDDParts.log)
exec 2>&1

echo "Log Location will be: [ $LOG_LOCATION ]"
  export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS  
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  dir_path="$1"
  rdvcf="$dir_path"/raw_data/vcf_files
  rdvcf_final="$rdvcf"/final
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
  if [ "$AIDDstep" == "fastqdumpsingle" ];
  then
    fastqdumpsingle
    movefastq
    fastqcsingle
    setreadlength
    trimsingle
    HISAT2_single
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "fastqdumppaired" ];
  then
    fastqdumppaired
    movefastq
    fastqcpaired
    setreadlength
    trimpaired
    HISAT2_paired
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "trimsingle" ];
  then
    setreadlength
    trimsingle
    HISAT2_single
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "trimpaired" ];
  then
    setreadlength
    trimpaired
    HISAT2_paired
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
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
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
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
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
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
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
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
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
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
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
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
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "samtobam" ];
  then
    samtobam
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "assemble" ];
  then
    assem_string #runs stringtie to assemble and count transcripts
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "prep_bam" ];
  then
    prep_bam_2 #runs bam file sorting for variant calling
    prep_bam_3 #runs bam file reordering by chromosome for variant calling
    prep_align_sum #collects alignment metrics and creates quality control file
    prep_align_sum2 #collects inset metrics
    prep_align_sum3 #collects depth out
    markduplicates #marks duplicates in bam file for variant calling
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "haplotype1" ];
  then
    haplotype1 #first variant calling step
    haplotype1B
    haplotype1C
    filter1 #first round of filtering after variant calling
    filter1B
    filter1C
    filter1D
    filter1E
    filter1F
    filter1G
    filter1H
    filter1I
    filter1J
    move_vcf
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "haplotype2" ];
  then
    haplotype2 #second variant calling step
    haplotype2B
    filter2 #second and final round of filtering 
    filter2B
    filter2C
    filter2D
    filter2E
    filter2F
    move_vcf2
    excitome_vcf
    move_vcf3
    AllsnpEff
  fi
  if [ "$AIDDstep" == "excitomevcf" ];
  then
    excitome_vcf
    move_vcf3
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
