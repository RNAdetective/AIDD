#!/usr/bin/env bash
source config.shlib; # load the config library functions
export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
####################################################################################################################
####################################################################################################################
####################################################################################################################
#defines the functions
####################################################################################################################
####################################################################################################################
####################################################################################################################
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
echo "'$DATE_WITH_TIME',"$run","$file_in","$tool"" >> "$dirqc"/time_check/"$run"time_check.csv
#file_size
echo "'$DATE_WITH_TIME' $echo1 $file_name $file_ext $file_size_kb
___________________________________________________________________________"
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
#file_size() {
#file_size_kb=`du -k "$file_in" | cut -f1`
#dir_name=$(echo "$file_in" | sed 's/\//./g' | cut -f 6 -d '.')
#file_name=$(echo "$dir_name" | cut -f 1 -d '.')
#file_ext=$(echo "$file_in" | sed 's/\//./g' | cut -f 7 -d '.')
#new_dir="$dirqc"/file_size
#create_dir
#sizefile="$dirqc"/file_size/sizefile.csv
#if [ ! -f "$sizefile" ];
#then
#  echo "run,file" >> "$sizefile"
#fi
#echo ""$run","$file_size_kb","$file_in"" >> "$sizefile"
#}
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
  file_name=$(echo "$dir_name" | cut -f 1 -d '.' | cut -f 1-"${#res}" -d '_' ) 
  file_ext=$(echo "$files" | sed 's/\//./g' | cut -f "$extnum" -d '.')
  echo "$file_name"  
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
new_dir="$wd"/fastq
create_dir
fastq-dump "$wd"/$file_sra -I --split-files --read-filter pass -O "$wd"/
mv "$wd"/"$run"_pass_1.fastq "$wd"/fastq/"$run"_1.fastq 
mv "$wd"/"$run"_pass_2.fastq "$wd"/fastq/"$run"_2.fastq
 }
fastqdumpsingle() { 
new_dir="$wd"/fastq
create_dir
fastq-dump "$wd"/$file_sra --read-filter pass -O "$wd"/
mv "$wd"/$file_fastqpass "$wd"/fastq/$file_fastq
 }
