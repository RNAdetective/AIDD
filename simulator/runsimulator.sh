export PATH=$PATH:~/AIDD/AIDD_tools/flux-simulator-1.2.1/bin
create_par() {
cat "$dir_path"/simulator/par_file.par | sed 's/read_num/'$num'000000/g' | sed 's/read_len/'$len'/g' >> "$dir_path"/par_files/"$num"M"$len"length.par
}
sim_tool() {
flux-simulator -p "$dir_path"/par_files/"$name".par
}
PHENO() {
mkdir "$dir_path"/PHENO_DATA/
echo ""$num"M"$len"length,"$num"M"$len"length,none,"$sample"" >> "$dir_path"/PHENO_DATA/PHENO_DATA"$num"M"$len"length.csv
}
createPHENO() {
cat "$dir_path"/PHENO_DATA/*.csv | sed '1i samp_name,Run,condition,sample' >> "$dir_path"/PHENO_DATA.csv
}
splitfq() {
python ~/AIDD/extra/simulator/splitfq.py "$dir_path"/sim_out/"$name"/"$name".fastq
}
compress() {
tar -cvzf "$dir_path"/"$name".fastq
}
Simcounts() {
cat "$dir_path"/sim_out/"$num"M"$len"length.pro | awk '{ print $2, $8 }' | column -t | sed 's/\t/,/g' | sed '1d' | sed '1i refseq,abcounts' >> /media/sf_sim/profiles/"$num"M"$len"length.csv
}
dir_create() {
for i in par_files PHENO_DATA sim_out tmp AIDD correlations ; 
do
  mkdir "$dir_path"/"$i"/
  if [ "$i" == AIDD ];
  then
    mkdir "$dir_path"/AIDD/counts
  fi
done
}
assembly_dir_create() {
INPUT="$dir_path"/PHENO_DATA.csv
{
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
read
while IFS=, read -r samp_name run codition sample condition2 condition3
do
    dir_path=/media/sf_AIDD
    ball="$ball"
    mkdir "$dir_path"/AIDD/"$ball"/"$sample"/

done
rm -rf "$dir_path"/raw_data/$ball/sample/
} < $INPUT
IFS=$OLDIFS
}
run_tool() {
if [ ! -s "$file_out" ];
then
  if [ -s "$file_in" ];
  then
    "$tool"
  else
    echo "Can't find "$file_in""
  fi
else
  echo ""$file_out" found moving on"
fi
} 
fastqcpaired() { fastqc "$dir_path"/AIDD/"$run"_1.fastq "$dir_path"/AIDD"$run"_2.fastq --outdir=$dirqc/fastqc ; }
HISAT2_paired() {  hisat2 -q -x "$dir_path"/references/genome -p3 --dta-cufflinks -1 "$dir_path"/AIDD/"$run"_1.fastq -2 "$dir_path"/AIDD/"$run"_2.fastq -t --summary-file "$dir_path"/AIDD/"$run".txt -S "$dir_path"/AIDD/"$run".sam ; }
samtobam() { java -Djava.io.tmpdir="$dir_path"/tmp -jar ~/AIDD/AIDD_tools/picard.jar SortSam INPUT="$dir_path"/AIDD/"$run".sam OUTPUT="$dir_path"/AIDD/"$run".bam SORT_ORDER=coordinate ; }
assem_string() { stringtie "$dir_path"/AIDD/"$run".bam -p3 -G "$dir_path"/references/ref.gtf -A "$dir_path"/AIDD/counts/"$run".tab -l -B -b "$dir_path"/AIDD/ballgown_in/"$sample"/"$run" -e -o "$dir_path"/AIDD/ballgown/"$sample"/"$sample".gtf ; }
count_AIDD() {
cat $dir_path/AIDD/counts/"$run".tab | sed 's/\t/,/g' | awk -F "," '{ print $1, $7 }' | sed '1d' | sed '1i gene_id,coverage' >> $dir_path/correlations/"$run"AIDD.csv
}
dir_path=/media/sf_AIDD
###########################################################################################
# RUN FLUX SIMULATOR
###########################################################################################
dir_create

INPUT="$dir_path"/simulator/experiments.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
while IFS=, read -r num len
do
  dir_path=/media/sf_AIDD
  name="$num"M"$len"length
  if [ ! -s "$dir_path"/par_files/"$name".par ]; # IF NO PAR FILE ARE THERE
  then
    create_par # CREATE PAR FILES
  fi
  if [ -s "$dir_path"/par_files/"$name".par ]; # IF PAR FILE ARE THERE
  then
    if [ -s "$dir_path"/sim_out/"$name".fastq ];
    then
      sim_tool
      PHENO
    else
      echo ""$name" already done"
    fi
    if [[ -s "$dir_path"/par_files/"$name".pro && -s "$dir_path"/par_files/"$name".lib ]]
    then
      mkdir "$dir_path"/sim_out/"$name"/
      mv "$dir_path"/par_files/"$name"* "$dir_path"/sim_out/"$name"/
      splitfq
      Simcounts
    else
      echo "Can't find pro file for "$name""
    fi
  else
    echo "Can't find par file for "$name""
  fi
done
} < $INPUT
IFS=$OLDIFS
###########################################################################################
# RUN AIDD
###########################################################################################
createPHENO
####################################################################################################################
#R
#library(ggplot2)
#table1 <- read.csv(""$dir_path"/300M150length_2.csv")
#table2 <- read.csv(""$dir_path"/refseq.csv")
#table3 <- merge(table1, table2, by="refseq")
#write.csv(table3, ""$dir_path"/300M150lengthsimulated.csv", row.names=FALSE)
#table1 <- read.csv(""$dir_path"/300M150lengthsimulated.csv")
#table2 <- read.csv(""$dir_path"/300M150lengthAIDD.csv")
#table3 <- merge(table1, table2, by="gene_id")
#write.csv(table3, ""$dir_path"/300M150lengthscatter.csv", row.names=FALSE)
#jpeg(""$dir_path"/300M150length.jpeg")
#ggplot(table3, aes(x=TPM, y=counts)) + geom_point() + geom_smooth(method=lm) + labs(title="300M150length", x="AIDD", y = "counts") + theme_classic()
#dev.off()
#cor.test( ~ TPM + counts, data=table3, method = "pearson", continuity = FALSE, conf.level = 0.95)

##run at transcript level download all parameters_2.csv and tab files from alignment.
#library(ggplot2)
#table1 <- read.csv(""$dir_path"/300M150length_2.csv")
#table2 <- read.csv(""$dir_path"/refseq.csv")
#table3 <- merge(table1, table2, by="refseqtrans")
#write.csv(table3, ""$dir_path"/300M150lengthsimulatedtrans.csv", row.names=FALSE)
#table1 <- read.csv(""$dir_path"/300M150lengthsimulatedtrans.csv")
#table2 <- read.csv(""$dir_path"/300M150lengthAIDDtrans.csv")
#table3 <- merge(table1, table2, by="transcript_id")
#write.csv(table3, ""$dir_path"/300M150lengthscattertrans.csv", row.names=FALSE)
#jpeg(""$dir_path"/300M150lengthtrans.jpeg")
#ggplot(table3, aes(x=TPM, y=counts, shape=condition, color=cell)) + geom_point() + geom_smooth(method=lm) + labs(title="300M150length", x="AIDD", y = "counts") + theme_classic()
#dev.off()
#cor.test( ~ TPM + counts, data=table3, method = "pearson", continuity = FALSE, conf.level = 0.95)

