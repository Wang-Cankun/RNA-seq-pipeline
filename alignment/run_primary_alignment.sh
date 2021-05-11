#!/usr/bin/bash
#SBATCH --account PCON0100
#SBATCH --time=02:00:00
#SBATCH --nodes=1 
#SBATCH --ntasks=16
#SBATCH --mem=64GB

tools=/fs/project/PAS1475/tools
wd=/fs/scratch/PCON0022/cankun/210305_Pearlly_GSL-PY-2037-transfer
#ref_dir=/fs/scratch/PAS1475/cankun/awc59/reference
###############################################
#### Set working directory and reference below: (Remember to remove the foreslash '/')
#ref_fasta=$ref_dir/Homo_sapiens.GRCh38.dna.primary_assembly.fa
ref_index=$tools/genome/Mus_musculus.GRCm38.99

###############################################
module load samtools
module load hisat2
module load subread
#module load java

cd $wd
echo $NAME

mkdir $wd/log
mkdir $wd/fastp_out
mkdir $wd/result
mkdir $wd/result/pre_alignment
#mkdir $wd/result/post_alignment
mkdir $wd/alignment_out

# FASTQ quality control, trimming, filtering
$tools/fastp -w 16 -i $R1 -I $R2 -o $wd/fastp_out/$NAME.R1.fastq.gz -O $wd/fastp_out/$NAME.R2.fastq.gz -h $wd/result/pre_alignment/$NAME.html -j $wd/result/pre_alignment/$NAME.json

# Reads alignment to reference genome using HISAT2
hisat2 -p 16 -x $ref_index -1 $wd/fastp_out/$NAME.R1.fastq.gz -2 $wd/fastp_out/$NAME.R2.fastq.gz -S $wd/alignment_out/$NAME.sam

# convert SAM file to BAM file
samtools view -S -b $wd/alignment_out/$NAME.sam -@ 16 > $wd/alignment_out/$NAME.bam

# sort bam files
samtools sort -@ 16 $wd/alignment_out/$NAME.bam -o $wd/alignment_out/$NAME.sorted.bam

# Post alignment quality control
#java -jar $tools/picard.jar CollectAlignmentSummaryMetrics R=$ref_fasta I=$wd/alignment_out/$NAME.sorted.bam O=$wd/result/post_alignment/$NAME.sorted.txt

# when finished, submit run_quantification.sh to generate count matrix