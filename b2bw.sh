#!/bin/bash

# Script: bamtobigwig 
# Converts bedfiles to bigwig files 

#SBATCH --job-name=bamtobigwig
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00


VAR=""

INPUT_DIR="../results/bedtobam/bed_bam"
OUTPUT_DIR="../results/bamtobigwig/cbed_bam"

mkdir -p $OUTPUT_DIR \

SORT_DIR="$OUTPUT_DIR/sort"
INDEX_DIR="$OUTPUT_DIR/index"
BW_DIR="$OUTPUT_DIR/bigwig_rpkm_5bs"

mkdir -p $BW_DIR \
        $SORT_DIR \
        $INDEX_DIR

        # Extract fragment related columns
for BAM_FILE in $INPUT_DIR/*.bam; do
    if [ -r "$BAM_FILE" ]; then
        SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
        samtools sort -o $SORT_DIR/${SAMPLE_NAME}.bam $INPUT_DIR/${SAMPLE_NAME}.bam 
        samtools index $SORT_DIR/${SAMPLE_NAME}.bam 
        bamCoverage -b $SORT_DIR/${SAMPLE_NAME}.bam -o $BW_DIR/${SAMPLE_NAME}.bigwig --binSize 5 --normalizeUsing RPKM -p 8
 
else
echo "Error: No SAM files found in $INPUT_DIR"
exit 1                                                                                                                                           
fi      
done



