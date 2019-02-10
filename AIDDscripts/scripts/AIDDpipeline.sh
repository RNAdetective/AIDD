#!/usr/bin/env bash
source config.shlib; # load the config library functions
export PATH=$PATH:"$home_dir"/AIDD/AIDD_tools/bin
####################################################################################################################
####################################################################################################################
####################################################################################################################
# this sets up variables for options
####################################################################################################################
####################################################################################################################
####################################################################################################################
#defines variables 
dir_path="$(config_get dir_path)"; # main directory
wd="$dir_path"/working_directory; # working directory
home_dir="$(config_get home_dir)"; # home directory
ref_dir_path="$(config_get ref_dir_path)"; # reference directory
dirqc="$dir_path"/quality_control; # qc directory
AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
rdbam="$dir_path"/raw_data/bam_files # directory for bam files
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
mes_out() {
DATE_WITH_TIME=$(date +%Y-%m-%d_%H-%M-%S)
echo "'$DATE_WITH_TIME' $echo1 $echo2 $echo3 $echo4
___________________________________________________________________________"
}
download() {
runfoldername=${run:0:3}
runfolder=${run:0:6}
cd "$wd"/
wget ftp://ftp-trace.ncbi.nih.gov/sra/sra-instant/reads/ByRun/sra/"$runfoldername"/"$runfolder"/"$run"/"$run".sra
cd "$home_dir"/AIDD/AIDD
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
gtfcheck() { 
echo ""$run","$sample","$answer"
" > $dirqc/$file_check_dir/"$sample".csv
}
file_check() {
if [ -f $path_to_file_check ] # IF FILE IS THERE
  then
    answer=$"yes"; 
      gtfcheck # ANSWER YES
  else
    answer=$"no"; 
      gtfcheck # ANSWER NO
  fi
}
makecheckfile() { cat $dirqc/"$filecheck"/sample* | grep -w no$ | while read run exist; do echo "$run","$sample"; done > "$dirqc/"$filecheck"/CheckTheseFiles.csv" ; rm -f $dirqc/"$filecheck"/sample* ; }
creatematrix() {
dir_path=$dir_path
    cd "$dir_path"/raw_data/
    python $AIDDtool/bin/prepDE.py -g "$dir_path"/Results/DESeq2/$Gmatrix_name -t "$dir_path"/Results/DESeq2/$Tmatrix_name # CREATE MATRIX FILES
    cd "$dir_path"/AIDD/
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
markduplicates(){
    java $javaset -jar $AIDDtool/picard.jar MarkDuplicates INPUT="$wd"/$file_bam_3 OUTPUT="$wd"/$file_bam_dup METRICS_FILE="$wd"/"$run"metrics.txt
}

compress_AIDD() {
      rm -f -r "$wd" # REMOVE UNNEEDED DIRECTORIES
      rm -f -r "$dir_path"/tmp # REMOVE UNNEEDED DIRECTORIES
      rm -f -r "$dir_path"/temp # REMOVE UNNEEDED DIRECTORIES
      tar -cvzf "$dir_path"/"$AIDD".tar.gz "$dir_path"
      split -d -b 8G "$dir_path"/"$AIDD".tar.gz """$dir_path""/"$AIDD".tar.gz." # REMOVE UNNEEDED DIRECTORIES
      ##add gdrive command here to upload bam files
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
excitome_vcf() { 
         ## filter out everything that is not ADAR mediated editing
        awk -F "\t" '/^#/' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalinfo.vcf #
        awk -F "\t" ' { if (($4 == "A") && ($5 == "G")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalAG.vcf
        awk -F "\t" '{ if (($4 == "T") && ($5 == "C")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalTC.vcf
        cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalAG.vcf "$rdvcf"/"$run"filtered_snps_finalTC.vcf > "$rdvcf"/"$file_vcf_finalADAR"
        rm -f "$rdvcf"/"$run"filtered_snps_finalAG.vcf
        rm -f "$rdvcf"/"$run"filtered_snps_finalTC.vcf
        awk -F "\t" ' { if (($4 == "C") && ($5 == "T")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalCT.vcf
        awk -F "\t" '{ if (($4 == "G") && ($5 == "A")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalGA.vcf
        cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalCT.vcf "$rdvcf"/"$run"filtered_snps_finalGA.vcf > "$rdvcf"/"$file_vcf_finalAPOBEC"
        rm -f "$rdvcf"/"$run"filtered_snps_finalTC.vcf
        rm -f "$rdvcf"/"$run"filtered_snps_finalTC.vcf
}
snpEff() {
    java $javaset -jar $AIDDtool/snpEff.jar -v GRCh37.75 "$wd"/$file_vcf_final$snptype.vcf -stats "$dir_path"/raw_data/snpEff/$snp_stats$snptype -csvStats "$dir_path"/raw_data/snpEff/$snp_csv$snptype.csf > "$dir_path"/raw_data/snpEff/$snpEff_out$snptype.vcf
    ##converts final annotationed vcf to table for easier processing
    java $javaset  -jar $AIDDtool/GenomeAnalysisTK.jar -T VariantsToTable -R "$ref_dir_path"/ref2.fa -V "$dir_path"/raw_data/snpEff/$snpEff_out$snptype.vcf -F CHROM -F POS -F ID -F REF -F ALT -F QUAL -F AC -F ANN -o "$dir_path"/raw_data/snpEff/$snpEff_out$snptype.table
}
VCsubmatrix() {
  echo "NOT DONE YET"
}
VCimpactmatrix() {
  echo "NOT DONE YET"
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
run_tools2o() {
    if [[ ! -f "$file_out" && ! -f "$file_out2" ]]; # IF OUTPUT FILE IS NOT THERE
    then
      if [ -f "$file_in" ]; # IF INPUT THERE
      then
        echo1=FOUND
        echo2="$file_in"
        echo3=STARTING
        echo4="$tool"
        mes_out
        $tool # TOOL
      else
        echo1=CANT_FIND
        echo2=$file_in
        echo3=FOR_THIS
        echo4="$sample"
        mes_out # ERROR INPUT NOT THERE
      fi
      if [[ -f "$file_out" && -f "$file_out2" ]]; # IF OUTPUT IS THERE
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
run_tools2i2o() {
if [[ ! -f "$file_out" && ! -f "$file_out2" ]]; # IF OUTPUT FILE IS NOT THERE
      then
      if [[ -f "$file_in" && -f "$file_in2" ]]; # IF INPUT THERE
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
      if [[ -f "$file_out" && -f "$file_out2" ]]; # IF OUTPUT IS THERE
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
run_tools2i() {
    if [ ! -f "$file_out" ]; # IF OUTPUT FILE IS NOT THERE
      then
      if [[ -f "$file_in" && -f "$file_in2" ]]; # IF INPUT THERE
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
  dir_path="$(config_get dir_path)"; # main directory
  wd="$dir_path"/working_directory; # working directory
  home_dir="$(config_get home_dir)"; # home directory
  ref_dir_path="$(config_get ref_dir_path)"; # reference directory
  dirqc="$dir_path"/quality_control; # qc directory
  AIDDtool="$home_dir"/AIDD/AIDD_tools; # AIDD tool directory
  rdvcf="$dir_path"/raw_data/vcf_files # directory for vcf files
  rdbam="$dir_path"/raw_data/bam_files # directory for bam files
  javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
  fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
  sra="$(config_get sra)"; # downloading sra files or have your own
  file_sra="$run".sra;
####################################################################################################################
#  DOWNLOADS
####################################################################################################################
  if [ "$sra" == 1 ]; # IF DOWNLOAD SRA
  then
    if [ ! -f "$wd"/"$file_sra" ]; # IF OUTPUT FILE IS NOT THERE
    then
      download
    fi
    if [ -f "$wd"/"$file_sra" ]; # IF OUTPUT IS THERE
    then
      echo1=FOUND
      echo2=$file_sra
      echo3=FINISHED
      echo4=DOWNLOADING_$sample
      mes_out # ERROR OUTPUT IS THERE
    else 
      download
      if [ ! -f "$wd"/"$file_sra" ]; # IF OUT IS NOT THERE
      then
        download
      fi  
    fi
  else
    echo1=FOUND
    echo2=$file_sra
    echo3=NOW_STARTING
    echo4=NEXT_SAMPLE
    mes_out
  fi
done
echo1=DONE_WITH
echo2=INTERNET
echo3=NOW_STARTING
echo4=ALIGN_AND_ASSEMBLE
mes_out
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
javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
ref_dir_path="$(config_get ref_dir_path)"; # directory for where to put the reference files
sra="$(config_get sra)"; # downloading sra files or have your own
library="$(config_get library)"; # paired or single
aligner="$(config_get aligner)"; # HISAT2 or STAR
assembler="$(config_get assembler)"; # Strintie or cufflinks
variant="$(config_get variant)"; # variant calling
start=12;
end=97;
file_sra="$run".sra;
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
  if [[ "$sra" == 1 && "$library" == 1 ]];
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
  if [[ "$sra" == 1 && "$library" == 2 ]];
  then
    tool=fastqdumpsingle
    file_in="$wd"/$file_sra   
    file_out="$wd"/$file_fastq
    run_tools
  else
        echo1=FOUND
        echo2=$file_out
        echo3=FINISHED
        echo4=$tool
        mes_out # ERROR OUTPUT IS THERE
  fi

####################################################################################################################
# CONVERT SRA TO FASTQ
####################################################################################################################

####################################################################################################################
# MOVEFASTQPAIRED
####################################################################################################################
  if [[ "$sra" == 2 && "$library" == 1 ]];
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
  if [[ "$sra" == 2 && "$library" == 2 ]];
  then
    tool=movefastqsingle
    file_in=$fastq_dir_path/$file_fastq   
    file_out="$wd"/$file_fastq
    run_tools
  else
        echo1=FOUND
        echo2=$file_out
        echo3=FINISHED
        echo4=$tool
        mes_out # ERROR OUTPUT IS THERE
  fi
####################################################################################################################
# PAIRED QC REPORTS
####################################################################################################################
  if [ "$library" == 1 ];
  then
    tool=fastqcpaired
    file_in="$wd"/$file_fastqpaired1
    file_in2="$wd"/$file_fastqpaired2
    file_out=$dirqc/fastqc/"$run"_1_fastqc.html
    file_out2=$dirqc/fastqc/"$run"_2_fastqc.html
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 11
    run_tools2i2o
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 8
  fi
####################################################################################################################
#  SINGLE QUALITY CONTROL
####################################################################################################################
  if [ "$library" == 2 ];
  then
    tool=fastqcsingle
    file_in="$wd"/$file_fastq    
    file_out=$dirqc/fastqc/"$run"_fastqc.html
    rm -f "$wd"/"$file_sra"
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 11
    run_tools
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 8
  else
        echo1=FOUND
        echo2=$file_out
        echo3=FINISHED
        echo4=$tool
        mes_out # ERROR OUTPUT IS THERE
  fi
####################################################################################################################
# PAIRED TRIMMING
####################################################################################################################
  if [ "$library" == 1 ];
  then
    tool=trimpaired
    file_in="$wd"/$file_fastqpaired1
    file_in2="$wd"/$file_fastqpaired2
    file_out=$dirqc/fastqc/"$run"_trim_1_fastqc.html 
    file_out2=$dirqc/fastqc/"$run"_trim_2_fastqc.html
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 11    
    run_tools2i2o
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 8
  fi
####################################################################################################################
# TRIMMING SINGLE
####################################################################################################################
  if [ "$library" == 2 ];
  then
    tool=trimsingle
    file_in="$wd"/$file_fastq    
    file_out=$dirqc/fastqc/"$run"_trim_fastqc.html
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 11
    run_tools
    source "$home_dir"/AIDD/AIDD/scripts/setjavaversion.sh 8
  else
        echo1=FOUND
        echo2=$file_out
        echo3=FINISHED
        echo4=$tool
        mes_out # ERROR OUTPUT IS THERE
  fi
####################################################################################################################
# ALIGNMENT HISAT2 PAIRED
####################################################################################################################
  if [[ "$library" == 1 && "$aligner" == 1 ]];
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
  if [[ "$library" == 2 && "$aligner" == 1 ]];
  then
    tool=HISAT2_single
    file_in="$wd"/$file_fastq    
    file_out="$wd"/$file_sam
    run_tools
  fi
####################################################################################################################
# ALIGNMENT STAR PAIRED
####################################################################################################################
  if [[ "$library" == 1 && "$aligner" == 2 ]];
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
  if [[ "$library" == 2 && "$aligner" == 2 ]];
  then
    tool=STAR_single
    file_in="$wd"/$file_fastq    
    file_out="$wd"/$file_sam
    run_tools
  else
        echo1=FOUND
        echo2=$file_out
        echo3=FINISHED
        echo4=$tool
        mes_out # ERROR OUTPUT IS THERE
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
  tool=assem_string
  file_in="$rdbam"/"$file_bam"    
  file_out="$dir_path"/raw_data/counts/"$file_tab" 
  run_tools
  rm -f "$wd"/"$file_sam"
####################################################################################################################
#  FINISH
####################################################################################################################
echo2="$sample"
echo4=next"$sample"
echo1=DONE_WITH
echo3=STARTING
mes_out
done
echo1=DONE_WITH
echo2=ALGIN_AND_ASSEMBLE
echo3=STARTING
echo4=EXTOOLSET_PART_1
mes_out
} < $INPUT
IFS=$OLDIFS
####################################################################################################################
####################################################################################################################
####################################################################################################################
#  CHECKS FOR GTF FILES
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
javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
file_name_gtf="$sample".gtf;
  if [ -d "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ ]; # IF TEMP_DIR IN SAMPLE FOLDER
  then
  echo1=FOUND
  echo2="$file_name_gtf"
  echo3=ALREADLY
  echo4=IN_FOLDER
  mes_out
  rm -f -R "$dir_path"/raw_data/ballgown/$sample/tmp.XX*/ #DELETE TMP_DIR
  fi
  path_to_file_check="$dir_path"/raw_data/ballgown/$sample/"$file_name_gtf" 
  file_check_dir=filecheck;
  file_check # makes temp file with yes or no
done
} < $INPUT
IFS=$OLDIFS

filecheck=filecheck
makecheckfile # MAKE ONE CSV WITH MISSING FILES
if [ ! -s "$dirqc/$filecheck/CheckTheseFiles.csv" ]; # IF ALL INPUT FILES ARE THERE CHECKFILE EMPTY
then
  file_in="$dir_path"/raw_data/ballgown/sample01/sample01.gtf
  file_out="$dir_path"/Results/DESeq2/"$Gmatrix_name"
  file_out2="$dir_path"/Results/DESeq2/"$Tmatrix_name"
  tool=creatematrix
  run_tools2o
fi
####################################################################################################################
# EXTOOLSET PART 1 EXPRESSION ANALYSIS
####################################################################################################################
if [[ -s "$dir_path"/Results/DESeq2/"$Gmatrix_name" && -s "$dir_path"/Results/DESeq2/"$Tmatrix_name" ]]; # IF COUNT MATRIX IS THERE
then
  echo1=DONE_WITH
  echo2=GENERATED_MARITX_FILE
  echo3=STARTING
  echo4=EXTOOLSET_PART_1
mes_out
  echo "bash "$dir_path"/ExToolset/GEX_TEX.sh" # RUN DE
  echo "bash "$dir_path"/ExToolset/PEX.sh" # RUN PATHWAY DE
  ##add in function here to make ExcitomeGeneEx.csv # RUN EXCITOME LIST
else
    echo1=CANT_FIND
    echo2="$Gmatrix_name"
    echo3=FOR_THIS
    echo4="$sample"
mes_out # ERROR 
fi
####################################################################################################################
####################################################################################################################
####################################################################################################################
# VARIANTCALLING STEP1 PREP BAM FILES
####################################################################################################################
####################################################################################################################
####################################################################################################################
if [[ "$variant" == 1 || "$variant" == 3 ]]; # IF DO DOWNLOAD NOW OR JUST DO VARIANT CALLING
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
    javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
    fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
    file_bam="$run".bam;
    file_bam_2="$run"_2.bam;
    file_bam_3="$run"_3.bam;
    file_pdf="$run"_insert_size_histogram.pdf;
    file_bam_dup="$run"_dedup_reads.bam; 
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
    file_out="$wd"/$file_pdf
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
  echo2=VARIANT_CALLING_PART_1
  echo4=VARIANT_CALLING_PART_2
  echo1=DONE_WITH
  echo3=STARTING
  mes_out
  } < $INPUT
  IFS=$OLDIFS
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
    javaset="-Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir="$dir_path"/tmp"; # sets java tools
    fastq_dir_path="$(config_get fastq_dir_path)"; # directory for local fastq files
    ref_dir_path="$(config_get ref_dir_path)"; # directory for where to put the reference files
    file_bam_dup="$run"_dedup_reads.bam;
    file_bam_recal="$run"recal_reads.bam;
    file_vcf_raw="$run"raw_variants.vcf;
####################################################################################################################
#  haplotype1
####################################################################################################################
    tool=haplotype1
    file_in="$wd"/$file_bam_dup    
    file_out="$wd"/$file_vcf_raw
    rm -f "$wd"/"$file_bam_3"
    run_tools
####################################################################################################################
#  filter1
####################################################################################################################
    tool=filter1
    file_in="$wd"/$file_vcf_raw    
    file_out="$wd"/$file_bam_recal
    run_tools
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    echo2="$sample"
    echo4=next"$sample"
    echo1=DONE_WITH
    echo3=STARTING
    mes_out
  done
    echo2=VARIANT_CALLING_PART_2
    echo4=VARIANT_CALLING_PART_3
    echo1=DONE_WITH
    echo3=STARTING
    mes_out
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
    file_out="$wd"/$file_vcf_raw_recal
    rm -f "$wd"/"$file_bam_dup"
    run_tools
####################################################################################################################
#  filter2
####################################################################################################################
    tool=filter2
    file_in="$wd"/$file_vcf_raw_recal    
    file_out="$wd"/$file_vcf_finalAll
    run_tools
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    echo2="$sample"
    echo4=next"$sample"
    echo1=DONE_WITH
    echo3=STARTING
    mes_out
  done
    echo2=VARIANT_CALLING_PART_3
    echo4=VARIANT_CALLING_PART_4
    echo1=DONE_WITH
    echo3=STARTING
    mes_out
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
    file_in="$wd"/$file_vcf_finalAll  
    file_out="$rdvcf"/$file_vcf_finalADAR
    file_out="$rdvcf"/$file_vcf_finalAPOBEC
    run_tools
####################################################################################################################
#  IMPACT PREDICTION
####################################################################################################################
    for snptype in All ADARediting APOBECediting ; # DO ALL VARIANTS, ADAR VARIANTS, AND APOBEC VARIANTS
    do
      tool=snpEff
      file_in="$wd"/"$file_vcf_final""$snptype".vcf    
      file_out="$wd"/"$snp_out""$snptype".vcf
      run_tools
    done 
####################################################################################################################
# DISPLAY MESSAGES
####################################################################################################################
    echo2="$sample"
    echo4=next"$sample"
    echo1=DONE_WITH
    echo3=STARTING
    mes_out
  done
    echo2=VARIANT_CALLING_PART_4
    echo4=CLEANING_UP_FILES
    echo1=DONE_WITH
    echo3=STARTING
    mes_out
  } < $INPUT
  IFS=$OLDIFS
####################################################################################################################
####################################################################################################################
####################################################################################################################
# CLEANING UP AND COMPRESSING FILES
####################################################################################################################
####################################################################################################################
####################################################################################################################
  echo1=DONE_WITH  
  echo2=AIDD_ANALYSIS_FULLY_COMPLETE
  echo3=STARTING
  echo4=NOW_CLEANING_UP_AND_COMPRESSING_RESULTS
  mes_out
  for i in raw final filtered; do
  mv $dir_path/raw_data/vcf_files/*"$i"* $dir_path/raw_data/vcf_files/"$i"/
  done
  #compress_AIDD
  echo1=DONE_WITH
  echo2=ENTIRE_AIDD_EXCITOME_ANALYSIS_AND_FILE_CLEANUP
  echo3=STARTING
  echo4=A_NEW_EXPERIMENT_WILL_REQUIRE_AN_EMPTY_DIRECTORY
  mes_out
fi
if [ "$variant" == 2 ];
then
  echo1=DONE_WITH
  echo2=AIDD_ANALYSIS_WITHOUT_VARIANTS_COMPLETE
  echo3=STARTING
  echo4=NOW_CLEANING_UP_AND_COMPRESSING_RESULTS
  mes_out
  #compress_AIDD
  echo1=DONE_WITH
  echo2=ENTIRE_AIDD_EXCITOME_ANALYSIS_WITHOUT_VARIANTS_AND_FILE_CLEANUP
  echo3=STARTING
  echo4=A_NEW_EXPERIMENT_WILL_REQUIRE_AN_EMPTY_DIRECTORY
  echo3=STARTING
  mes_out
fi
exit