movefastqpaired() {
new_dir="$wd"/fastq
create_dir
cp "$fastq_dir_path"/"$run"_1.fastq "$wd"/fastq/"$run"_1.fastq
cp "$fastq_dir_path"/"$run"_2.fastq "$wd"/fastq/"$run"_2.fastq
}
movefastqsingle() {
new_dir="$wd"/fastq
create_dir
cp "$fastq_dir_path"/"$run".fastq "$wd"/fastq/"$run".fastq
}
fastqcpaired() { 
cd "$dir_path"/AIDD
fastqc "$wd"/fastq/"$file_name"_1.fastq "$wd"/fastq/"$file_name"_2.fastq --outdir=$dirqc/fastqc
cd "$dir_path"/AIDD
}
fastqcsingle() { 
cd "$dir_path"/AIDD
fastqc "$wd"/fastq/"$file_name".fastq --outdir=$dirqc/fastqc
cd "$dir_path"/AIDD
}
setreadlength() {
#length=$(echo "Sequence length");
#seq_length=$(cat "$dirqc"/fastqc/"$run"_1_fastqc/fastqc_data.txt | awk -v search="sequence length" '$0~search{print $0; exit}');
#seq_length_final=${seq_length[3-1]}
#seq_length_final=$(expr "$seq_length_final" - "3");
start=12
end=400
}
trimpaired() {
new_dir="$wd"/trim
create_dir
fastx_trimmer -f "$start" -l "$end" -i "$wd"/fastq/"$file_name"_1.fastq -o "$wd"/trim/"$file_name"trim_1.fastq
fastx_trimmer -f "$start" -l "$end" -i "$wd"/fastq/"$file_name"_2.fastq -o "$wd"/trim/"$file_name"trim_2.fastq
cd $dirqc/fastqc
fastqc "$wd"/trim/"$file_name"trim_1.fastq "$wd"/trim/"$file_name"trim_1.fastq --outdir=$dirqc/fastqc 
cd "$dir_path"/AIDD/ 
rm -f "$wd"/fastq/"$file_name"_1.fastq 
rm -f "$wd"/fastq/"$file_name"_2.fastq 
mv "$wd"/trim/"$file_name"trim_1.fastq "$wd"/fastq/"$file_name"_1.fastq
mv "$wd"/trim/"$file_name"trim_2.fastq "$wd"/fastq/"$file_name"_2.fastq
}
trimsingle() { 
new_dir="$wd"/trim
create_dir
fastx_trimmer -f "$start" -l "$end" -i "$wd"/fastq/"$file_name".fastq -o "$wd"/"$file_name"_trim.fastq
cd $dirqc/fastqc
fastqc "$file_name"_trim.fastq --outdir=$dirqc/fastqc
cd "$dir_path"/AIDD/
rm -f "$wd"/fastq/"$file_name"
mv "$wd"/"$file_name"_trim.fastq "$wd"/fastq/"$file_name".fastq 
}
HISAT2_paired() {  
new_dir="$wd"/sam
create_dir
hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -1 "$wd"/fastq/"$file_name"_1.fastq -2 "$wd"/fastq/"$file_name"_2.fastq -t --summary-file $dirqc/alignment_metrics/"$file_name".txt -S "$wd"/sam/"$file_name".sam
}
HISAT2_single() { 
new_dir="$wd"/sam
create_dir
hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -U "$wd"/fastq/"$file_name".fastq -t --summary-file "$dir_path"/raw_data/counts/"$file_name".txt -S "$wd"/sam/"$file_name".sam
}
STAR_paired() { 
STAR --genomeDir "$home_dir"/AIDD/references/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn 1 "$wd"/fastq/"$file_name"_1.fastq -2 "$wd"/fastq/"$file_name"_2.fastq  --outFileNamePrefix ../results/STAR/Mov10_oe_1_ --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard 
} # 
 
