<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/AIDD2.jpg">
 </p>
 
<p align="center">Automated Isoform Diversity Detector<p align="center">
 
 ***
 
 # About AIDD
 [![DOI](https://zenodo.org/badge/119888778.svg)](https://zenodo.org/badge/latestdoi/119888778)
 
 
* AIDD incorporates open source tools into a static virtualbox to ensure reproducability in RNA-seq analysis.  
* AIDD includes a collection of scripts that completely automates the pipeline making it ease to use by simply double clicking the icon on the desktop.
* AIDD also has easy to use customizable options for more advance RNAseq analysis.  
* AIDD produces publication ready figures for gene and transcript level differential expression analysis.
* AIDD explores editome by mapping both ADAR and APOBEC editing sites on a global and local level and produces publication ready visualization of ADAR editing landscapes.
* AIDD includes a novel ExToolset which can look at all levels of transcriptome diversity in a RNA-seq dataset.
* AIDD has the ability to explore differential expression trends for entire pathways of genes at once with heatmaps and PCA plots.
* AIDD also has the ability to focus on just one gene isoform differential expression patterns.
* AIDD uses variant calling and snp effect to predict RNA editings role on protein diversity.
* AIDD uses gene enrichment analysis is to highlight pathways affected by variants.
* AIDD uses guttman scale for time series analysis of ADAR editing landscapes.

___

#### **AIDD also allows for customizable options** 

* options of aligners, assemblers, and DE tools.
* options for running VM on servers.
* analysis of mouse, rat, chimp data and more human reference version set options.
* analysis of scRNA-seq, miRNAseq, and lcRNAseq in addition to bulk RNAseq.
* multivariate analysis, dimension reduction, ANOVA, correlation analysis, and random forest of the excitome

___

## Getting Started

These are the directions to download the premade AIDD virtualbox or to create a new vm image with ubuntu 18 and how to use the script to update, download and install all necessary tools for AIDD to run the RNAseq computational pipeline for transcriptome diversity discovery.

### Prerequisites

1. Download and set up oracle virtual box machine 
```
https://www.virtualbox.org 
```
2. Download and install the extension pack as well.

### Installing

3. Download our ready to go AIDD virtualbox from the following link.

```
https://drive.google.com/file/d/1L2XBnZHJfuM4Ekg8ZYitWCJrLVlTg5t0/view?usp=sharing

```

4. Uncompress the file.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/step1.png">
 </p>
 
<p align="center">Step 4<p align="center">

 When finished you will have a folder called AIDD in whichever directory you were currently in (Note you need to have 7zip installed to do the uncompression this way).

5. Open Virtualbox manager and under the menu Machine select add.  A new pop window will allow you to find the file you just uncompressed.  Then click open.  AIDD will now appear on your list of virtualboxes.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/step2.png">
 </p>
 
<p align="center">Step 5<p align="center">
	
<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/step3.png">
 </p>
 
<p align="center">Step 5b<p align="center">
	
<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/step4.png">
 </p>
 
<p align="center"Step 5c<p align="center">

6. Make sure you check your setting for the machine and you have the correct amount of resources allocated to the virtualbox including RAM and CPU.

* You do this by selecting a virtualbox then clicking on settings.  
* Under the option in the menu on the right select systems. 
* There are two tabs you need to check on the right.  
* Under motherboard make sure the blue marker is in the green portion of the bar for how much RAM to allocate to the virtual box.  
* Do the same under the tab processors.  
* The top green bar is how much CPU to give to virtualbox and this needs to be in the green as well. 

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/step5.png">
 </p>
 
<p align="center">Step 6<p align="center">

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/step6.png">
 </p>
 
<p align="center">Step 6b<p align="center">
	
7. Set up ashared folder path for the pipeline to store files to.  The virtual box only has enough memory to run to the tools you will need a hard drive external to the virtual box below are the instructions to create the shared folder AIDD on your computer.  Just make sure the hard drive has enough space You will need about 50G for each file or more if you use deep sequencing.  You can also run AIDD in batches if space is a concern.

## Running AIDD

To Run AIDD for RNAseq transcriptome diversity discovery copy and paste the following command and follow the on screen prompts.  For detailed instructions as well as ways to edit the script for even more options see the manual.

Step 1: Make sure AIDD virutalbox is up an running following the steps outlined above and make sure that you have opened this github page in AIDD by using the web browser (if you do not open a new web browser in AIDD and continue using the one on your main computer then you will not be able to copy and paste from github into the terminal so you will have to maually type the command into the terminal).

Step 2: Follow the instructions on the desktop.
* 1.) Open PHENO_DATA.csv on the desktop and fill out for your experiment.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/pheno.png">
 </p>
 
<p align="center">Set up your PHENO_DATA file<p align="center">

        * a.) On the desktop you will find a file PHENO_DATA.csv add your experimental information into this file
        
        * b.) column 1: the sample names for each sample you wish to use to label graphs and tables for the results.
        
        * c.) column 2: the SRA run identification number or the name of the .fastq file you are using from non-public data.
        
        * d.) column 3: this is the main condition for the experiment for example AML or healthy (make sure to use this term instead of control). DO NOT use the word control because DESeq2 will not accept this as a condition.
        
        * e.) column 4: this is the sample number used to create matrix it is just sample01-sample what ever your last sample number is. Make sure if you have over a hundred samples that you use sample001. 
        
        * f.) column 5-6: these are addition conditions to be with multivariate analysis if you do not have any additional conditions leave them empty.
        
        * g.) Now save the new data with the same name on the desktop.
