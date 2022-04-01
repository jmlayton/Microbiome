#!/bin/tcsh
#BSUB -n 2             #At least 2 cores
#BSUB -x               #Autospawns threads, so use -x
#BSUB -R span[hosts=1] #One node for a shared memory job
#BSUB -W 30            #Maximum of 30min is fine
#BSUB -J dada2         #Job name, change if you like
#BSUB -o stdout.%J     #stdout file name
#BSUB -e stderr.%J     #stderr file name

#Load environment 
modular load /usr/local/usrapps/bioinfo/modulefiles/qiime2/2021.8
#Run the R script and redirect stderr *from R* to a file
Rscript dada2_tutorial.R >& dada2_tutorial.err
