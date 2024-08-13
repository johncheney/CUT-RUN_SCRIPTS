#!/bin/bash

# Script: filter_maker
# Description: Filters BAM, applies filters based on suspect regions,

#SBATCH --job-name=nordin
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00


###### STATIC #########################################    
# Input and output directories
SUSPECT_REGIONS="/home/users/cheneyjo/cheneyjo/references/suspect_lists/Nordin_Suspect_List.bed"
INPUT_DIR="../results/merge/bam"
# INPUT_DIR="../results/suspect_list_filter_l/bai" #unmerged file location (iirc)
# INPUT_DIR="../results/bowtie2_l/bam"

OUTPUT_DIR="../results/nordin"
mkdir -p $OUTPUT_DIR

# Create necessary output sub-directories
mkdir -p $OUTPUT_DIR/{merged,unmerged}


# # Convert bed files to bam files (for GoPeaks)
# for BED_FILE in $SL_OUTPUT_DIR/enrich/*.bed; do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
        SAMPLE_NAME=$(basename "$1")
        samtools view -L $SUSPECT_REGIONS -U $OUTPUT_DIR/merged/${SAMPLE_NAME}.norfilterd.bam $INPUT_DIR/${SAMPLE_NAME} 
        # samtools view -L $SUSPECT_REGIONS -U $OUTPUT_DIR/unmerged/${SAMPLE_NAME}.norfilterd.bam $INPUT_DIR/${SAMPLE_NAME} 
 
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done


