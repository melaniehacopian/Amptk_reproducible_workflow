#!/bin/bash -l

#SBATCH --job-name=amptk          ## Name of the job.
#SBATCH  -A <account_name>        ## Account to charge job to
#SBATCH -p standard                 ## Partition/queue name
#SBATCH --cpus-per-task=4           ## number of cpus
#SBATCH --mem-per-cpu=3G           ## number of cpus
#SBATCH --mail-user=<email>        ## Be emailed when a job starts and ends
#SBATCH --mail-type=ALL
#SBATCH --time=1-00:00:00          ##Allotted time for job (default 2 days)
#SBATCH -o myoutput_%j.out          ## File to which STDOUT will be written, %j inserts jobid
#SBATCH -e myerrors_%j.err          ## File to which STDERR will be written, %j inserts jobid

## Disclaimer: When I recieved my reads from the sequencer, I had to do some renaming in the terminal as I recieved reads as .txt and amptk requires .fastq format.
## For amptk, read file names must contain R1 and R2 (Ex. Sample1_AGTAAGATA_ATCTCGCGT_R1.fastq
## For amptk, sample ID must be first part of the line.

# Make sure you are in a conda environment w/ amptk installed.

conda activate <your_environment>

amptk illumina -i sampledata -o test -f <insert_forward_primer_sequence> -r <insert_reverse_primer_sequence> --require_primer off --rescue_forward off --primer_mismatch 6

# Clustering w/ cluster OR dada2
amptk cluster -i test.demux.fq.gz -o test

# Filtering

amptk filter -i test.otu_table.txt -f test.cluster.otus.fa

# Assign taxonomy
amptk taxonomy -f test.filtered.otus.fa -i test.final.txt -m test.mappingfile.txt -d ITS2 -o test

# Link to FunGuild
amptk funguild -i test.otu_table.taxonomy.txt -d fungi -o funguildtest
