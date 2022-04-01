#HPC: This writes stdout from R into a file dada2.out
#     If there is already a file, it will be overwritten.
#     The output will not go to the terminal 
sink("dada2.out",append=FALSE,split=FALSE)

#HPC:  Load the packages.  On HPC, first load the conda environment.
#      module load /usr/local/usrapps/bioinfo/modulefiles/qiime2/2021.8
# Note - The environment is named qiime2, but the environment contains many
# different applications, including R and the R packages 'dada2'
library(dada2); packageVersion("dada2")

#HPC: The files were downloaded to the current working directory
path <- "./MiSeq_SOP"
list.files(path)

# Forward and reverse fastq filenames have format: SAMPLENAME_R1_001.fastq and SAMPLENAME_R2_001.fastq
fnFs <- sort(list.files(path, pattern="_R1_001.fastq", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="_R2_001.fastq", full.names = TRUE))

# Extract sample names, assuming filenames have format: SAMPLENAME_XXX.fastq
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)
sample.names

#HPC: Send graphics to a PDF file instead of a window
pdf("fnFs.pdf")
plotQualityProfile(fnFs[1:2])
dev.off()
pdf("fnRs.pdf")
plotQualityProfile(fnRs[1:2])
dev.off()

# Place filtered files in filtered/ subdirectory
filtFs <- file.path(path, "filtered", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "filtered", paste0(sample.names, "_R_filt.fastq.gz"))
names(filtFs) <- sample.names
names(filtRs) <- sample.names

#HPC: This one does the multithreading!!!
out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,160),
              maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
              compress=TRUE, multithread=TRUE) # On Windows set multithread=FALSE
head(out)

#HPC: Output directed back to the terminal
sink()
