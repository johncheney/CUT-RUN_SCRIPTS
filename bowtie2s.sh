#!/bin/bash

#SBATCH --job-name=bowtie2s
#SBATCH --partition=exacloud
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=36:00:00

INDEX_DIR="/home/users/cheneyjo/cheneyjo/references/Escherichia_coli_K_12_DH10B/Ensembl/EB1/Sequence/Bowtie2Index/genome" 

### Use this bash command to get the spike in chrom sizes.  
#cut -f1,2 input.fa.fai > sizes.genome

INPUT_DIR="../results/trimmo/trimmed"
OUTPUT_BASE_DIR="../results/bowtie2_spikein"

mkdir -p "$OUTPUT_BASE_DIR"

SAM_DIR="$OUTPUT_BASE_DIR/sam_spikein"
SUMMARY_DIR="$OUTPUT_BASE_DIR/summary_spikein"

mkdir -p "$SAM_DIR" \
         "$SUMMARY_DIR"

for file in "$INPUT_DIR"/*_R1_001.trimmed.fastq; do
    if [ -r "$file" ]; then
        SAMPLE_NAME=$(basename "$file" _R1_001.trimmed.fastq)

        # Run Bowtie2 alignment
        time bowtie2 -x "$INDEX_DIR" \
			    -p 8 \
		        --end-to-end \
		        --very-sensitive \
		        --no-mixed \
		        --no-discordant \
		        --no-overlap \
		        --no-dovetail \
		        --phred33 \
		        -I 10 \
		        -X 700 \
                -1 "$INPUT_DIR/${SAMPLE_NAME}_R1_001.trimmed.fastq" \
                -2 "$INPUT_DIR/${SAMPLE_NAME}_R2_001.trimmed.fastq" \
                -S "$OUTPUT_BASE_DIR/sam_spikein/${SAMPLE_NAME}.sam" &> \
                "$OUTPUT_BASE_DIR/summary_spikein/${SAMPLE_NAME}_bowtie2_spikein.txt"


seqDepthDouble=`samtools view -F 0x04 ../results/bowtie2_spikein/sam_spikein/${SAMPLE_NAME}.sam | wc -l`
seqDepth=$((seqDepthDouble/2))
echo $seqDepth > ../results/bowtie2_spikein/summary_spikein/${SAMPLE_NAME}_bowtie2_spikeIn.seqDepth


    else
        echo "Error: No files found in $INPUT_DIR"
        exit 1
    fi
done


