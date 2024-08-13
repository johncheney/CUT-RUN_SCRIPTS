#!/bin/bash

# Script: bamtobigwig 
# Converts bamfiles to bigwig files 

#SBATCH --job-name=bbamtobigwig
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

#Parameter Sweep
#RPKM Normalization
#BPM Normalization

# IP_D_VAR="e2e"
IP_D_VAR="Ted_Data"
# IP_D_VAR="TEST_NOTRIM"
# IP_D_VAR="l"
# IP_D_VAR="l_dovetail"

INPUT_DIR="../results/bowtie2_$IP_D_VAR/sam"
OUTPUT_DIR="../results/bowtie2_$IP_D_VAR"

# mkdir -p $OUTPUT_DIR \

BW_DIR="$OUTPUT_DIR/bigwig"
BAI_DIR="$OUTPUT_DIR/bai"
BAM_DIR="$OUTPUT_DIR/bam"

mkdir -p $BW_DIR \
        $BAI_DIR \
        $BAM_DIR

        # Extract fragment related columns
# for BAM_FILE in $INPUT_DIR/*.bam; do
#     if [ -r "$BAM_FILE" ]; then

SAMPLE_NAME=$(basename "$1" )
# SAMPLE_NAME=$(basename "$1" .bam)

        ## bamCoverage looks for the bam and bai files in the same directory 
# samtools view -hbS $INPUT_DIR/${SAMPLE_NAME} > $BAM_DIR/${SAMPLE_NAME}.bam 
# samtools sort -o $BAM_DIR/${SAMPLE_NAME}_sorted.bam $BAM_DIR/${SAMPLE_NAME}
# samtools index -M $BAM_DIR/${SAMPLE_NAME} $BAI_DIR/${SAMPLE_NAME}.bai # move these over
bamCoverage -b $BAM_DIR/${SAMPLE_NAME} -o $BW_DIR/${SAMPLE_NAME}.bigwig \
        --binSize 10 \
        --normalizeUsing CPM \
        --smoothLength 50 \
        -p 8 

 
#         --centerReads \
        # --extendReads \
# else
# echo "Error: No SAM files found in $INPUT_DIR"
# exit 1                                                                                                                                           
# fi      
# done

# bamCoverage -b sample1.bam \

# Nextflow alignment params

#             ext.args   = { params.end_to_end ? '--end-to-end --
# very-sensitive --
# no-mixed --
# no-discordant --
# phred33 --
# minins 10 --
# maxins 700 --
# dovetail' : '--local --

# very-sensitive --
# no-mixed --
# no-discordant --
# phred33 --
# minins 10 --
# maxins 700 --
# dovetail' }
