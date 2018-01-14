#!/usr/bin/env bash
main_function() {
export PATH=$PATH:/home/user/Pipelines/HISAT2_pipeline/bin

echo "Please enter the path to external hard drive with at least 1 terabyte of space if you want to run all 18 files"
read path
mkdir $path
cd $path
##/media/user/ExtraSpace3/AML2


echo "Please enter up to 18 sra file numbers seperated by a space with no punctuation for example SRR0000000 SRR0000000 SRR0000000."
read varname1 varname2 varname3 varname4 varname5 varname6 varname7 varname8 varname9 varname10 varname11 varname12 varname13 varname14 varname15 varname16 varname17 varname18
##SRR1575102 SRR1575103 SRR1575104 SRR1575105 SRR3895734 SRR3895735 SRR3895736 SRR3895737 SRR3895738 SRR3895739 SRR3895741 SRR3895742 SRR3895743 SRR3895744 SRR3895746 SRR3895747

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard AddorReplaceReadGroups with RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20 for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar AddOrReplaceReadGroups I=$path/${samp}/${samp}.bam O=$path/${samp}/${samp}2.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
    
done
##the part reorders the reads to match the reference file provided which is in the correct chromosomal order for GATK haplotype caller.  It converts it to karyotypic order because the reference file was reordered this way with the python script during the bulk download step.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard ReorderSam and creating an index for the new order for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar ReorderSam I=$path/${samp}/${samp}2.bam O=$path/${samp}/${samp}3.bam R=$path/ref2.fa CREATE_INDEX=TRUE
    
done
##This step is again specific to illumina data and creates a detailed text file about alignment quality and threshold filters.  This is used by GATK when variant calling.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard CollectAlignmentSummaryMetrics to create text file for downstream variant calling for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CollectAlignmentSummaryMetrics R=$path/ref2.fa I=$path/${samp}/${samp}3.bam O=$path/${samp}/${samp}_alignment_metrics.txt

done
##This step creates another text file used by GATK which validates the library construction insert distribution and more.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard CollectInsertSizeMetrics to creat both a text file and pdf file summarizing insert size for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar CollectInsertSizeMetrics INPUT=$path/${samp}/${samp}3.bam OUTPUT=$path/${samp}/${samp}_insert_metrics.txt HISTOGRAM_FILE=$path/${samp}/${samp}_insert_size_histogram.pdf

done
##Samtools is used to filter out short or cutoff reads in the bam file to insure accuracy in GATK variant calling and adding headers necessary for GATK.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running samtools to filter short or cutoff reads for more accurate variant calling for ${samp}"
    samtools view -b -f2 $path/${samp}/${samp}3.bam > $path/${samp}/${samp}4.bam 

done 
##creates a text file containing the computed depth at each position.  This is used by GATK to assure accurate varaint calling.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running samtools depth to create depth text for downstream variant calling for ${samp}"
    samtools depth $path/${samp}/${samp}4.bam > $path/${samp}/${samp}depth_out.txt 

done
## this elimantes PCR duplicate artifacts or other duplicate reads within the bam file.  The first options here are adjusting the resource allocated to java to perform the mark duplicates task which is one of the most memory intensive steps.  The step creates a marked bam file with a metrics text file listing any duplicate flags found.  This step is required by GATK.  
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "java picard MarkDuplicates to annotate PCR duplicates for more accurate variant calling in RNA editing experiments for ${samp}"
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=$path/tmp -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar MarkDuplicates INPUT=$path/${samp}/${samp}4.bam OUTPUT=$path/${samp}/${samp}dedup_reads.bam METRICS_FILE=$path/${samp}/${samp}metrics.txt TMP_DIR=$path/tmp

done
##this creates an index of your bam file for faster look up during GATK haplotype calling.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard to build Bam index for downstream variant calling for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/picard.jar BuildBamIndex INPUT=$path/${samp}/${samp}dedup_reads.bam
    
done
##this minimizes the number of artifical mismatches created by the the presence of indels in an individuals genome compared to the reference genome by locally realignment.  This is used here with haplocaller because we are trying to detect RNA editing which requires even more accuracy during alignment to show true editing events.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting realigners using java GATK with reference sequences previously downloads for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $path/ref2.fa --filter_reads_with_N_cigar -I $path/${samp}/${samp}dedup_reads.bam -o $path/${samp}/${samp}realignment_targets.list
    
done
##this is another step of the local realignment to reduce false positives.  Again this is being done with Haplotype caller to imporve accuracy during RAN editing events.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Re aligning indels with java GATK with same reference sequences as previous step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T IndelRealigner -R $path/ref2.fa --filter_reads_with_N_cigar -I $path/${samp}/${samp}dedup_reads.bam -targetIntervals $path/${samp}/${samp}realignment_targets.list -o $path/${samp}/${samp}realigned_reads.bam
    
done
##HaplotypeCaller is used because it is a more sensitive and accurate tool and is more suited to detect RNA editing in RNAseq data.  When encountering highly variable regions it re-maps the region denovo allowing for more accuracy then position based callers.  This also allows for proper handling of splice junctions which is critical for proper RNA editing detection.  Also annotating with a known snp database will reduce the number of false positives allows for those variants to be discarded later as genomic and not part of RNA editing.  For more information on how Haplotype caller works see https://software.broadinstitute.org/gatk/documentation/tooldocs/current/org_broadinstitute_gatk_tools_walkers_haplotypecaller_HaplotypeCaller.php . stand_call_conf is the minimum phred-scaled confidence threshold at which variants should be called with the default of 10 we set it a 20 a more strict threshold lower number of false positives.   
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting GATK HaplotypeCaller using reference sequences from the previous step and known snp sites with special options for RNA editing detection for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T HaplotypeCaller -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam --dbsnp $path/dbsnp.vcf -dontUseSoftClippedBases -stand_call_conf 20.0 -o $path/${samp}/${samp}raw_variants.vcf
    
done
##this next two step select for a type of variant the first snp and second indel.  Both these files are needed even if only snp are used for RNA editing for base recalibration step.  
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK Select Variants to create vcf file of raw snps for filtering for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants.vcf -selectType SNP -o $path/${samp}/${samp}raw_snps.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK Select Variants to create vcf file of raw indels for filtering for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants.vcf -selectType INDEL -o $path/${samp}/${samp}raw_indels.vcf
    
done
##These next two steps are filtering steps for the variants.  this is where thresholds are set for the FILTER field and are need to PASS these inorder to be listed in the output vcf file.  QualByDepth is QD and standard is < 2.0.  FisherStrand is FS greater then 60 which is a standard value.  This is a measure of strand bias and 60 is used because it doesn't sacrafice losing true positives while still maintaining a lower number of false positives.  MQ is RMSMappingQuality this is square root of mapping quality at any given site and 40 is standard recommendation to increase true positives. MQRankSum compares mapping qualities of reads supporting reference allele and alternate allele.  Positive values are those matching alternative allele.  MQRankSum is -12.5 as the recommended hard filter.  ReadPosRankSum this is rank sum test for site position within reads.  Which is found at ends of reads with same positive and neg as with MQRankSum -8.0 is recommended hard filter.  SOR is StrandOddsRatio this is another measure of strand bias that takes into account reads at ends of exons which tend to be only covered in one direction.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting first filtering step for raw snps using GATK for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_snps.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 4.0' --filterName "basic_snp_filter" -o $path/${samp}/${samp}filtered_snps.vcf
    
done
## this is the same as for the previous step but for indels instead of snp.  All of the parameters selected are the recommended hard filters for more details about these filterExpression options see https://software.broadinstitute.org/gatk/documentation/article?id=6925 
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting second filtering step for raw indels using GATK for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_indels.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || SOR > 10.0' --filterName "basic_indel_filter" -o $path/${samp}/${samp}filtered_indels.vcf
    
done
##BQSR is base quality score recalibration apply machine learning to model errors and adjust score accordingly to reduce systematic technical error during variant calling algorithms quality scoring.  Builds a model of covariation based on known data then adjusts based on that model.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK baseRecalibrator to incorporate snp and indels from first variant calling step into a table to use for second variant calling for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -knownSites $path/${samp}/${samp}filtered_snps.vcf -knownSites $path/${samp}/${samp}filtered_indels.vcf -o $path/${samp}/${samp}recal_data.table
    
done
##base recalibration is ran a second time taking into account the first run to determine more accurate results.  Then creates a table for use in downstream steps.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Rerunniing GATK basRecalibrator as in the previous step but with BQSR option for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -knownSites $path/${samp}/${samp}filtered_snps.vcf -knownSites $path/${samp}/${samp}filtered_indels.vcf -BQSR $path/${samp}/${samp}recal_data.table -o $path/${samp}/${samp}post_recal_data.table
    
done
##this creates a plot to visualize base recalibration results.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK AnalyzeCovariates to visulaize base recalibration results ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T AnalyzeCovariates -R $path/ref2.fa -before $path/${samp}/${samp}recal_data.table -after $path/${samp}/${samp}post_recal_data.table -plots $path/${samp}/${samp}recalibration_plots.pdf
    
done
##This is the last part of the base quality recalibration where the reads are printed in a new bam file where the new covariates table is used to score the base quality.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK printreads to collect the previous filtering and annotations into the new .bam file for the last variant calling step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T PrintReads -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -BQSR $path/${samp}/${samp}recal_data.table -o $path/${samp}/${samp}recal_reads.bam
    
done
##This is the second round of variant calling using same commands and options as before but this time taking into account the first round of variant calling and new base calibration covariation tables.  
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK HaplotypeCaller for a second time with previous discovered variants already annotated in the starting bam file for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T HaplotypeCaller -R $path/ref2.fa --dbsnp $path/dbsnp.vcf -dontUseSoftClippedBases -stand_call_conf 20.0 -I $path/${samp}/${samp}recal_reads.bam -o $path/${samp}/${samp}raw_variants_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Using GATK to select snps for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants_recal.vcf -selectType SNP -o $path/${samp}/${samp}raw_snps_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Using GATK to select indels for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants_recal.vcf -selectType INDEL -o $path/${samp}/${samp}raw_indels_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Filtering raw snp from the second variant calling step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_snps_recal.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 4.0' --filterName "basic_snp_filter" -o $path/${samp}/${samp}filtered_snps_final.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Filtering raw indels from the second variant calling step for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_indels_recal.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || SOR > 10.0' --filterName "basic_indel_filter" -o $path/${samp}/${samp}filtered_indels_recal.vcf
    
done
## This step runs snpEff to predict protein function and structure predictions 
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running snpEff to predict effects of RNA editing events found in the variant calling on the protein stucture and function for ${samp}"
    java -jar /home/user/Pipelines/HISAT2_pipeline/snpEff.jar -v GRCh37.75 $path/${samp}/${samp}filtered_snps_final.vcf > $path/${samp}/${samp}filtered_snps_final.ann.vcf
    mv $path/snpEff_* $path/${samp}
    
done
##this step creates a bedgraph file for visualization of the sequences using bedtools.
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running bedtools on the bam file generated with the first haplotype variant calling annotated to create a bedgraph file for ${samp}"
    bedtools genomecov -bga -ibam $path/${samp}/${samp}recal_reads.bam > $path/${samp}/${samp}genomecov.bedgraph
    
done
mkdir "$path/Results/RNAediting"
mv "$path/Results/*.genes.txt" "$path/Results/RNAediting/*.genes.txt"
cd "$path/Results/RNAediting"
Rscript /home/user/Pipelines/Rscripts/variantcalling.R
rm "$path/Results/RNAediting/final.csv"
fi
cd "$path"
ls
cd "$path/Results"
ls
cd "$path/Results/DESeq2_gene"
ls
cd"$path/Results/DESeq2_transcript"
ls
cd"$path/Results/topGO_gene"
ls
}
main_function 2>&1 | tee -a RNAseq.log