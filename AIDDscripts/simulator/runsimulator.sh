export PATH=$PATH:~/AIDD/AIDD_tools/flux-simulator-1.2.1/bin
dir_create() {
for i in par_files PHENO_DATA sim_out tmp correlations ; 
do
  mkdir "$dir_path"/"$i"/
  if [ "$i" == AIDD ];
  then
    mkdir "$dir_path"/AIDD/counts
  fi
done
}
create_par() {
cat "$sim_scripts"/par_file.par | sed 's/read_num/'$num'000000/g' | sed 's/read_len/'$len'/g' >> "$par_dir"/"$name".par
}
get_gtf() {
dir_ref=/home/user/sim/genome_references/chromeFa
if [ ! "$dir_ref"/GRCh37.gtf ] ;
then
grep ^[0-9XYM] "$ref_path"/ref.gtf > "$dir_ref"/GRCh37.gtf
fi
}
get_chromfa() {
dir_ref=/home/user/sim/genome_references/chromFa
if [ ! -d "$dir_ref" ];
then
  mkdir "$dir_ref"
  cd "$dir_ref"
  for i in {1..22} MT X Y ;
  do
    if [ ! -s "$dir_ref"/"$i".fa ];
    then
      wget ftp://ftp.ensembl.org/pub/release-84/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.chromosome."$i".fa.gz -O "$i"raw.fa.gz
      gunzip "$i"raw.fa.gz
      cat "$dir_ref"/"$i"raw.fa | sed '1d' | sed '1i >'$i'' > "$dir_ref"/"$i".fa
      rm "$dir_ref"/"$i"raw.fa
    fi 
  done
fi
}
sim_tool() {
export FLUX_MEM="30G"; flux-simulator -p "$par_dir"/"$name".par
}
Simcounts() {
cat "$wkd"/"$name".pro | awk '{ print $2, $8 }' | column -t | sed 's/\t/,/g' | sed '1d' | sed '1i refseq,abcounts' >> "$wkd"/"$name"sim.csv
cp "$wkd"/"$name"sim.csv "$dir_path"/correlations/"$name"sim.csv
}
PHENO() {
mkdir "$dir_path"/PHENO_DATA/
echo ""$name","$name",none,"$sample"" >> "$dir_path"/PHENO_DATA/PHENO_DATA"$name".csv
}
createPHENO() {
cat "$dir_path"/PHENO_DATA/*.csv | sed '1i samp_name,Run,condition,sample' >> "$dir_path"/PHENO_DATA.csv
}
splitfq() {
perl "$sim_scripts"/splitfq.pl "$wkd"/"$name".fastq
mv "$wkd"/"$name".fastq_1 "$wkd"/"$name"_1.fastq
mv "$wkd"/"$name".fastq_2 "$wkd"/"$name"_2.fastq
}
fastqcpaired() { 
wkd="$dir_path"/sim_out/"$name"
fastqc "$wkd"/"$name"_1.fastq "$wkd"/"$name"_2.fastq --outdir="$wkd"
 }
HISAT2_paired() { 
hisat2 -q -x "$ref_path"/genome -p3 --dta-cufflinks -1 "$wkd"/"$name"_1.fastq -2 "$wkd"/"$name"_2.fastq -t --summary-file "$wkd"/"$name".txt -S "$wkd"/"$name".sam 
}
samtobam() { 
java -Djava.io.tmpdir="$dir_path"/tmp -jar "$tools"/picard.jar SortSam INPUT="$wkd"/"$name".sam OUTPUT="$wkd"/"$name".bam SORT_ORDER=coordinate
}
assem_string() { 
stringtie "$wkd"/"$name".bam -p3 -G "$ref_path"/ref.gtf -A "$wkd"/"$name".tab -l -B -b "$wkd"/"$name" -e -o "$wkd"/"$name".gtf 
}
count_AIDD() {
cat "$wkd"/"$name".tab | sed 's/\t/,/g' | awk -F "," '{ print $1, $7 }' | sed '1d' | sed '1i gene_id,coverage' >> "$wkd"/"$name"AIDD.csv
cp "$wkd"/"$name"AIDD.csv "$dir_path"/correlations/"$name"AIDD.csv
}
compress() {
tar -cvzf "$dir_path"/"$name".tar.gz "$wkd"
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
sim_scripts="$dir_path"/simulator
###########################################################################################
# RUN FLUX SIMULATOR
###########################################################################################
dir_create # creates directory
INPUT="$sim_scripts"/experiments.csv
OLDIFS=$IFS
{
[ ! -f $INPUT ] && { echo "$INPUT file not found #16"; exit 99; }
while IFS=, read -r num len
do
  dir_path=/home/user/sim
  ref_path=/home/user/AIDD/references
  home_dir=/home/user
  name="$num"M"$len"length
  wkd="$dir_path"/sim_out/"$name"
  tools=/home/user/AIDD/AIDD_tools
  sim_scripts="$dir_path"/simulator
  par_dir="$dir_path"/par_files
  scripts_dir="$home_dir"/AIDD/AIDD/scripts
  if [ ! -s "$par_dir"/"$name".par ]; # IF NO PAR FILE ARE THERE
  then
    create_par # CREATE PAR FILES
  fi
  if [ -s "$par_dir"/"$name".par ]; # IF PAR FILE ARE THERE
  then
    if [ ! -s "$wkd"/"$name".fastq ];
    then
      get_gtf
      get_chromfa
      sim_tool
      PHENO
    else
      echo ""$name" already done"
    fi
    if [[ -s "$wkd"/"$name".pro && -s "$wkd"/"$name".lib ]]
    then
      Simcounts
      splitfq 
      source "$scripts_dir"/setjavaversion.sh 11
      tool=fastqcpaired
      file_in="$wkd"/"$name"_1.fastq
      file_out="$wkd"/"$name"_1_fastq.html
      run_tool
      source "$scripts_dir"/setjavaversion.sh 8
      tool=HISAT2_paired
      file_in="$wkd"/"$name"_1.fastq
      file_out="wkd"/"$name".sam
      run_tools
      tool=samtobam
      file_in="$wkd"/"$name".sam
      file_out="$wkd"/"$name".bam
      run_tools
      tools=assem_string
      file_in="$wkd"/"$name".bam
      file_out="$wkd"/"$name".tab
      run_tools
      tool=count_AIDD
      file_in="$wkd"/"$name".tab
      file_out="$wkd"/"$name"AIDD.csv
      run_tools
      tool=compress
      file_in="$wkd"/"$name"AIDD.csv
      file_out="$dir_path"/"$name".tar.gz
      run_tools
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