STAR_single() { 
STAR --genomeDir "$home_dir"/AIDD/references/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn -"$wd"/fastq/"$file_name".fastq --outFileNamePrefix "$rdbam"/"$file_name".bam --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard 
} #
BOWTIE2_paired() { echo "BOWTIE2 some text line on how to run" ; }
BOWTIE2_single() { echo "BOWTIE2 some text line on how to run" ; }
samtobam() { 
java -Djava.io.tmpdir="$dir_path"/tmp -jar "$AIDDtool"/picard.jar SortSam INPUT="$wd"/sam/"$file_name".sam OUTPUT="$rdbam"/"$file_name".bam SORT_ORDER=coordinate
}
assem_string() { 
stringtie "$rdbam"/"$file_bam" -p3 -G "$ref_dir_path"/ref.gtf -A "$dir_path"/raw_data/counts/"$file_name".tab -l -B -b "$dir_path"/raw_data/ballgown_in/"$sample"/"$file_name" -e -o "$dir_path"/raw_data/ballgown/"$sample"/"$file_name".gtf
}
temp_dir() {
if [ -d "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ ]; # IF TEMP_DIR IN SAMPLE FOLDER
then
  echo "FOUND tempdir ALREADLY IN FOLDER"
  rm -f -R "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ #DELETE TMP_DIR
fi
}
prep_bam_2() {
java $javaset -jar $AIDDtool/picard.jar AddOrReplaceReadGroups I="$rdbam"/$file_bam O="$wd"/"$file_name"_2.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 ##this will set up filtering guidelines in bam files 
}
prep_bam_3() { 
java $javaset -jar $AIDDtool/picard.jar ReorderSam I="$wd"/"$file_name"_2.bam O="$wd"/"$file_name"_3.bam R="$ref_dir_path"/ref2.fa CREATE_INDEX=TRUE
}
prep_align_sum() {
java -jar $AIDDtool/picard.jar CollectAlignmentSummaryMetrics R="$ref_dir_path"/ref2.fa I="$wd"/"$file_name"_3.bam O="$dirqc"/alignment_metrics/"$file_name"_alignment_metrics.txt 
}
prep_align_sum2() {
java -jar $AIDDtool/picard.jar CollectInsertSizeMetrics INPUT="$wd"/"$file_name"_3.bam OUTPUT=$dirqc/insert_metrics/"$file_name"_insert_metrics.txt HISTOGRAM_FILE=$dirqc/insert_metrics/"$file_name"_insert_size_histogram.pdf ##this collect alignment metrics and piut them in quality control for user to look at for accuracy
}
prep_align_sum3() {
samtools depth "$wd"/"$file_name"_3.bam > "$wd"/"$file_name"depth_out.txt ##creates depth file for quality control on variant calling.
}
markduplicates(){
java $javaset -jar $AIDDtool/picard.jar MarkDuplicates INPUT="$wd"/$file_bam_3 OUTPUT="$wd"/$file_bam_dup METRICS_FILE="$wd"/"$run"metrics.txt
}
haplotype1() {
java -jar $AIDDtool/picard.jar BuildBamIndex INPUT="$wd"/"$file_name"_dedup_reads.bam
}
haplotype1B() {
AIDDtool=/home/user/AIDD/AIDD_tools
version=8
setjavaversion
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$wd"/"$wd"/"$file_name"_dedup_reads.bam --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$wd"/"$run"raw_variants.vcf
}
haplotype1C() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_variants.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_variants.table
}
filter1() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_variants.vcf -selectType SNP -o "$wd"/"$file_name"raw_snps.vcf
}
filter1B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$file_name"raw_snps.table ##select more variants for filtering
}
filter1C() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$run"raw_variants.vcf -selectType INDEL -o "$wd"/"$file_name"raw_indels.vcf ##starting filtering steps
}
filter1D() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_snps.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$wd"/"$file_name"filtered_snps.vcf ##moves and converts vcf filtered snp file into table
}
filter1E() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"filtered_snps.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$file_name"filtered_snps.table ##more filtering
}
filter1F() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_indels.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$wd"/"$file_name"filtered_indels.vcf ##rns base recalibrator to create new bam files with filtering taken into account
}
filter1G() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_dup -knownSites "$wd"/"$run"filtered_snps.vcf -knownSites "$wd"/"$run"filtered_indels.vcf --filter_reads_with_N_cigar -o "$wd"/"$run"recal_data.table ##moves and converts vcf files
}
filter1H() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T BaseRecalibrator -R "$ref_dir_path"/ref2.fa -I "$wd"/"$file_name"_dedup_reads.bam -knownSites "$wd"/"$file_name"filtered_snps.vcf -knownSites "$wd"/"$file_name"filtered_indels.vcf -BQSR "$wd"/"$file_name"recal_data.table --filter_reads_with_N_cigar -o "$wd"/"$file_name"post_recal_data.table
}
filter1I() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T AnalyzeCovariates -R "$ref_dir_path"/ref2.fa -before "$wd"/"$file_name"recal_data.table -after "$wd"/"$file_name"post_recal_data.table -plots "$wd"/"$file_name"recalibration_plots.pdf ##creates new bam file containing filtering data.
}
filter1J() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T PrintReads -R "$ref_dir_path"/ref2.fa -I "$wd"/"$file_name"_dedup_reads.bam -BQSR "$wd"/"$file_name"recal_data.table --filter_reads_with_N_cigar -o "$wd"/"$file_name"recal_reads.bam
}
haplotype2() {
AIDDtool=/home/user/AIDD/AIDD_tools
version=8
setjavaversion
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$wd"/"$file_name"recal_reads.bam --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$wd"/"$file_name"raw_variants_recal.vcf
}
haplotype2B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_variants_recal.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$file_name"raw_variants_recal.table   
}
filter2() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_variants_recal.vcf -selectType SNP -o "$wd"/"$file_name"raw_snps_recal.vcf
}
filter2B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_snps_recal.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$file_name"raw_snps_recal.table
}
filter2C() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_variants_recal.vcf -selectType INDEL -o "$wd"/"$file_name"raw_indels_recal.vcf
}
filter2D() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_snps_recal.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || SOR > 4.0' --filterName "basic_snp_filter" -o "$wd"/"$file_vcf_finalAll"
}
filter2E() {
java $javaset -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"filtered_snps_finalAll.vcf -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$file_name"filtered_snps_finalAll.table
}
filter2F() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantFiltration -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_name"raw_indels_recal.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || SOR > 10.0' --filterName "basic_indel_filter" -o "$wd"/"$file_name"filtered_indels_recal.vcf
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
awk -F "\t" ' { if (($4 == "A") && ($5 == "G") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAll.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalAG.vcf
awk -F "\t" '{ if (($4 == "T") && ($5 == "C") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAll.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalTC.vcf
cat "$rdvcf_final"/"$file_name"filtered_snps_finalinfo.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalAG.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalTC.vcf > "$rdvcf_final"/"$file_vcf_finalADAR"
awk -F "\t" ' { if (($4 == "C") && ($5 == "T") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAll.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalCT.vcf
awk -F "\t" '{ if (($4 == "G") && ($5 == "A") && ($3 == ".")) { print } }' "$rdvcf_final"/"$file_name"filtered_snps_finalAll.vcf > "$rdvcf_final"/"$file_name"filtered_snps_finalGA.vcf
cat "$rdvcf_final"/"$file_name"filtered_snps_finalinfo.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalCT.vcf "$rdvcf_final"/"$file_name"filtered_snps_finalGA.vcf > "$rdvcf_final"/"$file_vcf_finalAPOBEC"
}
snpEff() {
java $javaset -jar $AIDDtool/snpEff.jar -v GRCh37.75 "$rdvcf"/final/"$file_vcf_final""$snptype".vcf -stats "$dir_path"/raw_data/snpEff/"$snp_stats""$snptype" -csvStats "$dir_path"/raw_data/snpEff/"$snp_csv""$snptype".csv > "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf     ##converts final annotationed vcf to table for easier processing
java "$javaset"  -jar "$AIDDtool"/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".vcf -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F AC -F ANN -o "$dir_path"/raw_data/snpEff/"$snpEff_out""$snptype".table
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
####################################################################################################################
####################################################################################################################
####################################################################################################################
#  DOWNLOADS ALL SAMPLES BEFORE STARTING AIDD
####################################################################################################################
####################################################################################################################
####################################################################################################################
dir_path="$(config_get dir_path)"; # main directory
wd="$dir_path"/working_directory; # working directory
home_dir="$(config_get home_dir)"; # home directory
ref_dir_path="$(config_get ref_dir_path)"; # reference directory
dirqc="$dir_path"/quality_control; # qc directory
AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
rdbam="$dir_path"/raw_data/bam_files # directory for bam files
rdsnp="$dir_path"/raw_data/snpEff #directory for snp files
javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M ulimit -c unlimited -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
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
savesra="$(config_get savesra)"; # to save sra files
savefastq="$(config_get savefastq)"; # to save fastq files
start=12;
end=400;
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
  source config.shlib; # load the config library functions
  dir_path="$(config_get dir_path)"; # main directory
  wd="$dir_path"/working_directory; # working directory
  home_dir="$(config_get home_dir)"; # home directory
  ref_dir_path="$(config_get ref_dir_path)"; # reference directory
  dirqc="$dir_path"/quality_control; # qc directory  
  AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
  rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
  rdbam="$dir_path"/raw_data/bam_files # directory for bam files
  rdsnp="$dir_path"/raw_data/snpEff #directory for snp files
  file_sra="$run";
  file
  if [[ "$sra" == "yes" && "$bamfile" == "beginning" ]]; # IF DOWNLOAD SRA
  then
    if [ ! -f "$wd"/"$file_sra" ]; # IF OUTPUT FILE IS NOT THERE
    then
      echo1=$(echo "STARTING "$tool" FOR "$sample"");
      file_in=$(echo "downloading");
      mes_out
      download
    fi
    if [ -f "$wd"/"$file_sra" ]; # IF OUTPUT IS THERE
    then
      echo1=$(echo "FOUND $file_sra FINISHED DOWNLOADING $sample")
      file_in=$(echo "downloading");
      mes_out # ERROR OUTPUT IS THERE
    else
      echo1=$(echo "STARTING "$tool" FOR "$sample"");
      file_in=$(echo "downloading_second_time");
      download
      if [ ! -f "$wd"/"$file_sra" ]; # IF OUT IS NOT THERE
      then
        echo1=$(echo "STARTING "$tool" FOR "$sample"");
        file_in=$(echo "downloading_third_time");
        download
      fi  
    fi
  else
    next_samp
  fi
####################################################################################################################
# CONVERT SRA TO FASTQ
####################################################################################################################
  if [[ "$sra" == "yes" && "$library" == "paired" ]];
  then
    tool=fastqdumppaired
    file_in="$wd"/$file_sra
    file_out="$wd"/fastq/"$run"_1.fastq
    file_out2="$wd"/fastq/"$run"_2.fastq
    run_tools2o
  fi
####################################################################################################################
#  CONVERT SRA TO FASTQ
####################################################################################################################
  if [[ "$sra" == "yes" && "$library" == "single" ]];
  then
    tool=fastqdumpsingle
    file_in="$wd"/$file_sra   
    file_out="$wd"/fastq/"$run".fastq
    run_tools
  fi 
####################################################################################################################
# MOVEFASTQPAIRED
####################################################################################################################
  if [[ "$sra" == "no" && "$library" == "paired" ]];
  then
    tool=movefastqpaired
    file_in=$fastq_dir_path/"$run"_1.fastq
    file_in2=$fastq_dir_path/"$run"_2.fastq
    file_out="$wd"/fastq/"$run"_1.fastq
    file_out2="$wd"/fastq/"$run"_2.fastq
    run_tools2i2o
   fi
####################################################################################################################
#  MOVEFASTQSINGLE
####################################################################################################################
  if [[ "$sra" == "no" && "$library" == "single" ]];
  then
    tool=movefastqsingle
    file_in=$fastq_dir_path/"$run".fastq   
    file_out="$wd"/fastq/"$run".fastq
    run_tools
  fi 
done
step1=$(echo "INTERNET")
step2=$(echo "QUALITY CONTROL")
steps
} < $INPUT
IFS=$OLDIFS
####################################################################################################################
####################################################################################################################
####################################################################################################################
#NON-INTERNET PART OF THE PIPELINE
####################################################################################################################
####################################################################################################################
####################################################################################################################
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files  
####################################################################################################################
# PAIRED QUALITY CONTROL
####################################################################################################################
  if [ "$library" == "paired" ];
  then
    tool=fastqcpaired
    file_in="$wd"/fastq/"$file_name"_1.fastq
    file_in2="$wd"/fastq/"$file_name"_2.fastq
    file_out=$dirqc/fastqc/"$file_name"_1_fastqc.html
    file_out2=$dirqc/fastqc/"$file_name"_2_fastqc.html
    JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
    version=11
    setjavaversion
    run_tools2i2o
    version=8
    JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/ 
    setjavaversion
  fi
