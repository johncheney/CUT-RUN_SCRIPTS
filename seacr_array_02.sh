#!/bin/bash

# Script: seacr.sh
# Converts calls peaks using SEACR 

#SBATCH --job-name=seacr
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

############################### UNMERGED BIOLOGICAL REPLCIATE PROCESSING ###############################


# Set of bedtools preprocessing dirs for peak calling:
# # INPUT_DIR="../results/nordin/merged/bam"
# INPUT_DIR="../results/nordin/unmerged/bam"

# # OUTPUT_DIR="../results/nordin/merged/bedgraph"
# OUTPUT_DIR="../results/nordin/unmerged/bedgraph"


# Set of seacr-specific directories 
# Variable 1 options: non norm
VAR1="non"
# Variable 2 options: stringent, relaxed
# VAR2="stringent"
VAR2="relaxed"

# INPUT_DIR="../results/nordin/merged/bedgraph"
INPUT_DIR="../results/nordin/unmerged/bedgraph"

# OUTPUT_DIR="../results/merged/peaks/seacr_{$VAR1}_{$VAR2}"
OUTPUT_DIR="../results/unmerged/peaks/seacr_$VAR1_$VAR2"


############################### 

mkdir -p $OUTPUT_DIR \

seacr="/home/users/cheneyjo/miniconda3/pkgs/seacr-1.3-hdfd78af_2/bin/SEACR_1.3.sh"

##### Part 1 ################

# # Convert bedfiles to bedgraphs (for Seacr)
# for BED_FILE in $SL_OUTPUT_DIR/enrich/*.bed; do #Uncomment for Loop
#     if [ -r "$BED_FILE" ]; then #uncomment for loop
        # Extract base filename without extension
        # SAMPLE_NAME=$(basename "$BED_FILE" .bed) #Uncomment for loop
    #     SAMPLE_NAME=$(basename "$1" .bam)
    # bedtools genomecov -bg -ibam $INPUT_DIR/${SAMPLE_NAME}.bam -g "$chromSize" > $OUTPUT_DIR/${SAMPLE_NAME}.bedgraph
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done

# ##### Part 2 ################


FILE="$1"
SAMPLE_NAME=$(basename "$1" )  # Extract the sample name from the file

# Extract components from the filename using regex
        if [[ $SAMPLE_NAME =~ ^(LIB.*)_(S[0-9]+|W[0-9]+|WX)_(NS|S)_(AR|BRG|K27A|K27M|K4|IgG)_.*$ ]]; then
            base_name="${BASH_REMATCH[1]}"
            replicate="${BASH_REMATCH[2]}"
            condition="${BASH_REMATCH[3]}"
            treatment="${BASH_REMATCH[4]}"
        else
            echo "Filename does not match expected pattern: $SAMPLE_NAME"
            exit 1
        fi

        # Check if the file is an IgG control file
        if [[ "$treatment" == "IgG" ]]; then
            echo "Skipping IgG control file: $FILE"
            exit 0
        fi

        # Construct the name of the corresponding IgG control file
        IGG_PATTERN="${base_name}_${replicate}_${condition}_IgG_*.bedgraph"
        IG_CONTROL_FILE=$(ls "$INPUT_DIR"/$IGG_PATTERN 2>/dev/null)

        # Check if the IgG control file was found
        if [ -r "$IG_CONTROL_FILE" ]; then
            echo "Processing $FILE with IgG control file $IG_CONTROL_FILE"
            # Perform your SEACR operations or any other processing here
            # echo "$seacr $FILE $IG_CONTROL_FILE $VAR1 $VAR2 $OUTPUT_DIR/${SAMPLE_NAME}_seacr_control.peaks"
            # Uncomment the following line to run the SEACR command
            $seacr "$FILE" "$IG_CONTROL_FILE" $VAR1 $VAR2 "$OUTPUT_DIR/${SAMPLE_NAME}_seacr_control.peaks"
                        # Uncomment the following line to run the SEACR command (IgG-agnostic analysis)
            # $seacr "$FILE" 0.01 $VAR1 $VAR2 "$OUTPUT_DIR/${SAMPLE_NAME}_seacr_top0.01.peaks"
        else
            echo "Error: IgG control file not found for $SAMPLE_NAME"
        fi
