excitome_vcf() { 
## filter out everything that is not ADAR mediated editing
awk -F "\t" '/^#/' "$rdvcf"/"$run"filtered_snps_finalAll.vcf > "$rdvcf"/"$run"filtered_snps_finalinfo.vcf #
awk -F "\t" ' { if ($3 == ".") { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalAllNoSnpsediting.vcf
awk -F "\t" ' { if (($4 == "A") && ($5 == "G") && ($3 == ".")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalAG.vcf
awk -F "\t" '{ if (($4 == "T") && ($5 == "C") && ($3 == ".")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalTC.vcf
cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalAG.vcf "$rdvcf"/"$run"filtered_snps_finalTC.vcf > "$rdvcf"/"$run"filtered_snps_finalADARediting.vcf
awk -F "\t" ' { if (($4 == "C") && ($5 == "T") && ($3 == ".")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalCT.vcf
awk -F "\t" '{ if (($4 == "G") && ($5 == "A") && ($3 == ".")) { print } }' "$rdvcf"/"$file_vcf_finalAll" > "$rdvcf"/"$run"filtered_snps_finalGA.vcf
cat "$rdvcf"/"$run"filtered_snps_finalinfo.vcf "$rdvcf"/"$run"filtered_snps_finalCT.vcf "$rdvcf"/"$run"filtered_snps_finalGA.vcf > "$rdvcf"/"$run"filtered_snps_finalAPOBECediting.vcf
}
snpEff() {
AIDDtool=/home/user/AIDD/AIDD_tools
javaset="-Xmx30G -XX:-UseGCOverheadLimit -XX:ParallelGCThreads=2 -XX:ReservedCodeCacheSize=1024M -Djava.io.tmpdir=/media/sf_AIDD/MDD/tmp"
for snptype in ADARediting APOBECediting AllNoSnpsediting ;
do
  java -jar $AIDDtool/snpEff.jar -v GRCh37.75 "$rdvcf"/"$run"filtered_snps_final"$snptype".vcf -stats "$dir_path"/raw_data/snpEff/snpEff"$run""$snptype" -csvStats "$dir_path"/raw_data/snpEff/snpEff"$run""$snptype".csv > "$dir_path"/raw_data/snpEff/"$run"filtered_snps_finalAnn"$snptype".vcf     ##converts final annotationed vcf to table for easier processing
done
}
varfilter() {
Rscript "$ExToolset"/varfiltering.R "$file_in" "$file_out" "$image_out1" "$image_out2" "$image_out3" "$image_out4" "$image_out5" "$image_out6" "$image_out7" "$image_out8"
}
dir_path=/media/sf_AIDD/batch14
VarQC="$dir_path"/quality_control/variant_filtering
ExToolset=/home/user/AIDD/AIDD/ExToolset/scripts
INPUT="$dir_path"/PHENO_DATA.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
read
while IFS=, read -r samp_name run condition sample condition2 condition3
do
dir_path=/media/sf_AIDD/batch14
  for name in filtered_snps_finalAll raw_snps filtered_snps raw_snps_recal ;
  do
    file_vcf_finalAll="$run""$name".vcf
    echo "Running analysis for "$run" and "$name""
    if [[ "$name" == "raw_snps" || "$name" == "raw_snps_recal" ]];
    then
      rdvcf="$dir_path"/raw_data/vcf_files/raw
    fi
    if [ "$name" == "filtered_snps" ];
    then
      rdvcf="$dir_path"/raw_data/vcf_files/filtered
    fi
    if [ "$name" == "filtered_snps_finalAll" ];
    then
      rdvcf="$dir_path"/raw_data/vcf_files/final
      excitome_vcf
      snpEff
    fi
    ACcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "C")) { print } }' | wc -l)
    ATcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "T")) { print } }' | wc -l)
    AGcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "G")) { print } }' | wc -l)
    CAcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "A")) { print } }' | wc -l)
    CGcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "G")) { print } }' | wc -l)
    CTcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "T")) { print } }' | wc -l)
    GAcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "A")) { print } }' | wc -l)
    GCcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "C")) { print } }' | wc -l)
    GTcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "T")) { print } }' | wc -l)
    TAcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "A")) { print } }' | wc -l)
    TGcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "G")) { print } }' | wc -l)
    TCcount=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "C")) { print } }' | wc -l)
    ACcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "C") && ($3 == ".")) { print } }' | wc -l)
    ATcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "T") && ($3 == ".")) { print } }' | wc -l)
    AGcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "A") && ($5 == "G") && ($3 == ".")) { print } }' | wc -l)
    CAcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "A") && ($3 == ".")) { print } }' | wc -l)
    CGcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "G") && ($3 == ".")) { print } }' | wc -l)
    CTcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "C") && ($5 == "T") && ($3 == ".")) { print } }' | wc -l)
    GAcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "A") && ($3 == ".")) { print } }' | wc -l)
    GCcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "C") && ($3 == ".")) { print } }' | wc -l)
    GTcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "G") && ($5 == "T") && ($3 == ".")) { print } }' | wc -l)
    TAcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "A") && ($3 == ".")) { print } }' | wc -l)
    TGcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "G") && ($3 == ".")) { print } }' | wc -l)
    TCcountsnps=$(cat "$rdvcf"/"$file_vcf_finalAll" | awk -F "\t" ' { if (($4 == "T") && ($5 == "C") && ($3 == ".")) { print } }' | wc -l)
    final_file="$dir_path"/quality_control/variant_filtering/VariantFilteringVisual.csv
    if [ ! -s "$final_file" ];
    then
      echo "samp_name,condition,sex,name,type,ACcount,AGcount,ATcount,CAcount,CGcount,CTcount,GAcount,GCcount,GTcount,TAcount,TCcount,TGcount" >> "$final_file"
    fi
    echo ""$samp_name","$condition","$condition2","$name",total,"$ACcount","$AGcount","$ATcount","$CAcount","$CGcount","$CTcount","$GAcount","$GCcount","$GTcount","$TAcount","$TCcount","$TGcount"" >> "$final_file"
    echo ""$samp_name","$condition","$condition2","$name",nonsnps,"$ACcountsnps","$AGcountsnps","$ATcountsnps","$CAcountsnps","$CGcountsnps","$CTcountsnps","$GAcountsnps","$GCcountsnps","$GTcountsnps","$TAcountsnps","$TCcountsnps","$TGcountsnps"" >> "$final_file"
    ACsnp=$(expr "$ACcount" - "$ACcountsnps")
    ATsnp=$(expr "$ATcount" - "$ATcountsnps")
    AGsnp=$(expr "$AGcount" - "$AGcountsnps")
    CAsnp=$(expr "$CAcount" - "$CAcountsnps")
    CGsnp=$(expr "$CGcount" - "$CGcountsnps")
    CTsnp=$(expr "$CTcount" - "$CTcountsnps")
    GAsnp=$(expr "$GAcount" - "$GAcountsnps")
    GCsnp=$(expr "$GCcount" - "$GCcountsnps")
    GTsnp=$(expr "$GTcount" - "$GTcountsnps")
    TAsnp=$(expr "$TAcount" - "$TAcountsnps")
    TGsnp=$(expr "$TGcount" - "$TGcountsnps")
    TCsnp=$(expr "$TCcount" - "$TCcountsnps")
    echo ""$samp_name","$condition","$condition2","$name",withsnps,"$ACsnp","$AGsnp","$ATsnp","$CAsnp","$CGsnp","$CTsnp","$GAsnp","$GCsnp","$GTsnp","$TAsnp","$TCsnp","$TGsnp"" >> "$final_file"
    ACsnps=$(echo "scale=4 ; "$ACcountsnps"/"$ACcount"" | bc)
    ATsnps=$(echo "scale=4 ; "$ATcountsnps"/"$ATcount"" | bc)
    AGsnps=$(echo "scale=4 ; "$AGcountsnps"/"$AGcount"" | bc)
    CAsnps=$(echo "scale=4 ; "$CAcountsnps"/"$CAcount"" | bc)
    CGsnps=$(echo "scale=4 ; "$CGcountsnps"/"$CGcount"" | bc)
    CTsnps=$(echo "scale=4 ; "$CTcountsnps"/"$CTcount"" | bc)
    GAsnps=$(echo "scale=4 ; "$GAcountsnps"/"$GAcount"" | bc)
    GCsnps=$(echo "scale=4 ; "$GCcountsnps"/"$GCcount"" | bc)
    GTsnps=$(echo "scale=4 ; "$GTcountsnps"/"$GTcount"" | bc)
    TAsnps=$(echo "scale=4 ; "$TAcountsnps"/"$TAcount"" | bc)
    TGsnps=$(echo "scale=4 ; "$TGcountsnps"/"$TGcount"" | bc)
    TCsnps=$(echo "scale=4 ; "$TCcountsnps"/"$TCcount"" | bc)
    echo ""$samp_name","$condition","$condition2","$name",percent,"$ACsnps","$AGsnps","$ATsnps","$CAsnps","$CGsnps","$CTsnps","$GAsnps","$GCsnps","$GTsnps","$TAsnps","$TCsnps","$TGsnps"" >> "$final_file"
  done
done
} < $INPUT
IFS=$OLDIFS
file_in="$VarQC"/VariantFilteringVisual.csv
file_out="$VarQC"/VariantFilteringVisualSummary.csv
image_out1="$VarQC"/VariantFilteringVisualfiltered_snps_finalAllTotal.tiff
image_out2="$VarQC"/VariantFilteringVisualfiltered_snps_finalAllNoSnps.tiff
image_out3="$VarQC"/VariantFilteringVisualNoSnps.tiff
image_out4="$VarQC"/VariantFilteringVisualTotal.tiff
image_out5="$VarQC"/VariantFilteringVisualfiltered_snps_finalTotalNoSnps.tiff
image_out6="$VarQC"/VariantFilteringVisualraw_snpsTotalNoSnps.tiff
image_out7="$VarQC"/VariantFilteringVisualAll.tiff
image_out8="$VarQC"/VariantFilteringVisualAll2.tiff
varfilter
