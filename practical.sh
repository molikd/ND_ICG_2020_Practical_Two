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

	#Combine trimmed fastq files of each read mate
	cat "$f"_1.trim.fastq >> SRRCombined_1.trim.fastq
	cat "$f"_2.trim.fastq >> SRRCombined_2.trim.fastq
done

#Run velvet on all trimmed fastq data using a k-mer (hash) length of 27
velveth Assem 27 -fastq -separate -shortPaired SRRCombined_1.trim.fastq SRRCombined_2.trim.fastq

#Run  velvetg to only use sequences with a coverage of 5 or more,
# as well as only contigs with a length of 100 or more
velvetg Assem -cov_cutoff 5 -min_contig_lgth 100

#Output the contig N50 of the resulting assembly
grep "n50" Assem/Log

#Clean up for subsequent script usage
rm SRRCombined_*.trim.fastq