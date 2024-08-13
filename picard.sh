#!/bin/bash

#SBATCH --job-name=picard
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=24:00:00

## Notes: I updated this script to NOT REMOVE DUPLICATES 7/9 line 50

INPUT_DIR="../results/bowtie2/sam"
OUTPUT_BASE_DIR="../results/picard_local"
REFERENCE_GENOME="/home/users/cheneyjo/cheneyjo/references/Mus_musculus/Ensembl/GRCm38/Sequence/WholeGenomeFasta"

mkdir -p "$OUTPUT_BASE_DIR"


SORTED_SAM_DIR="$OUTPUT_BASE_DIR/sorted_sam"
MARKDUP_SAM_DIR="$OUTPUT_BASE_DIR/markdup_sam"
DEDUP_SAM_DIR="$OUTPUT_BASE_DIR/dedup_sam"
METRIC_SAM_DIR="$OUTPUT_BASE_DIR/metric_sam"


mkdir -p "$SORTED_SAM_DIR" \
	 "$MARKDUP_SAM_DIR" \
 	 "$DEDUP_SAM_DIR" \
	 "$METRIC_SAM_DIR"

for SAM_FILE in "$INPUT_DIR"/*.sam; do
    if [ -r "$SAM_FILE" ]; then
        SAMPLE_NAME=$(basename "$SAM_FILE" .sam)

# Sort by coordinate

 time picard SortSam INPUT=$INPUT_DIR/${SAMPLE_NAME}.sam\
		    OUTPUT=$OUTPUT_BASE_DIR/sorted_sam/${SAMPLE_NAME}_bowtie2.sorted.sam \
		    SORT_ORDER=coordinate


# Mark duplicates

 time picard MarkDuplicates INPUT=$OUTPUT_BASE_DIR/sorted_sam/${SAMPLE_NAME}_bowtie2.sorted.sam \
			   OUTPUT=$OUTPUT_BASE_DIR/markdup_sam/${SAMPLE_NAME}_bowtie2.sorted.dupMarked.sam \
		 	   METRICS_FILE=$OUTPUT_BASE_DIR/metric_sam/${SAMPLE_NAME}_picard.dupMark.txt

# remove duplicates 

 time picard MarkDuplicates INPUT=$OUTPUT_BASE_DIR/sorted_sam/${SAMPLE_NAME}_bowtie2.sorted.sam \
		 	   OUTPUT=$OUTPUT_BASE_DIR/dedup_sam/${SAMPLE_NAME}_bowtie2.sorted.rmDup.sam \
		 	   REMOVE_DUPLICATES=false \
			   METRICS_FILE=$OUTPUT_BASE_DIR/metric_sam/${SAMPLE_NAME}_rmdup.txt




    else
        echo "Error: No sam files found in $INPUT_DIR"
        exit 1
    fi
done


