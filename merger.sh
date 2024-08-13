#!/bin/bash

# Script: merger.sh  
# Sorts BAM files for each TF or Histone mark based on mapped fragment size for each file

#SBATCH --job-name=merger
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

INPUT_DIR="../results/suspect_list_filter_l/bam"
OUTPUT_DIR="../results/merge"

mkdir -p $OUTPUT_DIR

# INPUT_DIR="path/to/your/input/dir"
# OUTPUT_DIR="path/to/your/output/dir"

# Iterate over each BAM file in INPUT_DIR
for BAM_FILE in "$INPUT_DIR"/*.bam; do
    if [ -r "$BAM_FILE" ]; then
        # Extract base filename without extension
        SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
        #echo "sample name" $SAMPLE_NAME
    
        # Extract common identifier for treatment replicate
        if [[ $SAMPLE_NAME =~ ^(LIB.*)_(S[0-9]+|W[0-9]+)_(NS|S)_(AR|BRG|IgG|K27A|K27M|K4)_.*$ ]]; then
            base_name="${BASH_REMATCH[1]}"
            replicate="${BASH_REMATCH[2]}"
            condition="${BASH_REMATCH[3]}"
            treatment="${BASH_REMATCH[4]}"
            
            #echo "base_name" $base_name
            #echo "replicate" $replicate
            #echo "condition" $condition
            #echo "treatment" $treatment
            # Update replicate to SX or WX
        
            if [[ $replicate == "S0" ]]; then
                replicate="S9"
            elif [[ $replicate == "S9" ]]; then
                replicate="S0"
            elif [[ $replicate == "W4" ]]; then
                replicate="W5"
            elif [[ $replicate == "W5" ]]; then
                replicate="W4"
            fi

            partner_identifier="${base_name}_${replicate}_${condition}_${treatment}"
            #echo "partner ID" $partner_identifier

            # Check if the partner BAM file exists with matching conditions
            partner_bam=${INPUT_DIR}/${base_name}_${replicate}_${condition}_${treatment}*.bam
            echo "Looking for partner BAM files matching: $partner_bam"

            # Check if there are any matching files
            if ls $partner_bam 1>/dev/null 2>&1; then
                partner_bam=$(ls $partner_bam | head -n 1)
            else
                echo "No matching BAM files found for $SAMPLE_NAME. Skipping merge."
                continue
            fi

            echo "Found partner BAM file: $partner_bam"
            #echo "partner bamfile" $partner_bam
            #echo "-----------------------------"
            if [ -f "$partner_bam" ]; then
                partner_sample_name=$(basename "$partner_bam" .bam)
                if [[ $partner_sample_name =~ ^${base_name}_${replicate}_${condition}_${treatment}_.*$ ]]; then
                    # Merge the current BAM file and its partner
                    # Adjust the replicate identifier for output naming
                    if [[ $replicate == "S0" || $replicate == "S9" ]]; then
                        merge_replicate="SX"
                    elif [[ $replicate == "W4" || $replicate == "W5" ]]; then
                        merge_replicate="WX"
                    else
                        merge_replicate=$replicate
                    fi
                    merge_output="${base_name}_${merge_replicate}_${condition}_${treatment}_merged.bam"
                    echo "Merging files $SAMPLE_NAME and $partner_sample_name into $merge_output"
                    samtools merge "$OUTPUT_DIR/$merge_output" "$BAM_FILE" "$partner_bam"
                else
                    echo "Partner BAM file $partner_bam does not match conditions for $SAMPLE_NAME. Skipping merge."
                fi
            else
                echo "Partner BAM file $partner_bam does not exist for $SAMPLE_NAME. Skipping merge."
            fi
        else
            echo "Could not parse sample name: $SAMPLE_NAME. Skipping."
        fi
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
