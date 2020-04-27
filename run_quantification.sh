#!/usr/bin/bash
#PBS -l walltime=00:15:00
#PBS -l nodes=1:ppn=16
#PBS -l mem=16GB
#PBS -m n
#PBS -o log/quantification.out
#PBS -j oe
#PBS -S /usr/bin/bash
#PBS -A PAS1475

tools=/fs/project/PAS1475/tools

###############################################
#### Set working directory and reference below: (Remember to remove the foreslash '/')
wd=/fs/project/PCON0005/cankun/yutong_zhao
gtf=$tools/genome/Homo_sapiens.GRCh38.99.gtf
#gtf=$tools/genome/Mus_musculus.GRCm38.99.gtf

###############################################

bam_dir=$wd/alignment_out

module load samtools
module load hisat2
module load subread

cd $bamdir
ls
bamfiles="$(find $bam_dir -maxdepth 2 -name "*.sorted.bam" -print)"

featureCounts -T 16 -g gene_name --primary -a $gtf -o $wd/result/out.txt $bamfiles

# remove all large alignment files when finished
rm $bam_dir/*