# RNA-seq alignment code snippet

## Steps

0. Download and modify necessary part of sh scripts.

Download your reference genome (fasta), annotation(GTF), http://useast.ensembl.org/Mus_musculus/Info/Index

fastp software(for quality control) https://www.google.com/search?q=fastp+github&rlz=1C1GCEB_enUS873US873&oq=fastp+github&aqs=chrome..69i57.2959j0j1&sourceid=chrome&ie=UTF-8

 (if necessary) Build index for your reference genome.

```{shell}
qsub build_ref.sh
```


1. Prepare a fastq file list, e.g. fastq_list.txt, the fastq_list.txt should be three columns, the first two to specify two pair-end files of a sample, the third column is sample name, seperate by tab.

Put your fastq files into folders like /working_directory/fodler1/fastq1.fastq.gz

```{shell}
chmod +x *
module load R
Rscript build_fastq_list.R
```


2. modify run_primary_alignment.sh and run_quantification.sh, change to species and working directory. Then submit reads alignment jobs.
   
```{shell}
./submit_primary_alignment.sh
qstat | grep USERNAME
```

3. When 3 is finished, generate alignment report. The output is located at /result folder.

```{shell}
Rscript process_qc_report.R
```


4. run quantification to generate RNA-seq count matrix.
```{shell}
qsub run_quantification.sh
```

## REFERENCE
https://github.com/griffithlab/rnaseq_tutorial 

https://github.com/griffithlab/rnaseq_tutorial/wiki/Alignment 

https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0881-8
