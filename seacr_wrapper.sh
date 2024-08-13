#!/bin/bash

# Script: seacr.sh
# Converts calls peaks using SEACR 

#SBATCH --job-name=seacr
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00



# Iterate over files in INPUT_DIR
INPUT_DIR="../results/nordin/merged/bedgraph"
# INPUT_DIR="../results/nordin/merged/bam"

# Iterate over files in INPUT_DIR
# echo "Files in $INPUT_DIR:"
# ls -l "$INPUT_DIR"

# # Iterate over files in INPUT_DIR
# for file in "$INPUT_DIR"/*.bedgraph; do
#     # Check if file is a regular file
#     if [ -f "$file" ]; then
#         echo "Submitting job for file: $file"
#         # Submit each file as a separate Slurm job
#         sbatch ./seacr_array_01.sh "$file"
#     else
#         echo "Skipping non-file: $file"
#     fi
# done

# Iterate over files in INPUT_DIR

INPUT_DIR="../results/nordin/unmerged/bedgraph"
# INPUT_DIR="../results/nordin/unmerged/bam"

# Iterate over files in INPUT_DIR
for file in "$INPUT_DIR"/*.bedgraph; do
    # Check if file is a regular file
    if [ -f "$file" ]; then
        echo "Submitting job for file: $file"
        # Submit each file as a separate Slurm job
        sbatch ./seacr_array_02.sh "$file"
    else
        echo "Skipping non-file: $file"
    fi
done




##################################################################################  

#         # Extract fragment related columns
# for BED_FILE in $INPUT_DIR/*.bedgraph; do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bedgraph)
#         seacr $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
#         $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
#         non stringent $OUTPUT_DIR/${SAMPLE_NAME}_seacr_control.peaks


#        seacr $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
#         $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
#         0.01 non stringent $OUTPUT_DIR/${SAMPLE_NAME}_seacr_top0.01.peaks
 
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done


# histControl=$2
# mkdir -p $projPath/peakCalling/SEACR

# bash $seacr $projPath/alignment/bedgraph/${histName}_bowtie2.fragments.normalized.bedgraph \
#      $projPath/alignment/bedgraph/${histControl}_bowtie2.fragments.normalized.bedgraph \
#      non stringent $projPath/peakCalling/SEACR/${histName}_seacr_control.peaks

# bash $seacr $projPath/alignment/bedgraph/${histName}_bowtie2.fragments.normalized.bedgraph 0.01 non stringent $projPath/peakCalling/SEACR/${histName}_seacr_top0.01.peaks
