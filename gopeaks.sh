#!/bin/bash

# Script: seacr.sh
# Calls peaks using GoPeaks 

#SBATCH --job-name=GoPeaks
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

INPUT_DIR="../results/suspect_list_filter_local/sorted_bedbam"
OUTPUT_DIR="../results/peaks/gopeaks_bedbam"

mkdir -p $OUTPUT_DIR \


# Iterate over each bam file in INPUT_DIR
for BAM_FILE in "$INPUT_DIR"/*sorted.bam; do
    if [ -r "$BAM_FILE" ]; then
        # Extract base filename without extension
        SAMPLE_NAME=$(basename "$BAM_FILE" sorted.bam)
        
        # Extract common identifier for treatment replicate
        common_identifier=$(echo "$SAMPLE_NAME" | cut -d '_' -f 1-3)
        # echo $common_identifier 
        # Find the corresponding IgG control file dynamically
        IG_CONTROL_FILE=""
        for CONTROL_FILE in "$INPUT_DIR"/*.bam; do
            if [ -r "$CONTROL_FILE" ]; then
                CONTROL_NAME=$(basename "$CONTROL_FILE" sorted.bam)
                # echo $CONTROL_NAME
                if [ "$SAMPLE_NAME" != "$CONTROL_NAME" ] && [ "$(echo "$CONTROL_NAME" | cut -d '_' -f 1-3)" == "$common_identifier" ] && [[ "$CONTROL_NAME" == *"IgG"* ]]; then
                    IG_CONTROL_FILE="$CONTROL_FILE"
                    # echo $IG_CONTROL_FILE
                    break
                fi
            fi
        done
        
        # Check if the IgG control file exists and is readable
        if [ -r "$IG_CONTROL_FILE" ]; then
            echo "Processing $BAM_FILE and $IG_CONTROL_FILE"
            # Perform your seacr operations or any other processing here
            gopeaks -b "$BAM_FILE" -c "$IG_CONTROL_FILE" -o "$OUTPUT_DIR/${SAMPLE_NAME}"

else
            echo "Error: IgG control file not found for $SAMPLE_NAME"
        fi
    fi
done





##################################################################################  

#         # Extract fragment related columns
# for BAM_FILE in $INPUT_DIR/*.bam; do
#     if [ -r "$BAM_FILE" ]; then
#         SAMPLE_NAME=$(basename "$BAM_FILE" .bam)
#         seacr $INPUT_DIR/${SAMPLE_NAME}.bam \
#         $INPUT_DIR/${SAMPLE_NAME}.bam \
#         non stringent $OUTPUT_DIR/${SAMPLE_NAME}_seacr_control.peaks


#        seacr $INPUT_DIR/${SAMPLE_NAME}.bam \
#         $INPUT_DIR/${SAMPLE_NAME}.bam \
#         0.01 non stringent $OUTPUT_DIR/${SAMPLE_NAME}_seacr_top0.01.peaks
 
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done


# histControl=$2
# mkdir -p $projPath/peakCalling/SEACR

# bash $seacr $projPath/alignment/bam/${histName}_bowtie2.fragments.normalized.bam \
#      $projPath/alignment/bam/${histControl}_bowtie2.fragments.normalized.bam \
#      non stringent $projPath/peakCalling/SEACR/${histName}_seacr_control.peaks

# bash $seacr $projPath/alignment/bam/${histName}_bowtie2.fragments.normalized.bam 0.01 non stringent $projPath/peakCalling/SEACR/${histName}_seacr_top0.01.peaks
