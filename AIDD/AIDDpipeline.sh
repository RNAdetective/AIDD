#!/usr/bin/env bash
source config.shlib; # load the config library functions
export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
####################################################################################################################
# this sets up variables for options
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
start=12;
end=97;
Gmatrix_name=gene_count_matrix.csv; 
Tmatrix_name=transcript_count_matrix.csv;
file_sra="$run";
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
file_vcf_finalAll="$run"filtered_snps_finalAll.vcf;
file_vcf_finalADAR="$run"filtered_snps_finalADARediting.vcf;
file_vcf_finalAPOBEC="$run"filtered_snps_finalAPOBECediting.vcf;
file_vcf_final="$run"filtered_snps_final;
file_vcf_raw_recal="$run"raw_variants_recal.vcf;
snpEff_out="$run"filtered_snps_finalAnn;
snp_csv=snpEff"$run";
snp_stats="$run";
snpEff_in="$run"filtered_snps_final;
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
fastq-dump "$wd"/$file_sra -I --split-files --read-filter pass -O "$wd"/ 
mv "$wd"/$file_fastqpaired1pass "$wd"/$file_fastqpaired1 
mv "$wd"/$file_fastqpaired2pass "$wd"/$file_fastqpaired2
 }
fastqdumpsingle() { fastq-dump "$wd"/$file_sra --read-filter pass -O "$wd"/ ; }
movefastq() { mv $fastq_dir_path/$file_fastq "$wd"/ ; }
fastqcpaired() { cd "$dir_path"/AIDD ; fastqc "$wd"/$file_fastqpaired1 "$wd"/$file_fastqpaired2 --outdir=$dirqc/fastqc ; cd $dirqc/fastqc ; unzip "$run"_1_fastqc.zip ; unzip "$run"_2_fastqc.zip ; cd "$dir_path"/AIDD ; }
fastqcsingle() { cd $dirqc/fastqc/ ; fastqc "$wd"/$file_fastq ; cd $dirqc/fastqc ; unzip "$run"_fastqc.zip ; cd "$dir_path"/AIDD ; }
setreadlength() {
length=$(echo "Sequence length");
seq_length=$(cat "$dirqc"/fastqc/"$run"_1_fastqc/fastqc_data.txt | awk -v search=length '$0~search{print $0; exit}');
seq_length_final=${seq_length##*-}
seq_length_final=$(expr "$seq_length_final" - "5");
start=12
end="$seq_length_final" 
}
trimpaired() { fastx_trimmer -f "$start" -l "$end" -i "$wd"/$file_fastqpaired1 -o "$wd"/$file_fastqpaired1trim ; fastx_trimmer -f "$start" -l "$end" -i "$wd"/$file_fastqpaired2 -o "$wd"/$file_fastqpaired2trim ; cd $dirqc/fastqc ; fastqc "$wd"/$file_fastqpaired1trim "$wd"/$file_fastqpaired2trim --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD/ ; rm -f  "$wd"/$file_fastqpaired1 ; rm -f "$wd"/$file_fastqpaired2 ; mv "$wd"/$file_fastqpaired1trim "$wd"/$file_fastqpaired1 ; mv "$wd"/$file_fastqpaired2trim "$wd"/$file_fastqpaired2 ; }
trimsingle() { fastx_trimmer -f start -l end -i "$wd"/$file_fastq -o "$wd"/"$run"_trim.fastq ; cd $dirqc/fastqc ; fastqc "$run"_trim.fastq --outdir=$dirqc/fastqc ; cd "$dir_path"/AIDD/ ; rm -f "$wd"/$file_fastq ; mv "$wd"/"$run"_trim.fastq "$wd"/$file_fastq ; }
HISAT2_paired() {  hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -1 "$wd"/"$file_fastqpaired1" -2 "$wd"/"$file_fastqpaired2" -t --summary-file $dirqc/alignment_metrics/"$run".txt -S "$wd"/"$file_sam" ; }
HISAT2_single() { hisat2 -q -x "$ref_dir_path"/genome -p3 --dta-cufflinks -U "$wd"/"$file_fastq" -t --summary-file "$dir_path"/raw_data/counts/"$run".txt -S "$wd"/"$file_sam" ; }
STAR_paired() { echo "STAR some text line on how to run" ; } #STAR --genomeDir /n/groups/hbctraining/intro_rnaseq_hpc/reference_data_ensembl38/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn Mov10_oe_1.subset.fq --outFileNamePrefix ../results/STAR/Mov10_oe_1_ --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard 
 
STAR_single() { echo "STAR some text line on how to run" ; } #STAR --genomeDir /n/groups/hbctraining/intro_rnaseq_hpc/reference_data_ensembl38/ensembl38_STAR_index/ --runThreadN 3 --readFilesIn Mov10_oe_1.subset.fq --outFileNamePrefix ../results/STAR/Mov10_oe_1_ --outSAMtype BAM SortedByCoordinate --outSAMunmapped Within --outSAMattributes Standard
BOWTIE2_paired() { echo "BOWTIE2 some text line on how to run" ; }
BOWTIE2_single() { echo "BOWTIE2 some text line on how to run" ; }
samtobam() { java -Djava.io.tmpdir="$dir_path"/tmp -jar "$AIDDtool"/picard.jar SortSam INPUT="$wd"/"$file_sam" OUTPUT="$rdbam"/$file_bam SORT_ORDER=coordinate ; }
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
haplotype2() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T HaplotypeCaller -R "$ref_dir_path"/ref2.fa -I "$wd"/$file_bam_recal --dbsnp "$ref_dir_path"/dbsnp.vcf --filter_reads_with_N_cigar -dontUseSoftClippedBases -stand_call_conf 20.0 --max_alternate_alleles 40 -o "$wd"/"$file_vcf_raw_recal"
}
haplotype2B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_variants_recal.table   
}
filter2() {
java -jar $AIDDtool/GenomeAnalysisTK.jar -T SelectVariants -R "$ref_dir_path"/ref2.fa -V "$wd"/"$file_vcf_raw_recal" -selectType SNP -o "$wd"/"$file_vcf_recal"
}
filter2B() {
java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$wd"/$file_vcf_recal -F CHROM -F POS -F ID -F QUAL -F AC -o "$rdvcf"/"$run"raw_snps_recal.table
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
####################################################################################################################
####################################################################################################################
####################################################################################################################
#  DOWNLOADS ALL SAMPLES BEFORE STARTING AIDD
####################################################################################################################
####################################################################################################################
####################################################################################################################
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
  rdbam="$dir_path"/raw_data/bam_files # directory for bam files
  javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
  fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
  sra="$(config_get sra)"; # downloading sra files or have your own
  bamfile="$(config_get bamfile)"; #do you want to start at the beginning or with variant calling 
  file_sra="$run";
  file_bam="$run".bam;
####################################################################################################################
#  DOWNLOADS
####################################################################################################################
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
done
step1=$(echo "INTERNET")
step2=$(echo "ALIGN_AND_ASSEMBLE")
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
export PATH=$PATH:$AIDDtool/bin
cd "$dir_path"/AIDD
if [ "$bamfile" != "variantcalling" ];
then
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
    javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
    fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
    ref_dir_path="$(config_get ref_dir_path)"; # directory for where to put the reference files
    sra="$(config_get sra)"; # downloading sra files or have your own
    library="$(config_get library)"; # paired or single
    aligner="$(config_get aligner)"; # HISAT2 or STAR
    assembler="$(config_get assembler)"; # Strintie or cufflinks
    variant="$(config_get variant)"; # variant calling
    start=12;
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
    file_tab="$run".tab;
    file_name_gtf="$sample".gtf;
####################################################################################################################
# CONVERT SRA TO FASTQ
####################################################################################################################
    if [[ "$sra" == "yes" && "$library" == "paired" ]];
    then
      tool=fastqdumppaired
      file_in="$wd"/$file_sra
      file_out="$wd"/$file_fastqpaired1
      file_out2="$wd"/$file_fastqpaired2
      run_tools2o
    fi
####################################################################################################################
#  CONVERT SRA TO FASTQ
####################################################################################################################
    if [[ "$sra" == "yes" && "$library" == "single" ]];
    then
      tool=fastqdumpsingle
      file_in="$wd"/$file_sra   
      file_out="$wd"/$file_fastq
      run_tools
    fi
####################################################################################################################
# MOVEFASTQPAIRED
####################################################################################################################
    if [[ "$sra" == "no" && "$library" == "paired" ]];
    then
      tool=movefastqpaired
      file_in=$fastq_dir_path/$file_fastqpaired1
      file_in2=$fastq_dir_path/$file_fastqpaired2
      file_out="$wd"/$file_fastqpaired1
      file_out2="$wd"/$file_fastqpaired2
      run_tools2i2o
     fi
####################################################################################################################
#  MOVEFASTQSINGLE
####################################################################################################################
    if [[ "$sra" == "no" && "$library" == "single" ]];
    then
      tool=movefastqsingle
      file_in=$fastq_dir_path/$file_fastq   
      file_out="$wd"/$file_fastq
      run_tools
    fi
####################################################################################################################
# PAIRED QUALITY CONTROL
####################################################################################################################
    if [ "$library" == "paired" ];
    then
      tool=fastqcpaired
      file_in="$wd"/$file_fastqpaired1
      file_in2="$wd"/$file_fastqpaired2
      file_out=$dirqc/fastqc/"$run"_1_fastqc.html
      file_out2=$dirqc/fastqc/"$run"_2_fastqc.html
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
      file_out=$dirqc/fastqc/"$run"_fastqc.html
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
      pass=$(cat "$dirqc"/fastqc/"$run"_1_fastqc/fastqc_data.txt '{if (/'$check'/) print NR}');
      missing=$(grep -o 'pass' "$pass" | wc -l)
      if [ "$missing" == "0" ];
      then
        tool=trimpaired
        file_in="$wd"/$file_fastqpaired1
        file_in2="$wd"/$file_fastqpaired2
        file_out=$dirqc/fastqc/"$run"_trim_1_fastqc.html 
        file_out2=$dirqc/fastqc/"$run"_trim_2_fastqc.html
        JDK11=/usr/lib/jvm/java-11-openjdk-amd64/
        version=11
        setjavaversion 
        setreadlength
        echo1=$(echo "RUNNING TRIMMER CUTTING "$start" OFF THE BEGINNING AND "$end" OF THE END OF THE READS")
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
####################################################################################################################
# ALIGNMENT HISAT2 PAIRED
####################################################################################################################
    if [[ "$library" == "paired" && "$aligner" == "HISAT2" ]];
    then
      tool=HISAT2_paired
      file_in="$wd"/$file_fastqpaired1
      file_in2="$wd"/$file_fastqpaired2    
      file_out="$wd"/$file_sam
      rm -f "$wd"/"$file_sra"
      run_tools2i
    fi
####################################################################################################################
# ALIGNMENT HISAT2 SINGLE
####################################################################################################################
    if [[ "$library" == "single" && "$aligner" == "HISAT2" ]];
    then
      tool=HISAT2_single
      file_in="$wd"/$file_fastq    
      file_out="$wd"/$file_sam
      run_tools
    fi
####################################################################################################################
# ALIGNMENT STAR PAIRED
####################################################################################################################
    if [[ "$library" == "paired" && "$aligner" == "STAR" ]];
    then
      tool=STAR_paired
      file_in="$wd"/$file_fastqpaired1    
      file_in2="$wd"/$file_fastqpaired2    
      file_out="$wd"/$file_sam
      run_tools2i
    fi
####################################################################################################################
# ALIGNMENT STAR SINGLE
####################################################################################################################
    if [[ "$library" == "single" && "$aligner" == "STAR" ]];
    then
      tool=STAR_single
      file_in="$wd"/$file_fastq    
      file_out="$wd"/$file_sam
      run_tools
    fi
####################################################################################################################
# ALIGNMENT BOWTIE2 PAIRED
####################################################################################################################
    if [[ "$library" == "paired" && "$aligner" == "STAR" ]];
    then
      tool=BOWTIE2_paired
      file_in="$wd"/$file_fastqpaired1    
      file_in2="$wd"/$file_fastqpaired2    
      file_out="$wd"/$file_sam
      run_tools2i
    fi
####################################################################################################################
# ALIGNMENT BOWTIE2 SINGLE
####################################################################################################################
    if [[ "$library" == "single" && "$aligner" == "STAR" ]];
    then
      tool=BOWTIE2_single
      file_in="$wd"/$file_fastq    
      file_out="$wd"/$file_sam
      run_tools
    fi
####################################################################################################################
#  samtobam
####################################################################################################################
    tool=samtobam
    file_in="$wd"/$file_sam    
    file_out="$rdbam"/$file_bam
    rm -f "$wd"/*.fastq
    run_tools
####################################################################################################################
#  ASSEMBLY STRINGTIE
####################################################################################################################
    if [ "$assembler" == "stringtie" ];
    then
      tool=assem_string
      file_in="$rdbam"/"$file_bam"    
      file_out="$dir_path"/raw_data/counts/"$file_tab" 
      run_tools
      rm -f "$wd"/"$file_sam"
    fi
####################################################################################################################
#  ASSEMBLY CUFFLINKS
####################################################################################################################
    if [ "$assembler" == "cufflinks" ];
    then
      tool=assem_cuff
      file_in="$rdbam"/"$file_bam"
      file_out="$dir_path"/raw_data/counts
      run_tools
      rm -f "$wd"/"$file_sam"
    fi
    filecheckVC="$dirqc"/filecheck
    type1="$dir_path"/raw_data/ballgown/"$sample"/"$sample".gtf
    snptype=gtf
    temp_dir # delete temp directories if present
    create_filecheck
####################################################################################################################
#  FINISH
####################################################################################################################
  next_samp
  done
  step1=$(echo "ALIGN_AND_ASSEMBLE")
  step2=$(echo "VARIANT_CALLING_1_PREP_BAM_FILES")
  steps
  } < $INPUT
  IFS=$OLDIFS
fi
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING STEP1 PREP BAM FILES
####################################################################################################################
####################################################################################################################
####################################################################################################################
if [[ "$variant" == "yes" || "$bamfile" == "variantcalling" ]]; # IF DO DOWNLOAD NOW OR JUST DO VARIANT CALLING
then
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS  
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    dir_path="$(config_get dir_path)"; # main directory
    wd="$dir_path"/working_directory; # working directory
    home_dir="$(config_get home_dir)"; # home directory
    ref_dir_path="$(config_get ref_dir_path)"; # reference directory
    dirqc="$dir_path"/quality_control; # qc directory  
    AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
    rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
    rdbam="$dir_path"/raw_data/bam_files # directory for bam files
    rdsnp="$dir_path"/raw_data/snpEff #directory for snp files
    javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
    fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
    file_bam="$run".bam;
    file_bam_2="$run"_2.bam;
    file_bam_3="$run"_3.bam;
    file_pdf="$run"_insert_size_histogram.pdf;
    file_bam_dup="$run"_dedup_reads.bam;
    sum_file="$dirqc"/alignment_metrics/"$run".txt 
####################################################################################################################
#  prep_bam_2
####################################################################################################################
    tool=prep_bam_2
    file_in="$rdbam"/$file_bam    
    file_out="$wd"/$file_bam_2
    run_tools
####################################################################################################################
#  prep_bam_3
####################################################################################################################
    tool=prep_bam_3    
    file_in="$wd"/$file_bam_2    
    file_out="$wd"/$file_bam_3
    run_tools
####################################################################################################################
#  prep_align_sum
####################################################################################################################
    tool=prep_align_sum
    file_in="$wd"/$file_bam_3   
    file_out="$run"_alignment_metrics.txt
    run_tools
    tool=prep_align_sum2
    file_in="$wd"/$file_bam_3
    file_out=$dirqc/insert_metrics/"$run"_insert_metrics.txt
    run_tools
    tool=prep_align_sum3
    file_in="$wd"/$file_bam_3
    file_out="$wd"/"$run"depth_out.txt
    rm -f "$wd"/"$file_bam_2"
    run_tools
####################################################################################################################
#  markduplicates
####################################################################################################################
    tool=markduplicates
    file_in="$wd"/$file_bam_3    
    file_out="$wd"/$file_bam_dup
    run_tools
####################################################################################################################
#  DISPLAY MESSAGES
####################################################################################################################
  done
  step1=$(echo "VARIANT_CALLING_1_PREP_BAM_FILE")
  step2=$(echo "VARIANT_CALLING_2_FIRST_VARIANT_CALLING")
  steps
  } < $INPUT
  IFS=$OLDIFS
####################################################################################################################
#  GET ALIGNMENT SUMMARIES READY FOR EXTOOLSET
####################################################################################################################
  summary_split
  sum_combine
  sum_divid
  cd "$dir_path"/AIDD
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING STEP2 FIRST VARIANT CALLING
####################################################################################################################
####################################################################################################################
####################################################################################################################
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS  
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    dir_path="$(config_get dir_path)"; # main directory
    wd="$dir_path"/working_directory; # working directory
    home_dir="$(config_get home_dir)"; # home directory
    ref_dir_path="$(config_get ref_dir_path)"; # reference directory
    dirqc="$dir_path"/quality_control; # qc directory
    AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
    rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
    rdbam="$dir_path"/raw_data/bam_files # directory for bam files
    rdsnp="$dir_path"/raw_data/snpEff #directory for snp files
    javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
    fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
    ref_dir_path="$(config_get ref_dir_path)"; # directory for where to put the reference files
    file_bam_dup="$run"_dedup_reads.bam;
    file_bam_dupix="$run"_dedup_read.bai;
    file_bam_recal="$run"recal_reads.bam;
    file_vcf_raw="$run"raw_variants.vcf;
    file_vcf_rawtab="$rdvcf"/"$run"raw_variants.table;
####################################################################################################################
#  haplotype1
####################################################################################################################
    tool=haplotype1
    file_in="$wd"/$file_bam_dup    
    file_out="$wd"/"$file_bam_dupix"
    rm -f "$wd"/"$file_bam_3"
    run_tools
    tool=haplotype1B
    file_in="$wd"/$file_bam_dup    
    file_out="$wd"/$file_vcf_raw
    run_tools
    tool=haplotype1C
    file_in="$wd"/$file_vcf_raw   
    file_out="$file_vcf_rawtab"
    run_tools
####################################################################################################################
#  filter1
####################################################################################################################
    tool=filter1
    file_in="$wd"/$file_vcf_raw    
    file_out="$wd"/"$run"raw_snps.vcf
    run_tools
    tool=filter1B
    file_in="$wd"/"$run"raw_snps.vcf    
    file_out="$rdvcf"/"$run"raw_snps.table
    run_tools
    tool=filter1C
    file_in="$wd"/$file_vcf_raw
    file_out="$wd"/"$run"raw_indels.vcf
    run_tools
    tool=filter1D
    file_in="$wd"/"$run"raw_snps.vcf
    file_out="$wd"/"$run"filtered_snps.vcf
    run_tools
    tool=filter1E
    file_in="$wd"/"$run"filtered_snps.vcf
    file_out="$rdvcf"/"$run"filtered_snps.table
    run_tools
    tool=filter1F
    file_in="$wd"/"$run"raw_indels.vcf
    file_out="$wd"/"$run"filtered_indels.vcf
    run_tools
    tool=filter1G
    file_in="$wd"/$file_bam_dup
    file_out="$wd"/"$run"recal_data.table
    run_tools
    tool=filter1H
    file_in="$wd"/$file_bam_dup
    file_out="$wd"/"$run"post_recal_data.table
    run_tools
    tool=filter1I
    file_in="$wd"/"$run"recal_data.table
    file_in2="$wd"/"$run"post_recal_data.table
    file_out="$wd"/"$run"recalibration_plots.pdf
    run_tools2i
    tool=filter1J
    file_in="$wd"/$file_bam_dup
    file_out="$wd"/$file_bam_recal
    run_tools
    move_vcf
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    next_samp
  done
  step1=$(echo "VARIANT_CALLING_2_FIRST_VARIANT_CALLING")
  step2=$(echo "VARIANT_CALLING_3_SECOND_VARIANT_CALLING")
  steps
  } < $INPUT
  IFS=$OLDIFS
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING STEP3 SECOND VARIANT CALLING
####################################################################################################################
####################################################################################################################
####################################################################################################################
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS  
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    dir_path="$(config_get dir_path)"; # main directory
    wd="$dir_path"/working_directory; # working directory
	home_dir="$(config_get home_dir)"; # home directory
    ref_dir_path="$(config_get ref_dir_path)"; # reference directory
    dirqc="$dir_path"/quality_control; # qc directory
    AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
    rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
    rdbam="$dir_path"/raw_data/bam_files # directory for bam files
    rdsnp="$dir_path"/raw_data/snpEff #directory for snp files
    javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
    fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
    ref_dir_path="$(config_get ref_dir_path)"; # directory for where to put the reference files 
    file_bam_recal="$run"recal_reads.bam;
    file_vcf_raw_recal="$run"raw_variants_recal.vcf;
    file_vcf_recal="$run"raw_snps_recal.vcf;
    file_vcf_finalAll="$run"filtered_snps_finalAll.vcf;
    file_vcf_finalADAR="$run"filtered_snps_finalADARediting.vcf;
    file_vcf_finalAPOBEC="$run"filtered_snps_finalAPOBECediting.vcf;
####################################################################################################################
#  haplotype2
####################################################################################################################
    tool=haplotype2
    file_in="$wd"/$file_bam_recal    
    file_out="$wd"/"$file_vcf_raw_recal"
    rm -f "$wd"/"$file_bam_dup"
    run_tools
    tool=haplotype2B
    file_in="$wd"/"$file_vcf_raw_recal"
    file_out="$rdvcf"/"$run"raw_variants_recal.table
    run_tools
####################################################################################################################
#  filter2
####################################################################################################################
    tool=filter2
    file_in="$wd"/$file_vcf_raw_recal    
    file_out="$wd"/$file_vcf_recal
    run_tools
    tool=filter2B
    file_in="$wd"/$file_vcf_recal
    file_out="$rdvcf"/"$run"raw_snps_recal.table
    run_tools
    tool=filter2C
    file_in="$wd"/"$file_vcf_raw_recal"
    file_out="$wd"/"$run"raw_indels_recal.vcf
    run_tools
    tool=filter2D
    file_in="$wd"/"$file_vcf_recal"
    file_out="$wd"/"$file_vcf_finalAll"
    run_tools
    tool=filter2E
    file_in="$wd"/"$file_vcf_finalAll"
    file_out="$rdvcf"/"$run"filtered_snps_finalAll.table
    run_tools
    tool=filter2F
    file_in="$wd"/"$run"raw_indels_recal.vcf
    file_out="$wd"/"$run"filtered_indels_recal.vcf
    run_tools
    move_vcf2
    #move_vcf3
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    next_samp
  done
  step1=$(echo "VARIANT_CALLING_3_SECOND_VARIANT_CALLING")
  step2=$(echo "VARIANT_CALLING_4_IMPACT_PREDICTION")
  steps
  } < $INPUT
  IFS=$OLDIFS
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING STEP4 IMPACT PREDICTION
####################################################################################################################
####################################################################################################################
####################################################################################################################
  INPUT="$dir_path"/PHENO_DATA.csv
  OLDIFS=$IFS  
  {
  [ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
  read
  while IFS=, read -r samp_name run condition sample condition2 condition3
  do
    dir_path="$(config_get dir_path)"; # main directory
    wd="$dir_path"/working_directory; # working directory
    home_dir="$(config_get home_dir)"; # home directory
    ref_dir_path="$(config_get ref_dir_path)"; # reference directory
    dirqc="$dir_path"/quality_control; # qc directory
    AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
    rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
    rdvcf_final="$dir_path"/raw_data/vcf_files # directory for final vcf files
    rdsnp="$dir_path"/raw_data/snpEff # directory for snpEff files
    rdbam="$dir_path"/raw_data/bam_files # directory for bam files
    javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
    fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
    ref_dir_path="$(config_get ref_dir_path)"; # directory for where to put the reference files 
    file_vcf_final="$run"filtered_snps_final;
    file_vcf_finalAll="$run"filtered_snps_finalAll.vcf
    file_vcf_finalADAR="$run"filtered_snps_finalADARediting.vcf
    file_vcf_finalAPOBEC="$run"filtered_snps_finalAPOBECediting.vcf
    snpEff_out="$run"filtered_snps_finalAnn;
    snp_csv=snpEff"$run";
    snp_stats="$run";
    snpEff_in="$run"filtered_snps_final;
####################################################################################################################
#  EXCITOME FILTERING
####################################################################################################################
    tool=excitome_vcf
    file_in="$rdvcf"/"$file_vcf_final"All.vcf
    file_out="$rdvcf"/$file_vcf_finalADAR
    run_tools
####################################################################################################################
#  IMPACT PREDICTION
####################################################################################################################
    for snptype in All AG TC CT GA ADARediting APOBECediting ; # DO ALL VARIANTS, ADAR VARIANTS, AND APOBEC VARIANTS
    do
      tool=snpEff
      file_in="$rdvcf"/"$snpEff_in""$snptype".vcf    
      file_out="$rdsnp"/"$snpEff_out""$snptype".vcf
      run_tools 
    done  
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    next_samp
  done
  step1=$(echo "VARIANT_CALLING_4_IMPACT_PREDICTION")
  step2=$(echo "RUNNING_EXTOOLSET")
  steps
  } < $INPUT
  IFS=$OLDIFS
####################################################################################################################
# RUN EXTOOLSET
####################################################################################################################
  bash "$home_dir"/AIDD/AIDD/ExToolset/ExToolset.sh 1 "$home_dir" "$dir_path"
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
