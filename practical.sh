#!/bin/bash
#$ -M <you>@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N BIOS60132_Practical_Two

module load bio/2.0

fastqc -t 8 *.gz

trimmomatic PE -threads 8 SRR2584863_1.fastq.gz SRR2584863_2.fastq.gz \
	SRR2584863_1.trim.fastq SRR2584863_1.untrim.fastq \
	SRR2584863_2.trim.fastq SRR2584863_2.untrim.fastq \
	SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15

velveth Assem 31 -shortPaired -fastq -separate SRR2584863_1.trim.fastq SRR2584863_2.trim.fastq
