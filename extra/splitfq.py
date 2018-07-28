import sys
from Bio import SeqIO
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import generic_dna
from Bio.SeqRecord import SeqRecord

def main(fastq):

    Rd1_out_name = fastq.replace(".fastq", "_1.fastq")
    Rd2_out_name = fastq.replace(".fastq", "_2.fastq")
    Rd1_out = open(Rd1_out_name, 'w')
    Rd2_out = open(Rd2_out_name, 'w')

    for record in SeqIO.parse(fastq, "fastq"):

        seq = str(record.seq)
        Rd1_seq = seq[:len(seq)/2]
        Rd2_seq = seq[len(seq)/2:]                                  
        Q = record.letter_annotations["phred_quality"]
        Rd1_Q = Q[:len(Q)/2]
        Rd2_Q = Q[len(Q)/2:]            
        Rd1_id = record.id.strip("/1").strip("/2") + "/1"
        Rd2_id = record.id.strip("/1").strip("/2") + "/2"

        Rd1 = SeqRecord( Rd1_seq , id = Rd1_id, description = "" )
        Rd1.letter_annotations["phred_quality"] = Rd1_Q         
        Rd2 = SeqRecord( Rd2_seq , id = Rd2_id, description = "" )
        Rd2.letter_annotations["phred_quality"] = Rd2_Q

        Rd1_out.write(Rd1.format("fastq"),)
        Rd2_out.write(Rd2.format("fastq"),)


if __name__ == '__main__':
    main(sys.argv[1])
