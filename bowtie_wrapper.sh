#!/bin/bash

# Script: bamtobigwig 
# Converts bamfiles to bigwig files 

#SBATCH --job-name=bowtie2_array
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# 
# INPUT_DIR="../results/trimmo/trimmed_1"
# INPUT_DIR="../data/total_input"
INPUT_DIR="../data/LIB240408AM"

# for file in $INPUT_DIR/*; do echo sbatch ./b2bw_array.sh $file; done
 

# Iterate over files in INPUT_DIR
echo "Files in $INPUT_DIR:"
ls -l "$INPUT_DIR"

# # Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*_R1_001.trimmed.fastq; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./bowtie_array_01.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done

# Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*_R1_001.trimmed.fastq; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./bowtie_array_02.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done

# # Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*_R1_001.trimmed.fastq; do
for file in "$INPUT_DIR"/*_R1_001.fastq.gz; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        echo "Submitting job for file: $file"
        # Submit each file as a separate Slurm job
        sbatch ./bowtie_array_01.sh "$file"
    else
        echo "Skipping non-file: $file"
    fi
done