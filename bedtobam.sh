#!/bin/bash

# Script: bedtobam 
# Converts bedfiles to bigwig files 

#SBATCH --job-name=bedtobam
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

INDEX_DIR="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta/sizes.genome"
INPUT_DIR="../results/suspect_list_filter/cbed"
# INPUT_DIR=""
OUTPUT_DIR="../results/bedtobam"
mkdir -p $OUTPUT_DIR \

BAM_DIR="$OUTPUT_DIR/bed_bam"
mkdir -p $BAM_DIR \

        # Extract fragment related columns
for BED_FILE in $INPUT_DIR/*.bed; do
    if [ -r "$BED_FILE" ]; then
        SAMPLE_NAME=$(basename "$BED_FILE" .bed)
        bedToBam -ubam -i $INPUT_DIR/${SAMPLE_NAME}.bed -g $INDEX_DIR > $OUTPUT_DIR/bed_bam/${SAMPLE_NAME}.bam 
 
else
echo "Error: No SAM files found in $INPUT_DIR"
exit 1                                                                                                                                           
fi      
done