####################################################################################################################
#  SINGLE QUALITY CONTROL
####################################################################################################################
  if [ "$library" == "single" ];
  then
    tool=fastqcsingle
    file_in="$wd"/$file_fastq    
    file_out=$dirqc/fastqc/"$file_name"_fastqc.html
    rm -f "$wd"/"$file_sra"
    JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
    version=11
    setjavaversion
    run_tools
    JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/ 
    version=8
    setjavaversion
  fi
####################################################################################################################
# PAIRED TRIMMING
####################################################################################################################
  if [ "$library" == "paired" ];
  then
    check=$(echo ">>Per base sequence content")
    pass=$(cat "$dirqc"/fastqc/"$file_name"_1_fastqc/fastqc_data.txt '{if (/'$check'/) print NR}');
    missing=$(grep -o 'pass' "$pass" | wc -l)
    if [ "$missing" == "0" ];
    then
      tool=trimpaired
      file_in="$wd"/fastq/"$file_name"_1.fastq
      file_in2="$wd"/"$file_name"_1.fastq
      file_out=$dirqc/fastqc/"$file_name"_trim_1_fastqc.html 
      file_out2=$dirqc/fastqc/"$file_name"_trim_2_fastqc.html
      JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
      version=11
      setjavaversion 
      setreadlength
      echo1=$(echo "RUNNING TRIMMER CUTTING "$start" OFF THE BEGINNING AND ENDING AT "$end"")
      mes_out 
      run_tools2i2o
      JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/
      version=8 
      setjavaversion
    else
      echo1=$(echo "PASSED RAW SEQUENCE CHECK NO NEED TO TRIM FILES")
      mes_out
    fi
  fi
