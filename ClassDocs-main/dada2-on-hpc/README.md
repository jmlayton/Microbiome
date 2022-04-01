# dada2-on-hpc
A tutorial on how to do the DADA2 tutorial on HPC

# Join BUG!
Sign up to join the Bioinformatics Users Group (BUG):
[https://groups.google.com/u/1/a/ncsu.edu/g/group-bioinformatics-users](https://groups.google.com/u/1/a/ncsu.edu/g/group-bioinformatics-users)

# Preliminary steps
Before class, please do the following.

Log in and go to the scratch directory:
```
cd /share/mb590s22
ls
```

There should be a directory with your UnityID.
```
cd $USER
```

If not:
```
mkdir $USER
cd $USER
```

Check the groups:
```
groups
```
You should be in **mb590s22** and **bioinfo**.

Before logging out, do:
```
module load conda
conda init tcsh
```

That's it!


# Why do you need a tutorial on a tutorial??
When you run DADA2 on your own machine, you are...well, on your own machine.  As you learned in the [Acceptable Use Policy](https://projects.ncsu.edu/hpc/About/AUP.php), Henry2 is a shared machine.  If the class whole logged in and simply ran the DADA2 analysis, we could possibly crash the *login nodes*.  We will do the steps in the tutorial from the *compute nodes*.

Another difference between your own machine and Henry2, as well as most other HPC clusters, is that it can be painfully slow to open a window for plotting purposes.  Also, you cannot open a window or do other interactive work when running a batch job.  We will save plot output to PDF files rather than having plots open in an interactive window.

From the video on [HPC Storage](https://youtu.be/T2Av3uF4aEs?t=297), recall that you cannot download files while on a compute node.  We will download all the necessary data *before* running the analysis.

One last thing - filepath conventions are different between Windows vs Linux/macOS.  The 'slashes' are different.  Linux/macOS is also case sensitive while Windows is not, so check that the filenames used in your script are the same as the actual names of the files.  Beyond the difference in slashes, if you want portable code, you should not 'hard code' filepaths.  Instead, bring all the filepath declarations and any other machine/environment dependent commands to the top of the script so they can be easily modified to run from anywhere.  In this lab, we will simplify things by using relative filepaths. 


# Go to the Tutorial!
[Go to the DADA2 on the HPC Tutorial.](Tutorial.md)