The next four steps 2-5 are optional if you don't have any genes of interest or pathways to investigate skip these and go right to running AIDD step 3.

* 2.) Insert any gene lists of interest into the insert_gene_of_interest folder on the desk top.  Make .csv files with the first column numbered 1-X.  Then in the second column list your genes you want on one bar graph.  Also open GOI.csv and add to the list of genes any you want line graph count graphs for as well as a included in the table of gene of interest results.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/geneinterest.png">
 </p>
 
<p align="center">insert gene of interest files<p align="center">

* 3.) Do the same for transcript lists of interest into the insert_transcript_of_interest fold making sure you add your transcript of interest to the TOI.csv file.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/transinterest.png">
 </p>
 
<p align="center">insert transcript of interest files<p align="center">

* 4.) Add any pathway lists to the insert_gene_lists_for_pathways folder on the desktop.  Make a csv file that contains the first column labeled gene numbered 1-X.  Then in the second column labeled gene_name enter as many genes you want to include in that pathway.  Then name the file XXXXXXXX.csv (the name of your pathway) then add this name to the csv file pathway_list in the same format as the others on the list.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/genepathway.png">
 </p>
 
<p align="center">insert gene lists you want to perform pathway DE analysis on files<p align="center">

* 5.) repeat this same procedure but for the insert_transcript_lists_for_pathways folder on the desktop.  Making sure to add you pathway names to the csv file names pathwayT_list.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/transpathway.png">
 </p>
 
<p align="center">insert transcript lists you want to perform pathway DE analysis on files<p align="center">

Step 3: Simply double click the icon labeled Run_AIDD on the desktop to run AIDD with default settings.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/step12b.png">
 </p>
 
<p align="center">Run AIDD by double clicking the icon on the desktop <p align="center">

Once AIDD starts a terminal will open and ask you if you want to run defaults or with some user defined options or if you want to just make the AIDD directories to run AIDD later or to run parts of the ExToolset without having to run AIDD.
To run with defaults and no futher prompts enter defaults

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/runAIDD.png">
 </p>
 
<p align="center">Run AIDD with defaults see manual to customize<p align="center">
	
___
	
If you needed to install AIDD anywhere other then the defualt VM /home/user directory or want the output data stored somewhere other then the default /media/sf_AIDD/AIDD_data you need to specify this in the command line as explained below.

copy and paste the following command into the command prompt

```
bash AIDD.sh /path/to/AIDD /path/to/store/data
```

___

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/AIDDoptions.png">
 </p>
 
<p align="center">Run AIDD with options <p align="center">

___

## Pipeline Flow Chart
![Screenshot](flow_chart.png)

## AIDD Results directory structure

/media/sf_AIDD/ADD_data default directory structure.
In addition these file are compressed in AIDD_data.tar.gz file saved in the same folder.

<p align="center">
<img src="https://raw.githubusercontent.com/RNAdetective/AIDD/master/steps/directoryAIDD.png">
 </p>


