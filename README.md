# BDSI Reproducible Research 2019

This repo was used to demo git during the BDSI session on reproducible research. This repo will exist as a reference for the remainder of the summer.

## Topics Discussed

* Project organization
* Documentation
* Version Control
* Capturing the computational environemnt
* Automation

## How to add a project to Github 

```shell
echo "# Title" >> README.md
git init
git add README.md
git commit -a # and fill in commit message

# Then next two steps will link your local repo with a remote on Github and only need to be ran once.
git remote add origin https://github.com/<your_account>/<repo_name>.git
git push --set-upstream origin master
```


## How to run Snakemake pipeline

See link below for instructions on how to install Snakemake. The pipeline performs the following steps:

1. Subsets a few chromosomes of public [1000 Genomes](http://www.internationalgenome.org/about) data.
2. Generates allele frequency stats from the subsets for each chromosome.
3. Merges the per-chromosome stats into a single file.
4. Generates a plot from the merged file.

```shell
# Runs a maximum of 2 jobs in parallel
snakemake --use-conda -j 2 
```

## Links

Conda:
*  https://conda.io/docs/user-guide/install/index.html

Snakemake:
* https://snakemake.readthedocs.io/en/stable/getting_started/installation.html

Jupyter notebooks:
* http://jupyter.org/install

Containers:
* https://www.sylabs.io/guides/3.2/user-guide/
* https://docs.docker.com/docker-for-mac/install/
* https://docs.docker.com/docker-for-windows/install/

RStudio:
* https://www.rstudio.com/products/rstudio/download/#download