####################################################################################################################
# TRIMMING SINGLE
####################################################################################################################
  if [ "$library" == "single" ];
  then
    check=$(echo ">>Per base sequence content")
    pass=$(cat "$dirqc"/fastqc/"$run"_1_fastqc/fastqc_data.txt '{if (/'$check'/) print NR}');
    missing=$(grep -o 'pass' "$pass" | wc -l)
    if [ "$missing" == "0" ];
    then
      tool=trimsingle
      file_in="$wd"/$file_fastq    
      file_out=$dirqc/fastqc/"$run"_trim_fastqc.html
      JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
      version=11
      setjavaversion
      setreadlength
      echo1=$(echo "RUNNING TRIMMER CUTTING "$start" OFF THE BEGINNING AND "$end" OF THE END OF THE READS")
      mes_out 
      run_tools
      JDK8=/usr/lib/jvm/java-1.8.0_221/jdk1.8.0_221/ 
      version=8
      setjavaversion
    else
      echo1=$(echo "PASSED RAW SEQUENCE CHECK NO NEED TO TRIM FILES")
      mes_out
    fi
  fi
done 
 
dir_count="$wd"/fastq
for files in "$dir_count"/* ;
do
  name_files
####################################################################################################################
# ALIGNMENT HISAT2 PAIRED
####################################################################################################################
  if [[ "$library" == "paired" && "$aligner" == "HISAT2" ]];
  then
    tool=HISAT2_paired
    file_in="$wd"/fastq/"$file_name"_1.fastq
    file_in2="$wd"/fastq/"$file_name"_2.fastq    
    file_out="$wd"/sam/$file_sam
    if [ "$savesra" == "no" ];
    then
      rm -f "$wd"/"$file_sra" ##add option here donot remove files
    else
      new_dir="$dir_path"/raw_data/sra_files
      create_dir
      mv "$wd"/"$file_sra" "$dir_path"/raw_data/sra_files/"$file_sra"
    fi
    run_tools2i
  fi
####################################################################################################################
# ALIGNMENT HISAT2 SINGLE
####################################################################################################################
  if [[ "$library" == "single" && "$aligner" == "HISAT2" ]];
  then
    tool=HISAT2_single
    file_in="$wd"/fastq/"$file_name".fastq    
    file_out="$wd"/sam/"$file_name".sam
    run_tools
  fi
####################################################################################################################
# ALIGNMENT STAR PAIRED
####################################################################################################################
  if [[ "$library" == "paired" && "$aligner" == "STAR" ]];
  then
    tool=STAR_paired
    file_in="$wd"/fastq/"$file_name"_1.fastq    
    file_in2="$wd"/fastq/"$file_name"_2.fastq    
    file_out="$wd"/sam/"$file_name".sam
    run_tools2i
  fi
####################################################################################################################
# ALIGNMENT STAR SINGLE
####################################################################################################################
  if [[ "$library" == "single" && "$aligner" == "STAR" ]];
  then
    tool=STAR_single
    file_in="$wd"/fastq/"$file_name".fastq    
    file_out="$wd"/sam/"$file_name".sam
    run_tools
  fi
####################################################################################################################
# ALIGNMENT BOWTIE2 PAIRED
####################################################################################################################
  if [[ "$library" == "paired" && "$aligner" == "STAR" ]];
  then
    tool=BOWTIE2_paired
    file_in="$wd"/fastq/"$file_name"_1.fastq   
    file_in2="$wd"/fastq/"$file_name"_2.fastq    
    file_out="$wd"/sam/"$file_name".sam
    run_tools2i
  fi
####################################################################################################################
# ALIGNMENT BOWTIE2 SINGLE
####################################################################################################################
  if [[ "$library" == "single" && "$aligner" == "STAR" ]];
  then
    tool=BOWTIE2_single
    file_in="$wd"/fastq/"$file_name".fastq    
    file_out="$wd"/sam/"$file_name".sam
    run_tools
  fi
done
####################################################################################################################
#  samtobam
####################################################################################################################
dir_count="$wd"/sam
for files in "$dir_count"/* ;
do
  name_files
  tool=samtobam
  file_in="$wd"/sam/"$file_name".sam    
  file_out="$rdbam"/"$file_name".bam
  if [ "$savefastq" == "no" ];
  then
    rm -f "$wd"/fastq/"$file_name"*
    rm -f "$wd"/trim/"$file_name"*
  else
    new_dir="$dir_path"/raw_data/fastq_files
    create_dir
    mv "$wd"/fastq/*.fastq "$dir_path"/raw_data/fastq_files
  fi
  run_tools
####################################################################################################################
#  ASSEMBLY STRINGTIE
####################################################################################################################
  if [ "$assembler" == "stringtie" ];
  then
    tool=assem_string
    file_in="$rdbam"/"$file_name".bam    
    file_out="$dir_path"/raw_data/counts/"$file_name".tab 
    run_tools
    rm -f "$wd"/sam/"$file_name".sam ##add option here donot remove files
  fi
####################################################################################################################
#  ASSEMBLY CUFFLINKS
####################################################################################################################
  if [ "$assembler" == "cufflinks" ];
  then
    tool=assem_cuff
    file_in="$rdbam"/"$file_name".bam
    file_out="$dir_path"/raw_data/counts
    run_tools
    rm -f "$wd"/sam/"$file_name".sam
  fi
####################################################################################################################
#  FINISH
####################################################################################################################
  next_samp
done
step1=$(echo "ALIGN_AND_ASSEMBLE")
step2=$(echo "VARIANT_CALLING_1_PREP_BAM_FILES")
steps
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING STEP1 PREP BAM FILES
####################################################################################################################
####################################################################################################################
####################################################################################################################
if [[ "$variant" == "yes" || "$bamfile" == "variantcalling" ]]; # IF DO DOWNLOAD NOW OR JUST DO VARIANT CALLING
then
  dir_count="$rdbam"
  for files in "$dir_count"/* ;
  do
  name_files 
####################################################################################################################
#  prep_bam_2
####################################################################################################################
    tool=prep_bam_2
    file_in="$rdbam"/"$file_name".bam    
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
    file_out="$file_name"_alignment_metrics.txt
    file_pdf="$file_name"_insert_size_histogram.pdf;
    file_bam_dup="$file_name"_dedup_reads.bam;
    sum_file="$dirqc"/alignment_metrics/"$file_name".txt
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
####################################################################################################################
#  haplotype1
####################################################################################################################
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
    run_tools
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
    run_tools
    tool=filter1F
    file_in="$wd"/"$file_name"raw_indels.vcf
    file_out="$wd"/"$file_name"filtered_indels.vcf
    run_tools
    tool=filter1G
    file_in="$wd"/$file_bam_dup
    file_out="$wd"/"$file_name"recal_data.table
    run_tools
    tool=filter1H
    file_in="$wd"/$file_bam_dup
    file_out="$wd"/"$file_name"post_recal_data.table
    run_tools
    tool=filter1I
    file_in="$wd"/"$file_name"recal_data.table
    file_in2="$wd"/"$file_name"post_recal_data.table
    file_out="$wd"/"$file_name"recalibration_plots.pdf
    run_tools2i
    tool=filter1J
    file_in="$file_name"_dedup_reads.bam
    file_out="$wd"/"$file_name"recal_reads.bam
    run_tools
    move_vcf
####################################################################################################################
#  haplotype2
####################################################################################################################
    tool=haplotype2
    file_in="$wd"/"$file_name"recal_reads.bam    
    file_out="$wd"/"$file_name"raw_variants_recal.vcf
    rm -f "$wd"/"$file_name"_dedup_reads.bam
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
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    next_samp
  done
  step1=$(echo "VARIANT_CALLING")
  step2=$(echo "VARIANT_CALLING_IMPACT_PREDICTION")
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING IMPACT PREDICTION
####################################################################################################################
####################################################################################################################
####################################################################################################################
  dir_count="$rdvcf_final"
  for files in "$dir_count"/* ;
  do
  name_files
    then
####################################################################################################################
#  EXCITOME FILTERING
####################################################################################################################
      tool=excitome_vcf
      file_in="$rdvcf_final"/"$file_name".vcf
      file_out="$rdvcf_final"/*ADARediting.vcf
      run_tools
    fi
####################################################################################################################
#  IMPACT PREDICTION
####################################################################################################################
    tool=snpEff
    file_in="$rdvcf_final"/"$file_name".vcf    
    file_out="$rdsnp"/"$file_name"Ann.vcf
    run_tools  
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    next_samp
  done
  step1=$(echo "VARIANT_CALLING_4_IMPACT_PREDICTION")
  step2=$(echo "RUNNING_EXTOOLSET")
  steps
####################################################################################################################
# RUN EXTOOLSET
####################################################################################################################
  bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolset.sh 2 "$home_dir" "$dir_path" human
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
fi
####################################################################################################################
####################################################################################################################
####################################################################################################################
# EDITING FREQUENCY IMPACT PREDICTION
####################################################################################################################
####################################################################################################################
####################################################################################################################
new_dir=$dir_path
create_dir
bash /home/user/AIDD/AIDD/ExToolset/scripts/basecountsfrombam.sh "$main_dir" $dir_path/frequencies
####################################################################################################################
####################################################################################################################
####################################################################################################################
# CLEANING UP AND COMPRESSING FILES IF NOT RUNNING VARIANT CALLING
####################################################################################################################
####################################################################################################################
####################################################################################################################
if [ "$variant" == "no" ];
then
  step1=$(echo "AIDD_ANALYSIS_WITHOUT_VARIANTS_COMPLETE")
  step2=$(echo "NOW_CLEANING_UP_AND_COMPRESSING_RESULTS")
  steps
  compress_AIDD
  step1=$(echo "ENTIRE_AIDD_EXCITOME_ANALYSIS_WITHOUT_VARIANTS_AND_FILE_CLEANUP")
  step2=$(echo "A_NEW_EXPERIMENT_WILL_REQUIRE_AN_EMPTY_DIRECTORY")
  steps
fi
exit
