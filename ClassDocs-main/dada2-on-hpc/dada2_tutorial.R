#HPC: This writes stdout from R into a file dada2.out
#     If there is already a file, it will be overwritten.
#     The output will not go to the terminal 
sink("dada2_tutorial.out",append=FALSE,split=FALSE)

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

out <- filterAndTrim(fnFs, filtFs, fnRs, filtRs, truncLen=c(240,160),
              maxN=0, maxEE=c(2,2), truncQ=2, rm.phix=TRUE,
              compress=TRUE, multithread=TRUE) # On Windows set multithread=FALSE
head(out)

errF <- learnErrors(filtFs, multithread=TRUE)
errR <- learnErrors(filtRs, multithread=TRUE)

#HPC: -------  Did you read it first? -------------------------------
#HPC:  ERROR!!!  YOU SHOULD READ STUFF BEFORE RUNNING!!!
cat("\n\nBOO if you didn't at least open the code to see this giant BUG!!!\n\n")
snark
#HPC: delete that or your code will crash.


#HPC: Send graphics to a PDF file instead of a window
pdf("errF.pdf")
plotErrors(errF, nominalQ=TRUE)
dev.off()

dadaFs <- dada(filtFs, err=errF, multithread=TRUE)
dadaRs <- dada(filtRs, err=errR, multithread=TRUE)
dadaFs[[1]]

mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)
# Inspect the merger data.frame from the first sample
head(mergers[[1]])

mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)
# Inspect the merger data.frame from the first sample
head(mergers[[1]])

seqtab <- makeSequenceTable(mergers)
dim(seqtab)

# Inspect distribution of sequence lengths
table(nchar(getSequences(seqtab)))

seqtab.nochim <- removeBimeraDenovo(seqtab, method="consensus", multithread=TRUE, verbose=TRUE)
dim(seqtab.nochim)

getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), sapply(mergers, getN), rowSums(seqtab.nochim))
# If processing a single sample, remove the sapply calls: e.g. replace sapply(dadaFs, getN) with getN(dadaFs)
colnames(track) <- c("input", "filtered", "denoisedF", "denoisedR", "merged", "nonchim")
rownames(track) <- sample.names
head(track)

#HPC: The files were downloaded to the /share/mb590s22 directory 
taxa <- assignTaxonomy(seqtab.nochim, "../silva_nr_v132_train_set.fa.gz", multithread=TRUE)
taxa <- addSpecies(taxa, "../silva_species_assignment_v132.fa.gz")

taxa.print <- taxa # Removing sequence rownames for display only
rownames(taxa.print) <- NULL
head(taxa.print)
unqs.mock <- seqtab.nochim["Mock",]
unqs.mock <- sort(unqs.mock[unqs.mock>0], decreasing=TRUE) # Drop ASVs absent in the Mock
cat("DADA2 inferred", length(unqs.mock), "sample sequences present in the Mock community.\n")

mock.ref <- getSequences(file.path(path, "HMP_MOCK.v35.fasta"))
match.ref <- sum(sapply(names(unqs.mock), function(x) any(grepl(x, mock.ref))))
cat("Of those,", sum(match.ref), "were exact matches to the expected reference sequences.\n")

#HPC: Output directed back to the terminal
sink()
