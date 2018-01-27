#!/usr/bin/env bash

export PATH=$PATH:/home/user/AIDD/AIDD_tools/bin

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
    java -jar /home/user/AIDD/AIDD_tools/picard.jar AddOrReplaceReadGroups I=$path/${samp}/${samp}.bam O=$path/${samp}/${samp}2.bam RGID=4 RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=20
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard ReorderSam and creating an index for the new order for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/picard.jar ReorderSam I=$path/${samp}/${samp}2.bam O=$path/${samp}/${samp}3.bam R=$path/ref2.fa CREATE_INDEX=TRUE
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard CollectAlignmentSummaryMetrics to create text file for downstream variant calling for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/picard.jar CollectAlignmentSummaryMetrics R=$path/ref2.fa I=$path/${samp}/${samp}3.bam O=$path/${samp}/${samp}_alignment_metrics.txt

done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard CollectInsertSizeMetrics to creat both a text file and pdf file summarizing insert size for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/picard.jar CollectInsertSizeMetrics INPUT=$path/${samp}/${samp}3.bam OUTPUT=$path/${samp}/${samp}_insert_metrics.txt HISTOGRAM_FILE=$path/${samp}/${samp}_insert_size_histogram.pdf

done
for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running samtools to filter short or cutoff reads for more accurate variant calling for ${samp}"
    samtools view -b -f2 $path/${samp}/${samp}3.bam > $path/${samp}/${samp}4.bam 

done 

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running samtools depth to create depth text for downstream variant calling for ${samp}"
    samtools depth $path/${samp}/${samp}4.bam > $path/${samp}/${samp}depth_out.txt 

done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "java picard MarkDuplicates to annotate PCR duplicates for more accurate variant calling in RNA editing experiments for ${samp}"
    java -d64 -Xmx20G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=$path/tmp -jar /home/user/AIDD/AIDD_tools/picard.jar MarkDuplicates INPUT=$path/${samp}/${samp}4.bam OUTPUT=$path/${samp}/${samp}dedup_reads.bam METRICS_FILE=$path/${samp}/${samp}metrics.txt TMP_DIR=$path/tmp

done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running java picard to build Bam index for downstream variant calling for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/picard.jar BuildBamIndex INPUT=$path/${samp}/${samp}dedup_reads.bam
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting realigners using java GATK with reference sequences previously downloads for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T RealignerTargetCreator -R $path/ref2.fa --filter_reads_with_N_cigar -I $path/${samp}/${samp}dedup_reads.bam -o $path/${samp}/${samp}realignment_targets.list
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Re aligning indels with java GATK with same reference sequences as previous step for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T IndelRealigner -R $path/ref2.fa --filter_reads_with_N_cigar -I $path/${samp}/${samp}dedup_reads.bam -targetIntervals $path/${samp}/${samp}realignment_targets.list -o $path/${samp}/${samp}realigned_reads.bam
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting GATK HaplotypeCaller using reference sequences from the previous step and known snp sites with special options for RNA editing detection for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T HaplotypeCaller -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam --dbsnp $path/dbsnp.vcf -dontUseSoftClippedBases -stand_call_conf 20.0 -o $path/${samp}/${samp}raw_variants.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK Select Variants to create vcf file of raw snps for filtering for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants.vcf -selectType SNP -o $path/${samp}/${samp}raw_snps.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK Select Variants to create vcf file of raw indels for filtering for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants.vcf -selectType INDEL -o $path/${samp}/${samp}raw_indels.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting first filtering step for raw snps using GATK for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_snps.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 4.0' --filterName "basic_snp_filter" -o $path/${samp}/${samp}filtered_snps.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Starting first filtering step for raw indels using GATK for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_indels.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || SOR > 10.0' --filterName "basic_indel_filter" -o $path/${samp}/${samp}filtered_indels.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK baseRecalibrator to incorporate snp and indels from first variant calling step into a table to use for second variant calling for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -knownSites $path/${samp}/${samp}filtered_snps.vcf -knownSites $path/${samp}/${samp}filtered_indels.vcf -o $path/${samp}/${samp}recal_data.table
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Rerunniing GATK basRecalibrator as in the previous step but with BQSR option for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T BaseRecalibrator -R $path/ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -knownSites $path/${samp}/${samp}filtered_snps.vcf -knownSites $path/${samp}/${samp}filtered_indels.vcf -BQSR $path/${samp}/${samp}recal_data.table -o $path/${samp}/${samp}post_recal_data.table
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK AnalyzeCovariates to filter for less false positives for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T AnalyzeCovariates -R ref2.fa -before $path/${samp}/${samp}recal_data.table -after $path/${samp}/${samp}post_recal_data.table -plots $path/${samp}/${samp}recalibration_plots.pdf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK printreads to collect the previous filtering and annotations into the new .bam file for the last variant calling step for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T PrintReads -R ref2.fa -I $path/${samp}/${samp}realigned_reads.bam -BQSR $path/${samp}/${samp}recal_data.table -o $path/${samp}/${samp}recal_reads.bam
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running GATK HaplotypeCaller for a second time with previous discovered variants already annotated in the starting bam file for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T HaplotypeCaller -R $path/ref2.fa --dbsnp $path/dbsnp.vcf -dontUseSoftClippedBases -stand_call_conf 20.0 -I $path/${samp}/${samp}recal_reads.bam -o $path/${samp}/${samp}raw_variants_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Using GATK to select snps for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants_recal.vcf -selectType SNP -o $path/${samp}/${samp}raw_snps_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Using GATK to select indels for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T SelectVariants -R $path/ref2.fa -V $path/${samp}/${samp}raw_variants_recal.vcf -selectType INDEL -o $path/${samp}/${samp}raw_indels_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Filtering raw snp from the second variant calling step for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_snps_recal.vcf --filterExpression 'QD < 2.0 || FS > 60.0 || MQ < 40.0 || MQRankSum < -12.5 || ReadPosRankSum < -8.0 || SOR > 4.0' --filterName "basic_snp_filter" -o $path/${samp}/${samp}filtered_snps_final.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Filtering raw indels from the second variant calling step for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/GenomeAnalysisTK.jar -T VariantFiltration -R $path/ref2.fa -V $path/${samp}/${samp}raw_indels_recal.vcf --filterExpression 'QD < 2.0 || FS > 200.0 || ReadPosRankSum < -20.0 || SOR > 10.0' --filterName "basic_indel_filter" -o $path/${samp}/${samp}filtered_indels_recal.vcf
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running snpEff to predict effects of RNA editing events found in the variant calling on the protein stucture and function for ${samp}"
    java -jar /home/user/AIDD/AIDD_tools/snpEff.jar -v GRCh37.75 $path/${samp}/${samp}filtered_snps_final.vcf > $path/${samp}/${samp}filtered_snps_final.ann.vcf
    mv $path/snpEff_* $path/${samp}
    
done

for fn in $varname{1..18};
do

    samp=`basename ${fn}`
    echo "Running bedtools on the bam file generated with the first haplotype variant calling annotated to create a bedgraph file for ${samp}"
    bedtools genomecov -bga -ibam $path/${samp}/${samp}recal_reads.bam > $path/${samp}/${samp}genomecov.bedgraph
    
done

