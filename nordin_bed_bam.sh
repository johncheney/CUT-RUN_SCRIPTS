#!/bin/bash

# Script: filter_maker
# Description: Filters BAM, applies filters based on suspect regions,

#SBATCH --job-name=filters
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00


###### STATIC #########################################    
# Input and output directories
SUSPECT_REGIONS="/home/users/cheneyjo/cheneyjo/references/suspect_lists/modified_Nordin_Suspect_List.bed"
# INPUT_DIR="../results/picard_local/dedup_sam"
# INPUT_DIR="../results/bowtie2_l/bam"
# SL_OUTPUT_DIR="../results/suspect_list_filter_local"

# Assets
chromSize="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta/sizes.genome"

# Create necessary output sub-directories
# mkdir -p $SL_OUTPUT_DIR/{Nordin,sorted,bam,bed,cbed,fragment,counts,sorted2,sorted3}
# mkdir -p $SL_OUTPUT_DIR/{sorted,bam,bed,Nordin,enrich,bedgraph,bed_bam,sorted_bedbam,bigwig,bedgraph_Nordin}

# # Convert bed files to bam files (for GoPeaks)
# for BED_FILE in $SL_OUTPUT_DIR/enrich/*.bed; do
#     if [ -r "$BED_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BED_FILE" .bed)
        # SAMPLE_NAME=$(basename "$1" .bed)
        bedToBam -ubam -i $SUSPECT_REGIONS -g $chromSize > /home/users/cheneyjo/cheneyjo/references/suspect_lists/Nordin_Suspect_List.bam 
 
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done


