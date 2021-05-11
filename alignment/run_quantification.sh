#!/usr/bin/bash
#SBATCH --account PCON0022
#SBATCH --time=00:30:00
#SBATCH --nodes=1 
#SBATCH --ntasks=16
#SBATCH --mem=32GB

tools=/fs/project/PAS1475/tools

###############################################
#### Set working directory and reference below: (Remember to remove the foreslash '/')
wd=/fs/scratch/PAS1475/cankun/awc59/mapping
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

/fs/project/PAS1475/tools/subread/bin/featureCounts -T 16 -g gene_name --primary -a $gtf -o $wd/result/out.txt $bamfiles

# remove all large alignment files when finished
#rm $bam_dir/*