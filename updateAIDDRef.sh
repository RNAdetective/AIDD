downloaded_ref() {
wget "$ftpsite" -O "$ref_name".gz
gunzip "$ref_name".gz
if [ -s "$ref_dir_path"/"$ref_name" ] ;
then
  rm "$ref_name".gz
fi
}
split_file() {
if [ -s "$file_out" ];
then
  csplit -s -z "$file_out" /\>.*/ {*} #splits file into working directory
fi
}
createdir() {
if [ ! -d "$dirtomake" ];
then
  mkdir "$dirtomake"
fi
}
organize_ref() {
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' >> ref2.fa
java -jar -Djava.io.tmpdir=/media/sf_AIDD/tmp /home/user/AIDD/AIDD_tools/picard.jar CreateSequenceDictionary REFERENCE="$ref_dir_path"/ref2.fa OUTPUT="$ref_dir_path"/ref2.dict
samtools faidx "$ref_dir_path"/ref2.fa
}
ref_dir_path=/media/sf_AIDD/references
if [ -d "$ref_dir_path" ];
then
  rm -r "$ref_dir_path"
  dirtomake="$ref_dir_path"
  createdir
else
  dirtomake="$ref_dir_path"
  createdir
fi
cd "$ref_dir_path"
for files in ref1.fa ref2.fa ref2.dict ref2.fa.fai dbsnp.vcf dbsnp.vcf.idx ;
do
  refile=/home/user/AIDD/references/"$files"
  if [ -f "$refile" ];
  then
    rm "$refile"
  fi
done
ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz # ref1.fa
ref_name="$ref_dir_path"/ref1.fa
downloaded_ref
dirtomake="$ref_dir_path"/ref1
createdir
cd "$dirtomake"
file_out="$ref_dir_path"/ref1.fa
split_file
cd "$ref_dir_path"
cat "$ref_dir_path"/ref1/* >> "$ref_dir_path"/ref2.fa
ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
ref_name=dbsnp.vcf
downloaded_ref
for files in ref1.fa ref2.fa ref2.dict ref2.fa.fai dbsnp.vcf dbsnp.vcf.idx ;
do
  if [ -f "$ref_dir_path"/"$files" ];
  then
    mv "$ref_dir_path"/"$files" /home/user/AIDD/references
  fi
done
#rm -r "$ref_dir_path"
#cd /home/user/AIDD/references

