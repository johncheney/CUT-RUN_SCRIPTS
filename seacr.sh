#!/bin/bash

# Script: seacr.sh
# Converts calls peaks using SEACR 

#SBATCH --job-name=seacr
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

INPUT_DIR="../results/suspect_list_filter_local/bedgraph_Nordin"
OUTPUT_DIR="../results/peaks/seacr_Nordin"

mkdir -p $OUTPUT_DIR \

seacr="/home/users/cheneyjo/miniconda3/pkgs/seacr-1.3-hdfd78af_2/bin/SEACR_1.3.sh"

# Iterate over each bedgraph file in INPUT_DIR
for BED_FILE in "$INPUT_DIR"/*.bedgraph; do
    if [ -r "$BED_FILE" ]; then
        # Extract base filename without extension
        SAMPLE_NAME=$(basename "$BED_FILE" .bedgraph)
        
        # Extract common identifier for treatment replicate
        common_identifier=$(echo "$SAMPLE_NAME" | cut -d '_' -f 1-3)
        echo $common_identifier 
        # Find the corresponding IgG control file dynamically
        IG_CONTROL_FILE=""
        for CONTROL_FILE in "$INPUT_DIR"/*.bedgraph; do
            if [ -r "$CONTROL_FILE" ]; then
                CONTROL_NAME=$(basename "$CONTROL_FILE" .bedgraph)
                echo "control name: $CONTROL_NAME"
                if [ "$SAMPLE_NAME" != "$CONTROL_NAME" ] && [ "$(echo "$CONTROL_NAME" | cut -d '_' -f 1-3)" == "$common_identifier" ] && [[ "$CONTROL_NAME" == *"IgG"* ]]; then
                    IG_CONTROL_FILE="$CONTROL_FILE"
                    echo "control file $IG_CONTROL_FILE"
                    break
                fi
            fi
        done
        
        # Check if the IgG control file exists and is readable
        if [ -r "$IG_CONTROL_FILE" ]; then
            echo "Processing $BED_FILE and $IG_CONTROL_FILE"
            # Perform your seacr operations or any other processing here
            $seacr "$BED_FILE" "$IG_CONTROL_FILE" non stringent "$OUTPUT_DIR/${SAMPLE_NAME}_seacr_control.peaks"
            # $seacr "$BED_FILE" 0.01 non stringent "$OUTPUT_DIR/${SAMPLE_NAME}_seacr_top0.01.peaks"

else
            echo "Error: IgG control file not found for $SAMPLE_NAME"
        fi
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
