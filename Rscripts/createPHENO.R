##need to set 7set_col_del_con_1018-3 and 7set_col_del_con_1018-3P(for pheno_data file)
##this will split level_count_matrix by 3 cell_linename1names with however many replicates you have
countData <- read.csv("/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixedited.csv", row.names=1)
countDataF6 <- countData[ , c(set_col_del_con1)]
write.csv(countDataF6, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename1_cell_linename2.csv")
countDataM6 <- countData[ , c(set_col_del_con2)]
write.csv(countDataM6, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename1_cell_linename3.csv")
countDataL6 <- countData[ , c(set_col_del_con3)]
write.csv(countDataL6, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename1_cell_linename4.csv")
countDataA <- countData[ , c(set_col_del_con4)]
write.csv(countDataA, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename1_cell_linename5.csv")
countDataB <- countData[ , c(set_col_del_con5)]
write.csv(countDataB, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename2_cell_linename3.csv")
countDataC <- countData[ , c(set_col_del_con6)]
write.csv(countDataC, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename2_cell_linename4.csv")
countDataD <- countData[ , c(set_col_del_con7)]
write.csv(countDataD, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename2_cell_linename5.csv")
countDataE <- countData[ , c(set_col_del_con8)]
write.csv(countDataE, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename3_cell_linename4.csv")
countDataF <- countData[ , c(set_col_del_con9)]
write.csv(countDataF, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename3_cell_linename5.csv")
countDataG <- countData[ , c(set_col_del_con_10)]
write.csv(countDataG, "/media/sf_AIDD/Results/DESeq2/level/counts/level_count_matrixeditedcell_linename4_cell_linename5.csv")
##this does the same for the pheno_data file.
colData <- read.csv("/media/sf_AIDD/PHENO_DATA.csv")
colDataF6 <- colData[c(set_col_del_con1), ]
write.csv(colDataF6, "/media/sf_AIDD/PHENO_DATAcell_linename1_cell_linename2.csv", row.names=FALSE)
colDataM6 <- colData[c(set_col_del_con2), ]
write.csv(colDataM6, "/media/sf_AIDD/PHENO_DATAcell_linename1_cell_linename3.csv", row.names=FALSE)
colDataL6 <- colData[c(set_col_del_con3), ]
write.csv(colDataL6, "/media/sf_AIDD/PHENO_DATAcell_linename1_cell_linename4.csv", row.names=FALSE)
colDataA <- colData[c(set_col_del_con4), ]
write.csv(colDataA, "/media/sf_AIDD/PHENO_DATAcell_linename1_cell_linename5.csv", row.names=FALSE)
colDataB <- colData[c(set_col_del_con5), ]
write.csv(colDataB, "/media/sf_AIDD/PHENO_DATAcell_linename2_cell_linename3.csv", row.names=FALSE)
colDataC <- colData[c(set_col_del_con6), ]
write.csv(colDataC, "/media/sf_AIDD/PHENO_DATAcell_linename2_cell_linename4.csv", row.names=FALSE)
colDataD <- colData[c(set_col_del_con7), ]
write.csv(colDataD, "/media/sf_AIDD/PHENO_DATAcell_linename2_cell_linename5.csv", row.names=FALSE)
colDataE <- colData[c(set_col_del_con8), ]
write.csv(colDataE, "/media/sf_AIDD/PHENO_DATAcell_linename3_cell_linename4.csv", row.names=FALSE)
colDataF <- colData[c(set_col_del_con9), ]
write.csv(colDataF, "/media/sf_AIDD/PHENO_DATAcell_linename3_cell_linename5.csv", row.names=FALSE)
colDataG <- colData[c(set_col_del_con_10), ]
write.csv(colDataG, "/media/sf_AIDD/PHENO_DATAcell_linename4_cell_linename5.csv", row.names=FALSE)

