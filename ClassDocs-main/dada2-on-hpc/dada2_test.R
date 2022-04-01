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