#     fi
# done
# # Iterate over each bedgraph file in INPUT_DIR
# #for BED_FILE in "$INPUT_DIR"/*.bedgraph; do
#     # if [ -r "$BED_FILE" ]; then
#         # Extract base filename without extension
#         SAMPLE_NAME=$(basename "$1" ) #test (no bedgraphs yet)
#         # SAMPLE_NAME=$(basename "$1" .bedgraph) # use this for the application 
        
#         # Extract common identifier for treatment replicate
#         common_identifier=$(echo "$SAMPLE_NAME" | cut -d '_' -f 1-3)
#         echo $common_identifier 
#         # Find the corresponding IgG control file dynamically
#         IG_CONTROL_FILE=""
#         for CONTROL_FILE in "$INPUT_DIR"/; do
#             if [ -r "$CONTROL_FILE" ]; then
#                 CONTROL_NAME=$(basename "$CONTROL_FILE" )
#                 echo "control name: $CONTROL_NAME"
#                 if [ "$SAMPLE_NAME" != "$CONTROL_NAME" ] && [ "$(echo "$CONTROL_NAME" | cut -d '_' -f 1-3)" == "$common_identifier" ] && [[ "$CONTROL_NAME" == *"IgG"* ]]; then
#                     IG_CONTROL_FILE="$CONTROL_FILE"
#                     echo "control file $IG_CONTROL_FILE"
#                     break
#                 fi
#             fi
#         done
        
#         # Check if the IgG control file exists and is readable
#         if [ -r "$IG_CONTROL_FILE" ]; then
#             echo "Processing $SAMPLE_NAME and $IG_CONTROL_FILE"
#             # Perform your seacr operations or any other processing here
#             echo $seacr "$SAMPLE_NAME" "$IG_CONTROL_FILE" $VAR1 $VAR2 "$OUTPUT_DIR/${SAMPLE_NAME}_seacr_control.peaks"
#             # $seacr "$BED_FILE" 0.01 $VAR1 $VAR2 "$OUTPUT_DIR/${SAMPLE_NAME}_seacr_top0.01.peaks"

# else
#             echo "Error: IgG control file not found for $SAMPLE_NAME"
        # fi
#     fi
# done





# # ##################################################################################  

# # #         # Extract fragment related columns
# # # for BED_FILE in $INPUT_DIR/*.bedgraph; do
# # #     if [ -r "$BED_FILE" ]; then
# # #         SAMPLE_NAME=$(basename "$BED_FILE" .bedgraph)
# # #         seacr $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
# # #         $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
# # #         non stringent $OUTPUT_DIR/${SAMPLE_NAME}_seacr_control.peaks


# # #        seacr $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
# # #         $INPUT_DIR/${SAMPLE_NAME}.bedgraph \
# # #         0.01 non stringent $OUTPUT_DIR/${SAMPLE_NAME}_seacr_top0.01.peaks
 
# # # else
# # # echo "Error: No SAM files found in $INPUT_DIR"
# # # exit 1                                                                                                                                           
# # # fi      
# # # done


# # # histControl=$2
# # # mkdir -p $projPath/peakCalling/SEACR

# # # bash $seacr $projPath/alignment/bedgraph/${histName}_bowtie2.fragments.normalized.bedgraph \
# # #      $projPath/alignment/bedgraph/${histControl}_bowtie2.fragments.normalized.bedgraph \
# # #      non stringent $projPath/peakCalling/SEACR/${histName}_seacr_control.peaks

# # # bash $seacr $projPath/alignment/bedgraph/${histName}_bowtie2.fragments.normalized.bedgraph 0.01 non stringent $projPath/peakCalling/SEACR/${histName}_seacr_top0.01.peaks
# 