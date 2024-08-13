#!/bin/bash

# Script: seacr.sh
# Calls peaks using GoPeaks 

#SBATCH --job-name=homer_wrapper
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# INPUT_DIR="../results/merged/seacr_peaks/seacr_non_stringent_S0_W4"
# INPUT_DIR="../results/merged/seacr_peaks/seacr_non_stringent_S9_W5"

# gopeaks input dirs:
# INPUT_DIR="../results/merged/gopeaks_peaks/gopeaks_S0_W4"

# Unmerged Attempt: 
# INPUT_DIR="../results/unmerged/seacr/seacr_relaxed"
INPUT_DIR="../results/homer/homer_peaks/seacr_relaxed"

# Iterate over files in INPUT_DIR
# echo "Files in $INPUT_DIR:"
# ls -l "$INPUT_DIR"

# # Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*control*.bed; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./homerpeaks_array_01.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done

################## FIND MOTIFS  
#seacr input dirs
# INPUT_DIR="../results/homer/homer_peaks/seacr_non_stringent_S0_W4"
# INPUT_DIR="../results/homer/homer_peaks/seacr_non_stringent_S9_W5"

# gopeaks input dirs:
# INPUT_DIR="../results/homer/homer_peaks/gopeaks_S0_W4"
# Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*.peak; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./homer_findmotifs_array_01.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done

################## ANNOTATE PEAKS

echo "Files in $INPUT_DIR:"
ls -l "$INPUT_DIR"

# Iterate over files in INPUT_DIR
for file in "$INPUT_DIR"/*.peak; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        echo "Submitting job for file: $file"
        # Submit each file as a separate Slurm job
        sbatch ./homer_annotatep_array_01.sh "$file"
    else
        echo "Skipping non-file: $file"
    fi
done