#!/bin/bash

# Script: filter_and_process.sh
# Description: Filters SAM files, converts to BAM, applies filters based on suspect regions,
#              and processes fragments.

#SBATCH --job-name=fragsizedist
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00


INPUT_DIR="../results/picard/dedup_sam"
OUTPUT_DIR="../results/fragsizedist"

mkdir -p $OUTPUT_DIR



# Iterate over SAM files in INPUT_DIR
for SAM_FILE in "$INPUT_DIR"/*.sam; do
    if [ -r "$SAM_FILE" ]; then
        SAMPLE_NAME=$(basename "$SAM_FILE" .sam)

	# Sort them again

	samtools view -F 0x04 $INPUT_DIR/${SAMPLE_NAME}.sam \
    | awk -F'\t' 'function abs(x){return ((x < 0.0) ? -x : x)} {print abs($9)}' | sort | uniq -c | awk -v OFS="\t" '{print $2, $1/2}' > $OUTPUT_DIR/${SAMPLE_NAME}_fragmentLen.txt 

else
        echo "Error: No SAM files found in $INPUT_DIR"
        exit 1                                                                                                                                           
    fi      
done


# ##== linux command ==##
# mkdir -p $projPath/alignment/sam/fragmentLen

# ## Extract the 9th column from the alignment sam file which is the fragment length
# samtools view -F 0x04 $projPath/alignment/sam/${histName}_bowtie2.sam 



