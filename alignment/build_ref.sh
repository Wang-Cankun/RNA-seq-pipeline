#!/bin/bash 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --time=0:40:00
#SBATCH --job-name=build_ref
#SBATCH --output=build_ref_%j.txt
#SBATCH --mail-type=FAIL

###############################################
#### 1. Set working directory below:
wd= /gpfs/fs0/scratch/a/awc59/awc59/reference
####
###############################################

#module load samtools/1.9
#module load hisat2
#module load subread

cd /gpfs/fs0/scratch/a/awc59/awc59/codes/hisat2-2.2.1

./hisat2-build2 -p 16 $wd/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz $wd/Homo_sapiens.GRCh38.99
#hisat2-build -p 16 Mus_musculus.GRCm38.dna.primary_assembly.fa Mus_musculus.GRCm38.99
