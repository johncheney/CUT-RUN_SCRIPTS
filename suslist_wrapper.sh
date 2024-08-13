#!/bin/bash

# Script: bamtobigwig 
# Converts bamfiles to bigwig files 

#SBATCH --job-name=bamtobigwig
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# First input dir
# INPUT_DIR="../results/bowtie2_l/sam"

# Subsequent input dirs
# INPUT_DIR="../results/suspect_list_filter_l/sorted" # second array dir
# INPUT_DIR="../results/suspect_list_filter_l/bam" # third array dirs
# INPUT_DIR="../results/suspect_list_filter_l/sorted_bam" #forth array dir
INPUT_DIR="../results/suspect_list_filter_l/bai" # fifth array dir

# for file in $INPUT_DIR/*; do echo sbatch ./b2bw_array.sh $file; done
 

# Iterate over files in INPUT_DIR
echo "Files in $INPUT_DIR:"
ls -l "$INPUT_DIR"

# Iterate over files in INPUT_DIR
for file in "$INPUT_DIR"/*_sorted.bam; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        echo "Submitting job for file: $file"
        # Submit each file as a separate Slurm job
        sbatch ./suslist_array_01.sh "$file"
    else
        echo "Skipping non-file: $file"
    fi
done