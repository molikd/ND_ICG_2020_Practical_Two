#!/bin/bash
#$ -M bcoggins@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N BIOS60132_Practical_Two

module load bio/2.0
#fastQC reports
fastqc -t 8 *.gz
#trimming for all paired-end reads in directory
for f1 in *1.fastq.gz
do
f2=$(basename ${f1} 1.fastq.gz)2.fastq.gz
f3=$(basename ${f1} .fastq.gz).trim.fastq
f4=$(basename ${f1} .fastq.gz).untrim.fastq
f5=$(basename ${f2} .fastq.gz).trim.fastq
f6=$(basename ${f2} .fastq.gz).untrim.fastq
trimmomatic PE -threads 8 ${f1} ${f2} \
	${f3} ${f4} \
	${f5} ${f6} \
	SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
done
#velvet assembly for all trimmed paired end reads in directory. kmer length of 27
velveth Assem 27 -fastq -separate -shortPaired  SRR2584863_1.trim.fastq SRR2584863_2.trim.fastq \
-shortPaired2 SRR2584866_1.trim.fastq SRR2584866_2.trim.fastq
-shortPaired3 SRR2589044_1.trim.fastq SRR2589044_2.trim.fastq

#generate debrujin graph from velveth assembly. coverage must be at least 5x, contigs at least 100 bp. 
velvetg Assem/ -min_contig_lgth 100 -coverage_mask 5
#output N50 from graph
tail -1 Assem/Log
