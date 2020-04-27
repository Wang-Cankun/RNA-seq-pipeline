#!/usr/bin/bash
#PBS -N Build_reference
#PBS -l walltime=2:00:00
#PBS -l nodes=1:ppn=16
#PBS -l mem=64GB
#PBS -j oe
#PBS -S /usr/bin/bash
#PBS -A PAS1475

###############################################
#### 1. Set working directory below:
wd=
####
###############################################

module load samtools
module load hisat2
module load subread

cd $wd

hisat2-build -p 16 Homo_sapiens.GRCh38.dna.primary_assembly.fa Homo_sapiens.GRCh38.99
hisat2-build -p 16 Mus_musculus.GRCm38.dna.primary_assembly.fa Mus_musculus.GRCm38.99
