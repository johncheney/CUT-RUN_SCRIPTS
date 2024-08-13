#!/bin/bash

#SBATCH --job-name=trimmo
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=4G
#SBATCH --time=12:00:00

# IN_DIR="../data/LIB240408AM"
INPUT_DIR="../data/total_input"
TRIMMED_DIR="../results/trimmo/trimmed"
UNTRIMMED_DIR="../results/trimmo/untrimmed"
ADAPTER_FILE="../../references/trimmomatic/TruSeq2-PE.fa"

LEADING="20"
TRAILING="20"
SLIDINGWINDOW="4:15"
MINLEN="25"



# Iterate over files in INPUT_DIR
for file in "$INPUT_DIR"/*.gz; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        echo "Submitting job for file: $file"
        # Submit each file as a separate Slurm job
        sbatch ./trimmo_array_01.sh "$file"
    else
        echo "Skipping non-file: $file"
    fi
done
