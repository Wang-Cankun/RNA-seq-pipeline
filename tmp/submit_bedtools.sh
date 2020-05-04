# global variables. 
wd=/fs/project/PCON0005/cankun/laura2/alignment_out
clear_dir=/fs/project/PCON0005/cankun/cankun/CLEAR-master

module load python
module load gnu/4.8.5
module load bedtools/2.25.0

#cd $clear_dir

bamfiles="$(find $wd -maxdepth 2 -name "*.sorted.bam" -print)"

for FASTQ1 in $bamfiles
do
   qsub -v "R1=$FASTQ1" -N "$FASTQ1" run_bedtools.sh
   sleep 0.1s

done 
