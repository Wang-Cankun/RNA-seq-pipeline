#!/usr/bin/bash
#PBS -l walltime=00:30:00
#PBS -l nodes=1:ppn=16
#PBS -l mem=64GB
#PBS -j oe
#PBS -o log/$NAME.out
#PBS -A PAS1475
#PBS -S /usr/bin/bash
## for debugging set -x

tools=/fs/project/PAS1475/tools
ref_dir=$tools/genome

###############################################
#### Set working directory and reference below: (Remember to remove the foreslash '/')
wd=/fs/project/PCON0005/cankun/yutong_zhao

ref_fasta=$tools/genome/Homo_sapiens.GRCh38.dna.primary_assembly.fa
ref_index=Homo_sapiens.GRCh38.99
#ref_fasta=$tools/genome/Mus_musculus.GRCm38.dna.primary_assembly.fa
#ref_index=Mus_musculus.GRCm38.99
###############################################

module load samtools
module load hisat2
module load subread
module load java

cd $wd
echo $NAME

mkdir $wd/log
mkdir $wd/fastp_out
mkdir $wd/result
mkdir $wd/result/pre_alignment
mkdir $wd/result/post_alignment
mkdir $wd/alignment_out

# FASTQ quality control, trimming, filtering
$tools/fastp -w 16 -i $R1 -I $R2 -o $wd/fastp_out/$NAME.R1.fastq.gz -O $wd/fastp_out/$NAME.R2.fastq.gz -h $wd/result/pre_alignment/$NAME.html -j $wd/result/pre_alignment/$NAME.json

# Reads alignment to reference genome using HISAT2
hisat2 -p 16 -x $ref_dir/$ref_index -1 $wd/fastp_out/$NAME.R1.fastq.gz -2 $wd/fastp_out/$NAME.R2.fastq.gz -S $wd/alignment_out/$NAME.sam

# convert SAM file to BAM file
samtools view -S -b $wd/alignment_out/$NAME.sam -@ 16 > $wd/alignment_out/$NAME.bam

# sort bam files
samtools sort -@ 16 $wd/alignment_out/$NAME.bam -o $wd/alignment_out/$NAME.sorted.bam

# Post alignment quality control
java -jar $tools/picard.jar CollectAlignmentSummaryMetrics R=$ref_fasta I=$wd/alignment_out/$NAME.sorted.bam O=$wd/result/post_alignment/$NAME.sorted.txt

# when finished, submit run_quantification.sh to generate count matrix