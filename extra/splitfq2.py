fastq_1 = open('fastq_r1.fastq')

fastq_2 = open('fastq_r2.fastq')

[r1.write(line) if (i % 8 < 4) else r2.write(line) for i, line in enumerate(open('test.fastq'))]

fastq_1.close()

fastq_2.close()
