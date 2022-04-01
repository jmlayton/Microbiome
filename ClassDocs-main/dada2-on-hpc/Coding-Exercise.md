# Coding Exercise

Choose another analysis of your choice and run as a batch job on HPC

## Create the R script
You can test the R script on your personal machine in R Studio.  Open a new file and paste the commands.  Click "Source" to run the code.  If it runs without error, move the script to the HPC with `scp`, `sftp`, or Globus.

## Log in to HPC and prepare the files
Log in and go to the scratch directory.  You can run from the same directory we used for the tutorial or make a new one.  Check the following:
- Do you have all the data?
- Are the filepaths defined properly?
- Did you redirect graphical output to a PDF?

## Submit the job
If it looks okay, just submit!  Check for errors, debug and resubmit as necessary.  If you cannot tell what is wrong from looking at the LSF output and error files, then start an interactive session with `bsub -Is`, start R and type the commands one by one until you find the error.  Fix the error and resubmit.

## Grading
The final script will be due in your GitHub repo on 3/2.

## Class module
```
module load /usr/local/usrapps/bioinfo/modulefiles/mb590/mb590s22
```
