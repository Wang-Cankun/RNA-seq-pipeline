#!/usr/bin/bash
#PBS -l walltime=0:30:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32GB
#PBS -j oe
#PBS -A PAS1475
#PBS -S /usr/bin/bash
## for debugging set -x

wd=/fs/project/PCON0005/cankun/laura2/alignment_out
clear_dir=/fs/project/PCON0005/cankun/cankun/CLEAR-master

module load python
module load gnu/4.8.5
module load bedtools/2.25.0

cd $clear_dir

bamfiles="$(find $wd -maxdepth 2 -name "*.sorted.bam" -print)"


OUTPUT=$(basename "$R1" .sorted.bam)
echo $OUTPUT
bedtools genomecov  -bg -split -ibam $R1 > $OUTPUT.bg


#python make_dat.py ncbiRefSeq.txt $OUTPUT.bg 
#python python fitter.py $OUTPUT.bg.dat > $OUTPUT.bg.fit
#./wrapper.sh