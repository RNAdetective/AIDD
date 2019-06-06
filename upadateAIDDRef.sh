downloaded_ref() {
wget "$ftpsite" -O "$ref_name".gz
gunzip "$ref_name".gz
if [ -s "$ref_dir_path"/"$ref_name" ] ;
then
  rm "$ref_name".gz
else
  echo "_________________________________________________________
Can't find "$ref_name" file"
fi
}
organize_ref() {
perl -e 'use File::Temp qw/tempdir/; use IO::File; $d=tempdir; $fh; map{if(m/^\>(\S+)\s/){$fh=IO::File->new(">$d/$1.fa");} print $fh $_;}`cat ref1.fa`; foreach $c(1..22,X,Y,MT){print `cat $d/$c.fa`}; print `cat $d/GL*`' > ref2.fa
java -jar "$home_dir"/AIDD/AIDD_tools/picard.jar CreateSequenceDictionary REFERENCE="$ref_dir_path"/ref2.fa OUTPUT="$ref_dir_path"/ref2.dict
samtools faidx "$ref_dir_path"/ref2.fa
}
cd /home/user/AIDD/references
for files in ref1.fa ref2.fa ref2.dict ref2.fa.fai dbsnp.vcf dbsnp.vcf.idx ;
do
  rm "$files"
done
ftpsite=ftp://ftp.ensembl.org/pub/release-75/fasta/homo_sapiens/dna/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa.gz # ref1.fa
ref_name=ref1.fa
downloaded_ref
ftpsite=ftp://gsapubftp-anonymous@ftp.broadinstitute.org/bundle/b37/dbsnp_138.b37.vcf.gz
ref_name=dbsnp.vcf
downloaded_ref
organize_ref
