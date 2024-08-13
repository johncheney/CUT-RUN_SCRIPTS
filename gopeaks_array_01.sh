#!/bin/bash

# Script: seacr.sh
# Calls peaks using GoPeaks 

#SBATCH --job-name=GoPeaks
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=68G
#SBATCH --time=24:00:00

############################# MERGED FILES ############################# 

INPUT_DIR="../results/nordin/merged/bam"
# OUTPUT_DIR="../results/merged/gopeaks"
# OUTPUT_DIR="../results/merged/gopeaks_S0_W4"
OUTPUT_DIR="../results/merged/gopeaks_S9_W5"
# OUTPUT_DIR="../results/merged/gopeaks_broad"

mkdir -p $OUTPUT_DIR \

FILE="$1"
SAMPLE_NAME=$(basename "$1")  # Extract the sample name from the file

# Extract components from the filename using regex
if [[ $SAMPLE_NAME =~ ^(LIB.*)_(S[0-9]+|W[0-9]+|WX|SX)_(NS|S)_(AR|BRG|K27A|K27M|K4|IgG)_.*\.bam$ ]]; then
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
IGG_PATTERN="${base_name}_${replicate}_${condition}_IgG_*.bam"
IG_CONTROL_FILE=$(ls "$INPUT_DIR"/$IGG_PATTERN 2>/dev/null)

# Check if the IgG control file was found
if [ -r "$IG_CONTROL_FILE" ]; then
    echo "Processing $FILE with IgG control file $IG_CONTROL_FILE"
    # Perform your gopeaks operations or any other processing here
    # echo "gopeaks -b \"$FILE\" -c \"$IG_CONTROL_FILE\" -o \"$OUTPUT_DIR/${SAMPLE_NAME%.bam}\""
    # Uncomment the following line to run the gopeaks command
    gopeaks -b "$FILE" -c "$IG_CONTROL_FILE" -o "$OUTPUT_DIR/${SAMPLE_NAME}"
    # gopeaks --broad --mdist 3000 -b "$FILE" -c "$IG_CONTROL_FILE" -o "$OUTPUT_DIR/${SAMPLE_NAME%.bam}"
else
    echo "Error: IgG control file not found for $SAMPLE_NAME"
fi




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
