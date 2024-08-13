#!/bin/bash

# Script: bamtobigwig 
# Converts bamfiles to bigwig files 

#SBATCH --job-name=bbamtobigwig
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

## Here is the variable we are param sweeping across:
# IP_D_VAR="e2e"
# IP_D_VAR="l"
# IP_D_VAR="l_dovetail"
IP_D_VAR="Ted_Data"
# IP_D_VAR="TEST_NOTRIM"

#Named outdir
# OUTPUT_DIR="../results/bowtie2_$IP_D_VAR"
OUTPUT_DIR="../results/bowtie2_$IP_D_VAR"
# OUTPUT_DIR="../results/merge"

BAM_DIR="$OUTPUT_DIR/bam"
# # BAI_DIR="$OUTPUT_DIR/bai"
# # BW_DIR="$OUTPUT_DIR/bigwig"

# # For the merged files: 
# # INPUT_DIR="../results/merge"
# # INPUT_DIR="$BAM_DIR"

# # For the nordin filtered files: 
# INPUT_DIR="../results/nordin/merged/bam"
# # INPUT_DIR="../results/nordin/merged/bai"



# Toggle these next two comments after the first pass of this wrapper script
# INPUT_DIR="../results/bowtie2_$IP_D_VAR/sam"
INPUT_DIR="$BAM_DIR"


##### AFTER The Indexes are made, move them into the bam dir!

# Iterate over files in INPUT_DIR
echo "Files in $INPUT_DIR:"
ls -l "$INPUT_DIR"

# Iterate over files in INPUT_DIR
for file in "$INPUT_DIR"/*; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        echo "Submitting job for file: $file"
        # Submit each file as a separate Slurm job
        sbatch ./b2bw_array_01.sh "$file" ########################### Edit this line for bespoke b2bw_array_XX.sh files 
    else
        echo "Skipping non-file: $file"
    fi
done

# INPUT_DIR="../results/nordin/unmerged/bam"
# # INPUT_DIR="../results/nordin/unmerged/bai"

# # Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./b2bw_array_06.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done

# # Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./b2bw_array_03.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done