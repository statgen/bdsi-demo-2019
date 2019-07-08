
configfile: "config.yml"
singularity: "library://jonathonl/default/bdsi-demo:v1.0.0"

conda_env = "requirements.yml"

region_string = "9000001-12000000"
ftp_location = "ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/supporting/bcf_files/ALL.chr{chromosome}.phase3_shapeit2_mvncall_integrated_v5.20130502.genotypes.bcf"


rule all:
  input:
    "out/merged-stats.tsv"


# Subsets the BCF files to region specified in region_string so that
# the pipeline runs more quickly.
rule subset:
  params:
    input_uri = ftp_location,
    region = "{chromosome}:" + region_string
  output:
    "tmp/subset.chr{chromosome}.bcf"
  conda: conda_env
  shell:
    """
    bcftools view --regions {params.region} {params.input_uri} -Ob -o {output}
    """


# Produces counts of variants with allele frequency 10 bins.    
rule chromosome_stats:
  input:
    "tmp/subset.chr{chromosome}.bcf"
  output:
    "tmp/stats.chr{chromosome}.tsv"
  params:
    cut_columns = lambda wildcards: ("4","3-4")[wildcards.chromosome == str(config["chromosomes"][0])]
  conda: conda_env
  shell:
    """
    bcftools stats {input} --af-bins 0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1 | grep "^AF" | cut -f {params.cut_columns} > {output}
    """


# Merges stats for each chromosome into one TSV file.
rule merged_stats:
  input:
    ["tmp/stats.chr" + str(c) + ".tsv" for c in config["chromosomes"]]
  output:
    "out/merged-stats.tsv"
  params:
    header = '\t'.join(["chr" + str(c) for c in config["chromosomes"]])
  shell:
    """
    printf "AF\t{params.header}\n" > {output}
    paste {input} >> {output}
    """


# Plots data in merged TSV file.
rule plot:
  input:
    "out/merged-stats.tsv"
  output:
    "out/merged-stats.plot.jpg"
  params:
    end_idx = len(config["chromosomes"]) + 1
  conda: conda_env
  shell:
    """
    gnuplot -e "set terminal jpeg enhanced; set key autotitle columnhead; set logscale y; plot for [i=2:{params.end_idx}] '{input}' using 1:i with lines" > {output}
    """
