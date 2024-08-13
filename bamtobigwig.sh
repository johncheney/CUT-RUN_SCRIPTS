#!/bin/bash

# Script: bamtobigwig 
# Converts bamfiles to bigwig files 

#SBATCH --job-name=bamtobigwig
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00


# INPUT_DIR="/home/users/cheneyjo/cheneyjo/cutandrun/results/bam_sort/"
INPUT_DIR="../results/suspect_list_filter/bed_bam"
# INPUT_DIR="/home/users/cheneyjo/cheneyjo/cutandrun/results/suspect_list_filter/sorted2"
# OUTPUT_DIR="../results/bamtobigwig"
OUTPUT_DIR="../results/bamtobigwig/"
mkdir -p $OUTPUT_DIR \

# BW_DIR="$OUTPUT_DIR/raw_bam_bigwig_smooth60_bs5_exten"
BW_DIR="$OUTPUT_DIR/bamsort_bam_bigwig_smooth60_bs5_exten"
mkdir -p $BW_DIR \

        # Extract fragment related columns
for BAM_FILE in $INPUT_DIR/*.bam; do
    if [ -r "$BAM_FILE" ]; then
        SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
        samtools sort -o $BW_DIR/${SAMPLE_NAME}.bam $INPUT_DIR/${SAMPLE_NAME}.bam 
        samtools index $BW_DIR/${SAMPLE_NAME}.bam
        bamCoverage -b $BW_DIR/${SAMPLE_NAME}.bam -o $OUTPUT_DIR/${SAMPLE_NAME}.bigwig \
        --binSize 5 \
        --normalizeUsing BPM \
        --smoothLength 60 \
        --extendReads \
        --centerReads \
        -p 8 

 
else
echo "Error: No SAM files found in $INPUT_DIR"
exit 1                                                                                                                                           
fi      
done

# bamCoverage -b sample1.bam \


