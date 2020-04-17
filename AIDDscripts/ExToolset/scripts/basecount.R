#!/usr/bin/env Rscript
suppressPackageStartupMessages(library("GenomicAlignments"))
args = commandArgs(trailingOnly=TRUE)
bamfile1 <- paste0(args[1]) #"/media/sf_AIDD/ERR1473002.bam"
tempfile <- paste0(args[2]) #"/media/sf_AIDD/ERR1473002.csv"
edit1 <- alphabetFrequencyFromBam(bamfile1, param=(GRanges("chrome", IRanges(coord, coord))), baseOnly=TRUE)
write.csv(edit1, tempfile, row.names=FALSE, quote=FALSE)
