#!/bin/bash

# Script: seacr.sh
# Calls peaks using GoPeaks 

#SBATCH --job-name=GoPeaks
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00


# INPUT_DIR="../results/nordin/merged/bam"
INPUT_DIR="../results/suspect_list_filter_l/bam" # third array dir

# Iterate over files in INPUT_DIR
echo "Files in $INPUT_DIR:"
ls -l "$INPUT_DIR"

# Iterate over files in INPUT_DIR
for file in "$INPUT_DIR"/*sorted.bam; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        echo "Submitting job for file: $file"
        # Submit each file as a separate Slurm job
        sbatch ./gopeaks_array_01.sh "$file"
    else
        echo "Skipping non-file: $file"
    fi
done

# Iterate over files in INPUT_DIR

# INPUT_DIR="../results/nordin/unmerged/bam"

# # Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*.bam; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./gopeaks_array_02.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done
