# Using `targets` and `crew.controller` in R with SLURM

This operates mostly as a reminder / demo to myself as to how the hell to make all these things work together. To use the `targets` package with `crew`/`crew.controller` is an important way to automate and not have to re-run jobs on the Digital Alliance Canada cluster, which uses SLURM. 

I try to use the following components to stitch together a working network of packages and utilities to maximize reproducibility:

* The `renv` package  to manage R packages (s/o to the NYU high performacne computing group for their [handy tutorial on using `renv` with SLURM](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/r-packages-with-renv))
* The `targets` package, to reduce re-runs of redundant components of pipelines
* The `crew.cluster` package to launch the jobs via SLURM

Please feel free to use and borrow from this code base according to the licence below. 

Shield: [![CC BY 4.0][cc-by-shield]][cc-by]

This work is licensed under a
[Creative Commons Attribution 4.0 International License][cc-by].

[![CC BY 4.0][cc-by-image]][cc-by]

[cc-by]: http://creativecommons.org/licenses/by/4.0/
[cc-by-image]: https://i.creativecommons.org/l/by/4.0/88x31.png
[cc-by-shield]: https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg

## How-to:

1. Set up the new repository with the basic structure required by the targets package, including the main `_targets.R` file, the data files, etc. Then, initialize the project with `renv`:
   * use `renv::init()` to look for which packages need to be included, and follow instructions to do so
   * use `renv::snapshot()` to make the lock file
2. If step 1 occured on a local machine, push this repo to git, then pull it on your SLURM-enabled cluster.
3. To set up the package requirements, navigate to your project (e.g. `./home/user/scratch/PROJECTNAME/`) and load R with `module load StdEnv/2023` and `module load r/4.3.1` or whatever the most up-to-date versions of these two things is.
4. Following the suggestion of the [NYU tutorial](https://sites.google.com/nyu.edu/nyu-hpc/hpc-systems/greene/software/r-packages-with-renv), change the directory of where the packages that `renv` is installed will end up. See their tutorial for details. I used: `mkdir -p /home/USERNAME/scratch/.cache/R/renv`.
5. Start R with `R` - this should launch the R console, which should automatically recognize the `renv` components of the repo.
6. Use `renv::restore()` to get your packages into their desired location






