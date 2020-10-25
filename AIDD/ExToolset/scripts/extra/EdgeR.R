#!/usr/bin/env Rscript
suppressPackageStartupMessages(library("DESeq2"))
suppressPackageStartupMessages(library("vsn"))
suppressPackageStartupMessages(library("dplyr"))
suppressPackageStartupMessages(library("ggplot2"))
suppressPackageStartupMessages(library("pheatmap"))
suppressPackageStartupMessages(library("RColorBrewer"))
suppressPackageStartupMessages(library("PoiClaClu"))
suppressPackageStartupMessages(library("ggbeeswarm"))
suppressPackageStartupMessages(library("genefilter"))
suppressPackageStartupMessages(library("sva"))
suppressPackageStartupMessages(library("ggrepel"))
suppressPackageStartupMessages(library("plotly"))
suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("data.table"))
args = commandArgs(trailingOnly=TRUE)
file_in <- paste0(args[1]) #gene or transcript_count_matrix.csv
pheno <- paste0(args[2]) #PHENO_DATA.csv
cond <- paste0(args[3]) #cond used in DESeq2
