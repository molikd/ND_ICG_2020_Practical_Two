#!/bin/bash
#$ -M adriscoe@nd.edu
#$ -m abe
#$ -pe smp 8
#$ -N BIOS60132_Practical_Two

module load bio/2.0

# Quality Control
fastqc -t 8 *.gz

# Trimming: For Loop to use trimmomatic on each of the PE fastq.gz files
for infile in *_1.fastq.gz
do
	base=$(basename ${infile} _1.fastq.gz)
	trimmomatic PE ${infile} ${base}_2.fastq.gz \
        	${base}_1.trim.fastq.gz ${base}_1un.trim.fastq.gz \
                ${base}_2.trim.fastq.gz ${base}_2un.trim.fastq.gz \
                SLIDINGWINDOW:4:20 MINLEN:25 ILLUMINACLIP:NexteraPE-PE.fa:2:40:15 
done

echo -e "\nFinished Trimmomatic\n"

# Combine all trimmed fastq files by read direction
cat *_1.trim.fastq.gz > forward.trim.all.fastq.gz
cat *_2.trim.fastq.gz >	reverse.trim.all.fastq.gz

echo -e "\nCombined Trimmed fastq files\n"

# Genome assembly: velveth, set k-mer length to 27
velveth Assem 27 -fastq.gz -separate -shortPaired forward.trim.all.fastq.gz reverse.trim.all.fastq.gz
 
echo -e "\nFinished velveth\n"

# velvetg:  Only use sequences with a coverage of 5 or more and minimum contig length of 100
velvetg Assem -cov_cutoff 5 -min_contig_lgth 100

echo -e "\nFinished velvetg\n"

# Output the contig N50 of the resulting assembly
tail -1 Assem/Log

echo -e "\nThe End\n"

