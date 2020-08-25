#!/bin/bash
#$ -M sweaver4@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N sweaver4_Practical_Two

#Question: do the files (SRR2584863_1.fastq.gz etc) need to be in this repo for the script to work?
#I've added them and successfully gotten the script to run, but was unable to push with the files here.

module load bio/2.0

#use fastqc on all the zipped files
fastqc -t 8 *.gz


#use a for loop to go through all the gz files and trim them
for x in *_1.fastq.gz
do
  base=$(basename ${x} _1.fastq.gz)
  trimmomatic PE ${x} ${base}_2.fastq.gz \
               ${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
               ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
               SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
done


#use velveth on all the trimmed files, using 27 as the kmer length
velveth Assem 27 -shortPaired -fastq -separate SRR2584863_1.trim.fastq.gz SRR2584863_2.trim.fastq.gz \
        SRR2584866_1.trim.fastq.gz SRR2584866_2.trim.fastq.gz \
        SRR2589044_1.trim.fastq.gz SRR2589044_2.trim.fastq.gz

#use velvetg to do the assembly with a minimum coverage of 5 and a minimum contig length of 100
velvetg Assem -cov_cutoff 5 -min_contig_lgth 100


#prints out the last line of the Log file in the Assem directory, which has N50 value
tail -1 Assem/Log
