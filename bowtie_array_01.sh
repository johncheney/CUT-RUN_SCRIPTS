#!/bin/bash

#SBATCH --job-name=bowtie2
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

# Standalone as this script is, it's taking 6 hours to run 48 files. I want to make it very 
# 'embarassingly parallell' 

# 7-10 edit: I updated it to local alignment instead of 'end to end' 
# 7-19 edit: I've updated this copy of the script to run 'embarassingly parallel'

INDEX_DIR="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/Bowtie2Index/genome"
# INPUT_DIR="../results/trimmo/trimmed"
INPUT_DIR="../data/LIB240408AM" # no adapter removal 

OUTPUT_BASE_DIR="../results/bowtie2_TEST_NOTRIM"
# OUTPUT_BASE_DIR="../results/bowtie2_l"
# OUTPUT_BASE_DIR="../results/bowtie2_l_dovetail"

mkdir -p "$OUTPUT_BASE_DIR"

SAM_DIR="$OUTPUT_BASE_DIR/sam"
SUMMARY_DIR="$OUTPUT_BASE_DIR/summary"

mkdir -p "$SAM_DIR" \
         "$SUMMARY_DIR"

# for file in "$INPUT_DIR"/*_R1_001.trimmed.fastq; do
#     if [ -r "$file" ]; then
# SAMPLE_NAME=$(basename "$1" _R1_001.trimmed.fastq) 
SAMPLE_NAME=$(basename "$1" _R1_001.fastq.gz) # no adapter

# Run Bowtie2 alignment
bowtie2 -x "$INDEX_DIR" \
    --local \
    --very-sensitive-local \
    --no-unal \
    --no-mixed \
    --threads 8 \
    --no-discordant \
    -1 "$INPUT_DIR/${SAMPLE_NAME}_R1_001.fastq.gz" \
    -2 "$INPUT_DIR/${SAMPLE_NAME}_R2_001.fastq.gz" \
    -S "$OUTPUT_BASE_DIR/sam/${SAMPLE_NAME}.sam" &> \
    "$OUTPUT_BASE_DIR/summary/${SAMPLE_NAME}_bowtie2.txt"

    # -1 "$INPUT_DIR/${SAMPLE_NAME}_R1_001.trimmed.fastq" \
    # -2 "$INPUT_DIR/${SAMPLE_NAME}_R2_001.trimmed.fastq" \
#     else
#         echo "Error: No files found in $INPUT_DIR"
#         exit 1
#     fi
# done

#Henikoff Workflow: https://www.protocols.io/view/cut-amp-run-targeted-in-situ-genome-wide-profiling-14egnr4ql5dy/v3?version_warning=no&step=114

# We align paired-end reads using Bowtie2 version 2.2.5 with options: --local --very-sensitive-local --no-unal --no-mixed --no-discordant --phred33 -I 10 -X 700
# --local 
# --very-sensitive-local 
# --no-unal 
# --no-mixed 
# --no-discordant 
# --phred33 
# -I 10 
# -X 700


# Nextflow Options: 
#ext.args   = { params.end_to_end ? 
# '--end-to-end 
# --very-sensitive 
# --no-overlap 
# --no-dovetail 
# --no-mixed 
# --no-discordant
#  --phred33 
#  --minins 10
#   --maxins 700' :
  
#    --local 
#    --very-sensitive-local
#    --no-overlap 
#    --no-mixed 
#    --no-dovetail 
#    --no-discordant 
#    --phred33 
#    --minins 10 
#    --maxins 700' }

