#!/bin/bash

# Script: histone heatmap of enriched regions  

#SBATCH --job-name=histenrich
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

cores=8
INPUT_DIR="../results/peaks"
BW_INPUT_DIR="../results/bamtobigwig/bigwig"
OUTPUT_DIR="../results/enrichedhistone"

mkdir -p $OUTPUT_DIR \


        # Extract fragment related columns
for BED_FILE in $INPUT_DIR/*.bed; do
    if [ -r "$BED_FILE" ]; then
        SAMPLE_NAME=$(basename "$BED_FILE" .bed)
        # samtools sort -o $BED_DIR/${SAMPLE_NAME}.bed $INPUT_DIR/${SAMPLE_NAME}.bam 
        # samtools index $BED_DIR/${SAMPLE_NAME}.bed
        # bedCoverage -b $BED_DIR/${SAMPLE_NAME}.bam -o $OUTPUT_DIR/bigwig/${SAMPLE_NAME}.bigwig

# awk '{split($6, summit, ":"); split(summit[2], region, "-"); print summit[1]"\t"region[1]"\t"region[2]}'\
#         $INPUT_DIR/${SAMPLE_NAME}.bed > \
#         $INPUT_DIR/${SAMPLE_NAME}_seacr_top0.01.peaks.summitRegion.bed

# Begin Second nested loop here
        for BW_FILE in $BW_INPUT_DIR/*.bigwig; do
        if [ -r "$BW_FILE" ]; then
                BW_SAMPLE_NAME=$(basename "$BW_FILE" .bigwig)
computeMatrix reference-point -S $BW_INPUT_DIR/${BW_SAMPLE_NAME}.bigwig \
              -R $INPUT_DIR/SR/${SAMPLE_NAME}.bed \
              --skipZeros -o $INPUT_DIR/${SAMPLE_NAME}_SEACR.mat.gz \
              -p $cores \
              -a 3000 \
              -b 3000 \
              --referencePoint center

plotHeatmap -m $INPUT_DIR/${SAMPLE_NAME}_SEACR.mat.gz \
        -out $INPUT_DIR/${SAMPLE_NAME}_SEACR_heatmap.png \
        --sortUsing sum \
        --startLabel "Peak Start" \
        --endLabel "Peak End" \
        --xAxisLabel "" \
        --regionsLabel "Peaks" \
        --samplesLabel "${SAMPLE_NAME}" 

        else
        echo "Error: No SAM files found in $INPUT_DIR"
        exit 1                                                                                                                                           
        fi      
        done

else
echo "Error: No SAM files found in $INPUT_DIR"
exit 1                                                                                                                                           
fi      
done

