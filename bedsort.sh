#!/bin/bash

# Script: bamsort.sh
# Sorts BAM files for each TF or Histone mark based on mapped fragment size for each file

#SBATCH --job-name=bamsort
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

INPUT_DIR="../results/suspect_list_filter_local/bam"
OUTPUT_DIR="../results/bam_sort"

mkdir -p $OUTPUT_DIR

# Iterate over each BAM file in INPUT_DIR
for BAM_FILE in "$INPUT_DIR"/*.bam; do
    if [ -r "$BAM_FILE" ]; then
        # Extract base filename without extension
        SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
        
        # Extract common identifier for treatment replicate
        common_identifier=$(echo "$SAMPLE_NAME" | cut -d '_' -f 1-4)
        
        # Determine params based on common_identifier
        if [[ "$common_identifier" == *"AR"* || "$common_identifier" == *"BRG"* ]]; then
            params='<= 120 && abs($9) >= 10'
        else
            params='>= 140'
        fi
        
        echo "Processing $BAM_FILE with params: $params"
        
        # Perform samtools and awk processing
        # Save intermediate output after the awk command
        samtools view -H "$BAM_FILE" > "$OUTPUT_DIR/${SAMPLE_NAME}_header.sam"
        
        samtools view -h -q 30 -F 0xF04 "$BAM_FILE" | \
            samtools fixmate - - | \
            samtools view -f 0x3 - | \
            awk -v params="$params" 'function abs(x){return ((x < 0) ? -x : x)} abs($9) { if (params) print }' \
        > "$OUTPUT_DIR/${SAMPLE_NAME}_filtered.sam"
        
        cat "$OUTPUT_DIR/${SAMPLE_NAME}_header.sam" "$OUTPUT_DIR/${SAMPLE_NAME}_filtered.sam" | \
            samtools view -Sb - > "$OUTPUT_DIR/${SAMPLE_NAME}_sorted.bam"
        
        # Index the sorted BAM file
        samtools index "$OUTPUT_DIR/${SAMPLE_NAME}_sorted.bam"
        
        # Optionally, remove intermediate files if desired
        # rm "$OUTPUT_DIR/${SAMPLE_NAME}_header.sam" "$OUTPUT_DIR/${SAMPLE_NAME}_filtered.sam"
        
    fi
done


# ***********************************************************
# # Iterate over each BAM file in INPUT_DIR
# for BAM_FILE in "$INPUT_DIR"/*.bam; do
#     if [ -r "$BAM_FILE" ]; then
#         # Extract base filename without extension
#         SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
        
#         # Extract common identifier for treatment replicate
#         common_identifier=$(echo "$SAMPLE_NAME" | cut -d '_' -f 1-4)
        
#         # Determine params based on common_identifier
#         if [[ "$common_identifier" == *"AR"* || "$common_identifier" == *"BRG"* ]]; then
#             params='<=158 && (abs($9) >= 48)'
#         else
#             params='>=178'
#         fi
        
#         echo "Processing $BAM_FILE with params: $params"
        
#         # Perform samtools and awk processing here
#         samtools view -h "$BAM_FILE" | \
#             awk -v params="$params" 'function abs(x){return ((x < 0) ? -x : x)} abs($9) { if (params) print }' \
#     > "$OUTPUT_DIR/${SAMPLE_NAME}_sorted.bam"

        
#         samtools index $OUTPUT_DIR/${SAMPLE_NAME}_sorted.bam
#     fi
# done
