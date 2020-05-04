#!/usr/bin/bash
#PBS -l walltime=4:30:00
#PBS -l nodes=1:ppn=8
#PBS -l mem=32GB
#PBS -j oe
#PBS -A PAS1475
#PBS -S /usr/bin/bash
## for debugging set -x

clear_dir=/fs/project/PCON0005/cankun/cankun/CLEAR-master

module load python
module load gnu/4.8.5
module load bedtools/2.25.0

cd $clear_dir

#bamfiles="$(find $wd -maxdepth 2 -name "*.sorted.bam" -print)"


#OUTPUT=$(basename "$R1" .sorted.bam)
#echo $OUTPUT
#bedtools genomecov  -bg -split -ibam $R1 > $OUTPUT.bg


for i in *.bg
do
  python2 make_dat.py ncbiRefSeq.txt $i # generates `dat` files
  python2 fitter.py $i.dat > $i.dat.txt # finds passing transcripts
done

python2 grouper.py *.dat.txt > CLEAR_passed.txt # generates passed gene list
python2 make_violin_plots.py # generates CLEAR_violins.pdf
