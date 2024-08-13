#!/bin/bash

#SBATCH --job-name=bowtie2
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# Standalone as this script is, it's taking 6 hours to run 48 files. I want to make it very 
# 'embarassingly parallell' 

# 7-10 edit: I updated it to local alignment instead of 'end to end' 

INDEX_DIR="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/Bowtie2Index/genome"
INPUT_DIR="../results/trimmo/trimmed"
OUTPUT_BASE_DIR="../results/bowtie2"

mkdir -p "$OUTPUT_BASE_DIR"

SAM_DIR="$OUTPUT_BASE_DIR/sam"
SUMMARY_DIR="$OUTPUT_BASE_DIR/summary"

mkdir -p "$SAM_DIR" \
         "$SUMMARY_DIR"

for file in "$INPUT_DIR"/*_R1_001.trimmed.fastq; do
    if [ -r "$file" ]; then
        SAMPLE_NAME=$(basename "$file" _R1_001.trimmed.fastq)

# Run Bowtie2 alignment
time bowtie2 -x "$INDEX_DIR" \
    --phred33 \
    -p 8 \
    --local \
    --very-sensitive-local \
    --no-mixed \
    --no-unal \
    --no-discordant \
    --soft-clipped-unmapped-tlen \
    --dovetail \
    -I 10 \
    -X 700 \
    -1 "$INPUT_DIR/${SAMPLE_NAME}_R1_001.trimmed.fastq" \
    -2 "$INPUT_DIR/${SAMPLE_NAME}_R2_001.trimmed.fastq" \
    -S "$OUTPUT_BASE_DIR/sam/${SAMPLE_NAME}.sam" &> \
    "$OUTPUT_BASE_DIR/summary/${SAMPLE_NAME}_bowtie2.txt"

    else
        echo "Error: No files found in $INPUT_DIR"
        exit 1
    fi
done


