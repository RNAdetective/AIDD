data <- read.csv("/media/sf_AIDD/BinaryMDDCatChanged.csv")
data2 <- as.matrix(data)
image1 <- "/media/sf_AIDD/GuttmanCatphenotypeChanged.tiff"
tiff(image1, units="in", width=15, height=15, res=300)
ht <- Heatmap(data2, row_km = 6, column_km = 5, top_annotation = HeatmapAnnotation(Categories = 1:14, bar1 = anno_points(runif(14))),right_annotation = rowAnnotation(Excitome_Sites = 129:1, bar = anno_barplot(runif(129))))
ht
dev.off()

image1 <- "/media/sf_AIDD/UpSetMDDFemale2.tiff"
tiff(image1, units="in", width=20, height=15, res=300)
data <- read.csv("/media/sf_AIDD/BinaryphenotypeCatChangedFemale.csv")
data2 = make_comb_mat(data)
col_names=names(data2)
UpSet(data2, set_order = col_names, comb_order = order(comb_size(data2)))
dev.off()


m1 = make_comb_mat(data, mode = "distinct")
m2 = make_comb_mat(data, mode = "intersect")
m3 = make_comb_mat(data, mode = "union")
UpSet(m1, column_title = "distinct mode") +
UpSet(m2, column_title = "intersect mode") +
UpSet(m3, column_title = "union mode")

m = make_comb_mat(data)
UpSet(m, pt_size = unit(5, "mm"), lwd = 6,
    comb_col = c("red","orange","yellow","green","blue","purple","black"))



ht = draw(UpSet(data2))
od = column_order(ht)
cs = comb_size(data2)
decorate_annotation("Intersection\nsize", {
    grid.text(cs[od], x = seq_along(cs), y = unit(cs[od], "native") + unit(2, "pt"), 
        default.units = "native", just = "bottom", gp = gpar(fontsize = 8))
})






#Given that genes involved in metabolic pathways are enriched across all comparisons, we determine if this is due to the same or different genes changing expression in the 16 gene lists. We display the overlap of genes across the 16 gene lists (Table 2) using an ‘Upset plot’ (Figure 2, Lex et al. 2014), which is conceptually similar to a Venn diagram. We find there is limited amount of overlap of genes across the 16 gene lists. For example, the number of genes in common across any pairwise comparison includes only 36-56 genes, in the top five pairwise comparisons for overlapping gene lists. Furthermore, a maximum of five genes are shared across any eight gene lists (Figure 2). This demonstrates that expression of different genes were changing in the female head in the different conditions, and that the overlap of enriched pathways may largely be due to different genes or small numbers of genes.

#We next determine the significance of the overlap of genes in each pairwise comparison for the 16 gene lists (from Table 2). We find that genes that are induced by mating in one condition, significantly overlap with the seven other lists of genes induced by mating (Figure S5 for results from Fisher’s exact test). The same result holds for genes that are repressed by mating (Figure S5). Therefore, the significant overlap from the Fisher’s exact test is due to a small number of overlapping genes, as is expected from the Upset plot analyses (Figure 2).

#Overlap of differentially expressed genes. Comparison of the 16 lists of genes that were differentially expressed at one- and three-days post-mating, using an Upset plot, which is conceptually similar to a Venn diagram. The horizontal histogram at the left shows the number of genes in each of the 16 lists. The vertical histogram on the right shows the number of overlapping genes. The colored dots show the condition(s) where the gene(s) are present. The number of lists the gene is present within is indicated on the bottom, from left to right, going from one list to eight lists, with each category only showing the top five intersections.

image1 <- "/media/sf_AIDD/UpSsetMDDcolor.tiff"
tiff(image1, units="in", width=20, height=12, res=300)
data <- read.csv("/media/sf_AIDD/BinaryphenotypeCatChanged.csv")
col_names=names(data)
sets <- col_names
Sex <- c("Female","Male","Female","Male","Female","Male","Female","Male","Female","Male","Female","Male","Female","Male")
metadata <- as.data.frame(cbind(sets, Sex))
metadata$Sex <- as.character(metadata$Sex)
BrainRegion <- c("aINS","aINS","Cg25","Cg25","dlPFC","dlPFC","Nac","Nac","OFC","OFC","PFCB9","PFCB9","Sub","Sub")
metadata <- cbind(metadata, BrainRegion)
metadata$BrainRegion <- as.character(metadata$BrainRegion)
#Scores <- as.numeric(c(9.666666667,-0.447368421,9.69047619,-13.66666667,3.777777778,2.039473684,-0.388888889,5.464285714,3.722222222,-0.776315789,-6.916666667,-5.896551724,8.235294118))
#metadata <- cbind(metadata,Scores)
#metadata$Scores <- as.numeric(metadata$Scores)
braincolor <- c(aINS="red",Cg25="orange",dlPFC="yellow",Nac="green",OFC="blue",PFCB9="purple",Sub="black")
sexcolor <- c(Female="red",Male="blue")
matrixcolor <- c(aINS="red",Cg25="orange",dlPFC="yellow",Nac="green",OFC="blue",PFCB9="purple",Sub="black")
text <- c(2, 2, 2, 2, 2, 2)
names(metadata) <- c("Categories","Sex","BrainRegion")
upset(data, nset=14,nintersects=200,text.scale = text,set.metadata = list(data=metadata, plots = list(list(type = "heat", column = "Sex", assign=3,colors=sexcolor), list(type = "matrix_rows", column = "BrainRegion", colors=matrixcolor))))


upset(data, nset=14,nintersects=200,text.scale = text,point.size=4.2,mainbar.y.label="Editing Sites",sets.x.label="BrainRegions and Biological Sex",shade.alpha=0.51,matrix.dot.alpha=0.1,query.legend="top",set.metadata = list(data=metadata, plots = list(list(type = "matrix_rows", column = "BrainRegion", colors=matrixcolor))), queries = list(list(query = intersects, params = list("Sub_Female"), color = "black", active = F), list(query = intersects, params = list("PFCB9_Female", "PFCB9_Male"), active = T,color ="red"),list(query = intersects, params = list("dlPFC_Female", "dlPFC_Male"), active = T,color ="red"),list(query = intersects, params = list("Nac_Female", "Nac_Male"), active = T,color ="red")))

,




dev.off()



upset(movies, nsets = 7, nintersects = 30, mb.ratio = c(0.5, 0.5),
      order.by = c("freq", "degree"), decreasing = c(TRUE,FALSE))

upset(movies, sets = c("Drama", "Comedy", "Action", "Thriller", "Western", "Documentary"),
      queries = list(list(query = intersects, params = list("Drama", "Action")),
                list(query = between, params = list(1970, 1980), color = "red", active = TRUE)))

upset(movies, attribute.plots = attributeplots,
     queries = list(list(query = between, params = list(1920, 1940)),
                    list(query = intersects, params = list("Drama"), color= "red"),
                    list(query = elements, params = list("ReleaseDate", 1990, 1991, 1992))),
      main.bar.color = "yellow")
