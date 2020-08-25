#!/bin/bash
#$ -M ebrooks5@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N BIOS60132_Practical_Two

module load bio/2.0

fastqc -t 8 *.gz

#Make list of specified paired-end reads
readList="SRR2584863 SRR2584866 SRR2589044"
for f in $readList; do
	#Trim specified reads
	trimmomatic PE -threads 8 "$f"_1.fastq.gz "$f"_2.fastq.gz \
		"$f"_1.trim.fastq "$f"_1.untrim.fastq \
		"$f"_2.trim.fastq "$f"_2.untrim.fastq \
		SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15
done

#Run velvet on all trimmed fastq data using a k-mer (hash) length of 27
velveth Assem 27 -fastq -separate -shortPaired SRR2584863_1.trim.fastq SRR2584863_2.trim.fastq \
	-shortPaired2 SRR2584866_1.trim.fastq SRR2584866_2.trim.fastq \
	-shortPaired3 SRR2589044_1.trim.fastq SRR2589044_2.trim.fastq

#Run  velvetg to only use sequences with a coverage of 5 or more,
# as well as only contigs with a length of 100 or more
velvetg Assem -cov_cutoff 5 -min_contig_lgth 100

#Output the contig N50 of the resulting assembly
grep "n50" Assem/Log
