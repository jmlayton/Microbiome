# The DADA2 Pipeline Tutorial on HPC

See the original [DADA2 Pipeline Tutorial (1.16)](https://benjjneb.github.io/dada2/tutorial.html).  We will follow along, making changes for use on HPC.

## Login, go to /share, and download the files

Go to the scratch directory (/share):
```
cd /share/mb590s22/$USER
ls
```

We will do all the *computing* from the compute nodes.  Compute nodes cannot reach the internet, so we will download files from the login node.  Go through the tutorial and check which files you need.  The first link is **example data**.  Right click the link and copy the link address.  Use `wget` to download, and then unzip the files.  This will create a directory *MiSeq_SOP* in the current directory.  The current directory is called `.` (dot).  Check what is in this directory.
```
wget https://mothur.s3.us-east-2.amazonaws.com/wiki/miseqsopdata.zip
unzip miseqsopdata.zip 
ls
ls .
ls ./MiSeq_SOP
```

Next, it says to download the files `silva_nr_v132_train_set.fa.gz` and  `silva_species_assignment_v132.fa.gz`.  I put those on the HPC.  They should be in one directory up from where you are now, called `..` (dot-dot).  Check how big the two files are by adding `-lhrt` to `ls`, which is *long form, human readable, reverse time order*:
```
ls /share/mb590s22/
ls ..
ls -lhrt ../silva*gz 
```

The extra detail about the paths is because we need to specify the paths in the R script.

## One quick thing - redirecting graphical output
It is best to avoid opening windows on the HPC.  Also, several libraries that try to create PNGs in R do not seem to work on HPC.  Redirect all graphical output to a PDF when working on HPC.  In the DADA2 tutorial, the following command pops open a window to render the plot:
```
# R script - Plotting interactively
plotQualityProfile(fnFs[1:2])
```

Instead, we will have it pop open a pdf file, and then close the file:
```
# R script - Redirect graphics to PDF file
pdf("fnFs.pdf")
plotQualityProfile(fnFs[1:2])
dev.off()
```

## Try out DADA2 in an interactive session

Do an interactive session.  Choosing 10 minutes or less will put you in the debug queue:
```
bsub -Is -W 10 -n 1 -x tcsh
```

Load the environment.  This was actually installed with Conda, and is a Conda environment, but I repackaged it as a `module`. The module is named qiime2, but the environment contains many different applications, including R and the R package 'dada2'.

```
module load /usr/local/usrapps/bioinfo/modulefiles/qiime2/2021.8
```

Open R
```
R
```
and type the commands
```
library(dada2); packageVersion("dada2")
path <- "./MiSeq_SOP"
list.files(path)
# Forward and reverse fastq filenames have format: SAMPLENAME_R1_001.fastq and SAMPLENAME_R2_001.fastq
fnFs <- sort(list.files(path, pattern="_R1_001.fastq", full.names = TRUE))
fnRs <- sort(list.files(path, pattern="_R2_001.fastq", full.names = TRUE))
# Extract sample names, assuming filenames have format: SAMPLENAME_XXX.fastq
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)
sample.names
pdf("fnFs.pdf")
plotQualityProfile(fnFs[1:2])
dev.off()
#Do not save workspace image after quitting
quit() 
n
```

That is how you would debug R code on the HPC - with an interactive session using `bsub -Is`, opening R, and typing the commands.  

While still on the compute node, test out these same commands copied to an R script.  Open a text editor, such as nano or vi, and create a file called dada2_test.R with the commands you just typed interactively.  
```
nano dada2_test.R
[cut paste the R commands above, but leave off the quit and n]
[save and exit]
```

Run the script.
```
Rscript dada2_test.R
```

Notice all the output to the screen.  To redirect stdout to a file, do:
```
Rscript dada2_test.R > dada2_test.out
```
 
Why is there still output?  Some of the R output is written to stderr rather than stdout. Add an ampersand to catch both. Note, this will overwrite the file.
```
Rscript dada2_test.R >& dada2_test.out
```

One more thing before a longer run...we run on an interactive node not just to debug the code, but to look at how the code behaves in terms of processors and memory.  Putting an ampersand at the end of the command makes the job run in the background so you can do other things:
```
Rscript dada2_test.R >& dada2.out &
```
Type `ps` to check if R is running.  Hit the up arrow a couple times.  It will return 'Done' when finished running.

Exit the interactive session:
```
exit
```

## Get the sample scripts

Download the files for DADA2 on HPC from class GitHub repo. 
```
git clone https://github.ncsu.edu/MicrobiomeAnalysis2022/dada2-on-hpc.git
```

**Do not** `cd` to the directory, just copy the sample R script for a short run.
```
cp dada2-on-hpc/dada2_short.R .
```

Open the file *dada2_short.R* with `less`.  Notice I have added the `sink()` command, which redirects the stdout to a file.  (It does not redirect the stderr.)  This is a short run, but it includes some commands that take some compute power.  Notice the command that says `multithread=TRUE`.  We will check what it is doing in another interactive session.
  
```
bsub -Is -W 10 -n 1 -x tcsh
```

Check if the module is still loaded or not.
```
module list
```

If not, load the environment:
```
module load /usr/local/usrapps/bioinfo/modulefiles/qiime2/2021.8
```

Run the script in the background, and use the `htop` command to check the threading and memory.
```
Rscript dada2_short.R >& dada2_short.out &
htop
```

(How many cores are on your node?  Is it the same as your neighbors?)

At first, the code is using one core.  It is loading the library and reading the files - both are serial tasks.  Wait a bit, and see the cores "light up" when the script hits the first real command.

When everything stops, the script is likely done.  Use `Ctrl-C` to exit `htop`, and `exit` to quit the interactive session.

## Run the job
Now that you tested everything, we will go ahead and run the whole thing.  Copy the submit script and the full R script to the current working directory:
```
cp dada2-on-hpc/dada2_tutorial.R .
cp dada2-on-hpc/submit.csh .
```

**Do not submit jobs or run code without at least taking a glance first.**  Take a look at both the *dada2_tutorial.R* and *submit.csh*.  For the R script, you can do a quick scan, but go through the submit script and check every line. If something is unclear, check the [HPC documentation for submitting jobs](https://projects.ncsu.edu/hpc/Documents/LSF.php).

```
bsub < submit.csh
```

You can check the job status with `bjobs`, and you can easily see which files are being created by using `ls` with the *reverse time order* flags:
```
bjobs
ls -lrth
```
You can also watch the output as it runs
```
tail -f dada2_tutorial.out
```
The script is finished when you see the following output:
```
DADA2 inferred 20 sample sequences present in the Mock community.
Of those, 20 were exact matches to the expected reference sequences.
```

Type `Ctrl-C` to exit `tail -f`.

## Check the plots

We should have done this earlier, but better late then never...we should check if the PDFs actually have the expected plots.  There are various ways to do this.
- Open directly from HPC.  For MobaXterm users, X11 is enabled by default.  Type `display fnFs.pdf`.  For Mac users, you need to log in with ssh -X and have XQuartz installed.  If remote display doesn't work for you, we probably won't have time to debug.
- Use scp or sftp from a terminal on your local machine, see [Transferring Files](https://projects.ncsu.edu/hpc/Documents/CopyFiles.php).  Transfer and then open the files on your local machine.
- [Try out Globus](https://projects.ncsu.edu/hpc/Documents/CopyFiles.php#globus) to transfer the files to your local machine.  Globus is nearly essential when transferring very large files, but in this case, it is simply nice to have the GUI open and not have our connection time out.

## Coding Exercise 
[Check these tips to try your own analysis on the HPC.](Coding-Exercise.md) 
