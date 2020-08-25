#!/bin/bash
#$ -M svandext@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N BIOS60132_Practical_Two

module load bio/2.0

fastqc -t 8 *.gz

trimmomatic PE -threads 8 SRR2584863_1.fastq.gz SRR2584863_2.fastq.gz \
	SRR2584863_1.trim.fastq SRR2584863_1.untrim.fastq \
	SRR2584863_2.trim.fastq SRR2584863_2.untrim.fastq \
	SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15

trimmomatic PE -threads 8 SRR2584866_1.fastq.gz SRR2584866_2.fastq.gz \
        SRR2584866_1.trim.fastq SRR2584866_1.untrim.fastq \
        SRR2584866_2.trim.fastq SRR2584866_2.untrim.fastq \
        SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15

trimmomatic PE -threads 8 SRR2589044_1.fastq.gz SRR2589044_2.fastq.gz \
        SRR2589044_1.trim.fastq SRR2589044_1.untrim.fastq \
        SRR2589044_2.trim.fastq SRR2589044_2.untrim.fastq \
        SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15

velveth Assem 27 -shortPaired -fastq -separate SRR2584863_1.trim.fastq SRR2584863_2.trim.fastq \
	SRR2584866_1.trim.fastq SRR2584866_2.trim.fastq \
	SRR2589044_1.trim.fastq SRR2580466.trim.fastq

mkdir velvetg_out

./velvetg /afs/crc.nd.edu/user/s/svandext/Private/ND_ICG_2020_Practical_Two/velvetg_out -min_cov 5 -min_contig_lgth 50