## AIDD is built with
* [SRAtoolkit] (https://www.ncbi.nlm.nih.gov/sra/docs/toolkitsoft/)
* [Fastx-Toolkit] (http://hannonlab.cshl.edu/fastx_toolkit/)
* [Samtools] (http://samtools.sourceforge.net/)
* [HISAT2] (https://ccb.jhu.edu/software/hisat2/index.shtml)
* [STAR] (https://github.com/alexdobin/STAR)
* [Bowtie2] (http://bowtie-bio.sourceforge.net/bowtie2/index.shtml)
* [Kallisto] (https://pachterlab.github.io/kallisto/about)
* [Salmon] (http://salmon.readthedocs.io/en/latest/salmon.html)
* [Picard] (http://broadinstitute.github.io/picard/)
* [Stringtie] (https://ccb.jhu.edu/software/stringtie/)
* [Cuffdiff/Cufflinks] (http://cole-trapnell-lab.github.io/cufflinks/cuffdiff/)
* [GATK] (https://software.broadinstitute.org/gatk/)
* [snpEff] (http://snpeff.sourceforge.net/)


R packages
* [Bioconductor packages] (https://www.bioconductor.org/)
* [DESeq2] (https://bioconductor.org/packages/release/bioc/html/DESeq2.html)
* [DEXseq] (http://bioconductor.org/packages/release/bioc/html/DEXSeq.html)
* [Ballgown] (http://bioconductor.org/packages/release/bioc/html/ballgown.html)
* [Ggplot2] (https://cran.r-project.org/web/packages/ggplot2/index.html)
* [topGO] (http://bioconductor.org/packages/release/bioc/html/topGO.html)
* [ggbiplot] (http://github.com/vqv/ggbiplot)
* [randomForestSRC] (https://cran.r-project.org/web/packages/randomForest/randomForest.pdf)
* [cluster] (https://cran.r-project.org/web/packages/cluster/cluster.pdf)
* [edgeR] (http://bioconductor.org/packages/release/bioc/html/edgeR.html)
* [FactoMineR] (https://cran.r-project.org/web/packages/FactoMineR/FactoMineR.pdf)
* [ggplot2] (https://cran.r-project.org/web/packages/ggplot2/ggplot2.pdf)
* [GenomicAllignments] (https://bioconductor.org/packages/release/bioc/manuals/GenomicAlignments/man/GenomicAlignments.pdf)
* [sirt] (https://cran.r-project.org/web/packages/sirt/sirt.pdf)

If you use our tool please site our publication
Plonski, N-M., Johnson, E., Frederick, M. et al. Automated Isoform Diversity Detector (AIDD): a pipeline for investigating transcriptome diversity of RNA-seq data. BMC Bioinformatics 21, 578 (2020). https://doi.org/10.1186/s12859-020-03888-6

___

## References for tools.

Auwera, G. A. Van Der, Carneiro, M. O., Hartl, C., Poplin, R., Levy-moonshine, A., Jordan, T., … Depristo, M. A. (2014). From FastQ data to high confidence varant calls: the Genome Analysis Toolkit best practices pipeline. Curr Protoc Bioinformatics (Vol. 11). http://doi.org/10.1002/0471250953.bi1110s43.From

Depristo, M. A., Banks, E., Poplin, R., Garimella, K. V., Maguire, J. R., Hartl, C., … Daly, M. J. (2011). A framework for variation discovery and genotyping using next-generation DNA sequencing data. Nature Genetics, 43(5), 491–501. http://doi.org/10.1038/ng.806

Dobin A, Davis CA, Schlesinger F, et al. STAR: ultrafast universal RNA-seq aligner. Bioinformatics. 2012;29(1):15-21. 

Kim, D., Langmead, B., & Salzberg, S. L. (2015). HISAT: a fast spliced aligner with low memory requirements. Nature Methods, 12(4), 357–360. http://doi.org/10.1038/nmeth.3317

Langmead B, Salzberg S. Fast gapped-read alignment with Bowtie 2. Nature Methods. 2012, 9:357-359.

Li, H. (2011). A statistical framework for SNP calling, mutation discovery, association mapping and population genetical parameter estimation from sequencing data. Bioinformatics, 27(21), 2987–2993. http://doi.org/10.1093/bioinformatics/btr509

Li, H., Handsaker, B., Wysoker, A., Fennell, T., Ruan, J., Homer, N., … Durbin, R. (2009). The Sequence Alignment/Map format and SAMtools. Bioinformatics, 25(16), 2078–2079. http://doi.org/10.1093/bioinformatics/btp352

Love, M. I., Huber, W., & Anders, S. (2014). Moderated estimation of fold change and dispersion for RNA-seq data with DESeq2. Genome Biology, 15(12). http://doi.org/10.1186/s13059-014-0550-8

McKenna, A., Hanna, M., Banks, E., Sivachenko, A., Cibulskis, K., Kernytsky, A., … DePristo, M. A. (2010). The Genome Analysis Toolkit: A MapReduce framework for analyzing next-generation DNA sequencing data. Genome Research, 20(9), 1297–1303. http://doi.org/10.1101/gr.107524.110

Pertea, M., Kim, D., Pertea, G., Leek, J. T., & Steven, L. (2017). HHS Public Access, 11(9), 1650–1667. http://doi.org/10.1038/nprot.2016.095.Transcript-level

Pertea, M., Pertea, G. M., Antonescu, C. M., Chang, T.-C., Mendell, J. T., & Salzberg, S. L. (2015). StringTie enables improved reconstruction of a transcriptome from RNA-seq reads. Nature Biotechnology, 33(3), 290–295. http://doi.org/10.1038/nbt.3122

___
